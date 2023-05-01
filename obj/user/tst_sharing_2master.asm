
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 35 03 00 00       	call   80036b <libmain>
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
  80008d:	68 80 35 80 00       	push   $0x803580
  800092:	6a 13                	push   $0x13
  800094:	68 9c 35 80 00       	push   $0x80359c
  800099:	e8 09 04 00 00       	call   8004a7 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 52 16 00 00       	call   8016fa <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 e8 1a 00 00       	call   801b98 <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 b7 35 80 00       	push   $0x8035b7
  8000bf:	e8 b1 17 00 00       	call   801875 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 bc 35 80 00       	push   $0x8035bc
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 9c 35 80 00       	push   $0x80359c
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 a9 1a 00 00       	call   801b98 <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 20 36 80 00       	push   $0x803620
  800100:	6a 1f                	push   $0x1f
  800102:	68 9c 35 80 00       	push   $0x80359c
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 87 1a 00 00       	call   801b98 <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 a8 36 80 00       	push   $0x8036a8
  800120:	e8 50 17 00 00       	call   801875 <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 bc 35 80 00       	push   $0x8035bc
  80013c:	6a 24                	push   $0x24
  80013e:	68 9c 35 80 00       	push   $0x80359c
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 48 1a 00 00       	call   801b98 <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 20 36 80 00       	push   $0x803620
  800161:	6a 25                	push   $0x25
  800163:	68 9c 35 80 00       	push   $0x80359c
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 26 1a 00 00       	call   801b98 <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 aa 36 80 00       	push   $0x8036aa
  800181:	e8 ef 16 00 00       	call   801875 <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 bc 35 80 00       	push   $0x8035bc
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 9c 35 80 00       	push   $0x80359c
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 e7 19 00 00       	call   801b98 <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 20 36 80 00       	push   $0x803620
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 9c 35 80 00       	push   $0x80359c
  8001c9:	e8 d9 02 00 00       	call   8004a7 <_panic>

	*x = 10 ;
  8001ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001d1:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001da:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001f6:	89 c1                	mov    %eax,%ecx
  8001f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fd:	8b 40 74             	mov    0x74(%eax),%eax
  800200:	52                   	push   %edx
  800201:	51                   	push   %ecx
  800202:	50                   	push   %eax
  800203:	68 ac 36 80 00       	push   $0x8036ac
  800208:	e8 fd 1b 00 00       	call   801e0a <sys_create_env>
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800213:	a1 20 40 80 00       	mov    0x804020,%eax
  800218:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021e:	a1 20 40 80 00       	mov    0x804020,%eax
  800223:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800229:	89 c1                	mov    %eax,%ecx
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8b 40 74             	mov    0x74(%eax),%eax
  800233:	52                   	push   %edx
  800234:	51                   	push   %ecx
  800235:	50                   	push   %eax
  800236:	68 ac 36 80 00       	push   $0x8036ac
  80023b:	e8 ca 1b 00 00       	call   801e0a <sys_create_env>
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800246:	a1 20 40 80 00       	mov    0x804020,%eax
  80024b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800251:	a1 20 40 80 00       	mov    0x804020,%eax
  800256:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80025c:	89 c1                	mov    %eax,%ecx
  80025e:	a1 20 40 80 00       	mov    0x804020,%eax
  800263:	8b 40 74             	mov    0x74(%eax),%eax
  800266:	52                   	push   %edx
  800267:	51                   	push   %ecx
  800268:	50                   	push   %eax
  800269:	68 ac 36 80 00       	push   $0x8036ac
  80026e:	e8 97 1b 00 00       	call   801e0a <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 d8 1c 00 00       	call   801f56 <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 9f 1b 00 00       	call   801e28 <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 91 1b 00 00       	call   801e28 <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 83 1b 00 00       	call   801e28 <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 aa 2f 00 00       	call   80325f <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 13 1d 00 00       	call   801fd0 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 b7 36 80 00       	push   $0x8036b7
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 9c 35 80 00       	push   $0x80359c
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 c4 36 80 00       	push   $0x8036c4
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 9c 35 80 00       	push   $0x80359c
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 10 37 80 00       	push   $0x803710
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 6c 37 80 00       	push   $0x80376c
  80030c:	e8 4a 04 00 00       	call   80075b <cprintf>
  800311:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800314:	a1 20 40 80 00       	mov    0x804020,%eax
  800319:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80031f:	a1 20 40 80 00       	mov    0x804020,%eax
  800324:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80032a:	89 c1                	mov    %eax,%ecx
  80032c:	a1 20 40 80 00       	mov    0x804020,%eax
  800331:	8b 40 74             	mov    0x74(%eax),%eax
  800334:	52                   	push   %edx
  800335:	51                   	push   %ecx
  800336:	50                   	push   %eax
  800337:	68 c7 37 80 00       	push   $0x8037c7
  80033c:	e8 c9 1a 00 00       	call   801e0a <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 0b 2f 00 00       	call   80325f <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 c6 1a 00 00       	call   801e28 <sys_run_env>
  800362:	83 c4 10             	add    $0x10,%esp

	return;
  800365:	90                   	nop
}
  800366:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800371:	e8 02 1b 00 00       	call   801e78 <sys_getenvindex>
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80037c:	89 d0                	mov    %edx,%eax
  80037e:	c1 e0 03             	shl    $0x3,%eax
  800381:	01 d0                	add    %edx,%eax
  800383:	01 c0                	add    %eax,%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038e:	01 d0                	add    %edx,%eax
  800390:	c1 e0 04             	shl    $0x4,%eax
  800393:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800398:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80039d:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003a8:	84 c0                	test   %al,%al
  8003aa:	74 0f                	je     8003bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8003b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003bf:	7e 0a                	jle    8003cb <libmain+0x60>
		binaryname = argv[0];
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 5f fc ff ff       	call   800038 <_main>
  8003d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003dc:	e8 a4 18 00 00       	call   801c85 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 ec 37 80 00       	push   $0x8037ec
  8003e9:	e8 6d 03 00 00       	call   80075b <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800401:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800407:	83 ec 04             	sub    $0x4,%esp
  80040a:	52                   	push   %edx
  80040b:	50                   	push   %eax
  80040c:	68 14 38 80 00       	push   $0x803814
  800411:	e8 45 03 00 00       	call   80075b <cprintf>
  800416:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800419:	a1 20 40 80 00       	mov    0x804020,%eax
  80041e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800424:	a1 20 40 80 00       	mov    0x804020,%eax
  800429:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80042f:	a1 20 40 80 00       	mov    0x804020,%eax
  800434:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80043a:	51                   	push   %ecx
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	68 3c 38 80 00       	push   $0x80383c
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 40 80 00       	mov    0x804020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 94 38 80 00       	push   $0x803894
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 ec 37 80 00       	push   $0x8037ec
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 24 18 00 00       	call   801c9f <sys_enable_interrupt>

	// exit gracefully
	exit();
  80047b:	e8 19 00 00 00       	call   800499 <exit>
}
  800480:	90                   	nop
  800481:	c9                   	leave  
  800482:	c3                   	ret    

00800483 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800489:	83 ec 0c             	sub    $0xc,%esp
  80048c:	6a 00                	push   $0x0
  80048e:	e8 b1 19 00 00       	call   801e44 <sys_destroy_env>
  800493:	83 c4 10             	add    $0x10,%esp
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <exit>:

void
exit(void)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049f:	e8 06 1a 00 00       	call   801eaa <sys_exit_env>
}
  8004a4:	90                   	nop
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b0:	83 c0 04             	add    $0x4,%eax
  8004b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	74 16                	je     8004d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004bf:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	50                   	push   %eax
  8004c8:	68 a8 38 80 00       	push   $0x8038a8
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 40 80 00       	mov    0x804000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 ad 38 80 00       	push   $0x8038ad
  8004e6:	e8 70 02 00 00       	call   80075b <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f7:	50                   	push   %eax
  8004f8:	e8 f3 01 00 00       	call   8006f0 <vcprintf>
  8004fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	6a 00                	push   $0x0
  800505:	68 c9 38 80 00       	push   $0x8038c9
  80050a:	e8 e1 01 00 00       	call   8006f0 <vcprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800512:	e8 82 ff ff ff       	call   800499 <exit>

	// should not return here
	while (1) ;
  800517:	eb fe                	jmp    800517 <_panic+0x70>

00800519 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80051f:	a1 20 40 80 00       	mov    0x804020,%eax
  800524:	8b 50 74             	mov    0x74(%eax),%edx
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	39 c2                	cmp    %eax,%edx
  80052c:	74 14                	je     800542 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	68 cc 38 80 00       	push   $0x8038cc
  800536:	6a 26                	push   $0x26
  800538:	68 18 39 80 00       	push   $0x803918
  80053d:	e8 65 ff ff ff       	call   8004a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800550:	e9 c2 00 00 00       	jmp    800617 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800558:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	01 d0                	add    %edx,%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	85 c0                	test   %eax,%eax
  800568:	75 08                	jne    800572 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80056a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80056d:	e9 a2 00 00 00       	jmp    800614 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800572:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800580:	eb 69                	jmp    8005eb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800582:	a1 20 40 80 00       	mov    0x804020,%eax
  800587:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800590:	89 d0                	mov    %edx,%eax
  800592:	01 c0                	add    %eax,%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	c1 e0 03             	shl    $0x3,%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8a 40 04             	mov    0x4(%eax),%al
  80059e:	84 c0                	test   %al,%al
  8005a0:	75 46                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b0:	89 d0                	mov    %edx,%eax
  8005b2:	01 c0                	add    %eax,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	c1 e0 03             	shl    $0x3,%eax
  8005b9:	01 c8                	add    %ecx,%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	01 c8                	add    %ecx,%eax
  8005d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	75 09                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e6:	eb 12                	jmp    8005fa <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e8:	ff 45 e8             	incl   -0x18(%ebp)
  8005eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f0:	8b 50 74             	mov    0x74(%eax),%edx
  8005f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f6:	39 c2                	cmp    %eax,%edx
  8005f8:	77 88                	ja     800582 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005fe:	75 14                	jne    800614 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 24 39 80 00       	push   $0x803924
  800608:	6a 3a                	push   $0x3a
  80060a:	68 18 39 80 00       	push   $0x803918
  80060f:	e8 93 fe ff ff       	call   8004a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800614:	ff 45 f0             	incl   -0x10(%ebp)
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061d:	0f 8c 32 ff ff ff    	jl     800555 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800631:	eb 26                	jmp    800659 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800633:	a1 20 40 80 00       	mov    0x804020,%eax
  800638:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80063e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800641:	89 d0                	mov    %edx,%eax
  800643:	01 c0                	add    %eax,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	c1 e0 03             	shl    $0x3,%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8a 40 04             	mov    0x4(%eax),%al
  80064f:	3c 01                	cmp    $0x1,%al
  800651:	75 03                	jne    800656 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800653:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800656:	ff 45 e0             	incl   -0x20(%ebp)
  800659:	a1 20 40 80 00       	mov    0x804020,%eax
  80065e:	8b 50 74             	mov    0x74(%eax),%edx
  800661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800664:	39 c2                	cmp    %eax,%edx
  800666:	77 cb                	ja     800633 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80066e:	74 14                	je     800684 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800670:	83 ec 04             	sub    $0x4,%esp
  800673:	68 78 39 80 00       	push   $0x803978
  800678:	6a 44                	push   $0x44
  80067a:	68 18 39 80 00       	push   $0x803918
  80067f:	e8 23 fe ff ff       	call   8004a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800684:	90                   	nop
  800685:	c9                   	leave  
  800686:	c3                   	ret    

00800687 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800687:	55                   	push   %ebp
  800688:	89 e5                	mov    %esp,%ebp
  80068a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	8d 48 01             	lea    0x1(%eax),%ecx
  800695:	8b 55 0c             	mov    0xc(%ebp),%edx
  800698:	89 0a                	mov    %ecx,(%edx)
  80069a:	8b 55 08             	mov    0x8(%ebp),%edx
  80069d:	88 d1                	mov    %dl,%cl
  80069f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b0:	75 2c                	jne    8006de <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006b2:	a0 24 40 80 00       	mov    0x804024,%al
  8006b7:	0f b6 c0             	movzbl %al,%eax
  8006ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bd:	8b 12                	mov    (%edx),%edx
  8006bf:	89 d1                	mov    %edx,%ecx
  8006c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c4:	83 c2 08             	add    $0x8,%edx
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	50                   	push   %eax
  8006cb:	51                   	push   %ecx
  8006cc:	52                   	push   %edx
  8006cd:	e8 05 14 00 00       	call   801ad7 <sys_cputs>
  8006d2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	8b 40 04             	mov    0x4(%eax),%eax
  8006e4:	8d 50 01             	lea    0x1(%eax),%edx
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ed:	90                   	nop
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800700:	00 00 00 
	b.cnt = 0;
  800703:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	ff 75 08             	pushl  0x8(%ebp)
  800713:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800719:	50                   	push   %eax
  80071a:	68 87 06 80 00       	push   $0x800687
  80071f:	e8 11 02 00 00       	call   800935 <vprintfmt>
  800724:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800727:	a0 24 40 80 00       	mov    0x804024,%al
  80072c:	0f b6 c0             	movzbl %al,%eax
  80072f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	50                   	push   %eax
  800739:	52                   	push   %edx
  80073a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800740:	83 c0 08             	add    $0x8,%eax
  800743:	50                   	push   %eax
  800744:	e8 8e 13 00 00       	call   801ad7 <sys_cputs>
  800749:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80074c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800753:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <cprintf>:

int cprintf(const char *fmt, ...) {
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800761:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800768:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 f4             	pushl  -0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	e8 73 ff ff ff       	call   8006f0 <vcprintf>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800783:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80078e:	e8 f2 14 00 00       	call   801c85 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800793:	8d 45 0c             	lea    0xc(%ebp),%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a2:	50                   	push   %eax
  8007a3:	e8 48 ff ff ff       	call   8006f0 <vcprintf>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007ae:	e8 ec 14 00 00       	call   801c9f <sys_enable_interrupt>
	return cnt;
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	53                   	push   %ebx
  8007bc:	83 ec 14             	sub    $0x14,%esp
  8007bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d6:	77 55                	ja     80082d <printnum+0x75>
  8007d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007db:	72 05                	jb     8007e2 <printnum+0x2a>
  8007dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007e0:	77 4b                	ja     80082d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8007eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f0:	52                   	push   %edx
  8007f1:	50                   	push   %eax
  8007f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8007f8:	e8 17 2b 00 00       	call   803314 <__udivdi3>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	ff 75 20             	pushl  0x20(%ebp)
  800806:	53                   	push   %ebx
  800807:	ff 75 18             	pushl  0x18(%ebp)
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	ff 75 08             	pushl  0x8(%ebp)
  800812:	e8 a1 ff ff ff       	call   8007b8 <printnum>
  800817:	83 c4 20             	add    $0x20,%esp
  80081a:	eb 1a                	jmp    800836 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	ff 75 20             	pushl  0x20(%ebp)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80082d:	ff 4d 1c             	decl   0x1c(%ebp)
  800830:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800834:	7f e6                	jg     80081c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800836:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800839:	bb 00 00 00 00       	mov    $0x0,%ebx
  80083e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800844:	53                   	push   %ebx
  800845:	51                   	push   %ecx
  800846:	52                   	push   %edx
  800847:	50                   	push   %eax
  800848:	e8 d7 2b 00 00       	call   803424 <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 f4 3b 80 00       	add    $0x803bf4,%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be c0             	movsbl %al,%eax
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	50                   	push   %eax
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
}
  800869:	90                   	nop
  80086a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086d:	c9                   	leave  
  80086e:	c3                   	ret    

