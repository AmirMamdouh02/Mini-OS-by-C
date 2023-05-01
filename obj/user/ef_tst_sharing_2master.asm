
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 49 03 00 00       	call   80037f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
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
  80008d:	68 a0 35 80 00       	push   $0x8035a0
  800092:	6a 13                	push   $0x13
  800094:	68 bc 35 80 00       	push   $0x8035bc
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 09 1b 00 00       	call   801bac <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 da 35 80 00       	push   $0x8035da
  8000b2:	e8 d2 17 00 00       	call   801889 <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 dc 35 80 00       	push   $0x8035dc
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 bc 35 80 00       	push   $0x8035bc
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 ca 1a 00 00       	call   801bac <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 b9 1a 00 00       	call   801bac <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 b2 1a 00 00       	call   801bac <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 40 36 80 00       	push   $0x803640
  800107:	6a 1b                	push   $0x1b
  800109:	68 bc 35 80 00       	push   $0x8035bc
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 94 1a 00 00       	call   801bac <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 d1 36 80 00       	push   $0x8036d1
  800127:	e8 5d 17 00 00       	call   801889 <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 dc 35 80 00       	push   $0x8035dc
  800143:	6a 20                	push   $0x20
  800145:	68 bc 35 80 00       	push   $0x8035bc
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 55 1a 00 00       	call   801bac <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 44 1a 00 00       	call   801bac <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 3d 1a 00 00       	call   801bac <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 40 36 80 00       	push   $0x803640
  80017c:	6a 21                	push   $0x21
  80017e:	68 bc 35 80 00       	push   $0x8035bc
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 1f 1a 00 00       	call   801bac <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 d3 36 80 00       	push   $0x8036d3
  80019c:	e8 e8 16 00 00       	call   801889 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 dc 35 80 00       	push   $0x8035dc
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 bc 35 80 00       	push   $0x8035bc
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 e0 19 00 00       	call   801bac <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 d8 36 80 00       	push   $0x8036d8
  8001dd:	6a 27                	push   $0x27
  8001df:	68 bc 35 80 00       	push   $0x8035bc
  8001e4:	e8 d2 02 00 00       	call   8004bb <_panic>

	*x = 10 ;
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f5:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001fb:	a1 20 50 80 00       	mov    0x805020,%eax
  800200:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	a1 20 50 80 00       	mov    0x805020,%eax
  80020d:	8b 40 74             	mov    0x74(%eax),%eax
  800210:	6a 32                	push   $0x32
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	68 60 37 80 00       	push   $0x803760
  800219:	e8 00 1c 00 00       	call   801e1e <sys_create_env>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800224:	a1 20 50 80 00       	mov    0x805020,%eax
  800229:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80022f:	89 c2                	mov    %eax,%edx
  800231:	a1 20 50 80 00       	mov    0x805020,%eax
  800236:	8b 40 74             	mov    0x74(%eax),%eax
  800239:	6a 32                	push   $0x32
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 60 37 80 00       	push   $0x803760
  800242:	e8 d7 1b 00 00       	call   801e1e <sys_create_env>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80024d:	a1 20 50 80 00       	mov    0x805020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	a1 20 50 80 00       	mov    0x805020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	6a 32                	push   $0x32
  800264:	52                   	push   %edx
  800265:	50                   	push   %eax
  800266:	68 60 37 80 00       	push   $0x803760
  80026b:	e8 ae 1b 00 00       	call   801e1e <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 ef 1c 00 00       	call   801f6a <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 6e 37 80 00       	push   $0x80376e
  800287:	e8 fd 15 00 00       	call   801889 <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 9f 1b 00 00       	call   801e3c <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 91 1b 00 00       	call   801e3c <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 83 1b 00 00       	call   801e3c <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 aa 2f 00 00       	call   803273 <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 13 1d 00 00       	call   801fe4 <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 7e 37 80 00       	push   $0x80377e
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 bc 35 80 00       	push   $0x8035bc
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 8c 37 80 00       	push   $0x80378c
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 bc 35 80 00       	push   $0x8035bc
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 dc 37 80 00       	push   $0x8037dc
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 88 1b 00 00       	call   801ea5 <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 2c 1b 00 00       	call   801e58 <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 1e 1b 00 00       	call   801e58 <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 10 1b 00 00       	call   801e58 <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 4e 1b 00 00       	call   801ea5 <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 36 38 80 00       	push   $0x803836
  80035f:	50                   	push   %eax
  800360:	e8 f9 15 00 00       	call   80195e <sget>
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	89 45 cc             	mov    %eax,-0x34(%ebp)
		(*finishedCount)++ ;
  80036b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	8d 50 01             	lea    0x1(%eax),%edx
  800373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800376:	89 10                	mov    %edx,(%eax)
	}
	return;
  800378:	90                   	nop
  800379:	90                   	nop
}
  80037a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800385:	e8 02 1b 00 00       	call   801e8c <sys_getenvindex>
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80038d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800390:	89 d0                	mov    %edx,%eax
  800392:	c1 e0 03             	shl    $0x3,%eax
  800395:	01 d0                	add    %edx,%eax
  800397:	01 c0                	add    %eax,%eax
  800399:	01 d0                	add    %edx,%eax
  80039b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	c1 e0 04             	shl    $0x4,%eax
  8003a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003ac:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b6:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003bc:	84 c0                	test   %al,%al
  8003be:	74 0f                	je     8003cf <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c5:	05 5c 05 00 00       	add    $0x55c,%eax
  8003ca:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003d3:	7e 0a                	jle    8003df <libmain+0x60>
		binaryname = argv[0];
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 0c             	pushl  0xc(%ebp)
  8003e5:	ff 75 08             	pushl  0x8(%ebp)
  8003e8:	e8 4b fc ff ff       	call   800038 <_main>
  8003ed:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003f0:	e8 a4 18 00 00       	call   801c99 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 5c 38 80 00       	push   $0x80385c
  8003fd:	e8 6d 03 00 00       	call   80076f <cprintf>
  800402:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800405:	a1 20 50 80 00       	mov    0x805020,%eax
  80040a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800410:	a1 20 50 80 00       	mov    0x805020,%eax
  800415:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	52                   	push   %edx
  80041f:	50                   	push   %eax
  800420:	68 84 38 80 00       	push   $0x803884
  800425:	e8 45 03 00 00       	call   80076f <cprintf>
  80042a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80042d:	a1 20 50 80 00       	mov    0x805020,%eax
  800432:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800438:	a1 20 50 80 00       	mov    0x805020,%eax
  80043d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800443:	a1 20 50 80 00       	mov    0x805020,%eax
  800448:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80044e:	51                   	push   %ecx
  80044f:	52                   	push   %edx
  800450:	50                   	push   %eax
  800451:	68 ac 38 80 00       	push   $0x8038ac
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 50 80 00       	mov    0x805020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 04 39 80 00       	push   $0x803904
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 5c 38 80 00       	push   $0x80385c
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 24 18 00 00       	call   801cb3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80048f:	e8 19 00 00 00       	call   8004ad <exit>
}
  800494:	90                   	nop
  800495:	c9                   	leave  
  800496:	c3                   	ret    

00800497 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80049d:	83 ec 0c             	sub    $0xc,%esp
  8004a0:	6a 00                	push   $0x0
  8004a2:	e8 b1 19 00 00       	call   801e58 <sys_destroy_env>
  8004a7:	83 c4 10             	add    $0x10,%esp
}
  8004aa:	90                   	nop
  8004ab:	c9                   	leave  
  8004ac:	c3                   	ret    

008004ad <exit>:

void
exit(void)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004b3:	e8 06 1a 00 00       	call   801ebe <sys_exit_env>
}
  8004b8:	90                   	nop
  8004b9:	c9                   	leave  
  8004ba:	c3                   	ret    

008004bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8004c4:	83 c0 04             	add    $0x4,%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ca:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	74 16                	je     8004e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004d3:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	50                   	push   %eax
  8004dc:	68 18 39 80 00       	push   $0x803918
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 50 80 00       	mov    0x805000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 1d 39 80 00       	push   $0x80391d
  8004fa:	e8 70 02 00 00       	call   80076f <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800502:	8b 45 10             	mov    0x10(%ebp),%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	ff 75 f4             	pushl  -0xc(%ebp)
  80050b:	50                   	push   %eax
  80050c:	e8 f3 01 00 00       	call   800704 <vcprintf>
  800511:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	6a 00                	push   $0x0
  800519:	68 39 39 80 00       	push   $0x803939
  80051e:	e8 e1 01 00 00       	call   800704 <vcprintf>
  800523:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800526:	e8 82 ff ff ff       	call   8004ad <exit>

	// should not return here
	while (1) ;
  80052b:	eb fe                	jmp    80052b <_panic+0x70>

0080052d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800533:	a1 20 50 80 00       	mov    0x805020,%eax
  800538:	8b 50 74             	mov    0x74(%eax),%edx
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 14                	je     800556 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 3c 39 80 00       	push   $0x80393c
  80054a:	6a 26                	push   $0x26
  80054c:	68 88 39 80 00       	push   $0x803988
  800551:	e8 65 ff ff ff       	call   8004bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80055d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800564:	e9 c2 00 00 00       	jmp    80062b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	85 c0                	test   %eax,%eax
  80057c:	75 08                	jne    800586 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80057e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800581:	e9 a2 00 00 00       	jmp    800628 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800586:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800594:	eb 69                	jmp    8005ff <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800596:	a1 20 50 80 00       	mov    0x805020,%eax
  80059b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	01 c0                	add    %eax,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	c1 e0 03             	shl    $0x3,%eax
  8005ad:	01 c8                	add    %ecx,%eax
  8005af:	8a 40 04             	mov    0x4(%eax),%al
  8005b2:	84 c0                	test   %al,%al
  8005b4:	75 46                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c4:	89 d0                	mov    %edx,%eax
  8005c6:	01 c0                	add    %eax,%eax
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 03             	shl    $0x3,%eax
  8005cd:	01 c8                	add    %ecx,%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005dc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ef:	39 c2                	cmp    %eax,%edx
  8005f1:	75 09                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005f3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005fa:	eb 12                	jmp    80060e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fc:	ff 45 e8             	incl   -0x18(%ebp)
  8005ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800604:	8b 50 74             	mov    0x74(%eax),%edx
  800607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	77 88                	ja     800596 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80060e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800612:	75 14                	jne    800628 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	68 94 39 80 00       	push   $0x803994
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 88 39 80 00       	push   $0x803988
  800623:	e8 93 fe ff ff       	call   8004bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800628:	ff 45 f0             	incl   -0x10(%ebp)
  80062b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800631:	0f 8c 32 ff ff ff    	jl     800569 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800637:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800645:	eb 26                	jmp    80066d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800647:	a1 20 50 80 00       	mov    0x805020,%eax
  80064c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800652:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	01 c0                	add    %eax,%eax
  800659:	01 d0                	add    %edx,%eax
  80065b:	c1 e0 03             	shl    $0x3,%eax
  80065e:	01 c8                	add    %ecx,%eax
  800660:	8a 40 04             	mov    0x4(%eax),%al
  800663:	3c 01                	cmp    $0x1,%al
  800665:	75 03                	jne    80066a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800667:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066a:	ff 45 e0             	incl   -0x20(%ebp)
  80066d:	a1 20 50 80 00       	mov    0x805020,%eax
  800672:	8b 50 74             	mov    0x74(%eax),%edx
  800675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800678:	39 c2                	cmp    %eax,%edx
  80067a:	77 cb                	ja     800647 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800682:	74 14                	je     800698 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	68 e8 39 80 00       	push   $0x8039e8
  80068c:	6a 44                	push   $0x44
  80068e:	68 88 39 80 00       	push   $0x803988
  800693:	e8 23 fe ff ff       	call   8004bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800698:	90                   	nop
  800699:	c9                   	leave  
  80069a:	c3                   	ret    

0080069b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80069b:	55                   	push   %ebp
  80069c:	89 e5                	mov    %esp,%ebp
  80069e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ac:	89 0a                	mov    %ecx,(%edx)
  8006ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b1:	88 d1                	mov    %dl,%cl
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c4:	75 2c                	jne    8006f2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006c6:	a0 24 50 80 00       	mov    0x805024,%al
  8006cb:	0f b6 c0             	movzbl %al,%eax
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	8b 12                	mov    (%edx),%edx
  8006d3:	89 d1                	mov    %edx,%ecx
  8006d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d8:	83 c2 08             	add    $0x8,%edx
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	50                   	push   %eax
  8006df:	51                   	push   %ecx
  8006e0:	52                   	push   %edx
  8006e1:	e8 05 14 00 00       	call   801aeb <sys_cputs>
  8006e6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f5:	8b 40 04             	mov    0x4(%eax),%eax
  8006f8:	8d 50 01             	lea    0x1(%eax),%edx
  8006fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fe:	89 50 04             	mov    %edx,0x4(%eax)
}
  800701:	90                   	nop
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800714:	00 00 00 
	b.cnt = 0;
  800717:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80071e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072d:	50                   	push   %eax
  80072e:	68 9b 06 80 00       	push   $0x80069b
  800733:	e8 11 02 00 00       	call   800949 <vprintfmt>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80073b:	a0 24 50 80 00       	mov    0x805024,%al
  800740:	0f b6 c0             	movzbl %al,%eax
  800743:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	50                   	push   %eax
  80074d:	52                   	push   %edx
  80074e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800754:	83 c0 08             	add    $0x8,%eax
  800757:	50                   	push   %eax
  800758:	e8 8e 13 00 00       	call   801aeb <sys_cputs>
  80075d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800760:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800767:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80076d:	c9                   	leave  
  80076e:	c3                   	ret    

0080076f <cprintf>:

int cprintf(const char *fmt, ...) {
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800775:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80077c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 f4             	pushl  -0xc(%ebp)
  80078b:	50                   	push   %eax
  80078c:	e8 73 ff ff ff       	call   800704 <vcprintf>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a2:	e8 f2 14 00 00       	call   801c99 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007a7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	50                   	push   %eax
  8007b7:	e8 48 ff ff ff       	call   800704 <vcprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007c2:	e8 ec 14 00 00       	call   801cb3 <sys_enable_interrupt>
	return cnt;
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    

008007cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	83 ec 14             	sub    $0x14,%esp
  8007d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007df:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ea:	77 55                	ja     800841 <printnum+0x75>
  8007ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ef:	72 05                	jb     8007f6 <printnum+0x2a>
  8007f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f4:	77 4b                	ja     800841 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	52                   	push   %edx
  800805:	50                   	push   %eax
  800806:	ff 75 f4             	pushl  -0xc(%ebp)
  800809:	ff 75 f0             	pushl  -0x10(%ebp)
  80080c:	e8 17 2b 00 00       	call   803328 <__udivdi3>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	83 ec 04             	sub    $0x4,%esp
  800817:	ff 75 20             	pushl  0x20(%ebp)
  80081a:	53                   	push   %ebx
  80081b:	ff 75 18             	pushl  0x18(%ebp)
  80081e:	52                   	push   %edx
  80081f:	50                   	push   %eax
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	ff 75 08             	pushl  0x8(%ebp)
  800826:	e8 a1 ff ff ff       	call   8007cc <printnum>
  80082b:	83 c4 20             	add    $0x20,%esp
  80082e:	eb 1a                	jmp    80084a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 20             	pushl  0x20(%ebp)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800841:	ff 4d 1c             	decl   0x1c(%ebp)
  800844:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800848:	7f e6                	jg     800830 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80084d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800858:	53                   	push   %ebx
  800859:	51                   	push   %ecx
  80085a:	52                   	push   %edx
  80085b:	50                   	push   %eax
  80085c:	e8 d7 2b 00 00       	call   803438 <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 54 3c 80 00       	add    $0x803c54,%eax
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f be c0             	movsbl %al,%eax
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	50                   	push   %eax
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
}
  80087d:	90                   	nop
  80087e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800881:	c9                   	leave  
  800882:	c3                   	ret    