0080086f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800872:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800876:	7e 1c                	jle    800894 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	8d 50 08             	lea    0x8(%eax),%edx
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	89 10                	mov    %edx,(%eax)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	83 e8 08             	sub    $0x8,%eax
  80088d:	8b 50 04             	mov    0x4(%eax),%edx
  800890:	8b 00                	mov    (%eax),%eax
  800892:	eb 40                	jmp    8008d4 <getuint+0x65>
	else if (lflag)
  800894:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800898:	74 1e                	je     8008b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	eb 1c                	jmp    8008d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	8d 50 04             	lea    0x4(%eax),%edx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	89 10                	mov    %edx,(%eax)
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 e8 04             	sub    $0x4,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008dd:	7e 1c                	jle    8008fb <getint+0x25>
		return va_arg(*ap, long long);
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	8d 50 08             	lea    0x8(%eax),%edx
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	89 10                	mov    %edx,(%eax)
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	83 e8 08             	sub    $0x8,%eax
  8008f4:	8b 50 04             	mov    0x4(%eax),%edx
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	eb 38                	jmp    800933 <getint+0x5d>
	else if (lflag)
  8008fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ff:	74 1a                	je     80091b <getint+0x45>
		return va_arg(*ap, long);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 04             	lea    0x4(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	99                   	cltd   
  800919:	eb 18                	jmp    800933 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 04             	lea    0x4(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	99                   	cltd   
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093d:	eb 17                	jmp    800956 <vprintfmt+0x21>
			if (ch == '\0')
  80093f:	85 db                	test   %ebx,%ebx
  800941:	0f 84 af 03 00 00    	je     800cf6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800956:	8b 45 10             	mov    0x10(%ebp),%eax
  800959:	8d 50 01             	lea    0x1(%eax),%edx
  80095c:	89 55 10             	mov    %edx,0x10(%ebp)
  80095f:	8a 00                	mov    (%eax),%al
  800961:	0f b6 d8             	movzbl %al,%ebx
  800964:	83 fb 25             	cmp    $0x25,%ebx
  800967:	75 d6                	jne    80093f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800969:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80096d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800974:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80097b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800982:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800989:	8b 45 10             	mov    0x10(%ebp),%eax
  80098c:	8d 50 01             	lea    0x1(%eax),%edx
  80098f:	89 55 10             	mov    %edx,0x10(%ebp)
  800992:	8a 00                	mov    (%eax),%al
  800994:	0f b6 d8             	movzbl %al,%ebx
  800997:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80099a:	83 f8 55             	cmp    $0x55,%eax
  80099d:	0f 87 2b 03 00 00    	ja     800cce <vprintfmt+0x399>
  8009a3:	8b 04 85 18 3c 80 00 	mov    0x803c18(,%eax,4),%eax
  8009aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009b0:	eb d7                	jmp    800989 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009b6:	eb d1                	jmp    800989 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	c1 e0 02             	shl    $0x2,%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	01 c0                	add    %eax,%eax
  8009cb:	01 d8                	add    %ebx,%eax
  8009cd:	83 e8 30             	sub    $0x30,%eax
  8009d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d6:	8a 00                	mov    (%eax),%al
  8009d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009db:	83 fb 2f             	cmp    $0x2f,%ebx
  8009de:	7e 3e                	jle    800a1e <vprintfmt+0xe9>
  8009e0:	83 fb 39             	cmp    $0x39,%ebx
  8009e3:	7f 39                	jg     800a1e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e8:	eb d5                	jmp    8009bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	83 c0 04             	add    $0x4,%eax
  8009f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	83 e8 04             	sub    $0x4,%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009fe:	eb 1f                	jmp    800a1f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a04:	79 83                	jns    800989 <vprintfmt+0x54>
				width = 0;
  800a06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a0d:	e9 77 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a12:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a19:	e9 6b ff ff ff       	jmp    800989 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a1e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a23:	0f 89 60 ff ff ff    	jns    800989 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a36:	e9 4e ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a3e:	e9 46 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 c0 04             	add    $0x4,%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 e8 04             	sub    $0x4,%eax
  800a52:	8b 00                	mov    (%eax),%eax
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	e9 89 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	83 c0 04             	add    $0x4,%eax
  800a6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 e8 04             	sub    $0x4,%eax
  800a77:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a79:	85 db                	test   %ebx,%ebx
  800a7b:	79 02                	jns    800a7f <vprintfmt+0x14a>
				err = -err;
  800a7d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a7f:	83 fb 64             	cmp    $0x64,%ebx
  800a82:	7f 0b                	jg     800a8f <vprintfmt+0x15a>
  800a84:	8b 34 9d 60 3a 80 00 	mov    0x803a60(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 05 3c 80 00       	push   $0x803c05
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	e8 5e 02 00 00       	call   800cfe <printfmt>
  800aa0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa3:	e9 49 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa8:	56                   	push   %esi
  800aa9:	68 0e 3c 80 00       	push   $0x803c0e
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 45 02 00 00       	call   800cfe <printfmt>
  800ab9:	83 c4 10             	add    $0x10,%esp
			break;
  800abc:	e9 30 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	83 c0 04             	add    $0x4,%eax
  800ac7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 e8 04             	sub    $0x4,%eax
  800ad0:	8b 30                	mov    (%eax),%esi
  800ad2:	85 f6                	test   %esi,%esi
  800ad4:	75 05                	jne    800adb <vprintfmt+0x1a6>
				p = "(null)";
  800ad6:	be 11 3c 80 00       	mov    $0x803c11,%esi
			if (width > 0 && padc != '-')
  800adb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adf:	7e 6d                	jle    800b4e <vprintfmt+0x219>
  800ae1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ae5:	74 67                	je     800b4e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	50                   	push   %eax
  800aee:	56                   	push   %esi
  800aef:	e8 0c 03 00 00       	call   800e00 <strnlen>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800afa:	eb 16                	jmp    800b12 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800afc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	50                   	push   %eax
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b16:	7f e4                	jg     800afc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b18:	eb 34                	jmp    800b4e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b1e:	74 1c                	je     800b3c <vprintfmt+0x207>
  800b20:	83 fb 1f             	cmp    $0x1f,%ebx
  800b23:	7e 05                	jle    800b2a <vprintfmt+0x1f5>
  800b25:	83 fb 7e             	cmp    $0x7e,%ebx
  800b28:	7e 12                	jle    800b3c <vprintfmt+0x207>
					putch('?', putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	6a 3f                	push   $0x3f
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	eb 0f                	jmp    800b4b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4e:	89 f0                	mov    %esi,%eax
  800b50:	8d 70 01             	lea    0x1(%eax),%esi
  800b53:	8a 00                	mov    (%eax),%al
  800b55:	0f be d8             	movsbl %al,%ebx
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	74 24                	je     800b80 <vprintfmt+0x24b>
  800b5c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b60:	78 b8                	js     800b1a <vprintfmt+0x1e5>
  800b62:	ff 4d e0             	decl   -0x20(%ebp)
  800b65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b69:	79 af                	jns    800b1a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6b:	eb 13                	jmp    800b80 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 20                	push   $0x20
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b84:	7f e7                	jg     800b6d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b86:	e9 66 01 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b91:	8d 45 14             	lea    0x14(%ebp),%eax
  800b94:	50                   	push   %eax
  800b95:	e8 3c fd ff ff       	call   8008d6 <getint>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba9:	85 d2                	test   %edx,%edx
  800bab:	79 23                	jns    800bd0 <vprintfmt+0x29b>
				putch('-', putdat);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	6a 2d                	push   $0x2d
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	f7 d8                	neg    %eax
  800bc5:	83 d2 00             	adc    $0x0,%edx
  800bc8:	f7 da                	neg    %edx
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bd0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd7:	e9 bc 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 e8             	pushl  -0x18(%ebp)
  800be2:	8d 45 14             	lea    0x14(%ebp),%eax
  800be5:	50                   	push   %eax
  800be6:	e8 84 fc ff ff       	call   80086f <getuint>
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bf4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bfb:	e9 98 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	6a 58                	push   $0x58
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	ff d0                	call   *%eax
  800c0d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 58                	push   $0x58
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 58                	push   $0x58
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			break;
  800c30:	e9 bc 00 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	6a 30                	push   $0x30
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	ff d0                	call   *%eax
  800c42:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	6a 78                	push   $0x78
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	ff d0                	call   *%eax
  800c52:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 e8 04             	sub    $0x4,%eax
  800c64:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c70:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c77:	eb 1f                	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c82:	50                   	push   %eax
  800c83:	e8 e7 fb ff ff       	call   80086f <getuint>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c91:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c98:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	52                   	push   %edx
  800ca3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ca6:	50                   	push   %eax
  800ca7:	ff 75 f4             	pushl  -0xc(%ebp)
  800caa:	ff 75 f0             	pushl  -0x10(%ebp)
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	ff 75 08             	pushl  0x8(%ebp)
  800cb3:	e8 00 fb ff ff       	call   8007b8 <printnum>
  800cb8:	83 c4 20             	add    $0x20,%esp
			break;
  800cbb:	eb 34                	jmp    800cf1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cbd:	83 ec 08             	sub    $0x8,%esp
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	53                   	push   %ebx
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
			break;
  800ccc:	eb 23                	jmp    800cf1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 25                	push   $0x25
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cde:	ff 4d 10             	decl   0x10(%ebp)
  800ce1:	eb 03                	jmp    800ce6 <vprintfmt+0x3b1>
  800ce3:	ff 4d 10             	decl   0x10(%ebp)
  800ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce9:	48                   	dec    %eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 25                	cmp    $0x25,%al
  800cee:	75 f3                	jne    800ce3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cf0:	90                   	nop
		}
	}
  800cf1:	e9 47 fc ff ff       	jmp    80093d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cf6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 16 fc ff ff       	call   800935 <vprintfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d22:	90                   	nop
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 40 08             	mov    0x8(%eax),%eax
  800d2e:	8d 50 01             	lea    0x1(%eax),%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	8b 10                	mov    (%eax),%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 04             	mov    0x4(%eax),%eax
  800d42:	39 c2                	cmp    %eax,%edx
  800d44:	73 12                	jae    800d58 <sprintputch+0x33>
		*b->buf++ = ch;
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d51:	89 0a                	mov    %ecx,(%edx)
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	88 10                	mov    %dl,(%eax)
}
  800d58:	90                   	nop
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	01 d0                	add    %edx,%eax
  800d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d80:	74 06                	je     800d88 <vsnprintf+0x2d>
  800d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d86:	7f 07                	jg     800d8f <vsnprintf+0x34>
		return -E_INVAL;
  800d88:	b8 03 00 00 00       	mov    $0x3,%eax
  800d8d:	eb 20                	jmp    800daf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d8f:	ff 75 14             	pushl  0x14(%ebp)
  800d92:	ff 75 10             	pushl  0x10(%ebp)
  800d95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d98:	50                   	push   %eax
  800d99:	68 25 0d 80 00       	push   $0x800d25
  800d9e:	e8 92 fb ff ff       	call   800935 <vprintfmt>
  800da3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800db7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc6:	50                   	push   %eax
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 89 ff ff ff       	call   800d5b <vsnprintf>
  800dd2:	83 c4 10             	add    $0x10,%esp
  800dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800de3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dea:	eb 06                	jmp    800df2 <strlen+0x15>
		n++;
  800dec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800def:	ff 45 08             	incl   0x8(%ebp)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	75 f1                	jne    800dec <strlen+0xf>
		n++;
	return n;
  800dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0d:	eb 09                	jmp    800e18 <strnlen+0x18>
		n++;
  800e0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 4d 0c             	decl   0xc(%ebp)
  800e18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1c:	74 09                	je     800e27 <strnlen+0x27>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	75 e8                	jne    800e0f <strnlen+0xf>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e38:	90                   	nop
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	84 c0                	test   %al,%al
  800e53:	75 e4                	jne    800e39 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6d:	eb 1f                	jmp    800e8e <strncpy+0x34>
		*dst++ = *src;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 08             	mov    %edx,0x8(%ebp)
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	8a 12                	mov    (%edx),%dl
  800e7d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	84 c0                	test   %al,%al
  800e86:	74 03                	je     800e8b <strncpy+0x31>
			src++;
  800e88:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e8b:	ff 45 fc             	incl   -0x4(%ebp)
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e91:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e94:	72 d9                	jb     800e6f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	74 30                	je     800edd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ead:	eb 16                	jmp    800ec5 <strlcpy+0x2a>
			*dst++ = *src++;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8d 50 01             	lea    0x1(%eax),%edx
  800eb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ebe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec1:	8a 12                	mov    (%edx),%dl
  800ec3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ec5:	ff 4d 10             	decl   0x10(%ebp)
  800ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecc:	74 09                	je     800ed7 <strlcpy+0x3c>
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 d8                	jne    800eaf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	29 c2                	sub    %eax,%edx
  800ee5:	89 d0                	mov    %edx,%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eec:	eb 06                	jmp    800ef4 <strcmp+0xb>
		p++, q++;
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	84 c0                	test   %al,%al
  800efb:	74 0e                	je     800f0b <strcmp+0x22>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 10                	mov    (%eax),%dl
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	38 c2                	cmp    %al,%dl
  800f09:	74 e3                	je     800eee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	0f b6 d0             	movzbl %al,%edx
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f b6 c0             	movzbl %al,%eax
  800f1b:	29 c2                	sub    %eax,%edx
  800f1d:	89 d0                	mov    %edx,%eax
}
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    

00800f21 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f24:	eb 09                	jmp    800f2f <strncmp+0xe>
		n--, p++, q++;
  800f26:	ff 4d 10             	decl   0x10(%ebp)
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	74 17                	je     800f4c <strncmp+0x2b>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	74 0e                	je     800f4c <strncmp+0x2b>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 10                	mov    (%eax),%dl
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	38 c2                	cmp    %al,%dl
  800f4a:	74 da                	je     800f26 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	75 07                	jne    800f59 <strncmp+0x38>
		return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
  800f57:	eb 14                	jmp    800f6d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 c0             	movzbl %al,%eax
  800f69:	29 c2                	sub    %eax,%edx
  800f6b:	89 d0                	mov    %edx,%eax
}
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 04             	sub    $0x4,%esp
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f7b:	eb 12                	jmp    800f8f <strchr+0x20>
		if (*s == c)
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f85:	75 05                	jne    800f8c <strchr+0x1d>
			return (char *) s;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	eb 11                	jmp    800f9d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f8c:	ff 45 08             	incl   0x8(%ebp)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	84 c0                	test   %al,%al
  800f96:	75 e5                	jne    800f7d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	83 ec 04             	sub    $0x4,%esp
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fab:	eb 0d                	jmp    800fba <strfind+0x1b>
		if (*s == c)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb5:	74 0e                	je     800fc5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 ea                	jne    800fad <strfind+0xe>
  800fc3:	eb 01                	jmp    800fc6 <strfind+0x27>
		if (*s == c)
			break;
  800fc5:	90                   	nop
	return (char *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fdd:	eb 0e                	jmp    800fed <memset+0x22>
		*p++ = c;
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	8d 50 01             	lea    0x1(%eax),%edx
  800fe5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800feb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fed:	ff 4d f8             	decl   -0x8(%ebp)
  800ff0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ff4:	79 e9                	jns    800fdf <memset+0x14>
		*p++ = c;

	return v;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80100d:	eb 16                	jmp    801025 <memcpy+0x2a>
		*d++ = *s++;
  80100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801012:	8d 50 01             	lea    0x1(%eax),%edx
  801015:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801018:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801021:	8a 12                	mov    (%edx),%dl
  801023:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102b:	89 55 10             	mov    %edx,0x10(%ebp)
  80102e:	85 c0                	test   %eax,%eax
  801030:	75 dd                	jne    80100f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104f:	73 50                	jae    8010a1 <memmove+0x6a>
  801051:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80105c:	76 43                	jbe    8010a1 <memmove+0x6a>
		s += n;
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80106a:	eb 10                	jmp    80107c <memmove+0x45>
			*--d = *--s;
  80106c:	ff 4d f8             	decl   -0x8(%ebp)
  80106f:	ff 4d fc             	decl   -0x4(%ebp)
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	8a 10                	mov    (%eax),%dl
  801077:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	89 55 10             	mov    %edx,0x10(%ebp)
  801085:	85 c0                	test   %eax,%eax
  801087:	75 e3                	jne    80106c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801089:	eb 23                	jmp    8010ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8d 50 01             	lea    0x1(%eax),%edx
  801091:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801094:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801097:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80109d:	8a 12                	mov    (%edx),%dl
  80109f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	75 dd                	jne    80108b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010c5:	eb 2a                	jmp    8010f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 10                	mov    (%eax),%dl
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	38 c2                	cmp    %al,%dl
  8010d3:	74 16                	je     8010eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f b6 d0             	movzbl %al,%edx
  8010dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	0f b6 c0             	movzbl %al,%eax
  8010e5:	29 c2                	sub    %eax,%edx
  8010e7:	89 d0                	mov    %edx,%eax
  8010e9:	eb 18                	jmp    801103 <memcmp+0x50>
		s1++, s2++;
  8010eb:	ff 45 fc             	incl   -0x4(%ebp)
  8010ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 c9                	jne    8010c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801116:	eb 15                	jmp    80112d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f b6 d0             	movzbl %al,%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	0f b6 c0             	movzbl %al,%eax
  801126:	39 c2                	cmp    %eax,%edx
  801128:	74 0d                	je     801137 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80112a:	ff 45 08             	incl   0x8(%ebp)
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801133:	72 e3                	jb     801118 <memfind+0x13>
  801135:	eb 01                	jmp    801138 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801137:	90                   	nop
	return (void *) s;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80114a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801151:	eb 03                	jmp    801156 <strtol+0x19>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 20                	cmp    $0x20,%al
  80115d:	74 f4                	je     801153 <strtol+0x16>
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 09                	cmp    $0x9,%al
  801166:	74 eb                	je     801153 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2b                	cmp    $0x2b,%al
  80116f:	75 05                	jne    801176 <strtol+0x39>
		s++;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	eb 13                	jmp    801189 <strtol+0x4c>
	else if (*s == '-')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 2d                	cmp    $0x2d,%al
  80117d:	75 0a                	jne    801189 <strtol+0x4c>
		s++, neg = 1;
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801189:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118d:	74 06                	je     801195 <strtol+0x58>
  80118f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801193:	75 20                	jne    8011b5 <strtol+0x78>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 30                	cmp    $0x30,%al
  80119c:	75 17                	jne    8011b5 <strtol+0x78>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	40                   	inc    %eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 78                	cmp    $0x78,%al
  8011a6:	75 0d                	jne    8011b5 <strtol+0x78>
		s += 2, base = 16;
  8011a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b3:	eb 28                	jmp    8011dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b9:	75 15                	jne    8011d0 <strtol+0x93>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	3c 30                	cmp    $0x30,%al
  8011c2:	75 0c                	jne    8011d0 <strtol+0x93>
		s++, base = 8;
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ce:	eb 0d                	jmp    8011dd <strtol+0xa0>
	else if (base == 0)
  8011d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d4:	75 07                	jne    8011dd <strtol+0xa0>
		base = 10;
  8011d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 2f                	cmp    $0x2f,%al
  8011e4:	7e 19                	jle    8011ff <strtol+0xc2>
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 39                	cmp    $0x39,%al
  8011ed:	7f 10                	jg     8011ff <strtol+0xc2>
			dig = *s - '0';
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	0f be c0             	movsbl %al,%eax
  8011f7:	83 e8 30             	sub    $0x30,%eax
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011fd:	eb 42                	jmp    801241 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 60                	cmp    $0x60,%al
  801206:	7e 19                	jle    801221 <strtol+0xe4>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 7a                	cmp    $0x7a,%al
  80120f:	7f 10                	jg     801221 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	83 e8 57             	sub    $0x57,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121f:	eb 20                	jmp    801241 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 40                	cmp    $0x40,%al
  801228:	7e 39                	jle    801263 <strtol+0x126>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 5a                	cmp    $0x5a,%al
  801231:	7f 30                	jg     801263 <strtol+0x126>
			dig = *s - 'A' + 10;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	83 e8 37             	sub    $0x37,%eax
  80123e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801244:	3b 45 10             	cmp    0x10(%ebp),%eax
  801247:	7d 19                	jge    801262 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801249:	ff 45 08             	incl   0x8(%ebp)
  80124c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80125d:	e9 7b ff ff ff       	jmp    8011dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801262:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801263:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801267:	74 08                	je     801271 <strtol+0x134>
		*endptr = (char *) s;
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	8b 55 08             	mov    0x8(%ebp),%edx
  80126f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801271:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801275:	74 07                	je     80127e <strtol+0x141>
  801277:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127a:	f7 d8                	neg    %eax
  80127c:	eb 03                	jmp    801281 <strtol+0x144>
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <ltostr>:

void
ltostr(long value, char *str)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801290:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80129b:	79 13                	jns    8012b0 <ltostr+0x2d>
	{
		neg = 1;
  80129d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b8:	99                   	cltd   
  8012b9:	f7 f9                	idiv   %ecx
  8012bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d1:	83 c2 30             	add    $0x30,%edx
  8012d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012de:	f7 e9                	imul   %ecx
  8012e0:	c1 fa 02             	sar    $0x2,%edx
  8012e3:	89 c8                	mov    %ecx,%eax
  8012e5:	c1 f8 1f             	sar    $0x1f,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
  8012ec:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f7:	f7 e9                	imul   %ecx
  8012f9:	c1 fa 02             	sar    $0x2,%edx
  8012fc:	89 c8                	mov    %ecx,%eax
  8012fe:	c1 f8 1f             	sar    $0x1f,%eax
  801301:	29 c2                	sub    %eax,%edx
  801303:	89 d0                	mov    %edx,%eax
  801305:	c1 e0 02             	shl    $0x2,%eax
  801308:	01 d0                	add    %edx,%eax
  80130a:	01 c0                	add    %eax,%eax
  80130c:	29 c1                	sub    %eax,%ecx
  80130e:	89 ca                	mov    %ecx,%edx
  801310:	85 d2                	test   %edx,%edx
  801312:	75 9c                	jne    8012b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131e:	48                   	dec    %eax
  80131f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801322:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801326:	74 3d                	je     801365 <ltostr+0xe2>
		start = 1 ;
  801328:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80132f:	eb 34                	jmp    801365 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80133e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	01 c2                	add    %eax,%edx
  801346:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 c8                	add    %ecx,%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80135d:	88 02                	mov    %al,(%edx)
		start++ ;
  80135f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801362:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801368:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136b:	7c c4                	jl     801331 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80136d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 d0                	add    %edx,%eax
  801375:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801378:	90                   	nop
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	e8 54 fa ff ff       	call   800ddd <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	e8 46 fa ff ff       	call   800ddd <strlen>
  801397:	83 c4 04             	add    $0x4,%esp
  80139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80139d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ab:	eb 17                	jmp    8013c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 c2                	add    %eax,%edx
  8013b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	01 c8                	add    %ecx,%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c1:	ff 45 fc             	incl   -0x4(%ebp)
  8013c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ca:	7c e1                	jl     8013ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013da:	eb 1f                	jmp    8013fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8d 50 01             	lea    0x1(%eax),%edx
  8013e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e5:	89 c2                	mov    %eax,%edx
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 c2                	add    %eax,%edx
  8013ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 c8                	add    %ecx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f8:	ff 45 f8             	incl   -0x8(%ebp)
  8013fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801401:	7c d9                	jl     8013dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801403:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	01 d0                	add    %edx,%eax
  80140b:	c6 00 00             	movb   $0x0,(%eax)
}
  80140e:	90                   	nop
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80141d:	8b 45 14             	mov    0x14(%ebp),%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801429:	8b 45 10             	mov    0x10(%ebp),%eax
  80142c:	01 d0                	add    %edx,%eax
  80142e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	eb 0c                	jmp    801442 <strsplit+0x31>
			*string++ = 0;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8d 50 01             	lea    0x1(%eax),%edx
  80143c:	89 55 08             	mov    %edx,0x8(%ebp)
  80143f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	84 c0                	test   %al,%al
  801449:	74 18                	je     801463 <strsplit+0x52>
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	50                   	push   %eax
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	e8 13 fb ff ff       	call   800f6f <strchr>
  80145c:	83 c4 08             	add    $0x8,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	75 d3                	jne    801436 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	84 c0                	test   %al,%al
  80146a:	74 5a                	je     8014c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80146c:	8b 45 14             	mov    0x14(%ebp),%eax
  80146f:	8b 00                	mov    (%eax),%eax
  801471:	83 f8 0f             	cmp    $0xf,%eax
  801474:	75 07                	jne    80147d <strsplit+0x6c>
		{
			return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 66                	jmp    8014e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80147d:	8b 45 14             	mov    0x14(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	8d 48 01             	lea    0x1(%eax),%ecx
  801485:	8b 55 14             	mov    0x14(%ebp),%edx
  801488:	89 0a                	mov    %ecx,(%edx)
  80148a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 c2                	add    %eax,%edx
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149b:	eb 03                	jmp    8014a0 <strsplit+0x8f>
			string++;
  80149d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	84 c0                	test   %al,%al
  8014a7:	74 8b                	je     801434 <strsplit+0x23>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	0f be c0             	movsbl %al,%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	e8 b5 fa ff ff       	call   800f6f <strchr>
  8014ba:	83 c4 08             	add    $0x8,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	74 dc                	je     80149d <strsplit+0x8c>
			string++;
	}
  8014c1:	e9 6e ff ff ff       	jmp    801434 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	74 1f                	je     801513 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014f4:	e8 1d 00 00 00       	call   801516 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	68 70 3d 80 00       	push   $0x803d70
  801501:	e8 55 f2 ff ff       	call   80075b <cprintf>
  801506:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801509:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801510:	00 00 00 
	}
}
  801513:	90                   	nop
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80151c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801523:	00 00 00 
  801526:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80152d:	00 00 00 
  801530:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801537:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80153a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801541:	00 00 00 
  801544:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80154b:	00 00 00 
  80154e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801555:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801558:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  80155f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801562:	c1 e8 0c             	shr    $0xc,%eax
  801565:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80156a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801574:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801579:	2d 00 10 00 00       	sub    $0x1000,%eax
  80157e:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801583:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80158a:	a1 20 41 80 00       	mov    0x804120,%eax
  80158f:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801593:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801596:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80159d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a3:	01 d0                	add    %edx,%eax
  8015a5:	48                   	dec    %eax
  8015a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b1:	f7 75 e4             	divl   -0x1c(%ebp)
  8015b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b7:	29 d0                	sub    %edx,%eax
  8015b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8015bc:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8015c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015cb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	6a 07                	push   $0x7
  8015d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8015d8:	50                   	push   %eax
  8015d9:	e8 3d 06 00 00       	call   801c1b <sys_allocate_chunk>
  8015de:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015e1:	a1 20 41 80 00       	mov    0x804120,%eax
  8015e6:	83 ec 0c             	sub    $0xc,%esp
  8015e9:	50                   	push   %eax
  8015ea:	e8 b2 0c 00 00       	call   8022a1 <initialize_MemBlocksList>
  8015ef:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8015f2:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8015f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8015fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8015fe:	0f 84 f3 00 00 00    	je     8016f7 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801604:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801608:	75 14                	jne    80161e <initialize_dyn_block_system+0x108>
  80160a:	83 ec 04             	sub    $0x4,%esp
  80160d:	68 95 3d 80 00       	push   $0x803d95
  801612:	6a 36                	push   $0x36
  801614:	68 b3 3d 80 00       	push   $0x803db3
  801619:	e8 89 ee ff ff       	call   8004a7 <_panic>
  80161e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801621:	8b 00                	mov    (%eax),%eax
  801623:	85 c0                	test   %eax,%eax
  801625:	74 10                	je     801637 <initialize_dyn_block_system+0x121>
  801627:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80162a:	8b 00                	mov    (%eax),%eax
  80162c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80162f:	8b 52 04             	mov    0x4(%edx),%edx
  801632:	89 50 04             	mov    %edx,0x4(%eax)
  801635:	eb 0b                	jmp    801642 <initialize_dyn_block_system+0x12c>
  801637:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80163a:	8b 40 04             	mov    0x4(%eax),%eax
  80163d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801642:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801645:	8b 40 04             	mov    0x4(%eax),%eax
  801648:	85 c0                	test   %eax,%eax
  80164a:	74 0f                	je     80165b <initialize_dyn_block_system+0x145>
  80164c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80164f:	8b 40 04             	mov    0x4(%eax),%eax
  801652:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801655:	8b 12                	mov    (%edx),%edx
  801657:	89 10                	mov    %edx,(%eax)
  801659:	eb 0a                	jmp    801665 <initialize_dyn_block_system+0x14f>
  80165b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80165e:	8b 00                	mov    (%eax),%eax
  801660:	a3 48 41 80 00       	mov    %eax,0x804148
  801665:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80166e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801671:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801678:	a1 54 41 80 00       	mov    0x804154,%eax
  80167d:	48                   	dec    %eax
  80167e:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801683:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801686:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80168d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801690:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801697:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80169b:	75 14                	jne    8016b1 <initialize_dyn_block_system+0x19b>
  80169d:	83 ec 04             	sub    $0x4,%esp
  8016a0:	68 c0 3d 80 00       	push   $0x803dc0
  8016a5:	6a 3e                	push   $0x3e
  8016a7:	68 b3 3d 80 00       	push   $0x803db3
  8016ac:	e8 f6 ed ff ff       	call   8004a7 <_panic>
  8016b1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8016b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016ba:	89 10                	mov    %edx,(%eax)
  8016bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016bf:	8b 00                	mov    (%eax),%eax
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	74 0d                	je     8016d2 <initialize_dyn_block_system+0x1bc>
  8016c5:	a1 38 41 80 00       	mov    0x804138,%eax
  8016ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8016cd:	89 50 04             	mov    %edx,0x4(%eax)
  8016d0:	eb 08                	jmp    8016da <initialize_dyn_block_system+0x1c4>
  8016d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016d5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016dd:	a3 38 41 80 00       	mov    %eax,0x804138
  8016e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016ec:	a1 44 41 80 00       	mov    0x804144,%eax
  8016f1:	40                   	inc    %eax
  8016f2:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801700:	e8 e0 fd ff ff       	call   8014e5 <InitializeUHeap>
		if (size == 0) return NULL ;
  801705:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801709:	75 07                	jne    801712 <malloc+0x18>
  80170b:	b8 00 00 00 00       	mov    $0x0,%eax
  801710:	eb 7f                	jmp    801791 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801712:	e8 d2 08 00 00       	call   801fe9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801717:	85 c0                	test   %eax,%eax
  801719:	74 71                	je     80178c <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80171b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801722:	8b 55 08             	mov    0x8(%ebp),%edx
  801725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801728:	01 d0                	add    %edx,%eax
  80172a:	48                   	dec    %eax
  80172b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80172e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801731:	ba 00 00 00 00       	mov    $0x0,%edx
  801736:	f7 75 f4             	divl   -0xc(%ebp)
  801739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173c:	29 d0                	sub    %edx,%eax
  80173e:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801741:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801748:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80174f:	76 07                	jbe    801758 <malloc+0x5e>
					return NULL ;
  801751:	b8 00 00 00 00       	mov    $0x0,%eax
  801756:	eb 39                	jmp    801791 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801758:	83 ec 0c             	sub    $0xc,%esp
  80175b:	ff 75 08             	pushl  0x8(%ebp)
  80175e:	e8 e6 0d 00 00       	call   802549 <alloc_block_FF>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801769:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80176d:	74 16                	je     801785 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  80176f:	83 ec 0c             	sub    $0xc,%esp
  801772:	ff 75 ec             	pushl  -0x14(%ebp)
  801775:	e8 37 0c 00 00       	call   8023b1 <insert_sorted_allocList>
  80177a:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  80177d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801780:	8b 40 08             	mov    0x8(%eax),%eax
  801783:	eb 0c                	jmp    801791 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801785:	b8 00 00 00 00       	mov    $0x0,%eax
  80178a:	eb 05                	jmp    801791 <malloc+0x97>
				}
		}
	return 0;
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a5:	68 40 40 80 00       	push   $0x804040
  8017aa:	e8 cf 0b 00 00       	call   80237e <find_block>
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8017b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8017be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c1:	8b 40 08             	mov    0x8(%eax),%eax
  8017c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8017c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017cb:	0f 84 a1 00 00 00    	je     801872 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8017d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017d5:	75 17                	jne    8017ee <free+0x5b>
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	68 95 3d 80 00       	push   $0x803d95
  8017df:	68 80 00 00 00       	push   $0x80
  8017e4:	68 b3 3d 80 00       	push   $0x803db3
  8017e9:	e8 b9 ec ff ff       	call   8004a7 <_panic>
  8017ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f1:	8b 00                	mov    (%eax),%eax
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	74 10                	je     801807 <free+0x74>
  8017f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fa:	8b 00                	mov    (%eax),%eax
  8017fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ff:	8b 52 04             	mov    0x4(%edx),%edx
  801802:	89 50 04             	mov    %edx,0x4(%eax)
  801805:	eb 0b                	jmp    801812 <free+0x7f>
  801807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180a:	8b 40 04             	mov    0x4(%eax),%eax
  80180d:	a3 44 40 80 00       	mov    %eax,0x804044
  801812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801815:	8b 40 04             	mov    0x4(%eax),%eax
  801818:	85 c0                	test   %eax,%eax
  80181a:	74 0f                	je     80182b <free+0x98>
  80181c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181f:	8b 40 04             	mov    0x4(%eax),%eax
  801822:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801825:	8b 12                	mov    (%edx),%edx
  801827:	89 10                	mov    %edx,(%eax)
  801829:	eb 0a                	jmp    801835 <free+0xa2>
  80182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182e:	8b 00                	mov    (%eax),%eax
  801830:	a3 40 40 80 00       	mov    %eax,0x804040
  801835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801838:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801841:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801848:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80184d:	48                   	dec    %eax
  80184e:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801853:	83 ec 0c             	sub    $0xc,%esp
  801856:	ff 75 f0             	pushl  -0x10(%ebp)
  801859:	e8 29 12 00 00       	call   802a87 <insert_sorted_with_merge_freeList>
  80185e:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801861:	83 ec 08             	sub    $0x8,%esp
  801864:	ff 75 ec             	pushl  -0x14(%ebp)
  801867:	ff 75 e8             	pushl  -0x18(%ebp)
  80186a:	e8 74 03 00 00       	call   801be3 <sys_free_user_mem>
  80186f:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801872:	90                   	nop
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 38             	sub    $0x38,%esp
  80187b:	8b 45 10             	mov    0x10(%ebp),%eax
  80187e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801881:	e8 5f fc ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801886:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80188a:	75 0a                	jne    801896 <smalloc+0x21>
  80188c:	b8 00 00 00 00       	mov    $0x0,%eax
  801891:	e9 b2 00 00 00       	jmp    801948 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801896:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80189d:	76 0a                	jbe    8018a9 <smalloc+0x34>
		return NULL;
  80189f:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a4:	e9 9f 00 00 00       	jmp    801948 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8018a9:	e8 3b 07 00 00       	call   801fe9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	0f 84 8d 00 00 00    	je     801943 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8018b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8018bd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ca:	01 d0                	add    %edx,%eax
  8018cc:	48                   	dec    %eax
  8018cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	f7 75 f0             	divl   -0x10(%ebp)
  8018db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018de:	29 d0                	sub    %edx,%eax
  8018e0:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8018e3:	83 ec 0c             	sub    $0xc,%esp
  8018e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8018e9:	e8 5b 0c 00 00       	call   802549 <alloc_block_FF>
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8018f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018f8:	75 07                	jne    801901 <smalloc+0x8c>
			return NULL;
  8018fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ff:	eb 47                	jmp    801948 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801901:	83 ec 0c             	sub    $0xc,%esp
  801904:	ff 75 f4             	pushl  -0xc(%ebp)
  801907:	e8 a5 0a 00 00       	call   8023b1 <insert_sorted_allocList>
  80190c:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80190f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801912:	8b 40 08             	mov    0x8(%eax),%eax
  801915:	89 c2                	mov    %eax,%edx
  801917:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80191b:	52                   	push   %edx
  80191c:	50                   	push   %eax
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	ff 75 08             	pushl  0x8(%ebp)
  801923:	e8 46 04 00 00       	call   801d6e <sys_createSharedObject>
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80192e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801932:	78 08                	js     80193c <smalloc+0xc7>
		return (void *)b->sva;
  801934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801937:	8b 40 08             	mov    0x8(%eax),%eax
  80193a:	eb 0c                	jmp    801948 <smalloc+0xd3>
		}else{
		return NULL;
  80193c:	b8 00 00 00 00       	mov    $0x0,%eax
  801941:	eb 05                	jmp    801948 <smalloc+0xd3>
			}

	}return NULL;
  801943:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801950:	e8 90 fb ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801955:	e8 8f 06 00 00       	call   801fe9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80195a:	85 c0                	test   %eax,%eax
  80195c:	0f 84 ad 00 00 00    	je     801a0f <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801962:	83 ec 08             	sub    $0x8,%esp
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	ff 75 08             	pushl  0x8(%ebp)
  80196b:	e8 28 04 00 00       	call   801d98 <sys_getSizeOfSharedObject>
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801976:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80197a:	79 0a                	jns    801986 <sget+0x3c>
    {
    	return NULL;
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax
  801981:	e9 8e 00 00 00       	jmp    801a14 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801986:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80198d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199a:	01 d0                	add    %edx,%eax
  80199c:	48                   	dec    %eax
  80199d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a8:	f7 75 ec             	divl   -0x14(%ebp)
  8019ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019ae:	29 d0                	sub    %edx,%eax
  8019b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8019b3:	83 ec 0c             	sub    $0xc,%esp
  8019b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019b9:	e8 8b 0b 00 00       	call   802549 <alloc_block_FF>
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8019c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019c8:	75 07                	jne    8019d1 <sget+0x87>
				return NULL;
  8019ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8019cf:	eb 43                	jmp    801a14 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8019d1:	83 ec 0c             	sub    $0xc,%esp
  8019d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8019d7:	e8 d5 09 00 00       	call   8023b1 <insert_sorted_allocList>
  8019dc:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8019df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e2:	8b 40 08             	mov    0x8(%eax),%eax
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	50                   	push   %eax
  8019e9:	ff 75 0c             	pushl  0xc(%ebp)
  8019ec:	ff 75 08             	pushl  0x8(%ebp)
  8019ef:	e8 c1 03 00 00       	call   801db5 <sys_getSharedObject>
  8019f4:	83 c4 10             	add    $0x10,%esp
  8019f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8019fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019fe:	78 08                	js     801a08 <sget+0xbe>
			return (void *)b->sva;
  801a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a03:	8b 40 08             	mov    0x8(%eax),%eax
  801a06:	eb 0c                	jmp    801a14 <sget+0xca>
			}else{
			return NULL;
  801a08:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0d:	eb 05                	jmp    801a14 <sget+0xca>
			}
    }}return NULL;
  801a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a1c:	e8 c4 fa ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a21:	83 ec 04             	sub    $0x4,%esp
  801a24:	68 e4 3d 80 00       	push   $0x803de4
  801a29:	68 03 01 00 00       	push   $0x103
  801a2e:	68 b3 3d 80 00       	push   $0x803db3
  801a33:	e8 6f ea ff ff       	call   8004a7 <_panic>