00800883 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800886:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088a:	7e 1c                	jle    8008a8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 08             	lea    0x8(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 08             	sub    $0x8,%eax
  8008a1:	8b 50 04             	mov    0x4(%eax),%edx
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	eb 40                	jmp    8008e8 <getuint+0x65>
	else if (lflag)
  8008a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ac:	74 1e                	je     8008cc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	8d 50 04             	lea    0x4(%eax),%edx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	89 10                	mov    %edx,(%eax)
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	83 e8 04             	sub    $0x4,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	eb 1c                	jmp    8008e8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	8d 50 04             	lea    0x4(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 10                	mov    %edx,(%eax)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	83 e8 04             	sub    $0x4,%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f1:	7e 1c                	jle    80090f <getint+0x25>
		return va_arg(*ap, long long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 08             	lea    0x8(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 08             	sub    $0x8,%eax
  800908:	8b 50 04             	mov    0x4(%eax),%edx
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	eb 38                	jmp    800947 <getint+0x5d>
	else if (lflag)
  80090f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800913:	74 1a                	je     80092f <getint+0x45>
		return va_arg(*ap, long);
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	8d 50 04             	lea    0x4(%eax),%edx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	89 10                	mov    %edx,(%eax)
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	83 e8 04             	sub    $0x4,%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	99                   	cltd   
  80092d:	eb 18                	jmp    800947 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 50 04             	lea    0x4(%eax),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 10                	mov    %edx,(%eax)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	99                   	cltd   
}
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800951:	eb 17                	jmp    80096a <vprintfmt+0x21>
			if (ch == '\0')
  800953:	85 db                	test   %ebx,%ebx
  800955:	0f 84 af 03 00 00    	je     800d0a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	53                   	push   %ebx
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	ff d0                	call   *%eax
  800967:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096a:	8b 45 10             	mov    0x10(%ebp),%eax
  80096d:	8d 50 01             	lea    0x1(%eax),%edx
  800970:	89 55 10             	mov    %edx,0x10(%ebp)
  800973:	8a 00                	mov    (%eax),%al
  800975:	0f b6 d8             	movzbl %al,%ebx
  800978:	83 fb 25             	cmp    $0x25,%ebx
  80097b:	75 d6                	jne    800953 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800981:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800988:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80098f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800996:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099d:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a0:	8d 50 01             	lea    0x1(%eax),%edx
  8009a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	0f b6 d8             	movzbl %al,%ebx
  8009ab:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ae:	83 f8 55             	cmp    $0x55,%eax
  8009b1:	0f 87 2b 03 00 00    	ja     800ce2 <vprintfmt+0x399>
  8009b7:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
  8009be:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c4:	eb d7                	jmp    80099d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ca:	eb d1                	jmp    80099d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d6:	89 d0                	mov    %edx,%eax
  8009d8:	c1 e0 02             	shl    $0x2,%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	01 c0                	add    %eax,%eax
  8009df:	01 d8                	add    %ebx,%eax
  8009e1:	83 e8 30             	sub    $0x30,%eax
  8009e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ef:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f2:	7e 3e                	jle    800a32 <vprintfmt+0xe9>
  8009f4:	83 fb 39             	cmp    $0x39,%ebx
  8009f7:	7f 39                	jg     800a32 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009fc:	eb d5                	jmp    8009d3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	83 c0 04             	add    $0x4,%eax
  800a04:	89 45 14             	mov    %eax,0x14(%ebp)
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	83 e8 04             	sub    $0x4,%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a12:	eb 1f                	jmp    800a33 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a18:	79 83                	jns    80099d <vprintfmt+0x54>
				width = 0;
  800a1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a21:	e9 77 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a26:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a2d:	e9 6b ff ff ff       	jmp    80099d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a32:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a37:	0f 89 60 ff ff ff    	jns    80099d <vprintfmt+0x54>
				width = precision, precision = -1;
  800a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a43:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a4a:	e9 4e ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a4f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a52:	e9 46 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	83 c0 04             	add    $0x4,%eax
  800a5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 e8 04             	sub    $0x4,%eax
  800a66:	8b 00                	mov    (%eax),%eax
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	50                   	push   %eax
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			break;
  800a77:	e9 89 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a8d:	85 db                	test   %ebx,%ebx
  800a8f:	79 02                	jns    800a93 <vprintfmt+0x14a>
				err = -err;
  800a91:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a93:	83 fb 64             	cmp    $0x64,%ebx
  800a96:	7f 0b                	jg     800aa3 <vprintfmt+0x15a>
  800a98:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 65 3c 80 00       	push   $0x803c65
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	ff 75 08             	pushl  0x8(%ebp)
  800aaf:	e8 5e 02 00 00       	call   800d12 <printfmt>
  800ab4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab7:	e9 49 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800abc:	56                   	push   %esi
  800abd:	68 6e 3c 80 00       	push   $0x803c6e
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	ff 75 08             	pushl  0x8(%ebp)
  800ac8:	e8 45 02 00 00       	call   800d12 <printfmt>
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	e9 30 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 c0 04             	add    $0x4,%eax
  800adb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	83 e8 04             	sub    $0x4,%eax
  800ae4:	8b 30                	mov    (%eax),%esi
  800ae6:	85 f6                	test   %esi,%esi
  800ae8:	75 05                	jne    800aef <vprintfmt+0x1a6>
				p = "(null)";
  800aea:	be 71 3c 80 00       	mov    $0x803c71,%esi
			if (width > 0 && padc != '-')
  800aef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af3:	7e 6d                	jle    800b62 <vprintfmt+0x219>
  800af5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800af9:	74 67                	je     800b62 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	50                   	push   %eax
  800b02:	56                   	push   %esi
  800b03:	e8 0c 03 00 00       	call   800e14 <strnlen>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b0e:	eb 16                	jmp    800b26 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b10:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	50                   	push   %eax
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	ff d0                	call   *%eax
  800b20:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b23:	ff 4d e4             	decl   -0x1c(%ebp)
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7f e4                	jg     800b10 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2c:	eb 34                	jmp    800b62 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b32:	74 1c                	je     800b50 <vprintfmt+0x207>
  800b34:	83 fb 1f             	cmp    $0x1f,%ebx
  800b37:	7e 05                	jle    800b3e <vprintfmt+0x1f5>
  800b39:	83 fb 7e             	cmp    $0x7e,%ebx
  800b3c:	7e 12                	jle    800b50 <vprintfmt+0x207>
					putch('?', putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	6a 3f                	push   $0x3f
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	eb 0f                	jmp    800b5f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	53                   	push   %ebx
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	89 f0                	mov    %esi,%eax
  800b64:	8d 70 01             	lea    0x1(%eax),%esi
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	0f be d8             	movsbl %al,%ebx
  800b6c:	85 db                	test   %ebx,%ebx
  800b6e:	74 24                	je     800b94 <vprintfmt+0x24b>
  800b70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b74:	78 b8                	js     800b2e <vprintfmt+0x1e5>
  800b76:	ff 4d e0             	decl   -0x20(%ebp)
  800b79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7d:	79 af                	jns    800b2e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7f:	eb 13                	jmp    800b94 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 20                	push   $0x20
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b91:	ff 4d e4             	decl   -0x1c(%ebp)
  800b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b98:	7f e7                	jg     800b81 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b9a:	e9 66 01 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 3c fd ff ff       	call   8008ea <getint>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbd:	85 d2                	test   %edx,%edx
  800bbf:	79 23                	jns    800be4 <vprintfmt+0x29b>
				putch('-', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 2d                	push   $0x2d
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd7:	f7 d8                	neg    %eax
  800bd9:	83 d2 00             	adc    $0x0,%edx
  800bdc:	f7 da                	neg    %edx
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800beb:	e9 bc 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf6:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf9:	50                   	push   %eax
  800bfa:	e8 84 fc ff ff       	call   800883 <getuint>
  800bff:	83 c4 10             	add    $0x10,%esp
  800c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0f:	e9 98 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	6a 58                	push   $0x58
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	ff d0                	call   *%eax
  800c21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	6a 58                	push   $0x58
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	6a 58                	push   $0x58
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
			break;
  800c44:	e9 bc 00 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 30                	push   $0x30
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	6a 78                	push   $0x78
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	ff d0                	call   *%eax
  800c66:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c8b:	eb 1f                	jmp    800cac <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	ff 75 e8             	pushl  -0x18(%ebp)
  800c93:	8d 45 14             	lea    0x14(%ebp),%eax
  800c96:	50                   	push   %eax
  800c97:	e8 e7 fb ff ff       	call   800883 <getuint>
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ca5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	52                   	push   %edx
  800cb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbe:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	ff 75 08             	pushl  0x8(%ebp)
  800cc7:	e8 00 fb ff ff       	call   8007cc <printnum>
  800ccc:	83 c4 20             	add    $0x20,%esp
			break;
  800ccf:	eb 34                	jmp    800d05 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	53                   	push   %ebx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	ff d0                	call   *%eax
  800cdd:	83 c4 10             	add    $0x10,%esp
			break;
  800ce0:	eb 23                	jmp    800d05 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	6a 25                	push   $0x25
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf2:	ff 4d 10             	decl   0x10(%ebp)
  800cf5:	eb 03                	jmp    800cfa <vprintfmt+0x3b1>
  800cf7:	ff 4d 10             	decl   0x10(%ebp)
  800cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfd:	48                   	dec    %eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	3c 25                	cmp    $0x25,%al
  800d02:	75 f3                	jne    800cf7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d04:	90                   	nop
		}
	}
  800d05:	e9 47 fc ff ff       	jmp    800951 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d0a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d18:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1b:	83 c0 04             	add    $0x4,%eax
  800d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	ff 75 f4             	pushl  -0xc(%ebp)
  800d27:	50                   	push   %eax
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	ff 75 08             	pushl  0x8(%ebp)
  800d2e:	e8 16 fc ff ff       	call   800949 <vprintfmt>
  800d33:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d36:	90                   	nop
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 08             	mov    0x8(%eax),%eax
  800d42:	8d 50 01             	lea    0x1(%eax),%edx
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8b 10                	mov    (%eax),%edx
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8b 40 04             	mov    0x4(%eax),%eax
  800d56:	39 c2                	cmp    %eax,%edx
  800d58:	73 12                	jae    800d6c <sprintputch+0x33>
		*b->buf++ = ch;
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d65:	89 0a                	mov    %ecx,(%edx)
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	88 10                	mov    %dl,(%eax)
}
  800d6c:	90                   	nop
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	01 d0                	add    %edx,%eax
  800d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d94:	74 06                	je     800d9c <vsnprintf+0x2d>
  800d96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9a:	7f 07                	jg     800da3 <vsnprintf+0x34>
		return -E_INVAL;
  800d9c:	b8 03 00 00 00       	mov    $0x3,%eax
  800da1:	eb 20                	jmp    800dc3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800da3:	ff 75 14             	pushl  0x14(%ebp)
  800da6:	ff 75 10             	pushl  0x10(%ebp)
  800da9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dac:	50                   	push   %eax
  800dad:	68 39 0d 80 00       	push   $0x800d39
  800db2:	e8 92 fb ff ff       	call   800949 <vprintfmt>
  800db7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dbd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dce:	83 c0 04             	add    $0x4,%eax
  800dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dda:	50                   	push   %eax
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	ff 75 08             	pushl  0x8(%ebp)
  800de1:	e8 89 ff ff ff       	call   800d6f <vsnprintf>
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800df7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dfe:	eb 06                	jmp    800e06 <strlen+0x15>
		n++;
  800e00:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e03:	ff 45 08             	incl   0x8(%ebp)
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	84 c0                	test   %al,%al
  800e0d:	75 f1                	jne    800e00 <strlen+0xf>
		n++;
	return n;
  800e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e12:	c9                   	leave  
  800e13:	c3                   	ret    

00800e14 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e21:	eb 09                	jmp    800e2c <strnlen+0x18>
		n++;
  800e23:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e26:	ff 45 08             	incl   0x8(%ebp)
  800e29:	ff 4d 0c             	decl   0xc(%ebp)
  800e2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e30:	74 09                	je     800e3b <strnlen+0x27>
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	84 c0                	test   %al,%al
  800e39:	75 e8                	jne    800e23 <strnlen+0xf>
		n++;
	return n;
  800e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e4c:	90                   	nop
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 08             	mov    %edx,0x8(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e5f:	8a 12                	mov    (%edx),%dl
  800e61:	88 10                	mov    %dl,(%eax)
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	75 e4                	jne    800e4d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e81:	eb 1f                	jmp    800ea2 <strncpy+0x34>
		*dst++ = *src;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8d 50 01             	lea    0x1(%eax),%edx
  800e89:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	84 c0                	test   %al,%al
  800e9a:	74 03                	je     800e9f <strncpy+0x31>
			src++;
  800e9c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ea8:	72 d9                	jb     800e83 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebf:	74 30                	je     800ef1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ec1:	eb 16                	jmp    800ed9 <strlcpy+0x2a>
			*dst++ = *src++;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed5:	8a 12                	mov    (%edx),%dl
  800ed7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ed9:	ff 4d 10             	decl   0x10(%ebp)
  800edc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee0:	74 09                	je     800eeb <strlcpy+0x3c>
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 d8                	jne    800ec3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 d0                	mov    %edx,%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f00:	eb 06                	jmp    800f08 <strcmp+0xb>
		p++, q++;
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	74 0e                	je     800f1f <strcmp+0x22>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 10                	mov    (%eax),%dl
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	38 c2                	cmp    %al,%dl
  800f1d:	74 e3                	je     800f02 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 d0             	movzbl %al,%edx
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 c0             	movzbl %al,%eax
  800f2f:	29 c2                	sub    %eax,%edx
  800f31:	89 d0                	mov    %edx,%eax
}
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f38:	eb 09                	jmp    800f43 <strncmp+0xe>
		n--, p++, q++;
  800f3a:	ff 4d 10             	decl   0x10(%ebp)
  800f3d:	ff 45 08             	incl   0x8(%ebp)
  800f40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	74 17                	je     800f60 <strncmp+0x2b>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	84 c0                	test   %al,%al
  800f50:	74 0e                	je     800f60 <strncmp+0x2b>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 10                	mov    (%eax),%dl
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	38 c2                	cmp    %al,%dl
  800f5e:	74 da                	je     800f3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	75 07                	jne    800f6d <strncmp+0x38>
		return 0;
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	eb 14                	jmp    800f81 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 d0             	movzbl %al,%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	0f b6 c0             	movzbl %al,%eax
  800f7d:	29 c2                	sub    %eax,%edx
  800f7f:	89 d0                	mov    %edx,%eax
}
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8f:	eb 12                	jmp    800fa3 <strchr+0x20>
		if (*s == c)
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f99:	75 05                	jne    800fa0 <strchr+0x1d>
			return (char *) s;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	eb 11                	jmp    800fb1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	84 c0                	test   %al,%al
  800faa:	75 e5                	jne    800f91 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbf:	eb 0d                	jmp    800fce <strfind+0x1b>
		if (*s == c)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc9:	74 0e                	je     800fd9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fcb:	ff 45 08             	incl   0x8(%ebp)
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	84 c0                	test   %al,%al
  800fd5:	75 ea                	jne    800fc1 <strfind+0xe>
  800fd7:	eb 01                	jmp    800fda <strfind+0x27>
		if (*s == c)
			break;
  800fd9:	90                   	nop
	return (char *) s;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ff1:	eb 0e                	jmp    801001 <memset+0x22>
		*p++ = c;
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8d 50 01             	lea    0x1(%eax),%edx
  800ff9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fff:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801001:	ff 4d f8             	decl   -0x8(%ebp)
  801004:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801008:	79 e9                	jns    800ff3 <memset+0x14>
		*p++ = c;

	return v;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801021:	eb 16                	jmp    801039 <memcpy+0x2a>
		*d++ = *s++;
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801032:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801035:	8a 12                	mov    (%edx),%dl
  801037:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103f:	89 55 10             	mov    %edx,0x10(%ebp)
  801042:	85 c0                	test   %eax,%eax
  801044:	75 dd                	jne    801023 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801063:	73 50                	jae    8010b5 <memmove+0x6a>
  801065:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801068:	8b 45 10             	mov    0x10(%ebp),%eax
  80106b:	01 d0                	add    %edx,%eax
  80106d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801070:	76 43                	jbe    8010b5 <memmove+0x6a>
		s += n;
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80107e:	eb 10                	jmp    801090 <memmove+0x45>
			*--d = *--s;
  801080:	ff 4d f8             	decl   -0x8(%ebp)
  801083:	ff 4d fc             	decl   -0x4(%ebp)
  801086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801089:	8a 10                	mov    (%eax),%dl
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	8d 50 ff             	lea    -0x1(%eax),%edx
  801096:	89 55 10             	mov    %edx,0x10(%ebp)
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 e3                	jne    801080 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80109d:	eb 23                	jmp    8010c2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80109f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b1:	8a 12                	mov    (%edx),%dl
  8010b3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	75 dd                	jne    80109f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010d9:	eb 2a                	jmp    801105 <memcmp+0x3e>
		if (*s1 != *s2)
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8a 10                	mov    (%eax),%dl
  8010e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	38 c2                	cmp    %al,%dl
  8010e7:	74 16                	je     8010ff <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	0f b6 d0             	movzbl %al,%edx
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	0f b6 c0             	movzbl %al,%eax
  8010f9:	29 c2                	sub    %eax,%edx
  8010fb:	89 d0                	mov    %edx,%eax
  8010fd:	eb 18                	jmp    801117 <memcmp+0x50>
		s1++, s2++;
  8010ff:	ff 45 fc             	incl   -0x4(%ebp)
  801102:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110b:	89 55 10             	mov    %edx,0x10(%ebp)
  80110e:	85 c0                	test   %eax,%eax
  801110:	75 c9                	jne    8010db <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801112:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	8b 45 10             	mov    0x10(%ebp),%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80112a:	eb 15                	jmp    801141 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d0             	movzbl %al,%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	0f b6 c0             	movzbl %al,%eax
  80113a:	39 c2                	cmp    %eax,%edx
  80113c:	74 0d                	je     80114b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801147:	72 e3                	jb     80112c <memfind+0x13>
  801149:	eb 01                	jmp    80114c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80114b:	90                   	nop
	return (void *) s;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801165:	eb 03                	jmp    80116a <strtol+0x19>
		s++;
  801167:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 20                	cmp    $0x20,%al
  801171:	74 f4                	je     801167 <strtol+0x16>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 09                	cmp    $0x9,%al
  80117a:	74 eb                	je     801167 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 2b                	cmp    $0x2b,%al
  801183:	75 05                	jne    80118a <strtol+0x39>
		s++;
  801185:	ff 45 08             	incl   0x8(%ebp)
  801188:	eb 13                	jmp    80119d <strtol+0x4c>
	else if (*s == '-')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 2d                	cmp    $0x2d,%al
  801191:	75 0a                	jne    80119d <strtol+0x4c>
		s++, neg = 1;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80119d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a1:	74 06                	je     8011a9 <strtol+0x58>
  8011a3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011a7:	75 20                	jne    8011c9 <strtol+0x78>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3c 30                	cmp    $0x30,%al
  8011b0:	75 17                	jne    8011c9 <strtol+0x78>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	40                   	inc    %eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 78                	cmp    $0x78,%al
  8011ba:	75 0d                	jne    8011c9 <strtol+0x78>
		s += 2, base = 16;
  8011bc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011c7:	eb 28                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cd:	75 15                	jne    8011e4 <strtol+0x93>
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 30                	cmp    $0x30,%al
  8011d6:	75 0c                	jne    8011e4 <strtol+0x93>
		s++, base = 8;
  8011d8:	ff 45 08             	incl   0x8(%ebp)
  8011db:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011e2:	eb 0d                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0)
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 07                	jne    8011f1 <strtol+0xa0>
		base = 10;
  8011ea:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 2f                	cmp    $0x2f,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xc2>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 39                	cmp    $0x39,%al
  801201:	7f 10                	jg     801213 <strtol+0xc2>
			dig = *s - '0';
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 30             	sub    $0x30,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 42                	jmp    801255 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 60                	cmp    $0x60,%al
  80121a:	7e 19                	jle    801235 <strtol+0xe4>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 7a                	cmp    $0x7a,%al
  801223:	7f 10                	jg     801235 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 57             	sub    $0x57,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801233:	eb 20                	jmp    801255 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 40                	cmp    $0x40,%al
  80123c:	7e 39                	jle    801277 <strtol+0x126>
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 5a                	cmp    $0x5a,%al
  801245:	7f 30                	jg     801277 <strtol+0x126>
			dig = *s - 'A' + 10;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	0f be c0             	movsbl %al,%eax
  80124f:	83 e8 37             	sub    $0x37,%eax
  801252:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	3b 45 10             	cmp    0x10(%ebp),%eax
  80125b:	7d 19                	jge    801276 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80125d:	ff 45 08             	incl   0x8(%ebp)
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801263:	0f af 45 10          	imul   0x10(%ebp),%eax
  801267:	89 c2                	mov    %eax,%edx
  801269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801271:	e9 7b ff ff ff       	jmp    8011f1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801276:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801277:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127b:	74 08                	je     801285 <strtol+0x134>
		*endptr = (char *) s;
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	8b 55 08             	mov    0x8(%ebp),%edx
  801283:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801285:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801289:	74 07                	je     801292 <strtol+0x141>
  80128b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128e:	f7 d8                	neg    %eax
  801290:	eb 03                	jmp    801295 <strtol+0x144>
  801292:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <ltostr>:

void
ltostr(long value, char *str)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80129d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012af:	79 13                	jns    8012c4 <ltostr+0x2d>
	{
		neg = 1;
  8012b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012be:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012c1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012cc:	99                   	cltd   
  8012cd:	f7 f9                	idiv   %ecx
  8012cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012e5:	83 c2 30             	add    $0x30,%edx
  8012e8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f2:	f7 e9                	imul   %ecx
  8012f4:	c1 fa 02             	sar    $0x2,%edx
  8012f7:	89 c8                	mov    %ecx,%eax
  8012f9:	c1 f8 1f             	sar    $0x1f,%eax
  8012fc:	29 c2                	sub    %eax,%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801306:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130b:	f7 e9                	imul   %ecx
  80130d:	c1 fa 02             	sar    $0x2,%edx
  801310:	89 c8                	mov    %ecx,%eax
  801312:	c1 f8 1f             	sar    $0x1f,%eax
  801315:	29 c2                	sub    %eax,%edx
  801317:	89 d0                	mov    %edx,%eax
  801319:	c1 e0 02             	shl    $0x2,%eax
  80131c:	01 d0                	add    %edx,%eax
  80131e:	01 c0                	add    %eax,%eax
  801320:	29 c1                	sub    %eax,%ecx
  801322:	89 ca                	mov    %ecx,%edx
  801324:	85 d2                	test   %edx,%edx
  801326:	75 9c                	jne    8012c4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801332:	48                   	dec    %eax
  801333:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801336:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80133a:	74 3d                	je     801379 <ltostr+0xe2>
		start = 1 ;
  80133c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801343:	eb 34                	jmp    801379 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	01 c8                	add    %ecx,%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	01 c2                	add    %eax,%edx
  80136e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801371:	88 02                	mov    %al,(%edx)
		start++ ;
  801373:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801376:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80137f:	7c c4                	jl     801345 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801381:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 d0                	add    %edx,%eax
  801389:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80138c:	90                   	nop
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 54 fa ff ff       	call   800df1 <strlen>
  80139d:	83 c4 04             	add    $0x4,%esp
  8013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	e8 46 fa ff ff       	call   800df1 <strlen>
  8013ab:	83 c4 04             	add    $0x4,%esp
  8013ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013bf:	eb 17                	jmp    8013d8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	01 c2                	add    %eax,%edx
  8013c9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	01 c8                	add    %ecx,%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013d5:	ff 45 fc             	incl   -0x4(%ebp)
  8013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013de:	7c e1                	jl     8013c1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013ee:	eb 1f                	jmp    80140f <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f3:	8d 50 01             	lea    0x1(%eax),%edx
  8013f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013f9:	89 c2                	mov    %eax,%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80140c:	ff 45 f8             	incl   -0x8(%ebp)
  80140f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801412:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801415:	7c d9                	jl     8013f0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801417:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141a:	8b 45 10             	mov    0x10(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	c6 00 00             	movb   $0x0,(%eax)
}
  801422:	90                   	nop
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801428:	8b 45 14             	mov    0x14(%ebp),%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801431:	8b 45 14             	mov    0x14(%ebp),%eax
  801434:	8b 00                	mov    (%eax),%eax
  801436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80143d:	8b 45 10             	mov    0x10(%ebp),%eax
  801440:	01 d0                	add    %edx,%eax
  801442:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801448:	eb 0c                	jmp    801456 <strsplit+0x31>
			*string++ = 0;
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 08             	mov    %edx,0x8(%ebp)
  801453:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	74 18                	je     801477 <strsplit+0x52>
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	0f be c0             	movsbl %al,%eax
  801467:	50                   	push   %eax
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	e8 13 fb ff ff       	call   800f83 <strchr>
  801470:	83 c4 08             	add    $0x8,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	75 d3                	jne    80144a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	84 c0                	test   %al,%al
  80147e:	74 5a                	je     8014da <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801480:	8b 45 14             	mov    0x14(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	83 f8 0f             	cmp    $0xf,%eax
  801488:	75 07                	jne    801491 <strsplit+0x6c>
		{
			return 0;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	eb 66                	jmp    8014f7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801491:	8b 45 14             	mov    0x14(%ebp),%eax
  801494:	8b 00                	mov    (%eax),%eax
  801496:	8d 48 01             	lea    0x1(%eax),%ecx
  801499:	8b 55 14             	mov    0x14(%ebp),%edx
  80149c:	89 0a                	mov    %ecx,(%edx)
  80149e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a8:	01 c2                	add    %eax,%edx
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014af:	eb 03                	jmp    8014b4 <strsplit+0x8f>
			string++;
  8014b1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	84 c0                	test   %al,%al
  8014bb:	74 8b                	je     801448 <strsplit+0x23>
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	0f be c0             	movsbl %al,%eax
  8014c5:	50                   	push   %eax
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	e8 b5 fa ff ff       	call   800f83 <strchr>
  8014ce:	83 c4 08             	add    $0x8,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	74 dc                	je     8014b1 <strsplit+0x8c>
			string++;
	}
  8014d5:	e9 6e ff ff ff       	jmp    801448 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014da:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014db:	8b 45 14             	mov    0x14(%ebp),%eax
  8014de:	8b 00                	mov    (%eax),%eax
  8014e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014ff:	a1 04 50 80 00       	mov    0x805004,%eax
  801504:	85 c0                	test   %eax,%eax
  801506:	74 1f                	je     801527 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801508:	e8 1d 00 00 00       	call   80152a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80150d:	83 ec 0c             	sub    $0xc,%esp
  801510:	68 d0 3d 80 00       	push   $0x803dd0
  801515:	e8 55 f2 ff ff       	call   80076f <cprintf>
  80151a:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80151d:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801524:	00 00 00 
	}
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801530:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801537:	00 00 00 
  80153a:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801541:	00 00 00 
  801544:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80154b:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80154e:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801555:	00 00 00 
  801558:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80155f:	00 00 00 
  801562:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801569:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80156c:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801576:	c1 e8 0c             	shr    $0xc,%eax
  801579:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80157e:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801588:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80158d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801592:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801597:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80159e:	a1 20 51 80 00       	mov    0x805120,%eax
  8015a3:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8015a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8015aa:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8015b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b7:	01 d0                	add    %edx,%eax
  8015b9:	48                   	dec    %eax
  8015ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c5:	f7 75 e4             	divl   -0x1c(%ebp)
  8015c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015cb:	29 d0                	sub    %edx,%eax
  8015cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8015d0:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8015d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	6a 07                	push   $0x7
  8015e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ec:	50                   	push   %eax
  8015ed:	e8 3d 06 00 00       	call   801c2f <sys_allocate_chunk>
  8015f2:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015f5:	a1 20 51 80 00       	mov    0x805120,%eax
  8015fa:	83 ec 0c             	sub    $0xc,%esp
  8015fd:	50                   	push   %eax
  8015fe:	e8 b2 0c 00 00       	call   8022b5 <initialize_MemBlocksList>
  801603:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801606:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80160b:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  80160e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801612:	0f 84 f3 00 00 00    	je     80170b <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801618:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80161c:	75 14                	jne    801632 <initialize_dyn_block_system+0x108>
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	68 f5 3d 80 00       	push   $0x803df5
  801626:	6a 36                	push   $0x36
  801628:	68 13 3e 80 00       	push   $0x803e13
  80162d:	e8 89 ee ff ff       	call   8004bb <_panic>
  801632:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801635:	8b 00                	mov    (%eax),%eax
  801637:	85 c0                	test   %eax,%eax
  801639:	74 10                	je     80164b <initialize_dyn_block_system+0x121>
  80163b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80163e:	8b 00                	mov    (%eax),%eax
  801640:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801643:	8b 52 04             	mov    0x4(%edx),%edx
  801646:	89 50 04             	mov    %edx,0x4(%eax)
  801649:	eb 0b                	jmp    801656 <initialize_dyn_block_system+0x12c>
  80164b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80164e:	8b 40 04             	mov    0x4(%eax),%eax
  801651:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801656:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801659:	8b 40 04             	mov    0x4(%eax),%eax
  80165c:	85 c0                	test   %eax,%eax
  80165e:	74 0f                	je     80166f <initialize_dyn_block_system+0x145>
  801660:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801663:	8b 40 04             	mov    0x4(%eax),%eax
  801666:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801669:	8b 12                	mov    (%edx),%edx
  80166b:	89 10                	mov    %edx,(%eax)
  80166d:	eb 0a                	jmp    801679 <initialize_dyn_block_system+0x14f>
  80166f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801672:	8b 00                	mov    (%eax),%eax
  801674:	a3 48 51 80 00       	mov    %eax,0x805148
  801679:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80167c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801682:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801685:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80168c:	a1 54 51 80 00       	mov    0x805154,%eax
  801691:	48                   	dec    %eax
  801692:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801697:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80169a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8016a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016a4:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8016ab:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8016af:	75 14                	jne    8016c5 <initialize_dyn_block_system+0x19b>
  8016b1:	83 ec 04             	sub    $0x4,%esp
  8016b4:	68 20 3e 80 00       	push   $0x803e20
  8016b9:	6a 3e                	push   $0x3e
  8016bb:	68 13 3e 80 00       	push   $0x803e13
  8016c0:	e8 f6 ed ff ff       	call   8004bb <_panic>
  8016c5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8016cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016ce:	89 10                	mov    %edx,(%eax)
  8016d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016d3:	8b 00                	mov    (%eax),%eax
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	74 0d                	je     8016e6 <initialize_dyn_block_system+0x1bc>
  8016d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8016de:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8016e1:	89 50 04             	mov    %edx,0x4(%eax)
  8016e4:	eb 08                	jmp    8016ee <initialize_dyn_block_system+0x1c4>
  8016e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8016ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8016f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801700:	a1 44 51 80 00       	mov    0x805144,%eax
  801705:	40                   	inc    %eax
  801706:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  80170b:	90                   	nop
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801714:	e8 e0 fd ff ff       	call   8014f9 <InitializeUHeap>
		if (size == 0) return NULL ;
  801719:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80171d:	75 07                	jne    801726 <malloc+0x18>
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
  801724:	eb 7f                	jmp    8017a5 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801726:	e8 d2 08 00 00       	call   801ffd <sys_isUHeapPlacementStrategyFIRSTFIT>
  80172b:	85 c0                	test   %eax,%eax
  80172d:	74 71                	je     8017a0 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80172f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801736:	8b 55 08             	mov    0x8(%ebp),%edx
  801739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173c:	01 d0                	add    %edx,%eax
  80173e:	48                   	dec    %eax
  80173f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801745:	ba 00 00 00 00       	mov    $0x0,%edx
  80174a:	f7 75 f4             	divl   -0xc(%ebp)
  80174d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801750:	29 d0                	sub    %edx,%eax
  801752:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801755:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80175c:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801763:	76 07                	jbe    80176c <malloc+0x5e>
					return NULL ;
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
  80176a:	eb 39                	jmp    8017a5 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	e8 e6 0d 00 00       	call   80255d <alloc_block_FF>
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  80177d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801781:	74 16                	je     801799 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801783:	83 ec 0c             	sub    $0xc,%esp
  801786:	ff 75 ec             	pushl  -0x14(%ebp)
  801789:	e8 37 0c 00 00       	call   8023c5 <insert_sorted_allocList>
  80178e:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801794:	8b 40 08             	mov    0x8(%eax),%eax
  801797:	eb 0c                	jmp    8017a5 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
  80179e:	eb 05                	jmp    8017a5 <malloc+0x97>
				}
		}
	return 0;
  8017a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8017b3:	83 ec 08             	sub    $0x8,%esp
  8017b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b9:	68 40 50 80 00       	push   $0x805040
  8017be:	e8 cf 0b 00 00       	call   802392 <find_block>
  8017c3:	83 c4 10             	add    $0x10,%esp
  8017c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8017c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8017d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d5:	8b 40 08             	mov    0x8(%eax),%eax
  8017d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8017db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017df:	0f 84 a1 00 00 00    	je     801886 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8017e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017e9:	75 17                	jne    801802 <free+0x5b>
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	68 f5 3d 80 00       	push   $0x803df5
  8017f3:	68 80 00 00 00       	push   $0x80
  8017f8:	68 13 3e 80 00       	push   $0x803e13
  8017fd:	e8 b9 ec ff ff       	call   8004bb <_panic>
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	8b 00                	mov    (%eax),%eax
  801807:	85 c0                	test   %eax,%eax
  801809:	74 10                	je     80181b <free+0x74>
  80180b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180e:	8b 00                	mov    (%eax),%eax
  801810:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801813:	8b 52 04             	mov    0x4(%edx),%edx
  801816:	89 50 04             	mov    %edx,0x4(%eax)
  801819:	eb 0b                	jmp    801826 <free+0x7f>
  80181b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181e:	8b 40 04             	mov    0x4(%eax),%eax
  801821:	a3 44 50 80 00       	mov    %eax,0x805044
  801826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801829:	8b 40 04             	mov    0x4(%eax),%eax
  80182c:	85 c0                	test   %eax,%eax
  80182e:	74 0f                	je     80183f <free+0x98>
  801830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801833:	8b 40 04             	mov    0x4(%eax),%eax
  801836:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801839:	8b 12                	mov    (%edx),%edx
  80183b:	89 10                	mov    %edx,(%eax)
  80183d:	eb 0a                	jmp    801849 <free+0xa2>
  80183f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801842:	8b 00                	mov    (%eax),%eax
  801844:	a3 40 50 80 00       	mov    %eax,0x805040
  801849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80185c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801861:	48                   	dec    %eax
  801862:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801867:	83 ec 0c             	sub    $0xc,%esp
  80186a:	ff 75 f0             	pushl  -0x10(%ebp)
  80186d:	e8 29 12 00 00       	call   802a9b <insert_sorted_with_merge_freeList>
  801872:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801875:	83 ec 08             	sub    $0x8,%esp
  801878:	ff 75 ec             	pushl  -0x14(%ebp)
  80187b:	ff 75 e8             	pushl  -0x18(%ebp)
  80187e:	e8 74 03 00 00       	call   801bf7 <sys_free_user_mem>
  801883:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801886:	90                   	nop
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 38             	sub    $0x38,%esp
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801895:	e8 5f fc ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  80189a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80189e:	75 0a                	jne    8018aa <smalloc+0x21>
  8018a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a5:	e9 b2 00 00 00       	jmp    80195c <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8018aa:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8018b1:	76 0a                	jbe    8018bd <smalloc+0x34>
		return NULL;
  8018b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b8:	e9 9f 00 00 00       	jmp    80195c <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8018bd:	e8 3b 07 00 00       	call   801ffd <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	0f 84 8d 00 00 00    	je     801957 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8018ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8018d1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018de:	01 d0                	add    %edx,%eax
  8018e0:	48                   	dec    %eax
  8018e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ec:	f7 75 f0             	divl   -0x10(%ebp)
  8018ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018f2:	29 d0                	sub    %edx,%eax
  8018f4:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8018f7:	83 ec 0c             	sub    $0xc,%esp
  8018fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8018fd:	e8 5b 0c 00 00       	call   80255d <alloc_block_FF>
  801902:	83 c4 10             	add    $0x10,%esp
  801905:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80190c:	75 07                	jne    801915 <smalloc+0x8c>
			return NULL;
  80190e:	b8 00 00 00 00       	mov    $0x0,%eax
  801913:	eb 47                	jmp    80195c <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801915:	83 ec 0c             	sub    $0xc,%esp
  801918:	ff 75 f4             	pushl  -0xc(%ebp)
  80191b:	e8 a5 0a 00 00       	call   8023c5 <insert_sorted_allocList>
  801920:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801926:	8b 40 08             	mov    0x8(%eax),%eax
  801929:	89 c2                	mov    %eax,%edx
  80192b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80192f:	52                   	push   %edx
  801930:	50                   	push   %eax
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	ff 75 08             	pushl  0x8(%ebp)
  801937:	e8 46 04 00 00       	call   801d82 <sys_createSharedObject>
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801942:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801946:	78 08                	js     801950 <smalloc+0xc7>
		return (void *)b->sva;
  801948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194b:	8b 40 08             	mov    0x8(%eax),%eax
  80194e:	eb 0c                	jmp    80195c <smalloc+0xd3>
		}else{
		return NULL;
  801950:	b8 00 00 00 00       	mov    $0x0,%eax
  801955:	eb 05                	jmp    80195c <smalloc+0xd3>
			}

	}return NULL;
  801957:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801964:	e8 90 fb ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801969:	e8 8f 06 00 00       	call   801ffd <sys_isUHeapPlacementStrategyFIRSTFIT>
  80196e:	85 c0                	test   %eax,%eax
  801970:	0f 84 ad 00 00 00    	je     801a23 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801976:	83 ec 08             	sub    $0x8,%esp
  801979:	ff 75 0c             	pushl  0xc(%ebp)
  80197c:	ff 75 08             	pushl  0x8(%ebp)
  80197f:	e8 28 04 00 00       	call   801dac <sys_getSizeOfSharedObject>
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  80198a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80198e:	79 0a                	jns    80199a <sget+0x3c>
    {
    	return NULL;
  801990:	b8 00 00 00 00       	mov    $0x0,%eax
  801995:	e9 8e 00 00 00       	jmp    801a28 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  80199a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8019a1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ae:	01 d0                	add    %edx,%eax
  8019b0:	48                   	dec    %eax
  8019b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019bc:	f7 75 ec             	divl   -0x14(%ebp)
  8019bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019c2:	29 d0                	sub    %edx,%eax
  8019c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8019c7:	83 ec 0c             	sub    $0xc,%esp
  8019ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019cd:	e8 8b 0b 00 00       	call   80255d <alloc_block_FF>
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8019d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019dc:	75 07                	jne    8019e5 <sget+0x87>
				return NULL;
  8019de:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e3:	eb 43                	jmp    801a28 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8019e5:	83 ec 0c             	sub    $0xc,%esp
  8019e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8019eb:	e8 d5 09 00 00       	call   8023c5 <insert_sorted_allocList>
  8019f0:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8019f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f6:	8b 40 08             	mov    0x8(%eax),%eax
  8019f9:	83 ec 04             	sub    $0x4,%esp
  8019fc:	50                   	push   %eax
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	ff 75 08             	pushl  0x8(%ebp)
  801a03:	e8 c1 03 00 00       	call   801dc9 <sys_getSharedObject>
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801a0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a12:	78 08                	js     801a1c <sget+0xbe>
			return (void *)b->sva;
  801a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a17:	8b 40 08             	mov    0x8(%eax),%eax
  801a1a:	eb 0c                	jmp    801a28 <sget+0xca>
			}else{
			return NULL;
  801a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a21:	eb 05                	jmp    801a28 <sget+0xca>
			}
    }}return NULL;
  801a23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a30:	e8 c4 fa ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	68 44 3e 80 00       	push   $0x803e44
  801a3d:	68 03 01 00 00       	push   $0x103
  801a42:	68 13 3e 80 00       	push   $0x803e13
  801a47:	e8 6f ea ff ff       	call   8004bb <_panic>