00801a38 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	68 0c 3e 80 00       	push   $0x803e0c
  801a46:	68 17 01 00 00       	push   $0x117
  801a4b:	68 b3 3d 80 00       	push   $0x803db3
  801a50:	e8 52 ea ff ff       	call   8004a7 <_panic>

00801a55 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a5b:	83 ec 04             	sub    $0x4,%esp
  801a5e:	68 30 3e 80 00       	push   $0x803e30
  801a63:	68 22 01 00 00       	push   $0x122
  801a68:	68 b3 3d 80 00       	push   $0x803db3
  801a6d:	e8 35 ea ff ff       	call   8004a7 <_panic>

00801a72 <shrink>:

}
void shrink(uint32 newSize)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a78:	83 ec 04             	sub    $0x4,%esp
  801a7b:	68 30 3e 80 00       	push   $0x803e30
  801a80:	68 27 01 00 00       	push   $0x127
  801a85:	68 b3 3d 80 00       	push   $0x803db3
  801a8a:	e8 18 ea ff ff       	call   8004a7 <_panic>

00801a8f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a95:	83 ec 04             	sub    $0x4,%esp
  801a98:	68 30 3e 80 00       	push   $0x803e30
  801a9d:	68 2c 01 00 00       	push   $0x12c
  801aa2:	68 b3 3d 80 00       	push   $0x803db3
  801aa7:	e8 fb e9 ff ff       	call   8004a7 <_panic>

00801aac <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	57                   	push   %edi
  801ab0:	56                   	push   %esi
  801ab1:	53                   	push   %ebx
  801ab2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801abe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ac4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ac7:	cd 30                	int    $0x30
  801ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	5b                   	pop    %ebx
  801ad3:	5e                   	pop    %esi
  801ad4:	5f                   	pop    %edi
  801ad5:	5d                   	pop    %ebp
  801ad6:	c3                   	ret    

00801ad7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 04             	sub    $0x4,%esp
  801add:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ae3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	52                   	push   %edx
  801aef:	ff 75 0c             	pushl  0xc(%ebp)
  801af2:	50                   	push   %eax
  801af3:	6a 00                	push   $0x0
  801af5:	e8 b2 ff ff ff       	call   801aac <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	90                   	nop
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 01                	push   $0x1
  801b0f:	e8 98 ff ff ff       	call   801aac <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	52                   	push   %edx
  801b29:	50                   	push   %eax
  801b2a:	6a 05                	push   $0x5
  801b2c:	e8 7b ff ff ff       	call   801aac <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	56                   	push   %esi
  801b3a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b3b:	8b 75 18             	mov    0x18(%ebp),%esi
  801b3e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	56                   	push   %esi
  801b4b:	53                   	push   %ebx
  801b4c:	51                   	push   %ecx
  801b4d:	52                   	push   %edx
  801b4e:	50                   	push   %eax
  801b4f:	6a 06                	push   $0x6
  801b51:	e8 56 ff ff ff       	call   801aac <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b5c:	5b                   	pop    %ebx
  801b5d:	5e                   	pop    %esi
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    

00801b60 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	52                   	push   %edx
  801b70:	50                   	push   %eax
  801b71:	6a 07                	push   $0x7
  801b73:	e8 34 ff ff ff       	call   801aac <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	ff 75 08             	pushl  0x8(%ebp)
  801b8c:	6a 08                	push   $0x8
  801b8e:	e8 19 ff ff ff       	call   801aac <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 09                	push   $0x9
  801ba7:	e8 00 ff ff ff       	call   801aac <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 0a                	push   $0xa
  801bc0:	e8 e7 fe ff ff       	call   801aac <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 0b                	push   $0xb
  801bd9:	e8 ce fe ff ff       	call   801aac <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	ff 75 0c             	pushl  0xc(%ebp)
  801bef:	ff 75 08             	pushl  0x8(%ebp)
  801bf2:	6a 0f                	push   $0xf
  801bf4:	e8 b3 fe ff ff       	call   801aac <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
	return;
  801bfc:	90                   	nop
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	ff 75 0c             	pushl  0xc(%ebp)
  801c0b:	ff 75 08             	pushl  0x8(%ebp)
  801c0e:	6a 10                	push   $0x10
  801c10:	e8 97 fe ff ff       	call   801aac <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
	return ;
  801c18:	90                   	nop
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	ff 75 10             	pushl  0x10(%ebp)
  801c25:	ff 75 0c             	pushl  0xc(%ebp)
  801c28:	ff 75 08             	pushl  0x8(%ebp)
  801c2b:	6a 11                	push   $0x11
  801c2d:	e8 7a fe ff ff       	call   801aac <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
	return ;
  801c35:	90                   	nop
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 0c                	push   $0xc
  801c47:	e8 60 fe ff ff       	call   801aac <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	ff 75 08             	pushl  0x8(%ebp)
  801c5f:	6a 0d                	push   $0xd
  801c61:	e8 46 fe ff ff       	call   801aac <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 0e                	push   $0xe
  801c7a:	e8 2d fe ff ff       	call   801aac <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	90                   	nop
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 13                	push   $0x13
  801c94:	e8 13 fe ff ff       	call   801aac <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	90                   	nop
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 14                	push   $0x14
  801cae:	e8 f9 fd ff ff       	call   801aac <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	90                   	nop
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cc5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	50                   	push   %eax
  801cd2:	6a 15                	push   $0x15
  801cd4:	e8 d3 fd ff ff       	call   801aac <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	90                   	nop
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 16                	push   $0x16
  801cee:	e8 b9 fd ff ff       	call   801aac <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	90                   	nop
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	ff 75 0c             	pushl  0xc(%ebp)
  801d08:	50                   	push   %eax
  801d09:	6a 17                	push   $0x17
  801d0b:	e8 9c fd ff ff       	call   801aac <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	52                   	push   %edx
  801d25:	50                   	push   %eax
  801d26:	6a 1a                	push   $0x1a
  801d28:	e8 7f fd ff ff       	call   801aac <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	52                   	push   %edx
  801d42:	50                   	push   %eax
  801d43:	6a 18                	push   $0x18
  801d45:	e8 62 fd ff ff       	call   801aac <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	90                   	nop
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	52                   	push   %edx
  801d60:	50                   	push   %eax
  801d61:	6a 19                	push   $0x19
  801d63:	e8 44 fd ff ff       	call   801aac <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	90                   	nop
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 04             	sub    $0x4,%esp
  801d74:	8b 45 10             	mov    0x10(%ebp),%eax
  801d77:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d7a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d7d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	6a 00                	push   $0x0
  801d86:	51                   	push   %ecx
  801d87:	52                   	push   %edx
  801d88:	ff 75 0c             	pushl  0xc(%ebp)
  801d8b:	50                   	push   %eax
  801d8c:	6a 1b                	push   $0x1b
  801d8e:	e8 19 fd ff ff       	call   801aac <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	52                   	push   %edx
  801da8:	50                   	push   %eax
  801da9:	6a 1c                	push   $0x1c
  801dab:	e8 fc fc ff ff       	call   801aac <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801db8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	51                   	push   %ecx
  801dc6:	52                   	push   %edx
  801dc7:	50                   	push   %eax
  801dc8:	6a 1d                	push   $0x1d
  801dca:	e8 dd fc ff ff       	call   801aac <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	52                   	push   %edx
  801de4:	50                   	push   %eax
  801de5:	6a 1e                	push   $0x1e
  801de7:	e8 c0 fc ff ff       	call   801aac <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 1f                	push   $0x1f
  801e00:	e8 a7 fc ff ff       	call   801aac <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	6a 00                	push   $0x0
  801e12:	ff 75 14             	pushl  0x14(%ebp)
  801e15:	ff 75 10             	pushl  0x10(%ebp)
  801e18:	ff 75 0c             	pushl  0xc(%ebp)
  801e1b:	50                   	push   %eax
  801e1c:	6a 20                	push   $0x20
  801e1e:	e8 89 fc ff ff       	call   801aac <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	50                   	push   %eax
  801e37:	6a 21                	push   $0x21
  801e39:	e8 6e fc ff ff       	call   801aac <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	90                   	nop
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	50                   	push   %eax
  801e53:	6a 22                	push   $0x22
  801e55:	e8 52 fc ff ff       	call   801aac <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 02                	push   $0x2
  801e6e:	e8 39 fc ff ff       	call   801aac <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 03                	push   $0x3
  801e87:	e8 20 fc ff ff       	call   801aac <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 04                	push   $0x4
  801ea0:	e8 07 fc ff ff       	call   801aac <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_exit_env>:


void sys_exit_env(void)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 23                	push   $0x23
  801eb9:	e8 ee fb ff ff       	call   801aac <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	90                   	nop
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801eca:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ecd:	8d 50 04             	lea    0x4(%eax),%edx
  801ed0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	52                   	push   %edx
  801eda:	50                   	push   %eax
  801edb:	6a 24                	push   $0x24
  801edd:	e8 ca fb ff ff       	call   801aac <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
	return result;
  801ee5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eeb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801eee:	89 01                	mov    %eax,(%ecx)
  801ef0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	c9                   	leave  
  801ef7:	c2 04 00             	ret    $0x4

00801efa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	ff 75 10             	pushl  0x10(%ebp)
  801f04:	ff 75 0c             	pushl  0xc(%ebp)
  801f07:	ff 75 08             	pushl  0x8(%ebp)
  801f0a:	6a 12                	push   $0x12
  801f0c:	e8 9b fb ff ff       	call   801aac <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
	return ;
  801f14:	90                   	nop
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 25                	push   $0x25
  801f26:	e8 81 fb ff ff       	call   801aac <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 04             	sub    $0x4,%esp
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f3c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	50                   	push   %eax
  801f49:	6a 26                	push   $0x26
  801f4b:	e8 5c fb ff ff       	call   801aac <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
	return ;
  801f53:	90                   	nop
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <rsttst>:
void rsttst()
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 28                	push   $0x28
  801f65:	e8 42 fb ff ff       	call   801aac <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f6d:	90                   	nop
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 04             	sub    $0x4,%esp
  801f76:	8b 45 14             	mov    0x14(%ebp),%eax
  801f79:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f7c:	8b 55 18             	mov    0x18(%ebp),%edx
  801f7f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f83:	52                   	push   %edx
  801f84:	50                   	push   %eax
  801f85:	ff 75 10             	pushl  0x10(%ebp)
  801f88:	ff 75 0c             	pushl  0xc(%ebp)
  801f8b:	ff 75 08             	pushl  0x8(%ebp)
  801f8e:	6a 27                	push   $0x27
  801f90:	e8 17 fb ff ff       	call   801aac <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
	return ;
  801f98:	90                   	nop
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <chktst>:
void chktst(uint32 n)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	ff 75 08             	pushl  0x8(%ebp)
  801fa9:	6a 29                	push   $0x29
  801fab:	e8 fc fa ff ff       	call   801aac <syscall>
  801fb0:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb3:	90                   	nop
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <inctst>:

void inctst()
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 2a                	push   $0x2a
  801fc5:	e8 e2 fa ff ff       	call   801aac <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcd:	90                   	nop
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <gettst>:
uint32 gettst()
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 2b                	push   $0x2b
  801fdf:	e8 c8 fa ff ff       	call   801aac <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 2c                	push   $0x2c
  801ffb:	e8 ac fa ff ff       	call   801aac <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
  802003:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802006:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80200a:	75 07                	jne    802013 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80200c:	b8 01 00 00 00       	mov    $0x1,%eax
  802011:	eb 05                	jmp    802018 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802013:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 2c                	push   $0x2c
  80202c:	e8 7b fa ff ff       	call   801aac <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
  802034:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802037:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80203b:	75 07                	jne    802044 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80203d:	b8 01 00 00 00       	mov    $0x1,%eax
  802042:	eb 05                	jmp    802049 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 2c                	push   $0x2c
  80205d:	e8 4a fa ff ff       	call   801aac <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
  802065:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802068:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80206c:	75 07                	jne    802075 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80206e:	b8 01 00 00 00       	mov    $0x1,%eax
  802073:	eb 05                	jmp    80207a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 2c                	push   $0x2c
  80208e:	e8 19 fa ff ff       	call   801aac <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
  802096:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802099:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80209d:	75 07                	jne    8020a6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80209f:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a4:	eb 05                	jmp    8020ab <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	ff 75 08             	pushl  0x8(%ebp)
  8020bb:	6a 2d                	push   $0x2d
  8020bd:	e8 ea f9 ff ff       	call   801aac <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c5:	90                   	nop
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	6a 00                	push   $0x0
  8020da:	53                   	push   %ebx
  8020db:	51                   	push   %ecx
  8020dc:	52                   	push   %edx
  8020dd:	50                   	push   %eax
  8020de:	6a 2e                	push   $0x2e
  8020e0:	e8 c7 f9 ff ff       	call   801aac <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
}
  8020e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	52                   	push   %edx
  8020fd:	50                   	push   %eax
  8020fe:	6a 2f                	push   $0x2f
  802100:	e8 a7 f9 ff ff       	call   801aac <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802110:	83 ec 0c             	sub    $0xc,%esp
  802113:	68 40 3e 80 00       	push   $0x803e40
  802118:	e8 3e e6 ff ff       	call   80075b <cprintf>
  80211d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802120:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802127:	83 ec 0c             	sub    $0xc,%esp
  80212a:	68 6c 3e 80 00       	push   $0x803e6c
  80212f:	e8 27 e6 ff ff       	call   80075b <cprintf>
  802134:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802137:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80213b:	a1 38 41 80 00       	mov    0x804138,%eax
  802140:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802143:	eb 56                	jmp    80219b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802145:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802149:	74 1c                	je     802167 <print_mem_block_lists+0x5d>
  80214b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214e:	8b 50 08             	mov    0x8(%eax),%edx
  802151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802154:	8b 48 08             	mov    0x8(%eax),%ecx
  802157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215a:	8b 40 0c             	mov    0xc(%eax),%eax
  80215d:	01 c8                	add    %ecx,%eax
  80215f:	39 c2                	cmp    %eax,%edx
  802161:	73 04                	jae    802167 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802163:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	8b 50 08             	mov    0x8(%eax),%edx
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	8b 40 0c             	mov    0xc(%eax),%eax
  802173:	01 c2                	add    %eax,%edx
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 40 08             	mov    0x8(%eax),%eax
  80217b:	83 ec 04             	sub    $0x4,%esp
  80217e:	52                   	push   %edx
  80217f:	50                   	push   %eax
  802180:	68 81 3e 80 00       	push   $0x803e81
  802185:	e8 d1 e5 ff ff       	call   80075b <cprintf>
  80218a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802193:	a1 40 41 80 00       	mov    0x804140,%eax
  802198:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219f:	74 07                	je     8021a8 <print_mem_block_lists+0x9e>
  8021a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a4:	8b 00                	mov    (%eax),%eax
  8021a6:	eb 05                	jmp    8021ad <print_mem_block_lists+0xa3>
  8021a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ad:	a3 40 41 80 00       	mov    %eax,0x804140
  8021b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	75 8a                	jne    802145 <print_mem_block_lists+0x3b>
  8021bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bf:	75 84                	jne    802145 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021c1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021c5:	75 10                	jne    8021d7 <print_mem_block_lists+0xcd>
  8021c7:	83 ec 0c             	sub    $0xc,%esp
  8021ca:	68 90 3e 80 00       	push   $0x803e90
  8021cf:	e8 87 e5 ff ff       	call   80075b <cprintf>
  8021d4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021de:	83 ec 0c             	sub    $0xc,%esp
  8021e1:	68 b4 3e 80 00       	push   $0x803eb4
  8021e6:	e8 70 e5 ff ff       	call   80075b <cprintf>
  8021eb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021ee:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021f2:	a1 40 40 80 00       	mov    0x804040,%eax
  8021f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021fa:	eb 56                	jmp    802252 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802200:	74 1c                	je     80221e <print_mem_block_lists+0x114>
  802202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802205:	8b 50 08             	mov    0x8(%eax),%edx
  802208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220b:	8b 48 08             	mov    0x8(%eax),%ecx
  80220e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802211:	8b 40 0c             	mov    0xc(%eax),%eax
  802214:	01 c8                	add    %ecx,%eax
  802216:	39 c2                	cmp    %eax,%edx
  802218:	73 04                	jae    80221e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80221a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	8b 50 08             	mov    0x8(%eax),%edx
  802224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802227:	8b 40 0c             	mov    0xc(%eax),%eax
  80222a:	01 c2                	add    %eax,%edx
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	8b 40 08             	mov    0x8(%eax),%eax
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	52                   	push   %edx
  802236:	50                   	push   %eax
  802237:	68 81 3e 80 00       	push   $0x803e81
  80223c:	e8 1a e5 ff ff       	call   80075b <cprintf>
  802241:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802247:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80224a:	a1 48 40 80 00       	mov    0x804048,%eax
  80224f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802252:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802256:	74 07                	je     80225f <print_mem_block_lists+0x155>
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 00                	mov    (%eax),%eax
  80225d:	eb 05                	jmp    802264 <print_mem_block_lists+0x15a>
  80225f:	b8 00 00 00 00       	mov    $0x0,%eax
  802264:	a3 48 40 80 00       	mov    %eax,0x804048
  802269:	a1 48 40 80 00       	mov    0x804048,%eax
  80226e:	85 c0                	test   %eax,%eax
  802270:	75 8a                	jne    8021fc <print_mem_block_lists+0xf2>
  802272:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802276:	75 84                	jne    8021fc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802278:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80227c:	75 10                	jne    80228e <print_mem_block_lists+0x184>
  80227e:	83 ec 0c             	sub    $0xc,%esp
  802281:	68 cc 3e 80 00       	push   $0x803ecc
  802286:	e8 d0 e4 ff ff       	call   80075b <cprintf>
  80228b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80228e:	83 ec 0c             	sub    $0xc,%esp
  802291:	68 40 3e 80 00       	push   $0x803e40
  802296:	e8 c0 e4 ff ff       	call   80075b <cprintf>
  80229b:	83 c4 10             	add    $0x10,%esp

}
  80229e:	90                   	nop
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8022a7:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8022ae:	00 00 00 
  8022b1:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8022b8:	00 00 00 
  8022bb:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8022c2:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8022c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022cc:	e9 9e 00 00 00       	jmp    80236f <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8022d1:	a1 50 40 80 00       	mov    0x804050,%eax
  8022d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d9:	c1 e2 04             	shl    $0x4,%edx
  8022dc:	01 d0                	add    %edx,%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	75 14                	jne    8022f6 <initialize_MemBlocksList+0x55>
  8022e2:	83 ec 04             	sub    $0x4,%esp
  8022e5:	68 f4 3e 80 00       	push   $0x803ef4
  8022ea:	6a 3d                	push   $0x3d
  8022ec:	68 17 3f 80 00       	push   $0x803f17
  8022f1:	e8 b1 e1 ff ff       	call   8004a7 <_panic>
  8022f6:	a1 50 40 80 00       	mov    0x804050,%eax
  8022fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fe:	c1 e2 04             	shl    $0x4,%edx
  802301:	01 d0                	add    %edx,%eax
  802303:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802309:	89 10                	mov    %edx,(%eax)
  80230b:	8b 00                	mov    (%eax),%eax
  80230d:	85 c0                	test   %eax,%eax
  80230f:	74 18                	je     802329 <initialize_MemBlocksList+0x88>
  802311:	a1 48 41 80 00       	mov    0x804148,%eax
  802316:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80231c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80231f:	c1 e1 04             	shl    $0x4,%ecx
  802322:	01 ca                	add    %ecx,%edx
  802324:	89 50 04             	mov    %edx,0x4(%eax)
  802327:	eb 12                	jmp    80233b <initialize_MemBlocksList+0x9a>
  802329:	a1 50 40 80 00       	mov    0x804050,%eax
  80232e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802331:	c1 e2 04             	shl    $0x4,%edx
  802334:	01 d0                	add    %edx,%eax
  802336:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80233b:	a1 50 40 80 00       	mov    0x804050,%eax
  802340:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802343:	c1 e2 04             	shl    $0x4,%edx
  802346:	01 d0                	add    %edx,%eax
  802348:	a3 48 41 80 00       	mov    %eax,0x804148
  80234d:	a1 50 40 80 00       	mov    0x804050,%eax
  802352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802355:	c1 e2 04             	shl    $0x4,%edx
  802358:	01 d0                	add    %edx,%eax
  80235a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802361:	a1 54 41 80 00       	mov    0x804154,%eax
  802366:	40                   	inc    %eax
  802367:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80236c:	ff 45 f4             	incl   -0xc(%ebp)
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	3b 45 08             	cmp    0x8(%ebp),%eax
  802375:	0f 82 56 ff ff ff    	jb     8022d1 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80237b:	90                   	nop
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	8b 00                	mov    (%eax),%eax
  802389:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80238c:	eb 18                	jmp    8023a6 <find_block+0x28>

		if(tmp->sva == va){
  80238e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802391:	8b 40 08             	mov    0x8(%eax),%eax
  802394:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802397:	75 05                	jne    80239e <find_block+0x20>
			return tmp ;
  802399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80239c:	eb 11                	jmp    8023af <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  80239e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a1:	8b 00                	mov    (%eax),%eax
  8023a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8023a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023aa:	75 e2                	jne    80238e <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8023ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
  8023b4:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8023b7:	a1 40 40 80 00       	mov    0x804040,%eax
  8023bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8023bf:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8023c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023cb:	75 65                	jne    802432 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8023cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d1:	75 14                	jne    8023e7 <insert_sorted_allocList+0x36>
  8023d3:	83 ec 04             	sub    $0x4,%esp
  8023d6:	68 f4 3e 80 00       	push   $0x803ef4
  8023db:	6a 62                	push   $0x62
  8023dd:	68 17 3f 80 00       	push   $0x803f17
  8023e2:	e8 c0 e0 ff ff       	call   8004a7 <_panic>
  8023e7:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	89 10                	mov    %edx,(%eax)
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	8b 00                	mov    (%eax),%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	74 0d                	je     802408 <insert_sorted_allocList+0x57>
  8023fb:	a1 40 40 80 00       	mov    0x804040,%eax
  802400:	8b 55 08             	mov    0x8(%ebp),%edx
  802403:	89 50 04             	mov    %edx,0x4(%eax)
  802406:	eb 08                	jmp    802410 <insert_sorted_allocList+0x5f>
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	a3 44 40 80 00       	mov    %eax,0x804044
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	a3 40 40 80 00       	mov    %eax,0x804040
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802422:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802427:	40                   	inc    %eax
  802428:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80242d:	e9 14 01 00 00       	jmp    802546 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	8b 50 08             	mov    0x8(%eax),%edx
  802438:	a1 44 40 80 00       	mov    0x804044,%eax
  80243d:	8b 40 08             	mov    0x8(%eax),%eax
  802440:	39 c2                	cmp    %eax,%edx
  802442:	76 65                	jbe    8024a9 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802444:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802448:	75 14                	jne    80245e <insert_sorted_allocList+0xad>
  80244a:	83 ec 04             	sub    $0x4,%esp
  80244d:	68 30 3f 80 00       	push   $0x803f30
  802452:	6a 64                	push   $0x64
  802454:	68 17 3f 80 00       	push   $0x803f17
  802459:	e8 49 e0 ff ff       	call   8004a7 <_panic>
  80245e:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	89 50 04             	mov    %edx,0x4(%eax)
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	8b 40 04             	mov    0x4(%eax),%eax
  802470:	85 c0                	test   %eax,%eax
  802472:	74 0c                	je     802480 <insert_sorted_allocList+0xcf>
  802474:	a1 44 40 80 00       	mov    0x804044,%eax
  802479:	8b 55 08             	mov    0x8(%ebp),%edx
  80247c:	89 10                	mov    %edx,(%eax)
  80247e:	eb 08                	jmp    802488 <insert_sorted_allocList+0xd7>
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	a3 40 40 80 00       	mov    %eax,0x804040
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	a3 44 40 80 00       	mov    %eax,0x804044
  802490:	8b 45 08             	mov    0x8(%ebp),%eax
  802493:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802499:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80249e:	40                   	inc    %eax
  80249f:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8024a4:	e9 9d 00 00 00       	jmp    802546 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8024a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8024b0:	e9 85 00 00 00       	jmp    80253a <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	8b 50 08             	mov    0x8(%eax),%edx
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 40 08             	mov    0x8(%eax),%eax
  8024c1:	39 c2                	cmp    %eax,%edx
  8024c3:	73 6a                	jae    80252f <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8024c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c9:	74 06                	je     8024d1 <insert_sorted_allocList+0x120>
  8024cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024cf:	75 14                	jne    8024e5 <insert_sorted_allocList+0x134>
  8024d1:	83 ec 04             	sub    $0x4,%esp
  8024d4:	68 54 3f 80 00       	push   $0x803f54
  8024d9:	6a 6b                	push   $0x6b
  8024db:	68 17 3f 80 00       	push   $0x803f17
  8024e0:	e8 c2 df ff ff       	call   8004a7 <_panic>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 50 04             	mov    0x4(%eax),%edx
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	89 50 04             	mov    %edx,0x4(%eax)
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f7:	89 10                	mov    %edx,(%eax)
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 40 04             	mov    0x4(%eax),%eax
  8024ff:	85 c0                	test   %eax,%eax
  802501:	74 0d                	je     802510 <insert_sorted_allocList+0x15f>
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	8b 40 04             	mov    0x4(%eax),%eax
  802509:	8b 55 08             	mov    0x8(%ebp),%edx
  80250c:	89 10                	mov    %edx,(%eax)
  80250e:	eb 08                	jmp    802518 <insert_sorted_allocList+0x167>
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	a3 40 40 80 00       	mov    %eax,0x804040
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 55 08             	mov    0x8(%ebp),%edx
  80251e:	89 50 04             	mov    %edx,0x4(%eax)
  802521:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802526:	40                   	inc    %eax
  802527:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  80252c:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80252d:	eb 17                	jmp    802546 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 00                	mov    (%eax),%eax
  802534:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802537:	ff 45 f0             	incl   -0x10(%ebp)
  80253a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802540:	0f 8c 6f ff ff ff    	jl     8024b5 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802546:	90                   	nop
  802547:	c9                   	leave  
  802548:	c3                   	ret    

00802549 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
  80254c:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80254f:	a1 38 41 80 00       	mov    0x804138,%eax
  802554:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802557:	e9 7c 01 00 00       	jmp    8026d8 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	8b 40 0c             	mov    0xc(%eax),%eax
  802562:	3b 45 08             	cmp    0x8(%ebp),%eax
  802565:	0f 86 cf 00 00 00    	jbe    80263a <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80256b:	a1 48 41 80 00       	mov    0x804148,%eax
  802570:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802576:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802579:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257c:	8b 55 08             	mov    0x8(%ebp),%edx
  80257f:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 50 08             	mov    0x8(%eax),%edx
  802588:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258b:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 40 0c             	mov    0xc(%eax),%eax
  802594:	2b 45 08             	sub    0x8(%ebp),%eax
  802597:	89 c2                	mov    %eax,%edx
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 50 08             	mov    0x8(%eax),%edx
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	01 c2                	add    %eax,%edx
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8025b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025b4:	75 17                	jne    8025cd <alloc_block_FF+0x84>
  8025b6:	83 ec 04             	sub    $0x4,%esp
  8025b9:	68 89 3f 80 00       	push   $0x803f89
  8025be:	68 83 00 00 00       	push   $0x83
  8025c3:	68 17 3f 80 00       	push   $0x803f17
  8025c8:	e8 da de ff ff       	call   8004a7 <_panic>
  8025cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	74 10                	je     8025e6 <alloc_block_FF+0x9d>
  8025d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d9:	8b 00                	mov    (%eax),%eax
  8025db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025de:	8b 52 04             	mov    0x4(%edx),%edx
  8025e1:	89 50 04             	mov    %edx,0x4(%eax)
  8025e4:	eb 0b                	jmp    8025f1 <alloc_block_FF+0xa8>
  8025e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f4:	8b 40 04             	mov    0x4(%eax),%eax
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	74 0f                	je     80260a <alloc_block_FF+0xc1>
  8025fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fe:	8b 40 04             	mov    0x4(%eax),%eax
  802601:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802604:	8b 12                	mov    (%edx),%edx
  802606:	89 10                	mov    %edx,(%eax)
  802608:	eb 0a                	jmp    802614 <alloc_block_FF+0xcb>
  80260a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	a3 48 41 80 00       	mov    %eax,0x804148
  802614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802617:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80261d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802620:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802627:	a1 54 41 80 00       	mov    0x804154,%eax
  80262c:	48                   	dec    %eax
  80262d:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802632:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802635:	e9 ad 00 00 00       	jmp    8026e7 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 40 0c             	mov    0xc(%eax),%eax
  802640:	3b 45 08             	cmp    0x8(%ebp),%eax
  802643:	0f 85 87 00 00 00    	jne    8026d0 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264d:	75 17                	jne    802666 <alloc_block_FF+0x11d>
  80264f:	83 ec 04             	sub    $0x4,%esp
  802652:	68 89 3f 80 00       	push   $0x803f89
  802657:	68 87 00 00 00       	push   $0x87
  80265c:	68 17 3f 80 00       	push   $0x803f17
  802661:	e8 41 de ff ff       	call   8004a7 <_panic>
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	8b 00                	mov    (%eax),%eax
  80266b:	85 c0                	test   %eax,%eax
  80266d:	74 10                	je     80267f <alloc_block_FF+0x136>
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802677:	8b 52 04             	mov    0x4(%edx),%edx
  80267a:	89 50 04             	mov    %edx,0x4(%eax)
  80267d:	eb 0b                	jmp    80268a <alloc_block_FF+0x141>
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 40 04             	mov    0x4(%eax),%eax
  802685:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 40 04             	mov    0x4(%eax),%eax
  802690:	85 c0                	test   %eax,%eax
  802692:	74 0f                	je     8026a3 <alloc_block_FF+0x15a>
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	8b 40 04             	mov    0x4(%eax),%eax
  80269a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269d:	8b 12                	mov    (%edx),%edx
  80269f:	89 10                	mov    %edx,(%eax)
  8026a1:	eb 0a                	jmp    8026ad <alloc_block_FF+0x164>
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 00                	mov    (%eax),%eax
  8026a8:	a3 38 41 80 00       	mov    %eax,0x804138
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c0:	a1 44 41 80 00       	mov    0x804144,%eax
  8026c5:	48                   	dec    %eax
  8026c6:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	eb 17                	jmp    8026e7 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8026d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dc:	0f 85 7a fe ff ff    	jne    80255c <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8026e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e7:	c9                   	leave  
  8026e8:	c3                   	ret    

008026e9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
  8026ec:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8026ef:	a1 38 41 80 00       	mov    0x804138,%eax
  8026f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8026f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8026fe:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802705:	a1 38 41 80 00       	mov    0x804138,%eax
  80270a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270d:	e9 d0 00 00 00       	jmp    8027e2 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 40 0c             	mov    0xc(%eax),%eax
  802718:	3b 45 08             	cmp    0x8(%ebp),%eax
  80271b:	0f 82 b8 00 00 00    	jb     8027d9 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 40 0c             	mov    0xc(%eax),%eax
  802727:	2b 45 08             	sub    0x8(%ebp),%eax
  80272a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80272d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802730:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802733:	0f 83 a1 00 00 00    	jae    8027da <alloc_block_BF+0xf1>
				differsize = differance ;
  802739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802745:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802749:	0f 85 8b 00 00 00    	jne    8027da <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80274f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802753:	75 17                	jne    80276c <alloc_block_BF+0x83>
  802755:	83 ec 04             	sub    $0x4,%esp
  802758:	68 89 3f 80 00       	push   $0x803f89
  80275d:	68 a0 00 00 00       	push   $0xa0
  802762:	68 17 3f 80 00       	push   $0x803f17
  802767:	e8 3b dd ff ff       	call   8004a7 <_panic>
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 00                	mov    (%eax),%eax
  802771:	85 c0                	test   %eax,%eax
  802773:	74 10                	je     802785 <alloc_block_BF+0x9c>
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 00                	mov    (%eax),%eax
  80277a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277d:	8b 52 04             	mov    0x4(%edx),%edx
  802780:	89 50 04             	mov    %edx,0x4(%eax)
  802783:	eb 0b                	jmp    802790 <alloc_block_BF+0xa7>
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 40 04             	mov    0x4(%eax),%eax
  80278b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 40 04             	mov    0x4(%eax),%eax
  802796:	85 c0                	test   %eax,%eax
  802798:	74 0f                	je     8027a9 <alloc_block_BF+0xc0>
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 40 04             	mov    0x4(%eax),%eax
  8027a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a3:	8b 12                	mov    (%edx),%edx
  8027a5:	89 10                	mov    %edx,(%eax)
  8027a7:	eb 0a                	jmp    8027b3 <alloc_block_BF+0xca>
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	a3 38 41 80 00       	mov    %eax,0x804138
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c6:	a1 44 41 80 00       	mov    0x804144,%eax
  8027cb:	48                   	dec    %eax
  8027cc:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	e9 0c 01 00 00       	jmp    8028e5 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8027d9:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8027da:	a1 40 41 80 00       	mov    0x804140,%eax
  8027df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e6:	74 07                	je     8027ef <alloc_block_BF+0x106>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	eb 05                	jmp    8027f4 <alloc_block_BF+0x10b>
  8027ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f4:	a3 40 41 80 00       	mov    %eax,0x804140
  8027f9:	a1 40 41 80 00       	mov    0x804140,%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	0f 85 0c ff ff ff    	jne    802712 <alloc_block_BF+0x29>
  802806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280a:	0f 85 02 ff ff ff    	jne    802712 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802810:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802814:	0f 84 c6 00 00 00    	je     8028e0 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  80281a:	a1 48 41 80 00       	mov    0x804148,%eax
  80281f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802822:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802825:	8b 55 08             	mov    0x8(%ebp),%edx
  802828:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80282b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282e:	8b 50 08             	mov    0x8(%eax),%edx
  802831:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802834:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	8b 40 0c             	mov    0xc(%eax),%eax
  80283d:	2b 45 08             	sub    0x8(%ebp),%eax
  802840:	89 c2                	mov    %eax,%edx
  802842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802845:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284b:	8b 50 08             	mov    0x8(%eax),%edx
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	01 c2                	add    %eax,%edx
  802853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802856:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802859:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80285d:	75 17                	jne    802876 <alloc_block_BF+0x18d>
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	68 89 3f 80 00       	push   $0x803f89
  802867:	68 af 00 00 00       	push   $0xaf
  80286c:	68 17 3f 80 00       	push   $0x803f17
  802871:	e8 31 dc ff ff       	call   8004a7 <_panic>
  802876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	74 10                	je     80288f <alloc_block_BF+0x1a6>
  80287f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802882:	8b 00                	mov    (%eax),%eax
  802884:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802887:	8b 52 04             	mov    0x4(%edx),%edx
  80288a:	89 50 04             	mov    %edx,0x4(%eax)
  80288d:	eb 0b                	jmp    80289a <alloc_block_BF+0x1b1>
  80288f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802892:	8b 40 04             	mov    0x4(%eax),%eax
  802895:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80289a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80289d:	8b 40 04             	mov    0x4(%eax),%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	74 0f                	je     8028b3 <alloc_block_BF+0x1ca>
  8028a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a7:	8b 40 04             	mov    0x4(%eax),%eax
  8028aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028ad:	8b 12                	mov    (%edx),%edx
  8028af:	89 10                	mov    %edx,(%eax)
  8028b1:	eb 0a                	jmp    8028bd <alloc_block_BF+0x1d4>
  8028b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	a3 48 41 80 00       	mov    %eax,0x804148
  8028bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d0:	a1 54 41 80 00       	mov    0x804154,%eax
  8028d5:	48                   	dec    %eax
  8028d6:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8028db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028de:	eb 05                	jmp    8028e5 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8028e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028e5:	c9                   	leave  
  8028e6:	c3                   	ret    

008028e7 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
  8028ea:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8028ed:	a1 38 41 80 00       	mov    0x804138,%eax
  8028f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8028f5:	e9 7c 01 00 00       	jmp    802a76 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802900:	3b 45 08             	cmp    0x8(%ebp),%eax
  802903:	0f 86 cf 00 00 00    	jbe    8029d8 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802909:	a1 48 41 80 00       	mov    0x804148,%eax
  80290e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802914:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291a:	8b 55 08             	mov    0x8(%ebp),%edx
  80291d:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 50 08             	mov    0x8(%eax),%edx
  802926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802929:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 40 0c             	mov    0xc(%eax),%eax
  802932:	2b 45 08             	sub    0x8(%ebp),%eax
  802935:	89 c2                	mov    %eax,%edx
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	8b 50 08             	mov    0x8(%eax),%edx
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	01 c2                	add    %eax,%edx
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80294e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802952:	75 17                	jne    80296b <alloc_block_NF+0x84>
  802954:	83 ec 04             	sub    $0x4,%esp
  802957:	68 89 3f 80 00       	push   $0x803f89
  80295c:	68 c4 00 00 00       	push   $0xc4
  802961:	68 17 3f 80 00       	push   $0x803f17
  802966:	e8 3c db ff ff       	call   8004a7 <_panic>
  80296b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296e:	8b 00                	mov    (%eax),%eax
  802970:	85 c0                	test   %eax,%eax
  802972:	74 10                	je     802984 <alloc_block_NF+0x9d>
  802974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80297c:	8b 52 04             	mov    0x4(%edx),%edx
  80297f:	89 50 04             	mov    %edx,0x4(%eax)
  802982:	eb 0b                	jmp    80298f <alloc_block_NF+0xa8>
  802984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802987:	8b 40 04             	mov    0x4(%eax),%eax
  80298a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80298f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802992:	8b 40 04             	mov    0x4(%eax),%eax
  802995:	85 c0                	test   %eax,%eax
  802997:	74 0f                	je     8029a8 <alloc_block_NF+0xc1>
  802999:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299c:	8b 40 04             	mov    0x4(%eax),%eax
  80299f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029a2:	8b 12                	mov    (%edx),%edx
  8029a4:	89 10                	mov    %edx,(%eax)
  8029a6:	eb 0a                	jmp    8029b2 <alloc_block_NF+0xcb>
  8029a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ab:	8b 00                	mov    (%eax),%eax
  8029ad:	a3 48 41 80 00       	mov    %eax,0x804148
  8029b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c5:	a1 54 41 80 00       	mov    0x804154,%eax
  8029ca:	48                   	dec    %eax
  8029cb:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8029d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d3:	e9 ad 00 00 00       	jmp    802a85 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 40 0c             	mov    0xc(%eax),%eax
  8029de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e1:	0f 85 87 00 00 00    	jne    802a6e <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8029e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029eb:	75 17                	jne    802a04 <alloc_block_NF+0x11d>
  8029ed:	83 ec 04             	sub    $0x4,%esp
  8029f0:	68 89 3f 80 00       	push   $0x803f89
  8029f5:	68 c8 00 00 00       	push   $0xc8
  8029fa:	68 17 3f 80 00       	push   $0x803f17
  8029ff:	e8 a3 da ff ff       	call   8004a7 <_panic>
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	74 10                	je     802a1d <alloc_block_NF+0x136>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a15:	8b 52 04             	mov    0x4(%edx),%edx
  802a18:	89 50 04             	mov    %edx,0x4(%eax)
  802a1b:	eb 0b                	jmp    802a28 <alloc_block_NF+0x141>
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 40 04             	mov    0x4(%eax),%eax
  802a23:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 40 04             	mov    0x4(%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	74 0f                	je     802a41 <alloc_block_NF+0x15a>
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 40 04             	mov    0x4(%eax),%eax
  802a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3b:	8b 12                	mov    (%edx),%edx
  802a3d:	89 10                	mov    %edx,(%eax)
  802a3f:	eb 0a                	jmp    802a4b <alloc_block_NF+0x164>
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 00                	mov    (%eax),%eax
  802a46:	a3 38 41 80 00       	mov    %eax,0x804138
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a63:	48                   	dec    %eax
  802a64:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	eb 17                	jmp    802a85 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7a:	0f 85 7a fe ff ff    	jne    8028fa <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802a80:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802a85:	c9                   	leave  
  802a86:	c3                   	ret    

00802a87 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a87:	55                   	push   %ebp
  802a88:	89 e5                	mov    %esp,%ebp
  802a8a:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802a8d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802a95:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802a9d:	a1 44 41 80 00       	mov    0x804144,%eax
  802aa2:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802aa5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aa9:	75 68                	jne    802b13 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802aab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aaf:	75 17                	jne    802ac8 <insert_sorted_with_merge_freeList+0x41>
  802ab1:	83 ec 04             	sub    $0x4,%esp
  802ab4:	68 f4 3e 80 00       	push   $0x803ef4
  802ab9:	68 da 00 00 00       	push   $0xda
  802abe:	68 17 3f 80 00       	push   $0x803f17
  802ac3:	e8 df d9 ff ff       	call   8004a7 <_panic>
  802ac8:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	89 10                	mov    %edx,(%eax)
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	8b 00                	mov    (%eax),%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	74 0d                	je     802ae9 <insert_sorted_with_merge_freeList+0x62>
  802adc:	a1 38 41 80 00       	mov    0x804138,%eax
  802ae1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae4:	89 50 04             	mov    %edx,0x4(%eax)
  802ae7:	eb 08                	jmp    802af1 <insert_sorted_with_merge_freeList+0x6a>
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	a3 38 41 80 00       	mov    %eax,0x804138
  802af9:	8b 45 08             	mov    0x8(%ebp),%eax
  802afc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b03:	a1 44 41 80 00       	mov    0x804144,%eax
  802b08:	40                   	inc    %eax
  802b09:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802b0e:	e9 49 07 00 00       	jmp    80325c <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b16:	8b 50 08             	mov    0x8(%eax),%edx
  802b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1f:	01 c2                	add    %eax,%edx
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	8b 40 08             	mov    0x8(%eax),%eax
  802b27:	39 c2                	cmp    %eax,%edx
  802b29:	73 77                	jae    802ba2 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	85 c0                	test   %eax,%eax
  802b32:	75 6e                	jne    802ba2 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802b34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b38:	74 68                	je     802ba2 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802b3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3e:	75 17                	jne    802b57 <insert_sorted_with_merge_freeList+0xd0>
  802b40:	83 ec 04             	sub    $0x4,%esp
  802b43:	68 30 3f 80 00       	push   $0x803f30
  802b48:	68 e0 00 00 00       	push   $0xe0
  802b4d:	68 17 3f 80 00       	push   $0x803f17
  802b52:	e8 50 d9 ff ff       	call   8004a7 <_panic>
  802b57:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	89 50 04             	mov    %edx,0x4(%eax)
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	8b 40 04             	mov    0x4(%eax),%eax
  802b69:	85 c0                	test   %eax,%eax
  802b6b:	74 0c                	je     802b79 <insert_sorted_with_merge_freeList+0xf2>
  802b6d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b72:	8b 55 08             	mov    0x8(%ebp),%edx
  802b75:	89 10                	mov    %edx,(%eax)
  802b77:	eb 08                	jmp    802b81 <insert_sorted_with_merge_freeList+0xfa>
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	a3 38 41 80 00       	mov    %eax,0x804138
  802b81:	8b 45 08             	mov    0x8(%ebp),%eax
  802b84:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b92:	a1 44 41 80 00       	mov    0x804144,%eax
  802b97:	40                   	inc    %eax
  802b98:	a3 44 41 80 00       	mov    %eax,0x804144
  802b9d:	e9 ba 06 00 00       	jmp    80325c <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	8b 40 08             	mov    0x8(%eax),%eax
  802bae:	01 c2                	add    %eax,%edx
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 40 08             	mov    0x8(%eax),%eax
  802bb6:	39 c2                	cmp    %eax,%edx
  802bb8:	73 78                	jae    802c32 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 40 04             	mov    0x4(%eax),%eax
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	75 6e                	jne    802c32 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802bc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bc8:	74 68                	je     802c32 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802bca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bce:	75 17                	jne    802be7 <insert_sorted_with_merge_freeList+0x160>
  802bd0:	83 ec 04             	sub    $0x4,%esp
  802bd3:	68 f4 3e 80 00       	push   $0x803ef4
  802bd8:	68 e6 00 00 00       	push   $0xe6
  802bdd:	68 17 3f 80 00       	push   $0x803f17
  802be2:	e8 c0 d8 ff ff       	call   8004a7 <_panic>
  802be7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bed:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf0:	89 10                	mov    %edx,(%eax)
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 0d                	je     802c08 <insert_sorted_with_merge_freeList+0x181>
  802bfb:	a1 38 41 80 00       	mov    0x804138,%eax
  802c00:	8b 55 08             	mov    0x8(%ebp),%edx
  802c03:	89 50 04             	mov    %edx,0x4(%eax)
  802c06:	eb 08                	jmp    802c10 <insert_sorted_with_merge_freeList+0x189>
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	a3 38 41 80 00       	mov    %eax,0x804138
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c22:	a1 44 41 80 00       	mov    0x804144,%eax
  802c27:	40                   	inc    %eax
  802c28:	a3 44 41 80 00       	mov    %eax,0x804144
  802c2d:	e9 2a 06 00 00       	jmp    80325c <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802c32:	a1 38 41 80 00       	mov    0x804138,%eax
  802c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3a:	e9 ed 05 00 00       	jmp    80322c <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802c47:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c4b:	0f 84 a7 00 00 00    	je     802cf8 <insert_sorted_with_merge_freeList+0x271>
  802c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c54:	8b 50 0c             	mov    0xc(%eax),%edx
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 08             	mov    0x8(%eax),%eax
  802c5d:	01 c2                	add    %eax,%edx
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	8b 40 08             	mov    0x8(%eax),%eax
  802c65:	39 c2                	cmp    %eax,%edx
  802c67:	0f 83 8b 00 00 00    	jae    802cf8 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	8b 50 0c             	mov    0xc(%eax),%edx
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	8b 40 08             	mov    0x8(%eax),%eax
  802c79:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802c7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7e:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802c81:	39 c2                	cmp    %eax,%edx
  802c83:	73 73                	jae    802cf8 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802c85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c89:	74 06                	je     802c91 <insert_sorted_with_merge_freeList+0x20a>
  802c8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c8f:	75 17                	jne    802ca8 <insert_sorted_with_merge_freeList+0x221>
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	68 a8 3f 80 00       	push   $0x803fa8
  802c99:	68 f0 00 00 00       	push   $0xf0
  802c9e:	68 17 3f 80 00       	push   $0x803f17
  802ca3:	e8 ff d7 ff ff       	call   8004a7 <_panic>
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 10                	mov    (%eax),%edx
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	89 10                	mov    %edx,(%eax)
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	74 0b                	je     802cc6 <insert_sorted_with_merge_freeList+0x23f>
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc3:	89 50 04             	mov    %edx,0x4(%eax)
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccc:	89 10                	mov    %edx,(%eax)
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd4:	89 50 04             	mov    %edx,0x4(%eax)
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	75 08                	jne    802ce8 <insert_sorted_with_merge_freeList+0x261>
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ce8:	a1 44 41 80 00       	mov    0x804144,%eax
  802ced:	40                   	inc    %eax
  802cee:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802cf3:	e9 64 05 00 00       	jmp    80325c <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802cf8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cfd:	8b 50 0c             	mov    0xc(%eax),%edx
  802d00:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d05:	8b 40 08             	mov    0x8(%eax),%eax
  802d08:	01 c2                	add    %eax,%edx
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	8b 40 08             	mov    0x8(%eax),%eax
  802d10:	39 c2                	cmp    %eax,%edx
  802d12:	0f 85 b1 00 00 00    	jne    802dc9 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802d18:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	0f 84 a4 00 00 00    	je     802dc9 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802d25:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d2a:	8b 00                	mov    (%eax),%eax
  802d2c:	85 c0                	test   %eax,%eax
  802d2e:	0f 85 95 00 00 00    	jne    802dc9 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802d34:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d39:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d3f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d42:	8b 55 08             	mov    0x8(%ebp),%edx
  802d45:	8b 52 0c             	mov    0xc(%edx),%edx
  802d48:	01 ca                	add    %ecx,%edx
  802d4a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d65:	75 17                	jne    802d7e <insert_sorted_with_merge_freeList+0x2f7>
  802d67:	83 ec 04             	sub    $0x4,%esp
  802d6a:	68 f4 3e 80 00       	push   $0x803ef4
  802d6f:	68 ff 00 00 00       	push   $0xff
  802d74:	68 17 3f 80 00       	push   $0x803f17
  802d79:	e8 29 d7 ff ff       	call   8004a7 <_panic>
  802d7e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	89 10                	mov    %edx,(%eax)
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	85 c0                	test   %eax,%eax
  802d90:	74 0d                	je     802d9f <insert_sorted_with_merge_freeList+0x318>
  802d92:	a1 48 41 80 00       	mov    0x804148,%eax
  802d97:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9a:	89 50 04             	mov    %edx,0x4(%eax)
  802d9d:	eb 08                	jmp    802da7 <insert_sorted_with_merge_freeList+0x320>
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	a3 48 41 80 00       	mov    %eax,0x804148
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db9:	a1 54 41 80 00       	mov    0x804154,%eax
  802dbe:	40                   	inc    %eax
  802dbf:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802dc4:	e9 93 04 00 00       	jmp    80325c <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 50 08             	mov    0x8(%eax),%edx
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd5:	01 c2                	add    %eax,%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	8b 40 08             	mov    0x8(%eax),%eax
  802ddd:	39 c2                	cmp    %eax,%edx
  802ddf:	0f 85 ae 00 00 00    	jne    802e93 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	8b 50 0c             	mov    0xc(%eax),%edx
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	8b 40 08             	mov    0x8(%eax),%eax
  802df1:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802dfb:	39 c2                	cmp    %eax,%edx
  802dfd:	0f 84 90 00 00 00    	je     802e93 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	8b 50 0c             	mov    0xc(%eax),%edx
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0f:	01 c2                	add    %eax,%edx
  802e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e14:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2f:	75 17                	jne    802e48 <insert_sorted_with_merge_freeList+0x3c1>
  802e31:	83 ec 04             	sub    $0x4,%esp
  802e34:	68 f4 3e 80 00       	push   $0x803ef4
  802e39:	68 0b 01 00 00       	push   $0x10b
  802e3e:	68 17 3f 80 00       	push   $0x803f17
  802e43:	e8 5f d6 ff ff       	call   8004a7 <_panic>
  802e48:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	89 10                	mov    %edx,(%eax)
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	8b 00                	mov    (%eax),%eax
  802e58:	85 c0                	test   %eax,%eax
  802e5a:	74 0d                	je     802e69 <insert_sorted_with_merge_freeList+0x3e2>
  802e5c:	a1 48 41 80 00       	mov    0x804148,%eax
  802e61:	8b 55 08             	mov    0x8(%ebp),%edx
  802e64:	89 50 04             	mov    %edx,0x4(%eax)
  802e67:	eb 08                	jmp    802e71 <insert_sorted_with_merge_freeList+0x3ea>
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	a3 48 41 80 00       	mov    %eax,0x804148
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e83:	a1 54 41 80 00       	mov    0x804154,%eax
  802e88:	40                   	inc    %eax
  802e89:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802e8e:	e9 c9 03 00 00       	jmp    80325c <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	8b 50 0c             	mov    0xc(%eax),%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	8b 40 08             	mov    0x8(%eax),%eax
  802e9f:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ea7:	39 c2                	cmp    %eax,%edx
  802ea9:	0f 85 bb 00 00 00    	jne    802f6a <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb3:	0f 84 b1 00 00 00    	je     802f6a <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 40 04             	mov    0x4(%eax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	0f 85 a3 00 00 00    	jne    802f6a <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ec7:	a1 38 41 80 00       	mov    0x804138,%eax
  802ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecf:	8b 52 08             	mov    0x8(%edx),%edx
  802ed2:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802ed5:	a1 38 41 80 00       	mov    0x804138,%eax
  802eda:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ee0:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee6:	8b 52 0c             	mov    0xc(%edx),%edx
  802ee9:	01 ca                	add    %ecx,%edx
  802eeb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802f02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f06:	75 17                	jne    802f1f <insert_sorted_with_merge_freeList+0x498>
  802f08:	83 ec 04             	sub    $0x4,%esp
  802f0b:	68 f4 3e 80 00       	push   $0x803ef4
  802f10:	68 17 01 00 00       	push   $0x117
  802f15:	68 17 3f 80 00       	push   $0x803f17
  802f1a:	e8 88 d5 ff ff       	call   8004a7 <_panic>
  802f1f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	89 10                	mov    %edx,(%eax)
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 0d                	je     802f40 <insert_sorted_with_merge_freeList+0x4b9>
  802f33:	a1 48 41 80 00       	mov    0x804148,%eax
  802f38:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3b:	89 50 04             	mov    %edx,0x4(%eax)
  802f3e:	eb 08                	jmp    802f48 <insert_sorted_with_merge_freeList+0x4c1>
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	a3 48 41 80 00       	mov    %eax,0x804148
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5a:	a1 54 41 80 00       	mov    0x804154,%eax
  802f5f:	40                   	inc    %eax
  802f60:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802f65:	e9 f2 02 00 00       	jmp    80325c <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	8b 50 08             	mov    0x8(%eax),%edx
  802f70:	8b 45 08             	mov    0x8(%ebp),%eax
  802f73:	8b 40 0c             	mov    0xc(%eax),%eax
  802f76:	01 c2                	add    %eax,%edx
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 40 08             	mov    0x8(%eax),%eax
  802f7e:	39 c2                	cmp    %eax,%edx
  802f80:	0f 85 be 00 00 00    	jne    803044 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 40 04             	mov    0x4(%eax),%eax
  802f8c:	8b 50 08             	mov    0x8(%eax),%edx
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 40 04             	mov    0x4(%eax),%eax
  802f95:	8b 40 0c             	mov    0xc(%eax),%eax
  802f98:	01 c2                	add    %eax,%edx
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	8b 40 08             	mov    0x8(%eax),%eax
  802fa0:	39 c2                	cmp    %eax,%edx
  802fa2:	0f 84 9c 00 00 00    	je     803044 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	8b 50 08             	mov    0x8(%eax),%edx
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	8b 50 0c             	mov    0xc(%eax),%edx
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc0:	01 c2                	add    %eax,%edx
  802fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc5:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802fdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe0:	75 17                	jne    802ff9 <insert_sorted_with_merge_freeList+0x572>
  802fe2:	83 ec 04             	sub    $0x4,%esp
  802fe5:	68 f4 3e 80 00       	push   $0x803ef4
  802fea:	68 26 01 00 00       	push   $0x126
  802fef:	68 17 3f 80 00       	push   $0x803f17
  802ff4:	e8 ae d4 ff ff       	call   8004a7 <_panic>
  802ff9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	89 10                	mov    %edx,(%eax)
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	8b 00                	mov    (%eax),%eax
  803009:	85 c0                	test   %eax,%eax
  80300b:	74 0d                	je     80301a <insert_sorted_with_merge_freeList+0x593>
  80300d:	a1 48 41 80 00       	mov    0x804148,%eax
  803012:	8b 55 08             	mov    0x8(%ebp),%edx
  803015:	89 50 04             	mov    %edx,0x4(%eax)
  803018:	eb 08                	jmp    803022 <insert_sorted_with_merge_freeList+0x59b>
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	a3 48 41 80 00       	mov    %eax,0x804148
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803034:	a1 54 41 80 00       	mov    0x804154,%eax
  803039:	40                   	inc    %eax
  80303a:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  80303f:	e9 18 02 00 00       	jmp    80325c <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	8b 50 0c             	mov    0xc(%eax),%edx
  80304a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304d:	8b 40 08             	mov    0x8(%eax),%eax
  803050:	01 c2                	add    %eax,%edx
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	8b 40 08             	mov    0x8(%eax),%eax
  803058:	39 c2                	cmp    %eax,%edx
  80305a:	0f 85 c4 01 00 00    	jne    803224 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	8b 50 0c             	mov    0xc(%eax),%edx
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	8b 40 08             	mov    0x8(%eax),%eax
  80306c:	01 c2                	add    %eax,%edx
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	8b 40 08             	mov    0x8(%eax),%eax
  803076:	39 c2                	cmp    %eax,%edx
  803078:	0f 85 a6 01 00 00    	jne    803224 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  80307e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803082:	0f 84 9c 01 00 00    	je     803224 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 50 0c             	mov    0xc(%eax),%edx
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	8b 40 0c             	mov    0xc(%eax),%eax
  803094:	01 c2                	add    %eax,%edx
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	8b 40 0c             	mov    0xc(%eax),%eax
  80309e:	01 c2                	add    %eax,%edx
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8030ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030be:	75 17                	jne    8030d7 <insert_sorted_with_merge_freeList+0x650>
  8030c0:	83 ec 04             	sub    $0x4,%esp
  8030c3:	68 f4 3e 80 00       	push   $0x803ef4
  8030c8:	68 32 01 00 00       	push   $0x132
  8030cd:	68 17 3f 80 00       	push   $0x803f17
  8030d2:	e8 d0 d3 ff ff       	call   8004a7 <_panic>
  8030d7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	89 10                	mov    %edx,(%eax)
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	8b 00                	mov    (%eax),%eax
  8030e7:	85 c0                	test   %eax,%eax
  8030e9:	74 0d                	je     8030f8 <insert_sorted_with_merge_freeList+0x671>
  8030eb:	a1 48 41 80 00       	mov    0x804148,%eax
  8030f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f3:	89 50 04             	mov    %edx,0x4(%eax)
  8030f6:	eb 08                	jmp    803100 <insert_sorted_with_merge_freeList+0x679>
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	a3 48 41 80 00       	mov    %eax,0x804148
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803112:	a1 54 41 80 00       	mov    0x804154,%eax
  803117:	40                   	inc    %eax
  803118:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	8b 00                	mov    (%eax),%eax
  80312e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803138:	8b 00                	mov    (%eax),%eax
  80313a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  80313d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803141:	75 17                	jne    80315a <insert_sorted_with_merge_freeList+0x6d3>
  803143:	83 ec 04             	sub    $0x4,%esp
  803146:	68 89 3f 80 00       	push   $0x803f89
  80314b:	68 36 01 00 00       	push   $0x136
  803150:	68 17 3f 80 00       	push   $0x803f17
  803155:	e8 4d d3 ff ff       	call   8004a7 <_panic>
  80315a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	85 c0                	test   %eax,%eax
  803161:	74 10                	je     803173 <insert_sorted_with_merge_freeList+0x6ec>
  803163:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803166:	8b 00                	mov    (%eax),%eax
  803168:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80316b:	8b 52 04             	mov    0x4(%edx),%edx
  80316e:	89 50 04             	mov    %edx,0x4(%eax)
  803171:	eb 0b                	jmp    80317e <insert_sorted_with_merge_freeList+0x6f7>
  803173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803176:	8b 40 04             	mov    0x4(%eax),%eax
  803179:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80317e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803181:	8b 40 04             	mov    0x4(%eax),%eax
  803184:	85 c0                	test   %eax,%eax
  803186:	74 0f                	je     803197 <insert_sorted_with_merge_freeList+0x710>
  803188:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318b:	8b 40 04             	mov    0x4(%eax),%eax
  80318e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803191:	8b 12                	mov    (%edx),%edx
  803193:	89 10                	mov    %edx,(%eax)
  803195:	eb 0a                	jmp    8031a1 <insert_sorted_with_merge_freeList+0x71a>
  803197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319a:	8b 00                	mov    (%eax),%eax
  80319c:	a3 38 41 80 00       	mov    %eax,0x804138
  8031a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b4:	a1 44 41 80 00       	mov    0x804144,%eax
  8031b9:	48                   	dec    %eax
  8031ba:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8031bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031c3:	75 17                	jne    8031dc <insert_sorted_with_merge_freeList+0x755>
  8031c5:	83 ec 04             	sub    $0x4,%esp
  8031c8:	68 f4 3e 80 00       	push   $0x803ef4
  8031cd:	68 37 01 00 00       	push   $0x137
  8031d2:	68 17 3f 80 00       	push   $0x803f17
  8031d7:	e8 cb d2 ff ff       	call   8004a7 <_panic>
  8031dc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e5:	89 10                	mov    %edx,(%eax)
  8031e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ea:	8b 00                	mov    (%eax),%eax
  8031ec:	85 c0                	test   %eax,%eax
  8031ee:	74 0d                	je     8031fd <insert_sorted_with_merge_freeList+0x776>
  8031f0:	a1 48 41 80 00       	mov    0x804148,%eax
  8031f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031f8:	89 50 04             	mov    %edx,0x4(%eax)
  8031fb:	eb 08                	jmp    803205 <insert_sorted_with_merge_freeList+0x77e>
  8031fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803200:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803205:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803208:	a3 48 41 80 00       	mov    %eax,0x804148
  80320d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803210:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803217:	a1 54 41 80 00       	mov    0x804154,%eax
  80321c:	40                   	inc    %eax
  80321d:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  803222:	eb 38                	jmp    80325c <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803224:	a1 40 41 80 00       	mov    0x804140,%eax
  803229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80322c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803230:	74 07                	je     803239 <insert_sorted_with_merge_freeList+0x7b2>
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	8b 00                	mov    (%eax),%eax
  803237:	eb 05                	jmp    80323e <insert_sorted_with_merge_freeList+0x7b7>
  803239:	b8 00 00 00 00       	mov    $0x0,%eax
  80323e:	a3 40 41 80 00       	mov    %eax,0x804140
  803243:	a1 40 41 80 00       	mov    0x804140,%eax
  803248:	85 c0                	test   %eax,%eax
  80324a:	0f 85 ef f9 ff ff    	jne    802c3f <insert_sorted_with_merge_freeList+0x1b8>
  803250:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803254:	0f 85 e5 f9 ff ff    	jne    802c3f <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80325a:	eb 00                	jmp    80325c <insert_sorted_with_merge_freeList+0x7d5>
  80325c:	90                   	nop
  80325d:	c9                   	leave  
  80325e:	c3                   	ret    

0080325f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80325f:	55                   	push   %ebp
  803260:	89 e5                	mov    %esp,%ebp
  803262:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803265:	8b 55 08             	mov    0x8(%ebp),%edx
  803268:	89 d0                	mov    %edx,%eax
  80326a:	c1 e0 02             	shl    $0x2,%eax
  80326d:	01 d0                	add    %edx,%eax
  80326f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803276:	01 d0                	add    %edx,%eax
  803278:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80327f:	01 d0                	add    %edx,%eax
  803281:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803288:	01 d0                	add    %edx,%eax
  80328a:	c1 e0 04             	shl    $0x4,%eax
  80328d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803290:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803297:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80329a:	83 ec 0c             	sub    $0xc,%esp
  80329d:	50                   	push   %eax
  80329e:	e8 21 ec ff ff       	call   801ec4 <sys_get_virtual_time>
  8032a3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8032a6:	eb 41                	jmp    8032e9 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8032a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8032ab:	83 ec 0c             	sub    $0xc,%esp
  8032ae:	50                   	push   %eax
  8032af:	e8 10 ec ff ff       	call   801ec4 <sys_get_virtual_time>
  8032b4:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8032b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bd:	29 c2                	sub    %eax,%edx
  8032bf:	89 d0                	mov    %edx,%eax
  8032c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8032c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ca:	89 d1                	mov    %edx,%ecx
  8032cc:	29 c1                	sub    %eax,%ecx
  8032ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d4:	39 c2                	cmp    %eax,%edx
  8032d6:	0f 97 c0             	seta   %al
  8032d9:	0f b6 c0             	movzbl %al,%eax
  8032dc:	29 c1                	sub    %eax,%ecx
  8032de:	89 c8                	mov    %ecx,%eax
  8032e0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8032e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032ef:	72 b7                	jb     8032a8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8032f1:	90                   	nop
  8032f2:	c9                   	leave  
  8032f3:	c3                   	ret    

008032f4 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8032f4:	55                   	push   %ebp
  8032f5:	89 e5                	mov    %esp,%ebp
  8032f7:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8032fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803301:	eb 03                	jmp    803306 <busy_wait+0x12>
  803303:	ff 45 fc             	incl   -0x4(%ebp)
  803306:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803309:	3b 45 08             	cmp    0x8(%ebp),%eax
  80330c:	72 f5                	jb     803303 <busy_wait+0xf>
	return i;
  80330e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803311:	c9                   	leave  
  803312:	c3                   	ret    
  803313:	90                   	nop

00803314 <__udivdi3>:
  803314:	55                   	push   %ebp
  803315:	57                   	push   %edi
  803316:	56                   	push   %esi
  803317:	53                   	push   %ebx
  803318:	83 ec 1c             	sub    $0x1c,%esp
  80331b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80331f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803323:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803327:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80332b:	89 ca                	mov    %ecx,%edx
  80332d:	89 f8                	mov    %edi,%eax
  80332f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803333:	85 f6                	test   %esi,%esi
  803335:	75 2d                	jne    803364 <__udivdi3+0x50>
  803337:	39 cf                	cmp    %ecx,%edi
  803339:	77 65                	ja     8033a0 <__udivdi3+0x8c>
  80333b:	89 fd                	mov    %edi,%ebp
  80333d:	85 ff                	test   %edi,%edi
  80333f:	75 0b                	jne    80334c <__udivdi3+0x38>
  803341:	b8 01 00 00 00       	mov    $0x1,%eax
  803346:	31 d2                	xor    %edx,%edx
  803348:	f7 f7                	div    %edi
  80334a:	89 c5                	mov    %eax,%ebp
  80334c:	31 d2                	xor    %edx,%edx
  80334e:	89 c8                	mov    %ecx,%eax
  803350:	f7 f5                	div    %ebp
  803352:	89 c1                	mov    %eax,%ecx
  803354:	89 d8                	mov    %ebx,%eax
  803356:	f7 f5                	div    %ebp
  803358:	89 cf                	mov    %ecx,%edi
  80335a:	89 fa                	mov    %edi,%edx
  80335c:	83 c4 1c             	add    $0x1c,%esp
  80335f:	5b                   	pop    %ebx
  803360:	5e                   	pop    %esi
  803361:	5f                   	pop    %edi
  803362:	5d                   	pop    %ebp
  803363:	c3                   	ret    
  803364:	39 ce                	cmp    %ecx,%esi
  803366:	77 28                	ja     803390 <__udivdi3+0x7c>
  803368:	0f bd fe             	bsr    %esi,%edi
  80336b:	83 f7 1f             	xor    $0x1f,%edi
  80336e:	75 40                	jne    8033b0 <__udivdi3+0x9c>
  803370:	39 ce                	cmp    %ecx,%esi
  803372:	72 0a                	jb     80337e <__udivdi3+0x6a>
  803374:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803378:	0f 87 9e 00 00 00    	ja     80341c <__udivdi3+0x108>
  80337e:	b8 01 00 00 00       	mov    $0x1,%eax
  803383:	89 fa                	mov    %edi,%edx
  803385:	83 c4 1c             	add    $0x1c,%esp
  803388:	5b                   	pop    %ebx
  803389:	5e                   	pop    %esi
  80338a:	5f                   	pop    %edi
  80338b:	5d                   	pop    %ebp
  80338c:	c3                   	ret    
  80338d:	8d 76 00             	lea    0x0(%esi),%esi
  803390:	31 ff                	xor    %edi,%edi
  803392:	31 c0                	xor    %eax,%eax
  803394:	89 fa                	mov    %edi,%edx
  803396:	83 c4 1c             	add    $0x1c,%esp
  803399:	5b                   	pop    %ebx
  80339a:	5e                   	pop    %esi
  80339b:	5f                   	pop    %edi
  80339c:	5d                   	pop    %ebp
  80339d:	c3                   	ret    
  80339e:	66 90                	xchg   %ax,%ax
  8033a0:	89 d8                	mov    %ebx,%eax
  8033a2:	f7 f7                	div    %edi
  8033a4:	31 ff                	xor    %edi,%edi
  8033a6:	89 fa                	mov    %edi,%edx
  8033a8:	83 c4 1c             	add    $0x1c,%esp
  8033ab:	5b                   	pop    %ebx
  8033ac:	5e                   	pop    %esi
  8033ad:	5f                   	pop    %edi
  8033ae:	5d                   	pop    %ebp
  8033af:	c3                   	ret    
  8033b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033b5:	89 eb                	mov    %ebp,%ebx
  8033b7:	29 fb                	sub    %edi,%ebx
  8033b9:	89 f9                	mov    %edi,%ecx
  8033bb:	d3 e6                	shl    %cl,%esi
  8033bd:	89 c5                	mov    %eax,%ebp
  8033bf:	88 d9                	mov    %bl,%cl
  8033c1:	d3 ed                	shr    %cl,%ebp
  8033c3:	89 e9                	mov    %ebp,%ecx
  8033c5:	09 f1                	or     %esi,%ecx
  8033c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033cb:	89 f9                	mov    %edi,%ecx
  8033cd:	d3 e0                	shl    %cl,%eax
  8033cf:	89 c5                	mov    %eax,%ebp
  8033d1:	89 d6                	mov    %edx,%esi
  8033d3:	88 d9                	mov    %bl,%cl
  8033d5:	d3 ee                	shr    %cl,%esi
  8033d7:	89 f9                	mov    %edi,%ecx
  8033d9:	d3 e2                	shl    %cl,%edx
  8033db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033df:	88 d9                	mov    %bl,%cl
  8033e1:	d3 e8                	shr    %cl,%eax
  8033e3:	09 c2                	or     %eax,%edx
  8033e5:	89 d0                	mov    %edx,%eax
  8033e7:	89 f2                	mov    %esi,%edx
  8033e9:	f7 74 24 0c          	divl   0xc(%esp)
  8033ed:	89 d6                	mov    %edx,%esi
  8033ef:	89 c3                	mov    %eax,%ebx
  8033f1:	f7 e5                	mul    %ebp
  8033f3:	39 d6                	cmp    %edx,%esi
  8033f5:	72 19                	jb     803410 <__udivdi3+0xfc>
  8033f7:	74 0b                	je     803404 <__udivdi3+0xf0>
  8033f9:	89 d8                	mov    %ebx,%eax
  8033fb:	31 ff                	xor    %edi,%edi
  8033fd:	e9 58 ff ff ff       	jmp    80335a <__udivdi3+0x46>
  803402:	66 90                	xchg   %ax,%ax
  803404:	8b 54 24 08          	mov    0x8(%esp),%edx
  803408:	89 f9                	mov    %edi,%ecx
  80340a:	d3 e2                	shl    %cl,%edx
  80340c:	39 c2                	cmp    %eax,%edx
  80340e:	73 e9                	jae    8033f9 <__udivdi3+0xe5>
  803410:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803413:	31 ff                	xor    %edi,%edi
  803415:	e9 40 ff ff ff       	jmp    80335a <__udivdi3+0x46>
  80341a:	66 90                	xchg   %ax,%ax
  80341c:	31 c0                	xor    %eax,%eax
  80341e:	e9 37 ff ff ff       	jmp    80335a <__udivdi3+0x46>
  803423:	90                   	nop

00803424 <__umoddi3>:
  803424:	55                   	push   %ebp
  803425:	57                   	push   %edi
  803426:	56                   	push   %esi
  803427:	53                   	push   %ebx
  803428:	83 ec 1c             	sub    $0x1c,%esp
  80342b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80342f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803433:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803437:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80343b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80343f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803443:	89 f3                	mov    %esi,%ebx
  803445:	89 fa                	mov    %edi,%edx
  803447:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80344b:	89 34 24             	mov    %esi,(%esp)
  80344e:	85 c0                	test   %eax,%eax
  803450:	75 1a                	jne    80346c <__umoddi3+0x48>
  803452:	39 f7                	cmp    %esi,%edi
  803454:	0f 86 a2 00 00 00    	jbe    8034fc <__umoddi3+0xd8>
  80345a:	89 c8                	mov    %ecx,%eax
  80345c:	89 f2                	mov    %esi,%edx
  80345e:	f7 f7                	div    %edi
  803460:	89 d0                	mov    %edx,%eax
  803462:	31 d2                	xor    %edx,%edx
  803464:	83 c4 1c             	add    $0x1c,%esp
  803467:	5b                   	pop    %ebx
  803468:	5e                   	pop    %esi
  803469:	5f                   	pop    %edi
  80346a:	5d                   	pop    %ebp
  80346b:	c3                   	ret    
  80346c:	39 f0                	cmp    %esi,%eax
  80346e:	0f 87 ac 00 00 00    	ja     803520 <__umoddi3+0xfc>
  803474:	0f bd e8             	bsr    %eax,%ebp
  803477:	83 f5 1f             	xor    $0x1f,%ebp
  80347a:	0f 84 ac 00 00 00    	je     80352c <__umoddi3+0x108>
  803480:	bf 20 00 00 00       	mov    $0x20,%edi
  803485:	29 ef                	sub    %ebp,%edi
  803487:	89 fe                	mov    %edi,%esi
  803489:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80348d:	89 e9                	mov    %ebp,%ecx
  80348f:	d3 e0                	shl    %cl,%eax
  803491:	89 d7                	mov    %edx,%edi
  803493:	89 f1                	mov    %esi,%ecx
  803495:	d3 ef                	shr    %cl,%edi
  803497:	09 c7                	or     %eax,%edi
  803499:	89 e9                	mov    %ebp,%ecx
  80349b:	d3 e2                	shl    %cl,%edx
  80349d:	89 14 24             	mov    %edx,(%esp)
  8034a0:	89 d8                	mov    %ebx,%eax
  8034a2:	d3 e0                	shl    %cl,%eax
  8034a4:	89 c2                	mov    %eax,%edx
  8034a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034aa:	d3 e0                	shl    %cl,%eax
  8034ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034b4:	89 f1                	mov    %esi,%ecx
  8034b6:	d3 e8                	shr    %cl,%eax
  8034b8:	09 d0                	or     %edx,%eax
  8034ba:	d3 eb                	shr    %cl,%ebx
  8034bc:	89 da                	mov    %ebx,%edx
  8034be:	f7 f7                	div    %edi
  8034c0:	89 d3                	mov    %edx,%ebx
  8034c2:	f7 24 24             	mull   (%esp)
  8034c5:	89 c6                	mov    %eax,%esi
  8034c7:	89 d1                	mov    %edx,%ecx
  8034c9:	39 d3                	cmp    %edx,%ebx
  8034cb:	0f 82 87 00 00 00    	jb     803558 <__umoddi3+0x134>
  8034d1:	0f 84 91 00 00 00    	je     803568 <__umoddi3+0x144>
  8034d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034db:	29 f2                	sub    %esi,%edx
  8034dd:	19 cb                	sbb    %ecx,%ebx
  8034df:	89 d8                	mov    %ebx,%eax
  8034e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034e5:	d3 e0                	shl    %cl,%eax
  8034e7:	89 e9                	mov    %ebp,%ecx
  8034e9:	d3 ea                	shr    %cl,%edx
  8034eb:	09 d0                	or     %edx,%eax
  8034ed:	89 e9                	mov    %ebp,%ecx
  8034ef:	d3 eb                	shr    %cl,%ebx
  8034f1:	89 da                	mov    %ebx,%edx
  8034f3:	83 c4 1c             	add    $0x1c,%esp
  8034f6:	5b                   	pop    %ebx
  8034f7:	5e                   	pop    %esi
  8034f8:	5f                   	pop    %edi
  8034f9:	5d                   	pop    %ebp
  8034fa:	c3                   	ret    
  8034fb:	90                   	nop
  8034fc:	89 fd                	mov    %edi,%ebp
  8034fe:	85 ff                	test   %edi,%edi
  803500:	75 0b                	jne    80350d <__umoddi3+0xe9>
  803502:	b8 01 00 00 00       	mov    $0x1,%eax
  803507:	31 d2                	xor    %edx,%edx
  803509:	f7 f7                	div    %edi
  80350b:	89 c5                	mov    %eax,%ebp
  80350d:	89 f0                	mov    %esi,%eax
  80350f:	31 d2                	xor    %edx,%edx
  803511:	f7 f5                	div    %ebp
  803513:	89 c8                	mov    %ecx,%eax
  803515:	f7 f5                	div    %ebp
  803517:	89 d0                	mov    %edx,%eax
  803519:	e9 44 ff ff ff       	jmp    803462 <__umoddi3+0x3e>
  80351e:	66 90                	xchg   %ax,%ax
  803520:	89 c8                	mov    %ecx,%eax
  803522:	89 f2                	mov    %esi,%edx
  803524:	83 c4 1c             	add    $0x1c,%esp
  803527:	5b                   	pop    %ebx
  803528:	5e                   	pop    %esi
  803529:	5f                   	pop    %edi
  80352a:	5d                   	pop    %ebp
  80352b:	c3                   	ret    
  80352c:	3b 04 24             	cmp    (%esp),%eax
  80352f:	72 06                	jb     803537 <__umoddi3+0x113>
  803531:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803535:	77 0f                	ja     803546 <__umoddi3+0x122>
  803537:	89 f2                	mov    %esi,%edx
  803539:	29 f9                	sub    %edi,%ecx
  80353b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80353f:	89 14 24             	mov    %edx,(%esp)
  803542:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803546:	8b 44 24 04          	mov    0x4(%esp),%eax
  80354a:	8b 14 24             	mov    (%esp),%edx
  80354d:	83 c4 1c             	add    $0x1c,%esp
  803550:	5b                   	pop    %ebx
  803551:	5e                   	pop    %esi
  803552:	5f                   	pop    %edi
  803553:	5d                   	pop    %ebp
  803554:	c3                   	ret    
  803555:	8d 76 00             	lea    0x0(%esi),%esi
  803558:	2b 04 24             	sub    (%esp),%eax
  80355b:	19 fa                	sbb    %edi,%edx
  80355d:	89 d1                	mov    %edx,%ecx
  80355f:	89 c6                	mov    %eax,%esi
  803561:	e9 71 ff ff ff       	jmp    8034d7 <__umoddi3+0xb3>
  803566:	66 90                	xchg   %ax,%ax
  803568:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80356c:	72 ea                	jb     803558 <__umoddi3+0x134>
  80356e:	89 d9                	mov    %ebx,%ecx
  803570:	e9 62 ff ff ff       	jmp    8034d7 <__umoddi3+0xb3>