00801a4c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	68 6c 3e 80 00       	push   $0x803e6c
  801a5a:	68 17 01 00 00       	push   $0x117
  801a5f:	68 13 3e 80 00       	push   $0x803e13
  801a64:	e8 52 ea ff ff       	call   8004bb <_panic>

00801a69 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a6f:	83 ec 04             	sub    $0x4,%esp
  801a72:	68 90 3e 80 00       	push   $0x803e90
  801a77:	68 22 01 00 00       	push   $0x122
  801a7c:	68 13 3e 80 00       	push   $0x803e13
  801a81:	e8 35 ea ff ff       	call   8004bb <_panic>

00801a86 <shrink>:

}
void shrink(uint32 newSize)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	68 90 3e 80 00       	push   $0x803e90
  801a94:	68 27 01 00 00       	push   $0x127
  801a99:	68 13 3e 80 00       	push   $0x803e13
  801a9e:	e8 18 ea ff ff       	call   8004bb <_panic>

00801aa3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	68 90 3e 80 00       	push   $0x803e90
  801ab1:	68 2c 01 00 00       	push   $0x12c
  801ab6:	68 13 3e 80 00       	push   $0x803e13
  801abb:	e8 fb e9 ff ff       	call   8004bb <_panic>

00801ac0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	57                   	push   %edi
  801ac4:	56                   	push   %esi
  801ac5:	53                   	push   %ebx
  801ac6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ad8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801adb:	cd 30                	int    $0x30
  801add:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	5b                   	pop    %ebx
  801ae7:	5e                   	pop    %esi
  801ae8:	5f                   	pop    %edi
  801ae9:	5d                   	pop    %ebp
  801aea:	c3                   	ret    

00801aeb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801af7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	52                   	push   %edx
  801b03:	ff 75 0c             	pushl  0xc(%ebp)
  801b06:	50                   	push   %eax
  801b07:	6a 00                	push   $0x0
  801b09:	e8 b2 ff ff ff       	call   801ac0 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	90                   	nop
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 01                	push   $0x1
  801b23:	e8 98 ff ff ff       	call   801ac0 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	52                   	push   %edx
  801b3d:	50                   	push   %eax
  801b3e:	6a 05                	push   $0x5
  801b40:	e8 7b ff ff ff       	call   801ac0 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	56                   	push   %esi
  801b4e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b4f:	8b 75 18             	mov    0x18(%ebp),%esi
  801b52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
  801b60:	51                   	push   %ecx
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 06                	push   $0x6
  801b65:	e8 56 ff ff ff       	call   801ac0 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b70:	5b                   	pop    %ebx
  801b71:	5e                   	pop    %esi
  801b72:	5d                   	pop    %ebp
  801b73:	c3                   	ret    

00801b74 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	52                   	push   %edx
  801b84:	50                   	push   %eax
  801b85:	6a 07                	push   $0x7
  801b87:	e8 34 ff ff ff       	call   801ac0 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	6a 08                	push   $0x8
  801ba2:	e8 19 ff ff ff       	call   801ac0 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 09                	push   $0x9
  801bbb:	e8 00 ff ff ff       	call   801ac0 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 0a                	push   $0xa
  801bd4:	e8 e7 fe ff ff       	call   801ac0 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 0b                	push   $0xb
  801bed:	e8 ce fe ff ff       	call   801ac0 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	ff 75 0c             	pushl  0xc(%ebp)
  801c03:	ff 75 08             	pushl  0x8(%ebp)
  801c06:	6a 0f                	push   $0xf
  801c08:	e8 b3 fe ff ff       	call   801ac0 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
	return;
  801c10:	90                   	nop
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	ff 75 0c             	pushl  0xc(%ebp)
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	6a 10                	push   $0x10
  801c24:	e8 97 fe ff ff       	call   801ac0 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2c:	90                   	nop
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	ff 75 10             	pushl  0x10(%ebp)
  801c39:	ff 75 0c             	pushl  0xc(%ebp)
  801c3c:	ff 75 08             	pushl  0x8(%ebp)
  801c3f:	6a 11                	push   $0x11
  801c41:	e8 7a fe ff ff       	call   801ac0 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
	return ;
  801c49:	90                   	nop
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 0c                	push   $0xc
  801c5b:	e8 60 fe ff ff       	call   801ac0 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	ff 75 08             	pushl  0x8(%ebp)
  801c73:	6a 0d                	push   $0xd
  801c75:	e8 46 fe ff ff       	call   801ac0 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 0e                	push   $0xe
  801c8e:	e8 2d fe ff ff       	call   801ac0 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	90                   	nop
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 13                	push   $0x13
  801ca8:	e8 13 fe ff ff       	call   801ac0 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 14                	push   $0x14
  801cc2:	e8 f9 fd ff ff       	call   801ac0 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	90                   	nop
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_cputc>:


void
sys_cputc(const char c)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 04             	sub    $0x4,%esp
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cd9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	50                   	push   %eax
  801ce6:	6a 15                	push   $0x15
  801ce8:	e8 d3 fd ff ff       	call   801ac0 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	90                   	nop
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 16                	push   $0x16
  801d02:	e8 b9 fd ff ff       	call   801ac0 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	90                   	nop
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	ff 75 0c             	pushl  0xc(%ebp)
  801d1c:	50                   	push   %eax
  801d1d:	6a 17                	push   $0x17
  801d1f:	e8 9c fd ff ff       	call   801ac0 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	52                   	push   %edx
  801d39:	50                   	push   %eax
  801d3a:	6a 1a                	push   $0x1a
  801d3c:	e8 7f fd ff ff       	call   801ac0 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	52                   	push   %edx
  801d56:	50                   	push   %eax
  801d57:	6a 18                	push   $0x18
  801d59:	e8 62 fd ff ff       	call   801ac0 <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
}
  801d61:	90                   	nop
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	52                   	push   %edx
  801d74:	50                   	push   %eax
  801d75:	6a 19                	push   $0x19
  801d77:	e8 44 fd ff ff       	call   801ac0 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	90                   	nop
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 04             	sub    $0x4,%esp
  801d88:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d91:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	6a 00                	push   $0x0
  801d9a:	51                   	push   %ecx
  801d9b:	52                   	push   %edx
  801d9c:	ff 75 0c             	pushl  0xc(%ebp)
  801d9f:	50                   	push   %eax
  801da0:	6a 1b                	push   $0x1b
  801da2:	e8 19 fd ff ff       	call   801ac0 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	52                   	push   %edx
  801dbc:	50                   	push   %eax
  801dbd:	6a 1c                	push   $0x1c
  801dbf:	e8 fc fc ff ff       	call   801ac0 <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801dcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	51                   	push   %ecx
  801dda:	52                   	push   %edx
  801ddb:	50                   	push   %eax
  801ddc:	6a 1d                	push   $0x1d
  801dde:	e8 dd fc ff ff       	call   801ac0 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	52                   	push   %edx
  801df8:	50                   	push   %eax
  801df9:	6a 1e                	push   $0x1e
  801dfb:	e8 c0 fc ff ff       	call   801ac0 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 1f                	push   $0x1f
  801e14:	e8 a7 fc ff ff       	call   801ac0 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e21:	8b 45 08             	mov    0x8(%ebp),%eax
  801e24:	6a 00                	push   $0x0
  801e26:	ff 75 14             	pushl  0x14(%ebp)
  801e29:	ff 75 10             	pushl  0x10(%ebp)
  801e2c:	ff 75 0c             	pushl  0xc(%ebp)
  801e2f:	50                   	push   %eax
  801e30:	6a 20                	push   $0x20
  801e32:	e8 89 fc ff ff       	call   801ac0 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	50                   	push   %eax
  801e4b:	6a 21                	push   $0x21
  801e4d:	e8 6e fc ff ff       	call   801ac0 <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	90                   	nop
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	50                   	push   %eax
  801e67:	6a 22                	push   $0x22
  801e69:	e8 52 fc ff ff       	call   801ac0 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 02                	push   $0x2
  801e82:	e8 39 fc ff ff       	call   801ac0 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 03                	push   $0x3
  801e9b:	e8 20 fc ff ff       	call   801ac0 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 04                	push   $0x4
  801eb4:	e8 07 fc ff ff       	call   801ac0 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_exit_env>:


void sys_exit_env(void)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 23                	push   $0x23
  801ecd:	e8 ee fb ff ff       	call   801ac0 <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	90                   	nop
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ede:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ee1:	8d 50 04             	lea    0x4(%eax),%edx
  801ee4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	52                   	push   %edx
  801eee:	50                   	push   %eax
  801eef:	6a 24                	push   $0x24
  801ef1:	e8 ca fb ff ff       	call   801ac0 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
	return result;
  801ef9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801efc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f02:	89 01                	mov    %eax,(%ecx)
  801f04:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	c9                   	leave  
  801f0b:	c2 04 00             	ret    $0x4

00801f0e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	ff 75 10             	pushl  0x10(%ebp)
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	6a 12                	push   $0x12
  801f20:	e8 9b fb ff ff       	call   801ac0 <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
	return ;
  801f28:	90                   	nop
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_rcr2>:
uint32 sys_rcr2()
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 25                	push   $0x25
  801f3a:	e8 81 fb ff ff       	call   801ac0 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 04             	sub    $0x4,%esp
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f50:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	50                   	push   %eax
  801f5d:	6a 26                	push   $0x26
  801f5f:	e8 5c fb ff ff       	call   801ac0 <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
	return ;
  801f67:	90                   	nop
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <rsttst>:
void rsttst()
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 28                	push   $0x28
  801f79:	e8 42 fb ff ff       	call   801ac0 <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f81:	90                   	nop
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	83 ec 04             	sub    $0x4,%esp
  801f8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f90:	8b 55 18             	mov    0x18(%ebp),%edx
  801f93:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f97:	52                   	push   %edx
  801f98:	50                   	push   %eax
  801f99:	ff 75 10             	pushl  0x10(%ebp)
  801f9c:	ff 75 0c             	pushl  0xc(%ebp)
  801f9f:	ff 75 08             	pushl  0x8(%ebp)
  801fa2:	6a 27                	push   $0x27
  801fa4:	e8 17 fb ff ff       	call   801ac0 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fac:	90                   	nop
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <chktst>:
void chktst(uint32 n)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	ff 75 08             	pushl  0x8(%ebp)
  801fbd:	6a 29                	push   $0x29
  801fbf:	e8 fc fa ff ff       	call   801ac0 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc7:	90                   	nop
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <inctst>:

void inctst()
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 2a                	push   $0x2a
  801fd9:	e8 e2 fa ff ff       	call   801ac0 <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe1:	90                   	nop
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <gettst>:
uint32 gettst()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 2b                	push   $0x2b
  801ff3:	e8 c8 fa ff ff       	call   801ac0 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 2c                	push   $0x2c
  80200f:	e8 ac fa ff ff       	call   801ac0 <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
  802017:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80201a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80201e:	75 07                	jne    802027 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802020:	b8 01 00 00 00       	mov    $0x1,%eax
  802025:	eb 05                	jmp    80202c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 2c                	push   $0x2c
  802040:	e8 7b fa ff ff       	call   801ac0 <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
  802048:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80204b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80204f:	75 07                	jne    802058 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802051:	b8 01 00 00 00       	mov    $0x1,%eax
  802056:	eb 05                	jmp    80205d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802058:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 2c                	push   $0x2c
  802071:	e8 4a fa ff ff       	call   801ac0 <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
  802079:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80207c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802080:	75 07                	jne    802089 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802082:	b8 01 00 00 00       	mov    $0x1,%eax
  802087:	eb 05                	jmp    80208e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 2c                	push   $0x2c
  8020a2:	e8 19 fa ff ff       	call   801ac0 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
  8020aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020ad:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020b1:	75 07                	jne    8020ba <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b8:	eb 05                	jmp    8020bf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	ff 75 08             	pushl  0x8(%ebp)
  8020cf:	6a 2d                	push   $0x2d
  8020d1:	e8 ea f9 ff ff       	call   801ac0 <syscall>
  8020d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d9:	90                   	nop
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	6a 00                	push   $0x0
  8020ee:	53                   	push   %ebx
  8020ef:	51                   	push   %ecx
  8020f0:	52                   	push   %edx
  8020f1:	50                   	push   %eax
  8020f2:	6a 2e                	push   $0x2e
  8020f4:	e8 c7 f9 ff ff       	call   801ac0 <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
}
  8020fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802104:	8b 55 0c             	mov    0xc(%ebp),%edx
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	52                   	push   %edx
  802111:	50                   	push   %eax
  802112:	6a 2f                	push   $0x2f
  802114:	e8 a7 f9 ff ff       	call   801ac0 <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802124:	83 ec 0c             	sub    $0xc,%esp
  802127:	68 a0 3e 80 00       	push   $0x803ea0
  80212c:	e8 3e e6 ff ff       	call   80076f <cprintf>
  802131:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802134:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80213b:	83 ec 0c             	sub    $0xc,%esp
  80213e:	68 cc 3e 80 00       	push   $0x803ecc
  802143:	e8 27 e6 ff ff       	call   80076f <cprintf>
  802148:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80214b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80214f:	a1 38 51 80 00       	mov    0x805138,%eax
  802154:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802157:	eb 56                	jmp    8021af <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802159:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80215d:	74 1c                	je     80217b <print_mem_block_lists+0x5d>
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	8b 50 08             	mov    0x8(%eax),%edx
  802165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802168:	8b 48 08             	mov    0x8(%eax),%ecx
  80216b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216e:	8b 40 0c             	mov    0xc(%eax),%eax
  802171:	01 c8                	add    %ecx,%eax
  802173:	39 c2                	cmp    %eax,%edx
  802175:	73 04                	jae    80217b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802177:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217e:	8b 50 08             	mov    0x8(%eax),%edx
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	8b 40 0c             	mov    0xc(%eax),%eax
  802187:	01 c2                	add    %eax,%edx
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	8b 40 08             	mov    0x8(%eax),%eax
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	52                   	push   %edx
  802193:	50                   	push   %eax
  802194:	68 e1 3e 80 00       	push   $0x803ee1
  802199:	e8 d1 e5 ff ff       	call   80076f <cprintf>
  80219e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8021ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b3:	74 07                	je     8021bc <print_mem_block_lists+0x9e>
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 00                	mov    (%eax),%eax
  8021ba:	eb 05                	jmp    8021c1 <print_mem_block_lists+0xa3>
  8021bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c1:	a3 40 51 80 00       	mov    %eax,0x805140
  8021c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	75 8a                	jne    802159 <print_mem_block_lists+0x3b>
  8021cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d3:	75 84                	jne    802159 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021d5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021d9:	75 10                	jne    8021eb <print_mem_block_lists+0xcd>
  8021db:	83 ec 0c             	sub    $0xc,%esp
  8021de:	68 f0 3e 80 00       	push   $0x803ef0
  8021e3:	e8 87 e5 ff ff       	call   80076f <cprintf>
  8021e8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021f2:	83 ec 0c             	sub    $0xc,%esp
  8021f5:	68 14 3f 80 00       	push   $0x803f14
  8021fa:	e8 70 e5 ff ff       	call   80076f <cprintf>
  8021ff:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802202:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802206:	a1 40 50 80 00       	mov    0x805040,%eax
  80220b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220e:	eb 56                	jmp    802266 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802210:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802214:	74 1c                	je     802232 <print_mem_block_lists+0x114>
  802216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802219:	8b 50 08             	mov    0x8(%eax),%edx
  80221c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221f:	8b 48 08             	mov    0x8(%eax),%ecx
  802222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802225:	8b 40 0c             	mov    0xc(%eax),%eax
  802228:	01 c8                	add    %ecx,%eax
  80222a:	39 c2                	cmp    %eax,%edx
  80222c:	73 04                	jae    802232 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80222e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 50 08             	mov    0x8(%eax),%edx
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 40 0c             	mov    0xc(%eax),%eax
  80223e:	01 c2                	add    %eax,%edx
  802240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802243:	8b 40 08             	mov    0x8(%eax),%eax
  802246:	83 ec 04             	sub    $0x4,%esp
  802249:	52                   	push   %edx
  80224a:	50                   	push   %eax
  80224b:	68 e1 3e 80 00       	push   $0x803ee1
  802250:	e8 1a e5 ff ff       	call   80076f <cprintf>
  802255:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80225e:	a1 48 50 80 00       	mov    0x805048,%eax
  802263:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802266:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226a:	74 07                	je     802273 <print_mem_block_lists+0x155>
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	8b 00                	mov    (%eax),%eax
  802271:	eb 05                	jmp    802278 <print_mem_block_lists+0x15a>
  802273:	b8 00 00 00 00       	mov    $0x0,%eax
  802278:	a3 48 50 80 00       	mov    %eax,0x805048
  80227d:	a1 48 50 80 00       	mov    0x805048,%eax
  802282:	85 c0                	test   %eax,%eax
  802284:	75 8a                	jne    802210 <print_mem_block_lists+0xf2>
  802286:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228a:	75 84                	jne    802210 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80228c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802290:	75 10                	jne    8022a2 <print_mem_block_lists+0x184>
  802292:	83 ec 0c             	sub    $0xc,%esp
  802295:	68 2c 3f 80 00       	push   $0x803f2c
  80229a:	e8 d0 e4 ff ff       	call   80076f <cprintf>
  80229f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022a2:	83 ec 0c             	sub    $0xc,%esp
  8022a5:	68 a0 3e 80 00       	push   $0x803ea0
  8022aa:	e8 c0 e4 ff ff       	call   80076f <cprintf>
  8022af:	83 c4 10             	add    $0x10,%esp

}
  8022b2:	90                   	nop
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8022bb:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022c2:	00 00 00 
  8022c5:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022cc:	00 00 00 
  8022cf:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022d6:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8022d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022e0:	e9 9e 00 00 00       	jmp    802383 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8022e5:	a1 50 50 80 00       	mov    0x805050,%eax
  8022ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ed:	c1 e2 04             	shl    $0x4,%edx
  8022f0:	01 d0                	add    %edx,%eax
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	75 14                	jne    80230a <initialize_MemBlocksList+0x55>
  8022f6:	83 ec 04             	sub    $0x4,%esp
  8022f9:	68 54 3f 80 00       	push   $0x803f54
  8022fe:	6a 3d                	push   $0x3d
  802300:	68 77 3f 80 00       	push   $0x803f77
  802305:	e8 b1 e1 ff ff       	call   8004bb <_panic>
  80230a:	a1 50 50 80 00       	mov    0x805050,%eax
  80230f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802312:	c1 e2 04             	shl    $0x4,%edx
  802315:	01 d0                	add    %edx,%eax
  802317:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80231d:	89 10                	mov    %edx,(%eax)
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	85 c0                	test   %eax,%eax
  802323:	74 18                	je     80233d <initialize_MemBlocksList+0x88>
  802325:	a1 48 51 80 00       	mov    0x805148,%eax
  80232a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802330:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802333:	c1 e1 04             	shl    $0x4,%ecx
  802336:	01 ca                	add    %ecx,%edx
  802338:	89 50 04             	mov    %edx,0x4(%eax)
  80233b:	eb 12                	jmp    80234f <initialize_MemBlocksList+0x9a>
  80233d:	a1 50 50 80 00       	mov    0x805050,%eax
  802342:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802345:	c1 e2 04             	shl    $0x4,%edx
  802348:	01 d0                	add    %edx,%eax
  80234a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80234f:	a1 50 50 80 00       	mov    0x805050,%eax
  802354:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802357:	c1 e2 04             	shl    $0x4,%edx
  80235a:	01 d0                	add    %edx,%eax
  80235c:	a3 48 51 80 00       	mov    %eax,0x805148
  802361:	a1 50 50 80 00       	mov    0x805050,%eax
  802366:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802369:	c1 e2 04             	shl    $0x4,%edx
  80236c:	01 d0                	add    %edx,%eax
  80236e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802375:	a1 54 51 80 00       	mov    0x805154,%eax
  80237a:	40                   	inc    %eax
  80237b:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802380:	ff 45 f4             	incl   -0xc(%ebp)
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	3b 45 08             	cmp    0x8(%ebp),%eax
  802389:	0f 82 56 ff ff ff    	jb     8022e5 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80238f:	90                   	nop
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
  802395:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	8b 00                	mov    (%eax),%eax
  80239d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8023a0:	eb 18                	jmp    8023ba <find_block+0x28>

		if(tmp->sva == va){
  8023a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a5:	8b 40 08             	mov    0x8(%eax),%eax
  8023a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023ab:	75 05                	jne    8023b2 <find_block+0x20>
			return tmp ;
  8023ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b0:	eb 11                	jmp    8023c3 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8023b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8023ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023be:	75 e2                	jne    8023a2 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8023c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8023cb:	a1 40 50 80 00       	mov    0x805040,%eax
  8023d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8023d3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8023db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023df:	75 65                	jne    802446 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8023e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023e5:	75 14                	jne    8023fb <insert_sorted_allocList+0x36>
  8023e7:	83 ec 04             	sub    $0x4,%esp
  8023ea:	68 54 3f 80 00       	push   $0x803f54
  8023ef:	6a 62                	push   $0x62
  8023f1:	68 77 3f 80 00       	push   $0x803f77
  8023f6:	e8 c0 e0 ff ff       	call   8004bb <_panic>
  8023fb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	89 10                	mov    %edx,(%eax)
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	85 c0                	test   %eax,%eax
  80240d:	74 0d                	je     80241c <insert_sorted_allocList+0x57>
  80240f:	a1 40 50 80 00       	mov    0x805040,%eax
  802414:	8b 55 08             	mov    0x8(%ebp),%edx
  802417:	89 50 04             	mov    %edx,0x4(%eax)
  80241a:	eb 08                	jmp    802424 <insert_sorted_allocList+0x5f>
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	a3 44 50 80 00       	mov    %eax,0x805044
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	a3 40 50 80 00       	mov    %eax,0x805040
  80242c:	8b 45 08             	mov    0x8(%ebp),%eax
  80242f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802436:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80243b:	40                   	inc    %eax
  80243c:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802441:	e9 14 01 00 00       	jmp    80255a <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	8b 50 08             	mov    0x8(%eax),%edx
  80244c:	a1 44 50 80 00       	mov    0x805044,%eax
  802451:	8b 40 08             	mov    0x8(%eax),%eax
  802454:	39 c2                	cmp    %eax,%edx
  802456:	76 65                	jbe    8024bd <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802458:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80245c:	75 14                	jne    802472 <insert_sorted_allocList+0xad>
  80245e:	83 ec 04             	sub    $0x4,%esp
  802461:	68 90 3f 80 00       	push   $0x803f90
  802466:	6a 64                	push   $0x64
  802468:	68 77 3f 80 00       	push   $0x803f77
  80246d:	e8 49 e0 ff ff       	call   8004bb <_panic>
  802472:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	89 50 04             	mov    %edx,0x4(%eax)
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	8b 40 04             	mov    0x4(%eax),%eax
  802484:	85 c0                	test   %eax,%eax
  802486:	74 0c                	je     802494 <insert_sorted_allocList+0xcf>
  802488:	a1 44 50 80 00       	mov    0x805044,%eax
  80248d:	8b 55 08             	mov    0x8(%ebp),%edx
  802490:	89 10                	mov    %edx,(%eax)
  802492:	eb 08                	jmp    80249c <insert_sorted_allocList+0xd7>
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	a3 40 50 80 00       	mov    %eax,0x805040
  80249c:	8b 45 08             	mov    0x8(%ebp),%eax
  80249f:	a3 44 50 80 00       	mov    %eax,0x805044
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ad:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024b2:	40                   	inc    %eax
  8024b3:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8024b8:	e9 9d 00 00 00       	jmp    80255a <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8024bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8024c4:	e9 85 00 00 00       	jmp    80254e <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	8b 50 08             	mov    0x8(%eax),%edx
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 40 08             	mov    0x8(%eax),%eax
  8024d5:	39 c2                	cmp    %eax,%edx
  8024d7:	73 6a                	jae    802543 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8024d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024dd:	74 06                	je     8024e5 <insert_sorted_allocList+0x120>
  8024df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e3:	75 14                	jne    8024f9 <insert_sorted_allocList+0x134>
  8024e5:	83 ec 04             	sub    $0x4,%esp
  8024e8:	68 b4 3f 80 00       	push   $0x803fb4
  8024ed:	6a 6b                	push   $0x6b
  8024ef:	68 77 3f 80 00       	push   $0x803f77
  8024f4:	e8 c2 df ff ff       	call   8004bb <_panic>
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 50 04             	mov    0x4(%eax),%edx
  8024ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802502:	89 50 04             	mov    %edx,0x4(%eax)
  802505:	8b 45 08             	mov    0x8(%ebp),%eax
  802508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250b:	89 10                	mov    %edx,(%eax)
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 40 04             	mov    0x4(%eax),%eax
  802513:	85 c0                	test   %eax,%eax
  802515:	74 0d                	je     802524 <insert_sorted_allocList+0x15f>
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 40 04             	mov    0x4(%eax),%eax
  80251d:	8b 55 08             	mov    0x8(%ebp),%edx
  802520:	89 10                	mov    %edx,(%eax)
  802522:	eb 08                	jmp    80252c <insert_sorted_allocList+0x167>
  802524:	8b 45 08             	mov    0x8(%ebp),%eax
  802527:	a3 40 50 80 00       	mov    %eax,0x805040
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 55 08             	mov    0x8(%ebp),%edx
  802532:	89 50 04             	mov    %edx,0x4(%eax)
  802535:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80253a:	40                   	inc    %eax
  80253b:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802540:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802541:	eb 17                	jmp    80255a <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80254b:	ff 45 f0             	incl   -0x10(%ebp)
  80254e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802551:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802554:	0f 8c 6f ff ff ff    	jl     8024c9 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80255a:	90                   	nop
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
  802560:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802563:	a1 38 51 80 00       	mov    0x805138,%eax
  802568:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80256b:	e9 7c 01 00 00       	jmp    8026ec <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 40 0c             	mov    0xc(%eax),%eax
  802576:	3b 45 08             	cmp    0x8(%ebp),%eax
  802579:	0f 86 cf 00 00 00    	jbe    80264e <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80257f:	a1 48 51 80 00       	mov    0x805148,%eax
  802584:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258a:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80258d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802590:	8b 55 08             	mov    0x8(%ebp),%edx
  802593:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 50 08             	mov    0x8(%eax),%edx
  80259c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259f:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a8:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ab:	89 c2                	mov    %eax,%edx
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 50 08             	mov    0x8(%eax),%edx
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	01 c2                	add    %eax,%edx
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8025c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025c8:	75 17                	jne    8025e1 <alloc_block_FF+0x84>
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 e9 3f 80 00       	push   $0x803fe9
  8025d2:	68 83 00 00 00       	push   $0x83
  8025d7:	68 77 3f 80 00       	push   $0x803f77
  8025dc:	e8 da de ff ff       	call   8004bb <_panic>
  8025e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	74 10                	je     8025fa <alloc_block_FF+0x9d>
  8025ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025f2:	8b 52 04             	mov    0x4(%edx),%edx
  8025f5:	89 50 04             	mov    %edx,0x4(%eax)
  8025f8:	eb 0b                	jmp    802605 <alloc_block_FF+0xa8>
  8025fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fd:	8b 40 04             	mov    0x4(%eax),%eax
  802600:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802608:	8b 40 04             	mov    0x4(%eax),%eax
  80260b:	85 c0                	test   %eax,%eax
  80260d:	74 0f                	je     80261e <alloc_block_FF+0xc1>
  80260f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802612:	8b 40 04             	mov    0x4(%eax),%eax
  802615:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802618:	8b 12                	mov    (%edx),%edx
  80261a:	89 10                	mov    %edx,(%eax)
  80261c:	eb 0a                	jmp    802628 <alloc_block_FF+0xcb>
  80261e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802621:	8b 00                	mov    (%eax),%eax
  802623:	a3 48 51 80 00       	mov    %eax,0x805148
  802628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802634:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263b:	a1 54 51 80 00       	mov    0x805154,%eax
  802640:	48                   	dec    %eax
  802641:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802649:	e9 ad 00 00 00       	jmp    8026fb <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 40 0c             	mov    0xc(%eax),%eax
  802654:	3b 45 08             	cmp    0x8(%ebp),%eax
  802657:	0f 85 87 00 00 00    	jne    8026e4 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80265d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802661:	75 17                	jne    80267a <alloc_block_FF+0x11d>
  802663:	83 ec 04             	sub    $0x4,%esp
  802666:	68 e9 3f 80 00       	push   $0x803fe9
  80266b:	68 87 00 00 00       	push   $0x87
  802670:	68 77 3f 80 00       	push   $0x803f77
  802675:	e8 41 de ff ff       	call   8004bb <_panic>
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 00                	mov    (%eax),%eax
  80267f:	85 c0                	test   %eax,%eax
  802681:	74 10                	je     802693 <alloc_block_FF+0x136>
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 00                	mov    (%eax),%eax
  802688:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268b:	8b 52 04             	mov    0x4(%edx),%edx
  80268e:	89 50 04             	mov    %edx,0x4(%eax)
  802691:	eb 0b                	jmp    80269e <alloc_block_FF+0x141>
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 40 04             	mov    0x4(%eax),%eax
  802699:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 40 04             	mov    0x4(%eax),%eax
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	74 0f                	je     8026b7 <alloc_block_FF+0x15a>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 04             	mov    0x4(%eax),%eax
  8026ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b1:	8b 12                	mov    (%edx),%edx
  8026b3:	89 10                	mov    %edx,(%eax)
  8026b5:	eb 0a                	jmp    8026c1 <alloc_block_FF+0x164>
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	a3 38 51 80 00       	mov    %eax,0x805138
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8026d9:	48                   	dec    %eax
  8026da:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	eb 17                	jmp    8026fb <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 00                	mov    (%eax),%eax
  8026e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8026ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f0:	0f 85 7a fe ff ff    	jne    802570 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8026f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
  802700:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802703:	a1 38 51 80 00       	mov    0x805138,%eax
  802708:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  80270b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802712:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802719:	a1 38 51 80 00       	mov    0x805138,%eax
  80271e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802721:	e9 d0 00 00 00       	jmp    8027f6 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 40 0c             	mov    0xc(%eax),%eax
  80272c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272f:	0f 82 b8 00 00 00    	jb     8027ed <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 40 0c             	mov    0xc(%eax),%eax
  80273b:	2b 45 08             	sub    0x8(%ebp),%eax
  80273e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802744:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802747:	0f 83 a1 00 00 00    	jae    8027ee <alloc_block_BF+0xf1>
				differsize = differance ;
  80274d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802750:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802759:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80275d:	0f 85 8b 00 00 00    	jne    8027ee <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802763:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802767:	75 17                	jne    802780 <alloc_block_BF+0x83>
  802769:	83 ec 04             	sub    $0x4,%esp
  80276c:	68 e9 3f 80 00       	push   $0x803fe9
  802771:	68 a0 00 00 00       	push   $0xa0
  802776:	68 77 3f 80 00       	push   $0x803f77
  80277b:	e8 3b dd ff ff       	call   8004bb <_panic>
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 00                	mov    (%eax),%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	74 10                	je     802799 <alloc_block_BF+0x9c>
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 00                	mov    (%eax),%eax
  80278e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802791:	8b 52 04             	mov    0x4(%edx),%edx
  802794:	89 50 04             	mov    %edx,0x4(%eax)
  802797:	eb 0b                	jmp    8027a4 <alloc_block_BF+0xa7>
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 04             	mov    0x4(%eax),%eax
  80279f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 04             	mov    0x4(%eax),%eax
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	74 0f                	je     8027bd <alloc_block_BF+0xc0>
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 04             	mov    0x4(%eax),%eax
  8027b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b7:	8b 12                	mov    (%edx),%edx
  8027b9:	89 10                	mov    %edx,(%eax)
  8027bb:	eb 0a                	jmp    8027c7 <alloc_block_BF+0xca>
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 00                	mov    (%eax),%eax
  8027c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027da:	a1 44 51 80 00       	mov    0x805144,%eax
  8027df:	48                   	dec    %eax
  8027e0:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	e9 0c 01 00 00       	jmp    8028f9 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8027ed:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8027ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fa:	74 07                	je     802803 <alloc_block_BF+0x106>
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	eb 05                	jmp    802808 <alloc_block_BF+0x10b>
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	a3 40 51 80 00       	mov    %eax,0x805140
  80280d:	a1 40 51 80 00       	mov    0x805140,%eax
  802812:	85 c0                	test   %eax,%eax
  802814:	0f 85 0c ff ff ff    	jne    802726 <alloc_block_BF+0x29>
  80281a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281e:	0f 85 02 ff ff ff    	jne    802726 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802824:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802828:	0f 84 c6 00 00 00    	je     8028f4 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  80282e:	a1 48 51 80 00       	mov    0x805148,%eax
  802833:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802836:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802839:	8b 55 08             	mov    0x8(%ebp),%edx
  80283c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802842:	8b 50 08             	mov    0x8(%eax),%edx
  802845:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802848:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80284b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284e:	8b 40 0c             	mov    0xc(%eax),%eax
  802851:	2b 45 08             	sub    0x8(%ebp),%eax
  802854:	89 c2                	mov    %eax,%edx
  802856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802859:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80285c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285f:	8b 50 08             	mov    0x8(%eax),%edx
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	01 c2                	add    %eax,%edx
  802867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286a:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80286d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802871:	75 17                	jne    80288a <alloc_block_BF+0x18d>
  802873:	83 ec 04             	sub    $0x4,%esp
  802876:	68 e9 3f 80 00       	push   $0x803fe9
  80287b:	68 af 00 00 00       	push   $0xaf
  802880:	68 77 3f 80 00       	push   $0x803f77
  802885:	e8 31 dc ff ff       	call   8004bb <_panic>
  80288a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80288d:	8b 00                	mov    (%eax),%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	74 10                	je     8028a3 <alloc_block_BF+0x1a6>
  802893:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802896:	8b 00                	mov    (%eax),%eax
  802898:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80289b:	8b 52 04             	mov    0x4(%edx),%edx
  80289e:	89 50 04             	mov    %edx,0x4(%eax)
  8028a1:	eb 0b                	jmp    8028ae <alloc_block_BF+0x1b1>
  8028a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a6:	8b 40 04             	mov    0x4(%eax),%eax
  8028a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b1:	8b 40 04             	mov    0x4(%eax),%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	74 0f                	je     8028c7 <alloc_block_BF+0x1ca>
  8028b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028c1:	8b 12                	mov    (%edx),%edx
  8028c3:	89 10                	mov    %edx,(%eax)
  8028c5:	eb 0a                	jmp    8028d1 <alloc_block_BF+0x1d4>
  8028c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	a3 48 51 80 00       	mov    %eax,0x805148
  8028d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e4:	a1 54 51 80 00       	mov    0x805154,%eax
  8028e9:	48                   	dec    %eax
  8028ea:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  8028ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f2:	eb 05                	jmp    8028f9 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8028f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f9:	c9                   	leave  
  8028fa:	c3                   	ret    

008028fb <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8028fb:	55                   	push   %ebp
  8028fc:	89 e5                	mov    %esp,%ebp
  8028fe:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802901:	a1 38 51 80 00       	mov    0x805138,%eax
  802906:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802909:	e9 7c 01 00 00       	jmp    802a8a <alloc_block_NF+0x18f>
	        if (updated->size > size){
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 40 0c             	mov    0xc(%eax),%eax
  802914:	3b 45 08             	cmp    0x8(%ebp),%eax
  802917:	0f 86 cf 00 00 00    	jbe    8029ec <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80291d:	a1 48 51 80 00       	mov    0x805148,%eax
  802922:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802928:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  80292b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292e:	8b 55 08             	mov    0x8(%ebp),%edx
  802931:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 50 08             	mov    0x8(%eax),%edx
  80293a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293d:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 40 0c             	mov    0xc(%eax),%eax
  802946:	2b 45 08             	sub    0x8(%ebp),%eax
  802949:	89 c2                	mov    %eax,%edx
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 50 08             	mov    0x8(%eax),%edx
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	01 c2                	add    %eax,%edx
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802962:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802966:	75 17                	jne    80297f <alloc_block_NF+0x84>
  802968:	83 ec 04             	sub    $0x4,%esp
  80296b:	68 e9 3f 80 00       	push   $0x803fe9
  802970:	68 c4 00 00 00       	push   $0xc4
  802975:	68 77 3f 80 00       	push   $0x803f77
  80297a:	e8 3c db ff ff       	call   8004bb <_panic>
  80297f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802982:	8b 00                	mov    (%eax),%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	74 10                	je     802998 <alloc_block_NF+0x9d>
  802988:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802990:	8b 52 04             	mov    0x4(%edx),%edx
  802993:	89 50 04             	mov    %edx,0x4(%eax)
  802996:	eb 0b                	jmp    8029a3 <alloc_block_NF+0xa8>
  802998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299b:	8b 40 04             	mov    0x4(%eax),%eax
  80299e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a6:	8b 40 04             	mov    0x4(%eax),%eax
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	74 0f                	je     8029bc <alloc_block_NF+0xc1>
  8029ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b0:	8b 40 04             	mov    0x4(%eax),%eax
  8029b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029b6:	8b 12                	mov    (%edx),%edx
  8029b8:	89 10                	mov    %edx,(%eax)
  8029ba:	eb 0a                	jmp    8029c6 <alloc_block_NF+0xcb>
  8029bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8029c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8029de:	48                   	dec    %eax
  8029df:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  8029e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e7:	e9 ad 00 00 00       	jmp    802a99 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f5:	0f 85 87 00 00 00    	jne    802a82 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8029fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ff:	75 17                	jne    802a18 <alloc_block_NF+0x11d>
  802a01:	83 ec 04             	sub    $0x4,%esp
  802a04:	68 e9 3f 80 00       	push   $0x803fe9
  802a09:	68 c8 00 00 00       	push   $0xc8
  802a0e:	68 77 3f 80 00       	push   $0x803f77
  802a13:	e8 a3 da ff ff       	call   8004bb <_panic>
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	74 10                	je     802a31 <alloc_block_NF+0x136>
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a29:	8b 52 04             	mov    0x4(%edx),%edx
  802a2c:	89 50 04             	mov    %edx,0x4(%eax)
  802a2f:	eb 0b                	jmp    802a3c <alloc_block_NF+0x141>
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	8b 40 04             	mov    0x4(%eax),%eax
  802a37:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 40 04             	mov    0x4(%eax),%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	74 0f                	je     802a55 <alloc_block_NF+0x15a>
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 40 04             	mov    0x4(%eax),%eax
  802a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4f:	8b 12                	mov    (%edx),%edx
  802a51:	89 10                	mov    %edx,(%eax)
  802a53:	eb 0a                	jmp    802a5f <alloc_block_NF+0x164>
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	a3 38 51 80 00       	mov    %eax,0x805138
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a72:	a1 44 51 80 00       	mov    0x805144,%eax
  802a77:	48                   	dec    %eax
  802a78:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	eb 17                	jmp    802a99 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 00                	mov    (%eax),%eax
  802a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802a8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8e:	0f 85 7a fe ff ff    	jne    80290e <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802a99:	c9                   	leave  
  802a9a:	c3                   	ret    

00802a9b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a9b:	55                   	push   %ebp
  802a9c:	89 e5                	mov    %esp,%ebp
  802a9e:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802aa1:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802aa9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802ab1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab6:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802ab9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802abd:	75 68                	jne    802b27 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802abf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac3:	75 17                	jne    802adc <insert_sorted_with_merge_freeList+0x41>
  802ac5:	83 ec 04             	sub    $0x4,%esp
  802ac8:	68 54 3f 80 00       	push   $0x803f54
  802acd:	68 da 00 00 00       	push   $0xda
  802ad2:	68 77 3f 80 00       	push   $0x803f77
  802ad7:	e8 df d9 ff ff       	call   8004bb <_panic>
  802adc:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	89 10                	mov    %edx,(%eax)
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	74 0d                	je     802afd <insert_sorted_with_merge_freeList+0x62>
  802af0:	a1 38 51 80 00       	mov    0x805138,%eax
  802af5:	8b 55 08             	mov    0x8(%ebp),%edx
  802af8:	89 50 04             	mov    %edx,0x4(%eax)
  802afb:	eb 08                	jmp    802b05 <insert_sorted_with_merge_freeList+0x6a>
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	a3 38 51 80 00       	mov    %eax,0x805138
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b17:	a1 44 51 80 00       	mov    0x805144,%eax
  802b1c:	40                   	inc    %eax
  802b1d:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802b22:	e9 49 07 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	8b 50 08             	mov    0x8(%eax),%edx
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	8b 40 0c             	mov    0xc(%eax),%eax
  802b33:	01 c2                	add    %eax,%edx
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	8b 40 08             	mov    0x8(%eax),%eax
  802b3b:	39 c2                	cmp    %eax,%edx
  802b3d:	73 77                	jae    802bb6 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	75 6e                	jne    802bb6 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802b48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b4c:	74 68                	je     802bb6 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802b4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b52:	75 17                	jne    802b6b <insert_sorted_with_merge_freeList+0xd0>
  802b54:	83 ec 04             	sub    $0x4,%esp
  802b57:	68 90 3f 80 00       	push   $0x803f90
  802b5c:	68 e0 00 00 00       	push   $0xe0
  802b61:	68 77 3f 80 00       	push   $0x803f77
  802b66:	e8 50 d9 ff ff       	call   8004bb <_panic>
  802b6b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	89 50 04             	mov    %edx,0x4(%eax)
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	8b 40 04             	mov    0x4(%eax),%eax
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	74 0c                	je     802b8d <insert_sorted_with_merge_freeList+0xf2>
  802b81:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b86:	8b 55 08             	mov    0x8(%ebp),%edx
  802b89:	89 10                	mov    %edx,(%eax)
  802b8b:	eb 08                	jmp    802b95 <insert_sorted_with_merge_freeList+0xfa>
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	a3 38 51 80 00       	mov    %eax,0x805138
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba6:	a1 44 51 80 00       	mov    0x805144,%eax
  802bab:	40                   	inc    %eax
  802bac:	a3 44 51 80 00       	mov    %eax,0x805144
  802bb1:	e9 ba 06 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	8b 50 0c             	mov    0xc(%eax),%edx
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 40 08             	mov    0x8(%eax),%eax
  802bc2:	01 c2                	add    %eax,%edx
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 40 08             	mov    0x8(%eax),%eax
  802bca:	39 c2                	cmp    %eax,%edx
  802bcc:	73 78                	jae    802c46 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 40 04             	mov    0x4(%eax),%eax
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	75 6e                	jne    802c46 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802bd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bdc:	74 68                	je     802c46 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802bde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be2:	75 17                	jne    802bfb <insert_sorted_with_merge_freeList+0x160>
  802be4:	83 ec 04             	sub    $0x4,%esp
  802be7:	68 54 3f 80 00       	push   $0x803f54
  802bec:	68 e6 00 00 00       	push   $0xe6
  802bf1:	68 77 3f 80 00       	push   $0x803f77
  802bf6:	e8 c0 d8 ff ff       	call   8004bb <_panic>
  802bfb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	89 10                	mov    %edx,(%eax)
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	74 0d                	je     802c1c <insert_sorted_with_merge_freeList+0x181>
  802c0f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c14:	8b 55 08             	mov    0x8(%ebp),%edx
  802c17:	89 50 04             	mov    %edx,0x4(%eax)
  802c1a:	eb 08                	jmp    802c24 <insert_sorted_with_merge_freeList+0x189>
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	a3 38 51 80 00       	mov    %eax,0x805138
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c36:	a1 44 51 80 00       	mov    0x805144,%eax
  802c3b:	40                   	inc    %eax
  802c3c:	a3 44 51 80 00       	mov    %eax,0x805144
  802c41:	e9 2a 06 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802c46:	a1 38 51 80 00       	mov    0x805138,%eax
  802c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4e:	e9 ed 05 00 00       	jmp    803240 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802c5b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c5f:	0f 84 a7 00 00 00    	je     802d0c <insert_sorted_with_merge_freeList+0x271>
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 50 0c             	mov    0xc(%eax),%edx
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 08             	mov    0x8(%eax),%eax
  802c71:	01 c2                	add    %eax,%edx
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	8b 40 08             	mov    0x8(%eax),%eax
  802c79:	39 c2                	cmp    %eax,%edx
  802c7b:	0f 83 8b 00 00 00    	jae    802d0c <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	8b 50 0c             	mov    0xc(%eax),%edx
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	8b 40 08             	mov    0x8(%eax),%eax
  802c8d:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802c8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c92:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802c95:	39 c2                	cmp    %eax,%edx
  802c97:	73 73                	jae    802d0c <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9d:	74 06                	je     802ca5 <insert_sorted_with_merge_freeList+0x20a>
  802c9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca3:	75 17                	jne    802cbc <insert_sorted_with_merge_freeList+0x221>
  802ca5:	83 ec 04             	sub    $0x4,%esp
  802ca8:	68 08 40 80 00       	push   $0x804008
  802cad:	68 f0 00 00 00       	push   $0xf0
  802cb2:	68 77 3f 80 00       	push   $0x803f77
  802cb7:	e8 ff d7 ff ff       	call   8004bb <_panic>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 10                	mov    (%eax),%edx
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	89 10                	mov    %edx,(%eax)
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	8b 00                	mov    (%eax),%eax
  802ccb:	85 c0                	test   %eax,%eax
  802ccd:	74 0b                	je     802cda <insert_sorted_with_merge_freeList+0x23f>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd7:	89 50 04             	mov    %edx,0x4(%eax)
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce0:	89 10                	mov    %edx,(%eax)
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce8:	89 50 04             	mov    %edx,0x4(%eax)
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	75 08                	jne    802cfc <insert_sorted_with_merge_freeList+0x261>
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cfc:	a1 44 51 80 00       	mov    0x805144,%eax
  802d01:	40                   	inc    %eax
  802d02:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  802d07:	e9 64 05 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802d0c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d11:	8b 50 0c             	mov    0xc(%eax),%edx
  802d14:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d19:	8b 40 08             	mov    0x8(%eax),%eax
  802d1c:	01 c2                	add    %eax,%edx
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	8b 40 08             	mov    0x8(%eax),%eax
  802d24:	39 c2                	cmp    %eax,%edx
  802d26:	0f 85 b1 00 00 00    	jne    802ddd <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802d2c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d31:	85 c0                	test   %eax,%eax
  802d33:	0f 84 a4 00 00 00    	je     802ddd <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802d39:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	85 c0                	test   %eax,%eax
  802d42:	0f 85 95 00 00 00    	jne    802ddd <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802d48:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d4d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d53:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d56:	8b 55 08             	mov    0x8(%ebp),%edx
  802d59:	8b 52 0c             	mov    0xc(%edx),%edx
  802d5c:	01 ca                	add    %ecx,%edx
  802d5e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802d61:	8b 45 08             	mov    0x8(%ebp),%eax
  802d64:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d79:	75 17                	jne    802d92 <insert_sorted_with_merge_freeList+0x2f7>
  802d7b:	83 ec 04             	sub    $0x4,%esp
  802d7e:	68 54 3f 80 00       	push   $0x803f54
  802d83:	68 ff 00 00 00       	push   $0xff
  802d88:	68 77 3f 80 00       	push   $0x803f77
  802d8d:	e8 29 d7 ff ff       	call   8004bb <_panic>
  802d92:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	89 10                	mov    %edx,(%eax)
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	8b 00                	mov    (%eax),%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	74 0d                	je     802db3 <insert_sorted_with_merge_freeList+0x318>
  802da6:	a1 48 51 80 00       	mov    0x805148,%eax
  802dab:	8b 55 08             	mov    0x8(%ebp),%edx
  802dae:	89 50 04             	mov    %edx,0x4(%eax)
  802db1:	eb 08                	jmp    802dbb <insert_sorted_with_merge_freeList+0x320>
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	a3 48 51 80 00       	mov    %eax,0x805148
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcd:	a1 54 51 80 00       	mov    0x805154,%eax
  802dd2:	40                   	inc    %eax
  802dd3:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  802dd8:	e9 93 04 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 50 08             	mov    0x8(%eax),%edx
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	8b 40 0c             	mov    0xc(%eax),%eax
  802de9:	01 c2                	add    %eax,%edx
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	8b 40 08             	mov    0x8(%eax),%eax
  802df1:	39 c2                	cmp    %eax,%edx
  802df3:	0f 85 ae 00 00 00    	jne    802ea7 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	8b 50 0c             	mov    0xc(%eax),%edx
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	8b 40 08             	mov    0x8(%eax),%eax
  802e05:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802e0f:	39 c2                	cmp    %eax,%edx
  802e11:	0f 84 90 00 00 00    	je     802ea7 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	8b 40 0c             	mov    0xc(%eax),%eax
  802e23:	01 c2                	add    %eax,%edx
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e43:	75 17                	jne    802e5c <insert_sorted_with_merge_freeList+0x3c1>
  802e45:	83 ec 04             	sub    $0x4,%esp
  802e48:	68 54 3f 80 00       	push   $0x803f54
  802e4d:	68 0b 01 00 00       	push   $0x10b
  802e52:	68 77 3f 80 00       	push   $0x803f77
  802e57:	e8 5f d6 ff ff       	call   8004bb <_panic>
  802e5c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	89 10                	mov    %edx,(%eax)
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	85 c0                	test   %eax,%eax
  802e6e:	74 0d                	je     802e7d <insert_sorted_with_merge_freeList+0x3e2>
  802e70:	a1 48 51 80 00       	mov    0x805148,%eax
  802e75:	8b 55 08             	mov    0x8(%ebp),%edx
  802e78:	89 50 04             	mov    %edx,0x4(%eax)
  802e7b:	eb 08                	jmp    802e85 <insert_sorted_with_merge_freeList+0x3ea>
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	a3 48 51 80 00       	mov    %eax,0x805148
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e97:	a1 54 51 80 00       	mov    0x805154,%eax
  802e9c:	40                   	inc    %eax
  802e9d:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  802ea2:	e9 c9 03 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	8b 50 0c             	mov    0xc(%eax),%edx
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	8b 40 08             	mov    0x8(%eax),%eax
  802eb3:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ebb:	39 c2                	cmp    %eax,%edx
  802ebd:	0f 85 bb 00 00 00    	jne    802f7e <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec7:	0f 84 b1 00 00 00    	je     802f7e <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 40 04             	mov    0x4(%eax),%eax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	0f 85 a3 00 00 00    	jne    802f7e <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802edb:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee3:	8b 52 08             	mov    0x8(%edx),%edx
  802ee6:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802ee9:	a1 38 51 80 00       	mov    0x805138,%eax
  802eee:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ef4:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  802efa:	8b 52 0c             	mov    0xc(%edx),%edx
  802efd:	01 ca                	add    %ecx,%edx
  802eff:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802f16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1a:	75 17                	jne    802f33 <insert_sorted_with_merge_freeList+0x498>
  802f1c:	83 ec 04             	sub    $0x4,%esp
  802f1f:	68 54 3f 80 00       	push   $0x803f54
  802f24:	68 17 01 00 00       	push   $0x117
  802f29:	68 77 3f 80 00       	push   $0x803f77
  802f2e:	e8 88 d5 ff ff       	call   8004bb <_panic>
  802f33:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	89 10                	mov    %edx,(%eax)
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 0d                	je     802f54 <insert_sorted_with_merge_freeList+0x4b9>
  802f47:	a1 48 51 80 00       	mov    0x805148,%eax
  802f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4f:	89 50 04             	mov    %edx,0x4(%eax)
  802f52:	eb 08                	jmp    802f5c <insert_sorted_with_merge_freeList+0x4c1>
  802f54:	8b 45 08             	mov    0x8(%ebp),%eax
  802f57:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	a3 48 51 80 00       	mov    %eax,0x805148
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6e:	a1 54 51 80 00       	mov    0x805154,%eax
  802f73:	40                   	inc    %eax
  802f74:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  802f79:	e9 f2 02 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	8b 50 08             	mov    0x8(%eax),%edx
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8a:	01 c2                	add    %eax,%edx
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	8b 40 08             	mov    0x8(%eax),%eax
  802f92:	39 c2                	cmp    %eax,%edx
  802f94:	0f 85 be 00 00 00    	jne    803058 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9d:	8b 40 04             	mov    0x4(%eax),%eax
  802fa0:	8b 50 08             	mov    0x8(%eax),%edx
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	8b 40 04             	mov    0x4(%eax),%eax
  802fa9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fac:	01 c2                	add    %eax,%edx
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	8b 40 08             	mov    0x8(%eax),%eax
  802fb4:	39 c2                	cmp    %eax,%edx
  802fb6:	0f 84 9c 00 00 00    	je     803058 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	8b 50 08             	mov    0x8(%eax),%edx
  802fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc5:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 50 0c             	mov    0xc(%eax),%edx
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd4:	01 c2                	add    %eax,%edx
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802ff0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff4:	75 17                	jne    80300d <insert_sorted_with_merge_freeList+0x572>
  802ff6:	83 ec 04             	sub    $0x4,%esp
  802ff9:	68 54 3f 80 00       	push   $0x803f54
  802ffe:	68 26 01 00 00       	push   $0x126
  803003:	68 77 3f 80 00       	push   $0x803f77
  803008:	e8 ae d4 ff ff       	call   8004bb <_panic>
  80300d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	89 10                	mov    %edx,(%eax)
  803018:	8b 45 08             	mov    0x8(%ebp),%eax
  80301b:	8b 00                	mov    (%eax),%eax
  80301d:	85 c0                	test   %eax,%eax
  80301f:	74 0d                	je     80302e <insert_sorted_with_merge_freeList+0x593>
  803021:	a1 48 51 80 00       	mov    0x805148,%eax
  803026:	8b 55 08             	mov    0x8(%ebp),%edx
  803029:	89 50 04             	mov    %edx,0x4(%eax)
  80302c:	eb 08                	jmp    803036 <insert_sorted_with_merge_freeList+0x59b>
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	a3 48 51 80 00       	mov    %eax,0x805148
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803048:	a1 54 51 80 00       	mov    0x805154,%eax
  80304d:	40                   	inc    %eax
  80304e:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803053:	e9 18 02 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 50 0c             	mov    0xc(%eax),%edx
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	8b 40 08             	mov    0x8(%eax),%eax
  803064:	01 c2                	add    %eax,%edx
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	8b 40 08             	mov    0x8(%eax),%eax
  80306c:	39 c2                	cmp    %eax,%edx
  80306e:	0f 85 c4 01 00 00    	jne    803238 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	8b 50 0c             	mov    0xc(%eax),%edx
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	8b 40 08             	mov    0x8(%eax),%eax
  803080:	01 c2                	add    %eax,%edx
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	8b 00                	mov    (%eax),%eax
  803087:	8b 40 08             	mov    0x8(%eax),%eax
  80308a:	39 c2                	cmp    %eax,%edx
  80308c:	0f 85 a6 01 00 00    	jne    803238 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803092:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803096:	0f 84 9c 01 00 00    	je     803238 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 50 0c             	mov    0xc(%eax),%edx
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a8:	01 c2                	add    %eax,%edx
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b2:	01 c2                	add    %eax,%edx
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8030ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d2:	75 17                	jne    8030eb <insert_sorted_with_merge_freeList+0x650>
  8030d4:	83 ec 04             	sub    $0x4,%esp
  8030d7:	68 54 3f 80 00       	push   $0x803f54
  8030dc:	68 32 01 00 00       	push   $0x132
  8030e1:	68 77 3f 80 00       	push   $0x803f77
  8030e6:	e8 d0 d3 ff ff       	call   8004bb <_panic>
  8030eb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	89 10                	mov    %edx,(%eax)
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 0d                	je     80310c <insert_sorted_with_merge_freeList+0x671>
  8030ff:	a1 48 51 80 00       	mov    0x805148,%eax
  803104:	8b 55 08             	mov    0x8(%ebp),%edx
  803107:	89 50 04             	mov    %edx,0x4(%eax)
  80310a:	eb 08                	jmp    803114 <insert_sorted_with_merge_freeList+0x679>
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	a3 48 51 80 00       	mov    %eax,0x805148
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803126:	a1 54 51 80 00       	mov    0x805154,%eax
  80312b:	40                   	inc    %eax
  80312c:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314c:	8b 00                	mov    (%eax),%eax
  80314e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803151:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803155:	75 17                	jne    80316e <insert_sorted_with_merge_freeList+0x6d3>
  803157:	83 ec 04             	sub    $0x4,%esp
  80315a:	68 e9 3f 80 00       	push   $0x803fe9
  80315f:	68 36 01 00 00       	push   $0x136
  803164:	68 77 3f 80 00       	push   $0x803f77
  803169:	e8 4d d3 ff ff       	call   8004bb <_panic>
  80316e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	85 c0                	test   %eax,%eax
  803175:	74 10                	je     803187 <insert_sorted_with_merge_freeList+0x6ec>
  803177:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80317f:	8b 52 04             	mov    0x4(%edx),%edx
  803182:	89 50 04             	mov    %edx,0x4(%eax)
  803185:	eb 0b                	jmp    803192 <insert_sorted_with_merge_freeList+0x6f7>
  803187:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318a:	8b 40 04             	mov    0x4(%eax),%eax
  80318d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803195:	8b 40 04             	mov    0x4(%eax),%eax
  803198:	85 c0                	test   %eax,%eax
  80319a:	74 0f                	je     8031ab <insert_sorted_with_merge_freeList+0x710>
  80319c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319f:	8b 40 04             	mov    0x4(%eax),%eax
  8031a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031a5:	8b 12                	mov    (%edx),%edx
  8031a7:	89 10                	mov    %edx,(%eax)
  8031a9:	eb 0a                	jmp    8031b5 <insert_sorted_with_merge_freeList+0x71a>
  8031ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ae:	8b 00                	mov    (%eax),%eax
  8031b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8031b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8031cd:	48                   	dec    %eax
  8031ce:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8031d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031d7:	75 17                	jne    8031f0 <insert_sorted_with_merge_freeList+0x755>
  8031d9:	83 ec 04             	sub    $0x4,%esp
  8031dc:	68 54 3f 80 00       	push   $0x803f54
  8031e1:	68 37 01 00 00       	push   $0x137
  8031e6:	68 77 3f 80 00       	push   $0x803f77
  8031eb:	e8 cb d2 ff ff       	call   8004bb <_panic>
  8031f0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f9:	89 10                	mov    %edx,(%eax)
  8031fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	85 c0                	test   %eax,%eax
  803202:	74 0d                	je     803211 <insert_sorted_with_merge_freeList+0x776>
  803204:	a1 48 51 80 00       	mov    0x805148,%eax
  803209:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80320c:	89 50 04             	mov    %edx,0x4(%eax)
  80320f:	eb 08                	jmp    803219 <insert_sorted_with_merge_freeList+0x77e>
  803211:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803214:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80321c:	a3 48 51 80 00       	mov    %eax,0x805148
  803221:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803224:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322b:	a1 54 51 80 00       	mov    0x805154,%eax
  803230:	40                   	inc    %eax
  803231:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803236:	eb 38                	jmp    803270 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803238:	a1 40 51 80 00       	mov    0x805140,%eax
  80323d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803240:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803244:	74 07                	je     80324d <insert_sorted_with_merge_freeList+0x7b2>
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	8b 00                	mov    (%eax),%eax
  80324b:	eb 05                	jmp    803252 <insert_sorted_with_merge_freeList+0x7b7>
  80324d:	b8 00 00 00 00       	mov    $0x0,%eax
  803252:	a3 40 51 80 00       	mov    %eax,0x805140
  803257:	a1 40 51 80 00       	mov    0x805140,%eax
  80325c:	85 c0                	test   %eax,%eax
  80325e:	0f 85 ef f9 ff ff    	jne    802c53 <insert_sorted_with_merge_freeList+0x1b8>
  803264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803268:	0f 85 e5 f9 ff ff    	jne    802c53 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80326e:	eb 00                	jmp    803270 <insert_sorted_with_merge_freeList+0x7d5>
  803270:	90                   	nop
  803271:	c9                   	leave  
  803272:	c3                   	ret    

00803273 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803273:	55                   	push   %ebp
  803274:	89 e5                	mov    %esp,%ebp
  803276:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803279:	8b 55 08             	mov    0x8(%ebp),%edx
  80327c:	89 d0                	mov    %edx,%eax
  80327e:	c1 e0 02             	shl    $0x2,%eax
  803281:	01 d0                	add    %edx,%eax
  803283:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80328a:	01 d0                	add    %edx,%eax
  80328c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803293:	01 d0                	add    %edx,%eax
  803295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80329c:	01 d0                	add    %edx,%eax
  80329e:	c1 e0 04             	shl    $0x4,%eax
  8032a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8032a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8032ab:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8032ae:	83 ec 0c             	sub    $0xc,%esp
  8032b1:	50                   	push   %eax
  8032b2:	e8 21 ec ff ff       	call   801ed8 <sys_get_virtual_time>
  8032b7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8032ba:	eb 41                	jmp    8032fd <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8032bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8032bf:	83 ec 0c             	sub    $0xc,%esp
  8032c2:	50                   	push   %eax
  8032c3:	e8 10 ec ff ff       	call   801ed8 <sys_get_virtual_time>
  8032c8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8032cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d1:	29 c2                	sub    %eax,%edx
  8032d3:	89 d0                	mov    %edx,%eax
  8032d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8032d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032de:	89 d1                	mov    %edx,%ecx
  8032e0:	29 c1                	sub    %eax,%ecx
  8032e2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e8:	39 c2                	cmp    %eax,%edx
  8032ea:	0f 97 c0             	seta   %al
  8032ed:	0f b6 c0             	movzbl %al,%eax
  8032f0:	29 c1                	sub    %eax,%ecx
  8032f2:	89 c8                	mov    %ecx,%eax
  8032f4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8032f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803303:	72 b7                	jb     8032bc <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803305:	90                   	nop
  803306:	c9                   	leave  
  803307:	c3                   	ret    

00803308 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803308:	55                   	push   %ebp
  803309:	89 e5                	mov    %esp,%ebp
  80330b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80330e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803315:	eb 03                	jmp    80331a <busy_wait+0x12>
  803317:	ff 45 fc             	incl   -0x4(%ebp)
  80331a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80331d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803320:	72 f5                	jb     803317 <busy_wait+0xf>
	return i;
  803322:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803325:	c9                   	leave  
  803326:	c3                   	ret    
  803327:	90                   	nop

00803328 <__udivdi3>:
  803328:	55                   	push   %ebp
  803329:	57                   	push   %edi
  80332a:	56                   	push   %esi
  80332b:	53                   	push   %ebx
  80332c:	83 ec 1c             	sub    $0x1c,%esp
  80332f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803333:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803337:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80333b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80333f:	89 ca                	mov    %ecx,%edx
  803341:	89 f8                	mov    %edi,%eax
  803343:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803347:	85 f6                	test   %esi,%esi
  803349:	75 2d                	jne    803378 <__udivdi3+0x50>
  80334b:	39 cf                	cmp    %ecx,%edi
  80334d:	77 65                	ja     8033b4 <__udivdi3+0x8c>
  80334f:	89 fd                	mov    %edi,%ebp
  803351:	85 ff                	test   %edi,%edi
  803353:	75 0b                	jne    803360 <__udivdi3+0x38>
  803355:	b8 01 00 00 00       	mov    $0x1,%eax
  80335a:	31 d2                	xor    %edx,%edx
  80335c:	f7 f7                	div    %edi
  80335e:	89 c5                	mov    %eax,%ebp
  803360:	31 d2                	xor    %edx,%edx
  803362:	89 c8                	mov    %ecx,%eax
  803364:	f7 f5                	div    %ebp
  803366:	89 c1                	mov    %eax,%ecx
  803368:	89 d8                	mov    %ebx,%eax
  80336a:	f7 f5                	div    %ebp
  80336c:	89 cf                	mov    %ecx,%edi
  80336e:	89 fa                	mov    %edi,%edx
  803370:	83 c4 1c             	add    $0x1c,%esp
  803373:	5b                   	pop    %ebx
  803374:	5e                   	pop    %esi
  803375:	5f                   	pop    %edi
  803376:	5d                   	pop    %ebp
  803377:	c3                   	ret    
  803378:	39 ce                	cmp    %ecx,%esi
  80337a:	77 28                	ja     8033a4 <__udivdi3+0x7c>
  80337c:	0f bd fe             	bsr    %esi,%edi
  80337f:	83 f7 1f             	xor    $0x1f,%edi
  803382:	75 40                	jne    8033c4 <__udivdi3+0x9c>
  803384:	39 ce                	cmp    %ecx,%esi
  803386:	72 0a                	jb     803392 <__udivdi3+0x6a>
  803388:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80338c:	0f 87 9e 00 00 00    	ja     803430 <__udivdi3+0x108>
  803392:	b8 01 00 00 00       	mov    $0x1,%eax
  803397:	89 fa                	mov    %edi,%edx
  803399:	83 c4 1c             	add    $0x1c,%esp
  80339c:	5b                   	pop    %ebx
  80339d:	5e                   	pop    %esi
  80339e:	5f                   	pop    %edi
  80339f:	5d                   	pop    %ebp
  8033a0:	c3                   	ret    
  8033a1:	8d 76 00             	lea    0x0(%esi),%esi
  8033a4:	31 ff                	xor    %edi,%edi
  8033a6:	31 c0                	xor    %eax,%eax
  8033a8:	89 fa                	mov    %edi,%edx
  8033aa:	83 c4 1c             	add    $0x1c,%esp
  8033ad:	5b                   	pop    %ebx
  8033ae:	5e                   	pop    %esi
  8033af:	5f                   	pop    %edi
  8033b0:	5d                   	pop    %ebp
  8033b1:	c3                   	ret    
  8033b2:	66 90                	xchg   %ax,%ax
  8033b4:	89 d8                	mov    %ebx,%eax
  8033b6:	f7 f7                	div    %edi
  8033b8:	31 ff                	xor    %edi,%edi
  8033ba:	89 fa                	mov    %edi,%edx
  8033bc:	83 c4 1c             	add    $0x1c,%esp
  8033bf:	5b                   	pop    %ebx
  8033c0:	5e                   	pop    %esi
  8033c1:	5f                   	pop    %edi
  8033c2:	5d                   	pop    %ebp
  8033c3:	c3                   	ret    
  8033c4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033c9:	89 eb                	mov    %ebp,%ebx
  8033cb:	29 fb                	sub    %edi,%ebx
  8033cd:	89 f9                	mov    %edi,%ecx
  8033cf:	d3 e6                	shl    %cl,%esi
  8033d1:	89 c5                	mov    %eax,%ebp
  8033d3:	88 d9                	mov    %bl,%cl
  8033d5:	d3 ed                	shr    %cl,%ebp
  8033d7:	89 e9                	mov    %ebp,%ecx
  8033d9:	09 f1                	or     %esi,%ecx
  8033db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033df:	89 f9                	mov    %edi,%ecx
  8033e1:	d3 e0                	shl    %cl,%eax
  8033e3:	89 c5                	mov    %eax,%ebp
  8033e5:	89 d6                	mov    %edx,%esi
  8033e7:	88 d9                	mov    %bl,%cl
  8033e9:	d3 ee                	shr    %cl,%esi
  8033eb:	89 f9                	mov    %edi,%ecx
  8033ed:	d3 e2                	shl    %cl,%edx
  8033ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033f3:	88 d9                	mov    %bl,%cl
  8033f5:	d3 e8                	shr    %cl,%eax
  8033f7:	09 c2                	or     %eax,%edx
  8033f9:	89 d0                	mov    %edx,%eax
  8033fb:	89 f2                	mov    %esi,%edx
  8033fd:	f7 74 24 0c          	divl   0xc(%esp)
  803401:	89 d6                	mov    %edx,%esi
  803403:	89 c3                	mov    %eax,%ebx
  803405:	f7 e5                	mul    %ebp
  803407:	39 d6                	cmp    %edx,%esi
  803409:	72 19                	jb     803424 <__udivdi3+0xfc>
  80340b:	74 0b                	je     803418 <__udivdi3+0xf0>
  80340d:	89 d8                	mov    %ebx,%eax
  80340f:	31 ff                	xor    %edi,%edi
  803411:	e9 58 ff ff ff       	jmp    80336e <__udivdi3+0x46>
  803416:	66 90                	xchg   %ax,%ax
  803418:	8b 54 24 08          	mov    0x8(%esp),%edx
  80341c:	89 f9                	mov    %edi,%ecx
  80341e:	d3 e2                	shl    %cl,%edx
  803420:	39 c2                	cmp    %eax,%edx
  803422:	73 e9                	jae    80340d <__udivdi3+0xe5>
  803424:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803427:	31 ff                	xor    %edi,%edi
  803429:	e9 40 ff ff ff       	jmp    80336e <__udivdi3+0x46>
  80342e:	66 90                	xchg   %ax,%ax
  803430:	31 c0                	xor    %eax,%eax
  803432:	e9 37 ff ff ff       	jmp    80336e <__udivdi3+0x46>
  803437:	90                   	nop

00803438 <__umoddi3>:
  803438:	55                   	push   %ebp
  803439:	57                   	push   %edi
  80343a:	56                   	push   %esi
  80343b:	53                   	push   %ebx
  80343c:	83 ec 1c             	sub    $0x1c,%esp
  80343f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803443:	8b 74 24 34          	mov    0x34(%esp),%esi
  803447:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80344b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80344f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803453:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803457:	89 f3                	mov    %esi,%ebx
  803459:	89 fa                	mov    %edi,%edx
  80345b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80345f:	89 34 24             	mov    %esi,(%esp)
  803462:	85 c0                	test   %eax,%eax
  803464:	75 1a                	jne    803480 <__umoddi3+0x48>
  803466:	39 f7                	cmp    %esi,%edi
  803468:	0f 86 a2 00 00 00    	jbe    803510 <__umoddi3+0xd8>
  80346e:	89 c8                	mov    %ecx,%eax
  803470:	89 f2                	mov    %esi,%edx
  803472:	f7 f7                	div    %edi
  803474:	89 d0                	mov    %edx,%eax
  803476:	31 d2                	xor    %edx,%edx
  803478:	83 c4 1c             	add    $0x1c,%esp
  80347b:	5b                   	pop    %ebx
  80347c:	5e                   	pop    %esi
  80347d:	5f                   	pop    %edi
  80347e:	5d                   	pop    %ebp
  80347f:	c3                   	ret    
  803480:	39 f0                	cmp    %esi,%eax
  803482:	0f 87 ac 00 00 00    	ja     803534 <__umoddi3+0xfc>
  803488:	0f bd e8             	bsr    %eax,%ebp
  80348b:	83 f5 1f             	xor    $0x1f,%ebp
  80348e:	0f 84 ac 00 00 00    	je     803540 <__umoddi3+0x108>
  803494:	bf 20 00 00 00       	mov    $0x20,%edi
  803499:	29 ef                	sub    %ebp,%edi
  80349b:	89 fe                	mov    %edi,%esi
  80349d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034a1:	89 e9                	mov    %ebp,%ecx
  8034a3:	d3 e0                	shl    %cl,%eax
  8034a5:	89 d7                	mov    %edx,%edi
  8034a7:	89 f1                	mov    %esi,%ecx
  8034a9:	d3 ef                	shr    %cl,%edi
  8034ab:	09 c7                	or     %eax,%edi
  8034ad:	89 e9                	mov    %ebp,%ecx
  8034af:	d3 e2                	shl    %cl,%edx
  8034b1:	89 14 24             	mov    %edx,(%esp)
  8034b4:	89 d8                	mov    %ebx,%eax
  8034b6:	d3 e0                	shl    %cl,%eax
  8034b8:	89 c2                	mov    %eax,%edx
  8034ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034be:	d3 e0                	shl    %cl,%eax
  8034c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034c8:	89 f1                	mov    %esi,%ecx
  8034ca:	d3 e8                	shr    %cl,%eax
  8034cc:	09 d0                	or     %edx,%eax
  8034ce:	d3 eb                	shr    %cl,%ebx
  8034d0:	89 da                	mov    %ebx,%edx
  8034d2:	f7 f7                	div    %edi
  8034d4:	89 d3                	mov    %edx,%ebx
  8034d6:	f7 24 24             	mull   (%esp)
  8034d9:	89 c6                	mov    %eax,%esi
  8034db:	89 d1                	mov    %edx,%ecx
  8034dd:	39 d3                	cmp    %edx,%ebx
  8034df:	0f 82 87 00 00 00    	jb     80356c <__umoddi3+0x134>
  8034e5:	0f 84 91 00 00 00    	je     80357c <__umoddi3+0x144>
  8034eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034ef:	29 f2                	sub    %esi,%edx
  8034f1:	19 cb                	sbb    %ecx,%ebx
  8034f3:	89 d8                	mov    %ebx,%eax
  8034f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034f9:	d3 e0                	shl    %cl,%eax
  8034fb:	89 e9                	mov    %ebp,%ecx
  8034fd:	d3 ea                	shr    %cl,%edx
  8034ff:	09 d0                	or     %edx,%eax
  803501:	89 e9                	mov    %ebp,%ecx
  803503:	d3 eb                	shr    %cl,%ebx
  803505:	89 da                	mov    %ebx,%edx
  803507:	83 c4 1c             	add    $0x1c,%esp
  80350a:	5b                   	pop    %ebx
  80350b:	5e                   	pop    %esi
  80350c:	5f                   	pop    %edi
  80350d:	5d                   	pop    %ebp
  80350e:	c3                   	ret    
  80350f:	90                   	nop
  803510:	89 fd                	mov    %edi,%ebp
  803512:	85 ff                	test   %edi,%edi
  803514:	75 0b                	jne    803521 <__umoddi3+0xe9>
  803516:	b8 01 00 00 00       	mov    $0x1,%eax
  80351b:	31 d2                	xor    %edx,%edx
  80351d:	f7 f7                	div    %edi
  80351f:	89 c5                	mov    %eax,%ebp
  803521:	89 f0                	mov    %esi,%eax
  803523:	31 d2                	xor    %edx,%edx
  803525:	f7 f5                	div    %ebp
  803527:	89 c8                	mov    %ecx,%eax
  803529:	f7 f5                	div    %ebp
  80352b:	89 d0                	mov    %edx,%eax
  80352d:	e9 44 ff ff ff       	jmp    803476 <__umoddi3+0x3e>
  803532:	66 90                	xchg   %ax,%ax
  803534:	89 c8                	mov    %ecx,%eax
  803536:	89 f2                	mov    %esi,%edx
  803538:	83 c4 1c             	add    $0x1c,%esp
  80353b:	5b                   	pop    %ebx
  80353c:	5e                   	pop    %esi
  80353d:	5f                   	pop    %edi
  80353e:	5d                   	pop    %ebp
  80353f:	c3                   	ret    
  803540:	3b 04 24             	cmp    (%esp),%eax
  803543:	72 06                	jb     80354b <__umoddi3+0x113>
  803545:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803549:	77 0f                	ja     80355a <__umoddi3+0x122>
  80354b:	89 f2                	mov    %esi,%edx
  80354d:	29 f9                	sub    %edi,%ecx
  80354f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803553:	89 14 24             	mov    %edx,(%esp)
  803556:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80355a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80355e:	8b 14 24             	mov    (%esp),%edx
  803561:	83 c4 1c             	add    $0x1c,%esp
  803564:	5b                   	pop    %ebx
  803565:	5e                   	pop    %esi
  803566:	5f                   	pop    %edi
  803567:	5d                   	pop    %ebp
  803568:	c3                   	ret    
  803569:	8d 76 00             	lea    0x0(%esi),%esi
  80356c:	2b 04 24             	sub    (%esp),%eax
  80356f:	19 fa                	sbb    %edi,%edx
  803571:	89 d1                	mov    %edx,%ecx
  803573:	89 c6                	mov    %eax,%esi
  803575:	e9 71 ff ff ff       	jmp    8034eb <__umoddi3+0xb3>
  80357a:	66 90                	xchg   %ax,%ax
  80357c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803580:	72 ea                	jb     80356c <__umoddi3+0x134>
  803582:	89 d9                	mov    %ebx,%ecx
  803584:	e9 62 ff ff ff       	jmp    8034eb <__umoddi3+0xb3>
