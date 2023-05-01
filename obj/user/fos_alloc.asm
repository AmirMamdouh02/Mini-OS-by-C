
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 97 12 00 00       	call   8012e7 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 a0 32 80 00       	push   $0x8032a0
  800061:	e8 0f 03 00 00       	call   800375 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 b3 32 80 00       	push   $0x8032b3
  8000be:	e8 b2 02 00 00       	call   800375 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 a4 12 00 00       	call   801380 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 fd 11 00 00       	call   8012e7 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 b3 32 80 00       	push   $0x8032b3
  800114:	e8 5c 02 00 00       	call   800375 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 4e 12 00 00       	call   801380 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 22 19 00 00       	call   801a65 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	01 c0                	add    %eax,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015b:	01 d0                	add    %edx,%eax
  80015d:	c1 e0 04             	shl    $0x4,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016a:	a1 20 40 80 00       	mov    0x804020,%eax
  80016f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800175:	84 c0                	test   %al,%al
  800177:	74 0f                	je     800188 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800179:	a1 20 40 80 00       	mov    0x804020,%eax
  80017e:	05 5c 05 00 00       	add    $0x55c,%eax
  800183:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018c:	7e 0a                	jle    800198 <libmain+0x60>
		binaryname = argv[0];
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	8b 00                	mov    (%eax),%eax
  800193:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	ff 75 0c             	pushl  0xc(%ebp)
  80019e:	ff 75 08             	pushl  0x8(%ebp)
  8001a1:	e8 92 fe ff ff       	call   800038 <_main>
  8001a6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a9:	e8 c4 16 00 00       	call   801872 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 d8 32 80 00       	push   $0x8032d8
  8001b6:	e8 8d 01 00 00       	call   800348 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001be:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c3:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d4:	83 ec 04             	sub    $0x4,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	68 00 33 80 00       	push   $0x803300
  8001de:	e8 65 01 00 00       	call   800348 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001eb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800207:	51                   	push   %ecx
  800208:	52                   	push   %edx
  800209:	50                   	push   %eax
  80020a:	68 28 33 80 00       	push   $0x803328
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 80 33 80 00       	push   $0x803380
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 d8 32 80 00       	push   $0x8032d8
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 44 16 00 00       	call   80188c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800248:	e8 19 00 00 00       	call   800266 <exit>
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	6a 00                	push   $0x0
  80025b:	e8 d1 17 00 00       	call   801a31 <sys_destroy_env>
  800260:	83 c4 10             	add    $0x10,%esp
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <exit>:

void
exit(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026c:	e8 26 18 00 00       	call   801a97 <sys_exit_env>
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	8b 00                	mov    (%eax),%eax
  80027f:	8d 48 01             	lea    0x1(%eax),%ecx
  800282:	8b 55 0c             	mov    0xc(%ebp),%edx
  800285:	89 0a                	mov    %ecx,(%edx)
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
  80028a:	88 d1                	mov    %dl,%cl
  80028c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800293:	8b 45 0c             	mov    0xc(%ebp),%eax
  800296:	8b 00                	mov    (%eax),%eax
  800298:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029d:	75 2c                	jne    8002cb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80029f:	a0 24 40 80 00       	mov    0x804024,%al
  8002a4:	0f b6 c0             	movzbl %al,%eax
  8002a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002aa:	8b 12                	mov    (%edx),%edx
  8002ac:	89 d1                	mov    %edx,%ecx
  8002ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b1:	83 c2 08             	add    $0x8,%edx
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	50                   	push   %eax
  8002b8:	51                   	push   %ecx
  8002b9:	52                   	push   %edx
  8002ba:	e8 05 14 00 00       	call   8016c4 <sys_cputs>
  8002bf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	8b 40 04             	mov    0x4(%eax),%eax
  8002d1:	8d 50 01             	lea    0x1(%eax),%edx
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002da:	90                   	nop
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ed:	00 00 00 
	b.cnt = 0;
  8002f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002fa:	ff 75 0c             	pushl  0xc(%ebp)
  8002fd:	ff 75 08             	pushl  0x8(%ebp)
  800300:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800306:	50                   	push   %eax
  800307:	68 74 02 80 00       	push   $0x800274
  80030c:	e8 11 02 00 00       	call   800522 <vprintfmt>
  800311:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800314:	a0 24 40 80 00       	mov    0x804024,%al
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	50                   	push   %eax
  800326:	52                   	push   %edx
  800327:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032d:	83 c0 08             	add    $0x8,%eax
  800330:	50                   	push   %eax
  800331:	e8 8e 13 00 00       	call   8016c4 <sys_cputs>
  800336:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800339:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800340:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <cprintf>:

int cprintf(const char *fmt, ...) {
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80034e:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800355:	8d 45 0c             	lea    0xc(%ebp),%eax
  800358:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80035b:	8b 45 08             	mov    0x8(%ebp),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 f4             	pushl  -0xc(%ebp)
  800364:	50                   	push   %eax
  800365:	e8 73 ff ff ff       	call   8002dd <vcprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800370:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80037b:	e8 f2 14 00 00       	call   801872 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800380:	8d 45 0c             	lea    0xc(%ebp),%eax
  800383:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	50                   	push   %eax
  800390:	e8 48 ff ff ff       	call   8002dd <vcprintf>
  800395:	83 c4 10             	add    $0x10,%esp
  800398:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80039b:	e8 ec 14 00 00       	call   80188c <sys_enable_interrupt>
	return cnt;
  8003a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    

008003a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	53                   	push   %ebx
  8003a9:	83 ec 14             	sub    $0x14,%esp
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c3:	77 55                	ja     80041a <printnum+0x75>
  8003c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c8:	72 05                	jb     8003cf <printnum+0x2a>
  8003ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003cd:	77 4b                	ja     80041a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	52                   	push   %edx
  8003de:	50                   	push   %eax
  8003df:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e5:	e8 42 2c 00 00       	call   80302c <__udivdi3>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	ff 75 20             	pushl  0x20(%ebp)
  8003f3:	53                   	push   %ebx
  8003f4:	ff 75 18             	pushl  0x18(%ebp)
  8003f7:	52                   	push   %edx
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 0c             	pushl  0xc(%ebp)
  8003fc:	ff 75 08             	pushl  0x8(%ebp)
  8003ff:	e8 a1 ff ff ff       	call   8003a5 <printnum>
  800404:	83 c4 20             	add    $0x20,%esp
  800407:	eb 1a                	jmp    800423 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 20             	pushl  0x20(%ebp)
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	ff d0                	call   *%eax
  800417:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041a:	ff 4d 1c             	decl   0x1c(%ebp)
  80041d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800421:	7f e6                	jg     800409 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800423:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800431:	53                   	push   %ebx
  800432:	51                   	push   %ecx
  800433:	52                   	push   %edx
  800434:	50                   	push   %eax
  800435:	e8 02 2d 00 00       	call   80313c <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 b4 35 80 00       	add    $0x8035b4,%eax
  800442:	8a 00                	mov    (%eax),%al
  800444:	0f be c0             	movsbl %al,%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 0c             	pushl  0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	ff d0                	call   *%eax
  800453:	83 c4 10             	add    $0x10,%esp
}
  800456:	90                   	nop
  800457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    

0080045c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800463:	7e 1c                	jle    800481 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 50 08             	lea    0x8(%eax),%edx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	89 10                	mov    %edx,(%eax)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	83 e8 08             	sub    $0x8,%eax
  80047a:	8b 50 04             	mov    0x4(%eax),%edx
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	eb 40                	jmp    8004c1 <getuint+0x65>
	else if (lflag)
  800481:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800485:	74 1e                	je     8004a5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	8d 50 04             	lea    0x4(%eax),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	89 10                	mov    %edx,(%eax)
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 e8 04             	sub    $0x4,%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	eb 1c                	jmp    8004c1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	89 10                	mov    %edx,(%eax)
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	83 e8 04             	sub    $0x4,%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c1:	5d                   	pop    %ebp
  8004c2:	c3                   	ret    

008004c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ca:	7e 1c                	jle    8004e8 <getint+0x25>
		return va_arg(*ap, long long);
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	8d 50 08             	lea    0x8(%eax),%edx
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	89 10                	mov    %edx,(%eax)
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	83 e8 08             	sub    $0x8,%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	eb 38                	jmp    800520 <getint+0x5d>
	else if (lflag)
  8004e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ec:	74 1a                	je     800508 <getint+0x45>
		return va_arg(*ap, long);
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	8d 50 04             	lea    0x4(%eax),%edx
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	89 10                	mov    %edx,(%eax)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	83 e8 04             	sub    $0x4,%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	99                   	cltd   
  800506:	eb 18                	jmp    800520 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 50 04             	lea    0x4(%eax),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	89 10                	mov    %edx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	83 e8 04             	sub    $0x4,%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	99                   	cltd   
}
  800520:	5d                   	pop    %ebp
  800521:	c3                   	ret    

00800522 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	56                   	push   %esi
  800526:	53                   	push   %ebx
  800527:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052a:	eb 17                	jmp    800543 <vprintfmt+0x21>
			if (ch == '\0')
  80052c:	85 db                	test   %ebx,%ebx
  80052e:	0f 84 af 03 00 00    	je     8008e3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	53                   	push   %ebx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	ff d0                	call   *%eax
  800540:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	8d 50 01             	lea    0x1(%eax),%edx
  800549:	89 55 10             	mov    %edx,0x10(%ebp)
  80054c:	8a 00                	mov    (%eax),%al
  80054e:	0f b6 d8             	movzbl %al,%ebx
  800551:	83 fb 25             	cmp    $0x25,%ebx
  800554:	75 d6                	jne    80052c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800556:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80055a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800561:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800568:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80056f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800587:	83 f8 55             	cmp    $0x55,%eax
  80058a:	0f 87 2b 03 00 00    	ja     8008bb <vprintfmt+0x399>
  800590:	8b 04 85 d8 35 80 00 	mov    0x8035d8(,%eax,4),%eax
  800597:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800599:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80059d:	eb d7                	jmp    800576 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005a3:	eb d1                	jmp    800576 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005af:	89 d0                	mov    %edx,%eax
  8005b1:	c1 e0 02             	shl    $0x2,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	01 c0                	add    %eax,%eax
  8005b8:	01 d8                	add    %ebx,%eax
  8005ba:	83 e8 30             	sub    $0x30,%eax
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c3:	8a 00                	mov    (%eax),%al
  8005c5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c8:	83 fb 2f             	cmp    $0x2f,%ebx
  8005cb:	7e 3e                	jle    80060b <vprintfmt+0xe9>
  8005cd:	83 fb 39             	cmp    $0x39,%ebx
  8005d0:	7f 39                	jg     80060b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d5:	eb d5                	jmp    8005ac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	83 c0 04             	add    $0x4,%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 e8 04             	sub    $0x4,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005eb:	eb 1f                	jmp    80060c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f1:	79 83                	jns    800576 <vprintfmt+0x54>
				width = 0;
  8005f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005fa:	e9 77 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005ff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800606:	e9 6b ff ff ff       	jmp    800576 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80060b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800610:	0f 89 60 ff ff ff    	jns    800576 <vprintfmt+0x54>
				width = precision, precision = -1;
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800623:	e9 4e ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800628:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80062b:	e9 46 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	83 c0 04             	add    $0x4,%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	83 e8 04             	sub    $0x4,%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	50                   	push   %eax
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	ff d0                	call   *%eax
  80064d:	83 c4 10             	add    $0x10,%esp
			break;
  800650:	e9 89 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	83 c0 04             	add    $0x4,%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 e8 04             	sub    $0x4,%eax
  800664:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800666:	85 db                	test   %ebx,%ebx
  800668:	79 02                	jns    80066c <vprintfmt+0x14a>
				err = -err;
  80066a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80066c:	83 fb 64             	cmp    $0x64,%ebx
  80066f:	7f 0b                	jg     80067c <vprintfmt+0x15a>
  800671:	8b 34 9d 20 34 80 00 	mov    0x803420(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 c5 35 80 00       	push   $0x8035c5
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	ff 75 08             	pushl  0x8(%ebp)
  800688:	e8 5e 02 00 00       	call   8008eb <printfmt>
  80068d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800690:	e9 49 02 00 00       	jmp    8008de <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800695:	56                   	push   %esi
  800696:	68 ce 35 80 00       	push   $0x8035ce
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	ff 75 08             	pushl  0x8(%ebp)
  8006a1:	e8 45 02 00 00       	call   8008eb <printfmt>
  8006a6:	83 c4 10             	add    $0x10,%esp
			break;
  8006a9:	e9 30 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	83 c0 04             	add    $0x4,%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 30                	mov    (%eax),%esi
  8006bf:	85 f6                	test   %esi,%esi
  8006c1:	75 05                	jne    8006c8 <vprintfmt+0x1a6>
				p = "(null)";
  8006c3:	be d1 35 80 00       	mov    $0x8035d1,%esi
			if (width > 0 && padc != '-')
  8006c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cc:	7e 6d                	jle    80073b <vprintfmt+0x219>
  8006ce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006d2:	74 67                	je     80073b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	50                   	push   %eax
  8006db:	56                   	push   %esi
  8006dc:	e8 0c 03 00 00       	call   8009ed <strnlen>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e7:	eb 16                	jmp    8006ff <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006e9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	50                   	push   %eax
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	ff d0                	call   *%eax
  8006f9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	7f e4                	jg     8006e9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	eb 34                	jmp    80073b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800707:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80070b:	74 1c                	je     800729 <vprintfmt+0x207>
  80070d:	83 fb 1f             	cmp    $0x1f,%ebx
  800710:	7e 05                	jle    800717 <vprintfmt+0x1f5>
  800712:	83 fb 7e             	cmp    $0x7e,%ebx
  800715:	7e 12                	jle    800729 <vprintfmt+0x207>
					putch('?', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	6a 3f                	push   $0x3f
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	eb 0f                	jmp    800738 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	53                   	push   %ebx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	ff 4d e4             	decl   -0x1c(%ebp)
  80073b:	89 f0                	mov    %esi,%eax
  80073d:	8d 70 01             	lea    0x1(%eax),%esi
  800740:	8a 00                	mov    (%eax),%al
  800742:	0f be d8             	movsbl %al,%ebx
  800745:	85 db                	test   %ebx,%ebx
  800747:	74 24                	je     80076d <vprintfmt+0x24b>
  800749:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074d:	78 b8                	js     800707 <vprintfmt+0x1e5>
  80074f:	ff 4d e0             	decl   -0x20(%ebp)
  800752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800756:	79 af                	jns    800707 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800758:	eb 13                	jmp    80076d <vprintfmt+0x24b>
				putch(' ', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	6a 20                	push   $0x20
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	ff d0                	call   *%eax
  800767:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076a:	ff 4d e4             	decl   -0x1c(%ebp)
  80076d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800771:	7f e7                	jg     80075a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800773:	e9 66 01 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 e8             	pushl  -0x18(%ebp)
  80077e:	8d 45 14             	lea    0x14(%ebp),%eax
  800781:	50                   	push   %eax
  800782:	e8 3c fd ff ff       	call   8004c3 <getint>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800796:	85 d2                	test   %edx,%edx
  800798:	79 23                	jns    8007bd <vprintfmt+0x29b>
				putch('-', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	6a 2d                	push   $0x2d
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
  8007a7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b0:	f7 d8                	neg    %eax
  8007b2:	83 d2 00             	adc    $0x0,%edx
  8007b5:	f7 da                	neg    %edx
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c4:	e9 bc 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d2:	50                   	push   %eax
  8007d3:	e8 84 fc ff ff       	call   80045c <getuint>
  8007d8:	83 c4 10             	add    $0x10,%esp
  8007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007de:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e8:	e9 98 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	6a 58                	push   $0x58
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 0c             	pushl  0xc(%ebp)
  800803:	6a 58                	push   $0x58
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
  80080a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 58                	push   $0x58
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			break;
  80081d:	e9 bc 00 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	6a 30                	push   $0x30
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 78                	push   $0x78
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	83 c0 04             	add    $0x4,%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 e8 04             	sub    $0x4,%eax
  800851:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80085d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800864:	eb 1f                	jmp    800885 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 e8             	pushl  -0x18(%ebp)
  80086c:	8d 45 14             	lea    0x14(%ebp),%eax
  80086f:	50                   	push   %eax
  800870:	e8 e7 fb ff ff       	call   80045c <getuint>
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80087e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800885:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088c:	83 ec 04             	sub    $0x4,%esp
  80088f:	52                   	push   %edx
  800890:	ff 75 e4             	pushl  -0x1c(%ebp)
  800893:	50                   	push   %eax
  800894:	ff 75 f4             	pushl  -0xc(%ebp)
  800897:	ff 75 f0             	pushl  -0x10(%ebp)
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	ff 75 08             	pushl  0x8(%ebp)
  8008a0:	e8 00 fb ff ff       	call   8003a5 <printnum>
  8008a5:	83 c4 20             	add    $0x20,%esp
			break;
  8008a8:	eb 34                	jmp    8008de <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	53                   	push   %ebx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
			break;
  8008b9:	eb 23                	jmp    8008de <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	6a 25                	push   $0x25
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cb:	ff 4d 10             	decl   0x10(%ebp)
  8008ce:	eb 03                	jmp    8008d3 <vprintfmt+0x3b1>
  8008d0:	ff 4d 10             	decl   0x10(%ebp)
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	48                   	dec    %eax
  8008d7:	8a 00                	mov    (%eax),%al
  8008d9:	3c 25                	cmp    $0x25,%al
  8008db:	75 f3                	jne    8008d0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008dd:	90                   	nop
		}
	}
  8008de:	e9 47 fc ff ff       	jmp    80052a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5e                   	pop    %esi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f4:	83 c0 04             	add    $0x4,%eax
  8008f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	ff 75 08             	pushl  0x8(%ebp)
  800907:	e8 16 fc ff ff       	call   800522 <vprintfmt>
  80090c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090f:	90                   	nop
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800915:	8b 45 0c             	mov    0xc(%ebp),%eax
  800918:	8b 40 08             	mov    0x8(%eax),%eax
  80091b:	8d 50 01             	lea    0x1(%eax),%edx
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8b 10                	mov    (%eax),%edx
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 40 04             	mov    0x4(%eax),%eax
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	73 12                	jae    800945 <sprintputch+0x33>
		*b->buf++ = ch;
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	8d 48 01             	lea    0x1(%eax),%ecx
  80093b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093e:	89 0a                	mov    %ecx,(%edx)
  800940:	8b 55 08             	mov    0x8(%ebp),%edx
  800943:	88 10                	mov    %dl,(%eax)
}
  800945:	90                   	nop
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	8d 50 ff             	lea    -0x1(%eax),%edx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	01 d0                	add    %edx,%eax
  80095f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800969:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80096d:	74 06                	je     800975 <vsnprintf+0x2d>
  80096f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800973:	7f 07                	jg     80097c <vsnprintf+0x34>
		return -E_INVAL;
  800975:	b8 03 00 00 00       	mov    $0x3,%eax
  80097a:	eb 20                	jmp    80099c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80097c:	ff 75 14             	pushl  0x14(%ebp)
  80097f:	ff 75 10             	pushl  0x10(%ebp)
  800982:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800985:	50                   	push   %eax
  800986:	68 12 09 80 00       	push   $0x800912
  80098b:	e8 92 fb ff ff       	call   800522 <vprintfmt>
  800990:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800996:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800999:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 0c             	pushl  0xc(%ebp)
  8009b7:	ff 75 08             	pushl  0x8(%ebp)
  8009ba:	e8 89 ff ff ff       	call   800948 <vsnprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
  8009c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d7:	eb 06                	jmp    8009df <strlen+0x15>
		n++;
  8009d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009dc:	ff 45 08             	incl   0x8(%ebp)
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8a 00                	mov    (%eax),%al
  8009e4:	84 c0                	test   %al,%al
  8009e6:	75 f1                	jne    8009d9 <strlen+0xf>
		n++;
	return n;
  8009e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009fa:	eb 09                	jmp    800a05 <strnlen+0x18>
		n++;
  8009fc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ff:	ff 45 08             	incl   0x8(%ebp)
  800a02:	ff 4d 0c             	decl   0xc(%ebp)
  800a05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a09:	74 09                	je     800a14 <strnlen+0x27>
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	84 c0                	test   %al,%al
  800a12:	75 e8                	jne    8009fc <strnlen+0xf>
		n++;
	return n;
  800a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a25:	90                   	nop
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8d 50 01             	lea    0x1(%eax),%edx
  800a2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a38:	8a 12                	mov    (%edx),%dl
  800a3a:	88 10                	mov    %dl,(%eax)
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	84 c0                	test   %al,%al
  800a40:	75 e4                	jne    800a26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5a:	eb 1f                	jmp    800a7b <strncpy+0x34>
		*dst++ = *src;
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8d 50 01             	lea    0x1(%eax),%edx
  800a62:	89 55 08             	mov    %edx,0x8(%ebp)
  800a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a68:	8a 12                	mov    (%edx),%dl
  800a6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	74 03                	je     800a78 <strncpy+0x31>
			src++;
  800a75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a78:	ff 45 fc             	incl   -0x4(%ebp)
  800a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a81:	72 d9                	jb     800a5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a98:	74 30                	je     800aca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a9a:	eb 16                	jmp    800ab2 <strlcpy+0x2a>
			*dst++ = *src++;
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8d 50 01             	lea    0x1(%eax),%edx
  800aa2:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aae:	8a 12                	mov    (%edx),%dl
  800ab0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab2:	ff 4d 10             	decl   0x10(%ebp)
  800ab5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab9:	74 09                	je     800ac4 <strlcpy+0x3c>
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	84 c0                	test   %al,%al
  800ac2:	75 d8                	jne    800a9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad0:	29 c2                	sub    %eax,%edx
  800ad2:	89 d0                	mov    %edx,%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ad9:	eb 06                	jmp    800ae1 <strcmp+0xb>
		p++, q++;
  800adb:	ff 45 08             	incl   0x8(%ebp)
  800ade:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	84 c0                	test   %al,%al
  800ae8:	74 0e                	je     800af8 <strcmp+0x22>
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 10                	mov    (%eax),%dl
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	38 c2                	cmp    %al,%dl
  800af6:	74 e3                	je     800adb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8a 00                	mov    (%eax),%al
  800afd:	0f b6 d0             	movzbl %al,%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	0f b6 c0             	movzbl %al,%eax
  800b08:	29 c2                	sub    %eax,%edx
  800b0a:	89 d0                	mov    %edx,%eax
}
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b11:	eb 09                	jmp    800b1c <strncmp+0xe>
		n--, p++, q++;
  800b13:	ff 4d 10             	decl   0x10(%ebp)
  800b16:	ff 45 08             	incl   0x8(%ebp)
  800b19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b20:	74 17                	je     800b39 <strncmp+0x2b>
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	84 c0                	test   %al,%al
  800b29:	74 0e                	je     800b39 <strncmp+0x2b>
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 10                	mov    (%eax),%dl
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	8a 00                	mov    (%eax),%al
  800b35:	38 c2                	cmp    %al,%dl
  800b37:	74 da                	je     800b13 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3d:	75 07                	jne    800b46 <strncmp+0x38>
		return 0;
  800b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b44:	eb 14                	jmp    800b5a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f b6 d0             	movzbl %al,%edx
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	0f b6 c0             	movzbl %al,%eax
  800b56:	29 c2                	sub    %eax,%edx
  800b58:	89 d0                	mov    %edx,%eax
}
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 04             	sub    $0x4,%esp
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b68:	eb 12                	jmp    800b7c <strchr+0x20>
		if (*s == c)
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b72:	75 05                	jne    800b79 <strchr+0x1d>
			return (char *) s;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	eb 11                	jmp    800b8a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b79:	ff 45 08             	incl   0x8(%ebp)
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	84 c0                	test   %al,%al
  800b83:	75 e5                	jne    800b6a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b98:	eb 0d                	jmp    800ba7 <strfind+0x1b>
		if (*s == c)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba2:	74 0e                	je     800bb2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ba4:	ff 45 08             	incl   0x8(%ebp)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 ea                	jne    800b9a <strfind+0xe>
  800bb0:	eb 01                	jmp    800bb3 <strfind+0x27>
		if (*s == c)
			break;
  800bb2:	90                   	nop
	return (char *) s;
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bca:	eb 0e                	jmp    800bda <memset+0x22>
		*p++ = c;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcf:	8d 50 01             	lea    0x1(%eax),%edx
  800bd2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bda:	ff 4d f8             	decl   -0x8(%ebp)
  800bdd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800be1:	79 e9                	jns    800bcc <memset+0x14>
		*p++ = c;

	return v;
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bfa:	eb 16                	jmp    800c12 <memcpy+0x2a>
		*d++ = *s++;
  800bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bff:	8d 50 01             	lea    0x1(%eax),%edx
  800c02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c0e:	8a 12                	mov    (%edx),%dl
  800c10:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c18:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1b:	85 c0                	test   %eax,%eax
  800c1d:	75 dd                	jne    800bfc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c39:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c3c:	73 50                	jae    800c8e <memmove+0x6a>
  800c3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	01 d0                	add    %edx,%eax
  800c46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c49:	76 43                	jbe    800c8e <memmove+0x6a>
		s += n;
  800c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c57:	eb 10                	jmp    800c69 <memmove+0x45>
			*--d = *--s;
  800c59:	ff 4d f8             	decl   -0x8(%ebp)
  800c5c:	ff 4d fc             	decl   -0x4(%ebp)
  800c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c62:	8a 10                	mov    (%eax),%dl
  800c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c67:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	75 e3                	jne    800c59 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c76:	eb 23                	jmp    800c9b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c84:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c87:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c94:	89 55 10             	mov    %edx,0x10(%ebp)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	75 dd                	jne    800c78 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cb2:	eb 2a                	jmp    800cde <memcmp+0x3e>
		if (*s1 != *s2)
  800cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb7:	8a 10                	mov    (%eax),%dl
  800cb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	38 c2                	cmp    %al,%dl
  800cc0:	74 16                	je     800cd8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 d0             	movzbl %al,%edx
  800cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 c0             	movzbl %al,%eax
  800cd2:	29 c2                	sub    %eax,%edx
  800cd4:	89 d0                	mov    %edx,%eax
  800cd6:	eb 18                	jmp    800cf0 <memcmp+0x50>
		s1++, s2++;
  800cd8:	ff 45 fc             	incl   -0x4(%ebp)
  800cdb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cde:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	75 c9                	jne    800cb4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfe:	01 d0                	add    %edx,%eax
  800d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d03:	eb 15                	jmp    800d1a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	0f b6 c0             	movzbl %al,%eax
  800d13:	39 c2                	cmp    %eax,%edx
  800d15:	74 0d                	je     800d24 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d20:	72 e3                	jb     800d05 <memfind+0x13>
  800d22:	eb 01                	jmp    800d25 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d24:	90                   	nop
	return (void *) s;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3e:	eb 03                	jmp    800d43 <strtol+0x19>
		s++;
  800d40:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3c 20                	cmp    $0x20,%al
  800d4a:	74 f4                	je     800d40 <strtol+0x16>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3c 09                	cmp    $0x9,%al
  800d53:	74 eb                	je     800d40 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 2b                	cmp    $0x2b,%al
  800d5c:	75 05                	jne    800d63 <strtol+0x39>
		s++;
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	eb 13                	jmp    800d76 <strtol+0x4c>
	else if (*s == '-')
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	3c 2d                	cmp    $0x2d,%al
  800d6a:	75 0a                	jne    800d76 <strtol+0x4c>
		s++, neg = 1;
  800d6c:	ff 45 08             	incl   0x8(%ebp)
  800d6f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	74 06                	je     800d82 <strtol+0x58>
  800d7c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d80:	75 20                	jne    800da2 <strtol+0x78>
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	3c 30                	cmp    $0x30,%al
  800d89:	75 17                	jne    800da2 <strtol+0x78>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	40                   	inc    %eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3c 78                	cmp    $0x78,%al
  800d93:	75 0d                	jne    800da2 <strtol+0x78>
		s += 2, base = 16;
  800d95:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d99:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da0:	eb 28                	jmp    800dca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800da2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da6:	75 15                	jne    800dbd <strtol+0x93>
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 30                	cmp    $0x30,%al
  800daf:	75 0c                	jne    800dbd <strtol+0x93>
		s++, base = 8;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dbb:	eb 0d                	jmp    800dca <strtol+0xa0>
	else if (base == 0)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	75 07                	jne    800dca <strtol+0xa0>
		base = 10;
  800dc3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	3c 2f                	cmp    $0x2f,%al
  800dd1:	7e 19                	jle    800dec <strtol+0xc2>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	3c 39                	cmp    $0x39,%al
  800dda:	7f 10                	jg     800dec <strtol+0xc2>
			dig = *s - '0';
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f be c0             	movsbl %al,%eax
  800de4:	83 e8 30             	sub    $0x30,%eax
  800de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dea:	eb 42                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	3c 60                	cmp    $0x60,%al
  800df3:	7e 19                	jle    800e0e <strtol+0xe4>
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3c 7a                	cmp    $0x7a,%al
  800dfc:	7f 10                	jg     800e0e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	0f be c0             	movsbl %al,%eax
  800e06:	83 e8 57             	sub    $0x57,%eax
  800e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e0c:	eb 20                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	3c 40                	cmp    $0x40,%al
  800e15:	7e 39                	jle    800e50 <strtol+0x126>
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	3c 5a                	cmp    $0x5a,%al
  800e1e:	7f 30                	jg     800e50 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f be c0             	movsbl %al,%eax
  800e28:	83 e8 37             	sub    $0x37,%eax
  800e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e31:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e34:	7d 19                	jge    800e4f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e40:	89 c2                	mov    %eax,%edx
  800e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e4a:	e9 7b ff ff ff       	jmp    800dca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e4f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e54:	74 08                	je     800e5e <strtol+0x134>
		*endptr = (char *) s;
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e62:	74 07                	je     800e6b <strtol+0x141>
  800e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e67:	f7 d8                	neg    %eax
  800e69:	eb 03                	jmp    800e6e <strtol+0x144>
  800e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <ltostr>:

void
ltostr(long value, char *str)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	79 13                	jns    800e9d <ltostr+0x2d>
	{
		neg = 1;
  800e8a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e97:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e9a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ea5:	99                   	cltd   
  800ea6:	f7 f9                	idiv   %ecx
  800ea8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	8d 50 01             	lea    0x1(%eax),%edx
  800eb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb4:	89 c2                	mov    %eax,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	01 d0                	add    %edx,%eax
  800ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ebe:	83 c2 30             	add    $0x30,%edx
  800ec1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ec3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ecb:	f7 e9                	imul   %ecx
  800ecd:	c1 fa 02             	sar    $0x2,%edx
  800ed0:	89 c8                	mov    %ecx,%eax
  800ed2:	c1 f8 1f             	sar    $0x1f,%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
  800ed9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800edc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee4:	f7 e9                	imul   %ecx
  800ee6:	c1 fa 02             	sar    $0x2,%edx
  800ee9:	89 c8                	mov    %ecx,%eax
  800eeb:	c1 f8 1f             	sar    $0x1f,%eax
  800eee:	29 c2                	sub    %eax,%edx
  800ef0:	89 d0                	mov    %edx,%eax
  800ef2:	c1 e0 02             	shl    $0x2,%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	01 c0                	add    %eax,%eax
  800ef9:	29 c1                	sub    %eax,%ecx
  800efb:	89 ca                	mov    %ecx,%edx
  800efd:	85 d2                	test   %edx,%edx
  800eff:	75 9c                	jne    800e9d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0b:	48                   	dec    %eax
  800f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f13:	74 3d                	je     800f52 <ltostr+0xe2>
		start = 1 ;
  800f15:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f1c:	eb 34                	jmp    800f52 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	01 d0                	add    %edx,%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	01 c2                	add    %eax,%edx
  800f33:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	01 c8                	add    %ecx,%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	01 c2                	add    %eax,%edx
  800f47:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f4a:	88 02                	mov    %al,(%edx)
		start++ ;
  800f4c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f4f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f58:	7c c4                	jl     800f1e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f5a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f6e:	ff 75 08             	pushl  0x8(%ebp)
  800f71:	e8 54 fa ff ff       	call   8009ca <strlen>
  800f76:	83 c4 04             	add    $0x4,%esp
  800f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f7c:	ff 75 0c             	pushl  0xc(%ebp)
  800f7f:	e8 46 fa ff ff       	call   8009ca <strlen>
  800f84:	83 c4 04             	add    $0x4,%esp
  800f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f98:	eb 17                	jmp    800fb1 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	01 c2                	add    %eax,%edx
  800fa2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	01 c8                	add    %ecx,%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fb7:	7c e1                	jl     800f9a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fc7:	eb 1f                	jmp    800fe8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcc:	8d 50 01             	lea    0x1(%eax),%edx
  800fcf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd2:	89 c2                	mov    %eax,%edx
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	01 c2                	add    %eax,%edx
  800fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 c8                	add    %ecx,%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fe5:	ff 45 f8             	incl   -0x8(%ebp)
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fee:	7c d9                	jl     800fc9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ff0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	c6 00 00             	movb   $0x0,(%eax)
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	8b 00                	mov    (%eax),%eax
  80100f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801016:	8b 45 10             	mov    0x10(%ebp),%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801021:	eb 0c                	jmp    80102f <strsplit+0x31>
			*string++ = 0;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 08             	mov    %edx,0x8(%ebp)
  80102c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	84 c0                	test   %al,%al
  801036:	74 18                	je     801050 <strsplit+0x52>
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	50                   	push   %eax
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	e8 13 fb ff ff       	call   800b5c <strchr>
  801049:	83 c4 08             	add    $0x8,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	75 d3                	jne    801023 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	84 c0                	test   %al,%al
  801057:	74 5a                	je     8010b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801059:	8b 45 14             	mov    0x14(%ebp),%eax
  80105c:	8b 00                	mov    (%eax),%eax
  80105e:	83 f8 0f             	cmp    $0xf,%eax
  801061:	75 07                	jne    80106a <strsplit+0x6c>
		{
			return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
  801068:	eb 66                	jmp    8010d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80106a:	8b 45 14             	mov    0x14(%ebp),%eax
  80106d:	8b 00                	mov    (%eax),%eax
  80106f:	8d 48 01             	lea    0x1(%eax),%ecx
  801072:	8b 55 14             	mov    0x14(%ebp),%edx
  801075:	89 0a                	mov    %ecx,(%edx)
  801077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 c2                	add    %eax,%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801088:	eb 03                	jmp    80108d <strsplit+0x8f>
			string++;
  80108a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	84 c0                	test   %al,%al
  801094:	74 8b                	je     801021 <strsplit+0x23>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	0f be c0             	movsbl %al,%eax
  80109e:	50                   	push   %eax
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	e8 b5 fa ff ff       	call   800b5c <strchr>
  8010a7:	83 c4 08             	add    $0x8,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	74 dc                	je     80108a <strsplit+0x8c>
			string++;
	}
  8010ae:	e9 6e ff ff ff       	jmp    801021 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	8b 00                	mov    (%eax),%eax
  8010b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	01 d0                	add    %edx,%eax
  8010c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8010d8:	a1 04 40 80 00       	mov    0x804004,%eax
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 1f                	je     801100 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8010e1:	e8 1d 00 00 00       	call   801103 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	68 30 37 80 00       	push   $0x803730
  8010ee:	e8 55 f2 ff ff       	call   800348 <cprintf>
  8010f3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8010f6:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8010fd:	00 00 00 
	}
}
  801100:	90                   	nop
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801109:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801110:	00 00 00 
  801113:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80111a:	00 00 00 
  80111d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801124:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801127:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80112e:	00 00 00 
  801131:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801138:	00 00 00 
  80113b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801142:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801145:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  80114c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114f:	c1 e8 0c             	shr    $0xc,%eax
  801152:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801157:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80115e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801161:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801166:	2d 00 10 00 00       	sub    $0x1000,%eax
  80116b:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801170:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801177:	a1 20 41 80 00       	mov    0x804120,%eax
  80117c:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801180:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801183:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80118a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80118d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801190:	01 d0                	add    %edx,%eax
  801192:	48                   	dec    %eax
  801193:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801196:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801199:	ba 00 00 00 00       	mov    $0x0,%edx
  80119e:	f7 75 e4             	divl   -0x1c(%ebp)
  8011a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011a4:	29 d0                	sub    %edx,%eax
  8011a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8011a9:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8011b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011bd:	83 ec 04             	sub    $0x4,%esp
  8011c0:	6a 07                	push   $0x7
  8011c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8011c5:	50                   	push   %eax
  8011c6:	e8 3d 06 00 00       	call   801808 <sys_allocate_chunk>
  8011cb:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011ce:	a1 20 41 80 00       	mov    0x804120,%eax
  8011d3:	83 ec 0c             	sub    $0xc,%esp
  8011d6:	50                   	push   %eax
  8011d7:	e8 b2 0c 00 00       	call   801e8e <initialize_MemBlocksList>
  8011dc:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8011df:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8011e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8011e7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8011eb:	0f 84 f3 00 00 00    	je     8012e4 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8011f1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8011f5:	75 14                	jne    80120b <initialize_dyn_block_system+0x108>
  8011f7:	83 ec 04             	sub    $0x4,%esp
  8011fa:	68 55 37 80 00       	push   $0x803755
  8011ff:	6a 36                	push   $0x36
  801201:	68 73 37 80 00       	push   $0x803773
  801206:	e8 41 1c 00 00       	call   802e4c <_panic>
  80120b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80120e:	8b 00                	mov    (%eax),%eax
  801210:	85 c0                	test   %eax,%eax
  801212:	74 10                	je     801224 <initialize_dyn_block_system+0x121>
  801214:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801217:	8b 00                	mov    (%eax),%eax
  801219:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80121c:	8b 52 04             	mov    0x4(%edx),%edx
  80121f:	89 50 04             	mov    %edx,0x4(%eax)
  801222:	eb 0b                	jmp    80122f <initialize_dyn_block_system+0x12c>
  801224:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801227:	8b 40 04             	mov    0x4(%eax),%eax
  80122a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80122f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801232:	8b 40 04             	mov    0x4(%eax),%eax
  801235:	85 c0                	test   %eax,%eax
  801237:	74 0f                	je     801248 <initialize_dyn_block_system+0x145>
  801239:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80123c:	8b 40 04             	mov    0x4(%eax),%eax
  80123f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801242:	8b 12                	mov    (%edx),%edx
  801244:	89 10                	mov    %edx,(%eax)
  801246:	eb 0a                	jmp    801252 <initialize_dyn_block_system+0x14f>
  801248:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80124b:	8b 00                	mov    (%eax),%eax
  80124d:	a3 48 41 80 00       	mov    %eax,0x804148
  801252:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80125b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80125e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801265:	a1 54 41 80 00       	mov    0x804154,%eax
  80126a:	48                   	dec    %eax
  80126b:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801270:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801273:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80127a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80127d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801284:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801288:	75 14                	jne    80129e <initialize_dyn_block_system+0x19b>
  80128a:	83 ec 04             	sub    $0x4,%esp
  80128d:	68 80 37 80 00       	push   $0x803780
  801292:	6a 3e                	push   $0x3e
  801294:	68 73 37 80 00       	push   $0x803773
  801299:	e8 ae 1b 00 00       	call   802e4c <_panic>
  80129e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8012a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012a7:	89 10                	mov    %edx,(%eax)
  8012a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012ac:	8b 00                	mov    (%eax),%eax
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	74 0d                	je     8012bf <initialize_dyn_block_system+0x1bc>
  8012b2:	a1 38 41 80 00       	mov    0x804138,%eax
  8012b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8012ba:	89 50 04             	mov    %edx,0x4(%eax)
  8012bd:	eb 08                	jmp    8012c7 <initialize_dyn_block_system+0x1c4>
  8012bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012c2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012ca:	a3 38 41 80 00       	mov    %eax,0x804138
  8012cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8012d9:	a1 44 41 80 00       	mov    0x804144,%eax
  8012de:	40                   	inc    %eax
  8012df:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8012e4:	90                   	nop
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8012ed:	e8 e0 fd ff ff       	call   8010d2 <InitializeUHeap>
		if (size == 0) return NULL ;
  8012f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f6:	75 07                	jne    8012ff <malloc+0x18>
  8012f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fd:	eb 7f                	jmp    80137e <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8012ff:	e8 d2 08 00 00       	call   801bd6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801304:	85 c0                	test   %eax,%eax
  801306:	74 71                	je     801379 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801308:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80130f:	8b 55 08             	mov    0x8(%ebp),%edx
  801312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	48                   	dec    %eax
  801318:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80131b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131e:	ba 00 00 00 00       	mov    $0x0,%edx
  801323:	f7 75 f4             	divl   -0xc(%ebp)
  801326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801329:	29 d0                	sub    %edx,%eax
  80132b:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80132e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801335:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80133c:	76 07                	jbe    801345 <malloc+0x5e>
					return NULL ;
  80133e:	b8 00 00 00 00       	mov    $0x0,%eax
  801343:	eb 39                	jmp    80137e <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801345:	83 ec 0c             	sub    $0xc,%esp
  801348:	ff 75 08             	pushl  0x8(%ebp)
  80134b:	e8 e6 0d 00 00       	call   802136 <alloc_block_FF>
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801356:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80135a:	74 16                	je     801372 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  80135c:	83 ec 0c             	sub    $0xc,%esp
  80135f:	ff 75 ec             	pushl  -0x14(%ebp)
  801362:	e8 37 0c 00 00       	call   801f9e <insert_sorted_allocList>
  801367:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  80136a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80136d:	8b 40 08             	mov    0x8(%eax),%eax
  801370:	eb 0c                	jmp    80137e <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801372:	b8 00 00 00 00       	mov    $0x0,%eax
  801377:	eb 05                	jmp    80137e <malloc+0x97>
				}
		}
	return 0;
  801379:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	ff 75 f4             	pushl  -0xc(%ebp)
  801392:	68 40 40 80 00       	push   $0x804040
  801397:	e8 cf 0b 00 00       	call   801f6b <find_block>
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8013a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8013ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ae:	8b 40 08             	mov    0x8(%eax),%eax
  8013b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8013b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b8:	0f 84 a1 00 00 00    	je     80145f <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8013be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c2:	75 17                	jne    8013db <free+0x5b>
  8013c4:	83 ec 04             	sub    $0x4,%esp
  8013c7:	68 55 37 80 00       	push   $0x803755
  8013cc:	68 80 00 00 00       	push   $0x80
  8013d1:	68 73 37 80 00       	push   $0x803773
  8013d6:	e8 71 1a 00 00       	call   802e4c <_panic>
  8013db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013de:	8b 00                	mov    (%eax),%eax
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	74 10                	je     8013f4 <free+0x74>
  8013e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e7:	8b 00                	mov    (%eax),%eax
  8013e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ec:	8b 52 04             	mov    0x4(%edx),%edx
  8013ef:	89 50 04             	mov    %edx,0x4(%eax)
  8013f2:	eb 0b                	jmp    8013ff <free+0x7f>
  8013f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f7:	8b 40 04             	mov    0x4(%eax),%eax
  8013fa:	a3 44 40 80 00       	mov    %eax,0x804044
  8013ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801402:	8b 40 04             	mov    0x4(%eax),%eax
  801405:	85 c0                	test   %eax,%eax
  801407:	74 0f                	je     801418 <free+0x98>
  801409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140c:	8b 40 04             	mov    0x4(%eax),%eax
  80140f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801412:	8b 12                	mov    (%edx),%edx
  801414:	89 10                	mov    %edx,(%eax)
  801416:	eb 0a                	jmp    801422 <free+0xa2>
  801418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141b:	8b 00                	mov    (%eax),%eax
  80141d:	a3 40 40 80 00       	mov    %eax,0x804040
  801422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80142b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801435:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80143a:	48                   	dec    %eax
  80143b:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801440:	83 ec 0c             	sub    $0xc,%esp
  801443:	ff 75 f0             	pushl  -0x10(%ebp)
  801446:	e8 29 12 00 00       	call   802674 <insert_sorted_with_merge_freeList>
  80144b:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  80144e:	83 ec 08             	sub    $0x8,%esp
  801451:	ff 75 ec             	pushl  -0x14(%ebp)
  801454:	ff 75 e8             	pushl  -0x18(%ebp)
  801457:	e8 74 03 00 00       	call   8017d0 <sys_free_user_mem>
  80145c:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80145f:	90                   	nop
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 38             	sub    $0x38,%esp
  801468:	8b 45 10             	mov    0x10(%ebp),%eax
  80146b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80146e:	e8 5f fc ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  801473:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801477:	75 0a                	jne    801483 <smalloc+0x21>
  801479:	b8 00 00 00 00       	mov    $0x0,%eax
  80147e:	e9 b2 00 00 00       	jmp    801535 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801483:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80148a:	76 0a                	jbe    801496 <smalloc+0x34>
		return NULL;
  80148c:	b8 00 00 00 00       	mov    $0x0,%eax
  801491:	e9 9f 00 00 00       	jmp    801535 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801496:	e8 3b 07 00 00       	call   801bd6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80149b:	85 c0                	test   %eax,%eax
  80149d:	0f 84 8d 00 00 00    	je     801530 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8014a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8014aa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b7:	01 d0                	add    %edx,%eax
  8014b9:	48                   	dec    %eax
  8014ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c5:	f7 75 f0             	divl   -0x10(%ebp)
  8014c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014cb:	29 d0                	sub    %edx,%eax
  8014cd:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8014d0:	83 ec 0c             	sub    $0xc,%esp
  8014d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8014d6:	e8 5b 0c 00 00       	call   802136 <alloc_block_FF>
  8014db:	83 c4 10             	add    $0x10,%esp
  8014de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8014e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014e5:	75 07                	jne    8014ee <smalloc+0x8c>
			return NULL;
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ec:	eb 47                	jmp    801535 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8014ee:	83 ec 0c             	sub    $0xc,%esp
  8014f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f4:	e8 a5 0a 00 00       	call   801f9e <insert_sorted_allocList>
  8014f9:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8014fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ff:	8b 40 08             	mov    0x8(%eax),%eax
  801502:	89 c2                	mov    %eax,%edx
  801504:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801508:	52                   	push   %edx
  801509:	50                   	push   %eax
  80150a:	ff 75 0c             	pushl  0xc(%ebp)
  80150d:	ff 75 08             	pushl  0x8(%ebp)
  801510:	e8 46 04 00 00       	call   80195b <sys_createSharedObject>
  801515:	83 c4 10             	add    $0x10,%esp
  801518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80151b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80151f:	78 08                	js     801529 <smalloc+0xc7>
		return (void *)b->sva;
  801521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801524:	8b 40 08             	mov    0x8(%eax),%eax
  801527:	eb 0c                	jmp    801535 <smalloc+0xd3>
		}else{
		return NULL;
  801529:	b8 00 00 00 00       	mov    $0x0,%eax
  80152e:	eb 05                	jmp    801535 <smalloc+0xd3>
			}

	}return NULL;
  801530:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80153d:	e8 90 fb ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801542:	e8 8f 06 00 00       	call   801bd6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801547:	85 c0                	test   %eax,%eax
  801549:	0f 84 ad 00 00 00    	je     8015fc <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	ff 75 0c             	pushl  0xc(%ebp)
  801555:	ff 75 08             	pushl  0x8(%ebp)
  801558:	e8 28 04 00 00       	call   801985 <sys_getSizeOfSharedObject>
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801567:	79 0a                	jns    801573 <sget+0x3c>
    {
    	return NULL;
  801569:	b8 00 00 00 00       	mov    $0x0,%eax
  80156e:	e9 8e 00 00 00       	jmp    801601 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801573:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80157a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801581:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801587:	01 d0                	add    %edx,%eax
  801589:	48                   	dec    %eax
  80158a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80158d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801590:	ba 00 00 00 00       	mov    $0x0,%edx
  801595:	f7 75 ec             	divl   -0x14(%ebp)
  801598:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80159b:	29 d0                	sub    %edx,%eax
  80159d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8015a0:	83 ec 0c             	sub    $0xc,%esp
  8015a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015a6:	e8 8b 0b 00 00       	call   802136 <alloc_block_FF>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8015b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015b5:	75 07                	jne    8015be <sget+0x87>
				return NULL;
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bc:	eb 43                	jmp    801601 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8015be:	83 ec 0c             	sub    $0xc,%esp
  8015c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8015c4:	e8 d5 09 00 00       	call   801f9e <insert_sorted_allocList>
  8015c9:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8015cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cf:	8b 40 08             	mov    0x8(%eax),%eax
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	50                   	push   %eax
  8015d6:	ff 75 0c             	pushl  0xc(%ebp)
  8015d9:	ff 75 08             	pushl  0x8(%ebp)
  8015dc:	e8 c1 03 00 00       	call   8019a2 <sys_getSharedObject>
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8015e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015eb:	78 08                	js     8015f5 <sget+0xbe>
			return (void *)b->sva;
  8015ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f0:	8b 40 08             	mov    0x8(%eax),%eax
  8015f3:	eb 0c                	jmp    801601 <sget+0xca>
			}else{
			return NULL;
  8015f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fa:	eb 05                	jmp    801601 <sget+0xca>
			}
    }}return NULL;
  8015fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801609:	e8 c4 fa ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80160e:	83 ec 04             	sub    $0x4,%esp
  801611:	68 a4 37 80 00       	push   $0x8037a4
  801616:	68 03 01 00 00       	push   $0x103
  80161b:	68 73 37 80 00       	push   $0x803773
  801620:	e8 27 18 00 00       	call   802e4c <_panic>

00801625 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80162b:	83 ec 04             	sub    $0x4,%esp
  80162e:	68 cc 37 80 00       	push   $0x8037cc
  801633:	68 17 01 00 00       	push   $0x117
  801638:	68 73 37 80 00       	push   $0x803773
  80163d:	e8 0a 18 00 00       	call   802e4c <_panic>

00801642 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801648:	83 ec 04             	sub    $0x4,%esp
  80164b:	68 f0 37 80 00       	push   $0x8037f0
  801650:	68 22 01 00 00       	push   $0x122
  801655:	68 73 37 80 00       	push   $0x803773
  80165a:	e8 ed 17 00 00       	call   802e4c <_panic>

0080165f <shrink>:

}
void shrink(uint32 newSize)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	68 f0 37 80 00       	push   $0x8037f0
  80166d:	68 27 01 00 00       	push   $0x127
  801672:	68 73 37 80 00       	push   $0x803773
  801677:	e8 d0 17 00 00       	call   802e4c <_panic>

0080167c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	68 f0 37 80 00       	push   $0x8037f0
  80168a:	68 2c 01 00 00       	push   $0x12c
  80168f:	68 73 37 80 00       	push   $0x803773
  801694:	e8 b3 17 00 00       	call   802e4c <_panic>

00801699 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	57                   	push   %edi
  80169d:	56                   	push   %esi
  80169e:	53                   	push   %ebx
  80169f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ae:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016b1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016b4:	cd 30                	int    $0x30
  8016b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	5b                   	pop    %ebx
  8016c0:	5e                   	pop    %esi
  8016c1:	5f                   	pop    %edi
  8016c2:	5d                   	pop    %ebp
  8016c3:	c3                   	ret    

008016c4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	83 ec 04             	sub    $0x4,%esp
  8016ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	52                   	push   %edx
  8016dc:	ff 75 0c             	pushl  0xc(%ebp)
  8016df:	50                   	push   %eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	e8 b2 ff ff ff       	call   801699 <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	90                   	nop
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_cgetc>:

int
sys_cgetc(void)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 01                	push   $0x1
  8016fc:	e8 98 ff ff ff       	call   801699 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801709:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	52                   	push   %edx
  801716:	50                   	push   %eax
  801717:	6a 05                	push   $0x5
  801719:	e8 7b ff ff ff       	call   801699 <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801728:	8b 75 18             	mov    0x18(%ebp),%esi
  80172b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80172e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801731:	8b 55 0c             	mov    0xc(%ebp),%edx
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	56                   	push   %esi
  801738:	53                   	push   %ebx
  801739:	51                   	push   %ecx
  80173a:	52                   	push   %edx
  80173b:	50                   	push   %eax
  80173c:	6a 06                	push   $0x6
  80173e:	e8 56 ff ff ff       	call   801699 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801749:	5b                   	pop    %ebx
  80174a:	5e                   	pop    %esi
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    

0080174d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801750:	8b 55 0c             	mov    0xc(%ebp),%edx
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	52                   	push   %edx
  80175d:	50                   	push   %eax
  80175e:	6a 07                	push   $0x7
  801760:	e8 34 ff ff ff       	call   801699 <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	ff 75 0c             	pushl  0xc(%ebp)
  801776:	ff 75 08             	pushl  0x8(%ebp)
  801779:	6a 08                	push   $0x8
  80177b:	e8 19 ff ff ff       	call   801699 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 09                	push   $0x9
  801794:	e8 00 ff ff ff       	call   801699 <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 0a                	push   $0xa
  8017ad:	e8 e7 fe ff ff       	call   801699 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 0b                	push   $0xb
  8017c6:	e8 ce fe ff ff       	call   801699 <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	ff 75 0c             	pushl  0xc(%ebp)
  8017dc:	ff 75 08             	pushl  0x8(%ebp)
  8017df:	6a 0f                	push   $0xf
  8017e1:	e8 b3 fe ff ff       	call   801699 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
	return;
  8017e9:	90                   	nop
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	ff 75 08             	pushl  0x8(%ebp)
  8017fb:	6a 10                	push   $0x10
  8017fd:	e8 97 fe ff ff       	call   801699 <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
	return ;
  801805:	90                   	nop
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	ff 75 10             	pushl  0x10(%ebp)
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	ff 75 08             	pushl  0x8(%ebp)
  801818:	6a 11                	push   $0x11
  80181a:	e8 7a fe ff ff       	call   801699 <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
	return ;
  801822:	90                   	nop
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 0c                	push   $0xc
  801834:	e8 60 fe ff ff       	call   801699 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	ff 75 08             	pushl  0x8(%ebp)
  80184c:	6a 0d                	push   $0xd
  80184e:	e8 46 fe ff ff       	call   801699 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 0e                	push   $0xe
  801867:	e8 2d fe ff ff       	call   801699 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	90                   	nop
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 13                	push   $0x13
  801881:	e8 13 fe ff ff       	call   801699 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	90                   	nop
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 14                	push   $0x14
  80189b:	e8 f9 fd ff ff       	call   801699 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	90                   	nop
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018b2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	50                   	push   %eax
  8018bf:	6a 15                	push   $0x15
  8018c1:	e8 d3 fd ff ff       	call   801699 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	90                   	nop
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 16                	push   $0x16
  8018db:	e8 b9 fd ff ff       	call   801699 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	90                   	nop
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	50                   	push   %eax
  8018f6:	6a 17                	push   $0x17
  8018f8:	e8 9c fd ff ff       	call   801699 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801905:	8b 55 0c             	mov    0xc(%ebp),%edx
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	52                   	push   %edx
  801912:	50                   	push   %eax
  801913:	6a 1a                	push   $0x1a
  801915:	e8 7f fd ff ff       	call   801699 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801922:	8b 55 0c             	mov    0xc(%ebp),%edx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	52                   	push   %edx
  80192f:	50                   	push   %eax
  801930:	6a 18                	push   $0x18
  801932:	e8 62 fd ff ff       	call   801699 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	90                   	nop
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801940:	8b 55 0c             	mov    0xc(%ebp),%edx
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	52                   	push   %edx
  80194d:	50                   	push   %eax
  80194e:	6a 19                	push   $0x19
  801950:	e8 44 fd ff ff       	call   801699 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	90                   	nop
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 04             	sub    $0x4,%esp
  801961:	8b 45 10             	mov    0x10(%ebp),%eax
  801964:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801967:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80196a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	6a 00                	push   $0x0
  801973:	51                   	push   %ecx
  801974:	52                   	push   %edx
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	50                   	push   %eax
  801979:	6a 1b                	push   $0x1b
  80197b:	e8 19 fd ff ff       	call   801699 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	52                   	push   %edx
  801995:	50                   	push   %eax
  801996:	6a 1c                	push   $0x1c
  801998:	e8 fc fc ff ff       	call   801699 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	51                   	push   %ecx
  8019b3:	52                   	push   %edx
  8019b4:	50                   	push   %eax
  8019b5:	6a 1d                	push   $0x1d
  8019b7:	e8 dd fc ff ff       	call   801699 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	52                   	push   %edx
  8019d1:	50                   	push   %eax
  8019d2:	6a 1e                	push   $0x1e
  8019d4:	e8 c0 fc ff ff       	call   801699 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 1f                	push   $0x1f
  8019ed:	e8 a7 fc ff ff       	call   801699 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	ff 75 14             	pushl  0x14(%ebp)
  801a02:	ff 75 10             	pushl  0x10(%ebp)
  801a05:	ff 75 0c             	pushl  0xc(%ebp)
  801a08:	50                   	push   %eax
  801a09:	6a 20                	push   $0x20
  801a0b:	e8 89 fc ff ff       	call   801699 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	50                   	push   %eax
  801a24:	6a 21                	push   $0x21
  801a26:	e8 6e fc ff ff       	call   801699 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	50                   	push   %eax
  801a40:	6a 22                	push   $0x22
  801a42:	e8 52 fc ff ff       	call   801699 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 02                	push   $0x2
  801a5b:	e8 39 fc ff ff       	call   801699 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 03                	push   $0x3
  801a74:	e8 20 fc ff ff       	call   801699 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 04                	push   $0x4
  801a8d:	e8 07 fc ff ff       	call   801699 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_exit_env>:


void sys_exit_env(void)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 23                	push   $0x23
  801aa6:	e8 ee fb ff ff       	call   801699 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	90                   	nop
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ab7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aba:	8d 50 04             	lea    0x4(%eax),%edx
  801abd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	52                   	push   %edx
  801ac7:	50                   	push   %eax
  801ac8:	6a 24                	push   $0x24
  801aca:	e8 ca fb ff ff       	call   801699 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
	return result;
  801ad2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801adb:	89 01                	mov    %eax,(%ecx)
  801add:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	c9                   	leave  
  801ae4:	c2 04 00             	ret    $0x4

00801ae7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	ff 75 10             	pushl  0x10(%ebp)
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	ff 75 08             	pushl  0x8(%ebp)
  801af7:	6a 12                	push   $0x12
  801af9:	e8 9b fb ff ff       	call   801699 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
	return ;
  801b01:	90                   	nop
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 25                	push   $0x25
  801b13:	e8 81 fb ff ff       	call   801699 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	83 ec 04             	sub    $0x4,%esp
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b29:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	50                   	push   %eax
  801b36:	6a 26                	push   $0x26
  801b38:	e8 5c fb ff ff       	call   801699 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b40:	90                   	nop
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <rsttst>:
void rsttst()
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 28                	push   $0x28
  801b52:	e8 42 fb ff ff       	call   801699 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5a:	90                   	nop
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	8b 45 14             	mov    0x14(%ebp),%eax
  801b66:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b69:	8b 55 18             	mov    0x18(%ebp),%edx
  801b6c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	ff 75 10             	pushl  0x10(%ebp)
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 27                	push   $0x27
  801b7d:	e8 17 fb ff ff       	call   801699 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <chktst>:
void chktst(uint32 n)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	ff 75 08             	pushl  0x8(%ebp)
  801b96:	6a 29                	push   $0x29
  801b98:	e8 fc fa ff ff       	call   801699 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba0:	90                   	nop
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <inctst>:

void inctst()
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 2a                	push   $0x2a
  801bb2:	e8 e2 fa ff ff       	call   801699 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bba:	90                   	nop
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <gettst>:
uint32 gettst()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 2b                	push   $0x2b
  801bcc:	e8 c8 fa ff ff       	call   801699 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 2c                	push   $0x2c
  801be8:	e8 ac fa ff ff       	call   801699 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
  801bf0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bf3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bf7:	75 07                	jne    801c00 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bf9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfe:	eb 05                	jmp    801c05 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 2c                	push   $0x2c
  801c19:	e8 7b fa ff ff       	call   801699 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
  801c21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c24:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c28:	75 07                	jne    801c31 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2f:	eb 05                	jmp    801c36 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 2c                	push   $0x2c
  801c4a:	e8 4a fa ff ff       	call   801699 <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
  801c52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c55:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c59:	75 07                	jne    801c62 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c60:	eb 05                	jmp    801c67 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 2c                	push   $0x2c
  801c7b:	e8 19 fa ff ff       	call   801699 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
  801c83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c86:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c8a:	75 07                	jne    801c93 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c91:	eb 05                	jmp    801c98 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	ff 75 08             	pushl  0x8(%ebp)
  801ca8:	6a 2d                	push   $0x2d
  801caa:	e8 ea f9 ff ff       	call   801699 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb2:	90                   	nop
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	53                   	push   %ebx
  801cc8:	51                   	push   %ecx
  801cc9:	52                   	push   %edx
  801cca:	50                   	push   %eax
  801ccb:	6a 2e                	push   $0x2e
  801ccd:	e8 c7 f9 ff ff       	call   801699 <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	52                   	push   %edx
  801cea:	50                   	push   %eax
  801ceb:	6a 2f                	push   $0x2f
  801ced:	e8 a7 f9 ff ff       	call   801699 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	68 00 38 80 00       	push   $0x803800
  801d05:	e8 3e e6 ff ff       	call   800348 <cprintf>
  801d0a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d14:	83 ec 0c             	sub    $0xc,%esp
  801d17:	68 2c 38 80 00       	push   $0x80382c
  801d1c:	e8 27 e6 ff ff       	call   800348 <cprintf>
  801d21:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d24:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d28:	a1 38 41 80 00       	mov    0x804138,%eax
  801d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d30:	eb 56                	jmp    801d88 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d36:	74 1c                	je     801d54 <print_mem_block_lists+0x5d>
  801d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3b:	8b 50 08             	mov    0x8(%eax),%edx
  801d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d41:	8b 48 08             	mov    0x8(%eax),%ecx
  801d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d47:	8b 40 0c             	mov    0xc(%eax),%eax
  801d4a:	01 c8                	add    %ecx,%eax
  801d4c:	39 c2                	cmp    %eax,%edx
  801d4e:	73 04                	jae    801d54 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d50:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d57:	8b 50 08             	mov    0x8(%eax),%edx
  801d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d60:	01 c2                	add    %eax,%edx
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	8b 40 08             	mov    0x8(%eax),%eax
  801d68:	83 ec 04             	sub    $0x4,%esp
  801d6b:	52                   	push   %edx
  801d6c:	50                   	push   %eax
  801d6d:	68 41 38 80 00       	push   $0x803841
  801d72:	e8 d1 e5 ff ff       	call   800348 <cprintf>
  801d77:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d80:	a1 40 41 80 00       	mov    0x804140,%eax
  801d85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d8c:	74 07                	je     801d95 <print_mem_block_lists+0x9e>
  801d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d91:	8b 00                	mov    (%eax),%eax
  801d93:	eb 05                	jmp    801d9a <print_mem_block_lists+0xa3>
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9a:	a3 40 41 80 00       	mov    %eax,0x804140
  801d9f:	a1 40 41 80 00       	mov    0x804140,%eax
  801da4:	85 c0                	test   %eax,%eax
  801da6:	75 8a                	jne    801d32 <print_mem_block_lists+0x3b>
  801da8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dac:	75 84                	jne    801d32 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dae:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801db2:	75 10                	jne    801dc4 <print_mem_block_lists+0xcd>
  801db4:	83 ec 0c             	sub    $0xc,%esp
  801db7:	68 50 38 80 00       	push   $0x803850
  801dbc:	e8 87 e5 ff ff       	call   800348 <cprintf>
  801dc1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dc4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	68 74 38 80 00       	push   $0x803874
  801dd3:	e8 70 e5 ff ff       	call   800348 <cprintf>
  801dd8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ddb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ddf:	a1 40 40 80 00       	mov    0x804040,%eax
  801de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de7:	eb 56                	jmp    801e3f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801de9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ded:	74 1c                	je     801e0b <print_mem_block_lists+0x114>
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	8b 50 08             	mov    0x8(%eax),%edx
  801df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df8:	8b 48 08             	mov    0x8(%eax),%ecx
  801dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  801e01:	01 c8                	add    %ecx,%eax
  801e03:	39 c2                	cmp    %eax,%edx
  801e05:	73 04                	jae    801e0b <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e07:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0e:	8b 50 08             	mov    0x8(%eax),%edx
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e14:	8b 40 0c             	mov    0xc(%eax),%eax
  801e17:	01 c2                	add    %eax,%edx
  801e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1c:	8b 40 08             	mov    0x8(%eax),%eax
  801e1f:	83 ec 04             	sub    $0x4,%esp
  801e22:	52                   	push   %edx
  801e23:	50                   	push   %eax
  801e24:	68 41 38 80 00       	push   $0x803841
  801e29:	e8 1a e5 ff ff       	call   800348 <cprintf>
  801e2e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e37:	a1 48 40 80 00       	mov    0x804048,%eax
  801e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e43:	74 07                	je     801e4c <print_mem_block_lists+0x155>
  801e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e48:	8b 00                	mov    (%eax),%eax
  801e4a:	eb 05                	jmp    801e51 <print_mem_block_lists+0x15a>
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e51:	a3 48 40 80 00       	mov    %eax,0x804048
  801e56:	a1 48 40 80 00       	mov    0x804048,%eax
  801e5b:	85 c0                	test   %eax,%eax
  801e5d:	75 8a                	jne    801de9 <print_mem_block_lists+0xf2>
  801e5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e63:	75 84                	jne    801de9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e65:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e69:	75 10                	jne    801e7b <print_mem_block_lists+0x184>
  801e6b:	83 ec 0c             	sub    $0xc,%esp
  801e6e:	68 8c 38 80 00       	push   $0x80388c
  801e73:	e8 d0 e4 ff ff       	call   800348 <cprintf>
  801e78:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e7b:	83 ec 0c             	sub    $0xc,%esp
  801e7e:	68 00 38 80 00       	push   $0x803800
  801e83:	e8 c0 e4 ff ff       	call   800348 <cprintf>
  801e88:	83 c4 10             	add    $0x10,%esp

}
  801e8b:	90                   	nop
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801e94:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e9b:	00 00 00 
  801e9e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ea5:	00 00 00 
  801ea8:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801eaf:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  801eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eb9:	e9 9e 00 00 00       	jmp    801f5c <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  801ebe:	a1 50 40 80 00       	mov    0x804050,%eax
  801ec3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec6:	c1 e2 04             	shl    $0x4,%edx
  801ec9:	01 d0                	add    %edx,%eax
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	75 14                	jne    801ee3 <initialize_MemBlocksList+0x55>
  801ecf:	83 ec 04             	sub    $0x4,%esp
  801ed2:	68 b4 38 80 00       	push   $0x8038b4
  801ed7:	6a 3d                	push   $0x3d
  801ed9:	68 d7 38 80 00       	push   $0x8038d7
  801ede:	e8 69 0f 00 00       	call   802e4c <_panic>
  801ee3:	a1 50 40 80 00       	mov    0x804050,%eax
  801ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eeb:	c1 e2 04             	shl    $0x4,%edx
  801eee:	01 d0                	add    %edx,%eax
  801ef0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ef6:	89 10                	mov    %edx,(%eax)
  801ef8:	8b 00                	mov    (%eax),%eax
  801efa:	85 c0                	test   %eax,%eax
  801efc:	74 18                	je     801f16 <initialize_MemBlocksList+0x88>
  801efe:	a1 48 41 80 00       	mov    0x804148,%eax
  801f03:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f09:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f0c:	c1 e1 04             	shl    $0x4,%ecx
  801f0f:	01 ca                	add    %ecx,%edx
  801f11:	89 50 04             	mov    %edx,0x4(%eax)
  801f14:	eb 12                	jmp    801f28 <initialize_MemBlocksList+0x9a>
  801f16:	a1 50 40 80 00       	mov    0x804050,%eax
  801f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1e:	c1 e2 04             	shl    $0x4,%edx
  801f21:	01 d0                	add    %edx,%eax
  801f23:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f28:	a1 50 40 80 00       	mov    0x804050,%eax
  801f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f30:	c1 e2 04             	shl    $0x4,%edx
  801f33:	01 d0                	add    %edx,%eax
  801f35:	a3 48 41 80 00       	mov    %eax,0x804148
  801f3a:	a1 50 40 80 00       	mov    0x804050,%eax
  801f3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f42:	c1 e2 04             	shl    $0x4,%edx
  801f45:	01 d0                	add    %edx,%eax
  801f47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f4e:	a1 54 41 80 00       	mov    0x804154,%eax
  801f53:	40                   	inc    %eax
  801f54:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  801f59:	ff 45 f4             	incl   -0xc(%ebp)
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f62:	0f 82 56 ff ff ff    	jb     801ebe <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  801f68:	90                   	nop
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	8b 00                	mov    (%eax),%eax
  801f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  801f79:	eb 18                	jmp    801f93 <find_block+0x28>

		if(tmp->sva == va){
  801f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7e:	8b 40 08             	mov    0x8(%eax),%eax
  801f81:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f84:	75 05                	jne    801f8b <find_block+0x20>
			return tmp ;
  801f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f89:	eb 11                	jmp    801f9c <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  801f8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f8e:	8b 00                	mov    (%eax),%eax
  801f90:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  801f93:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f97:	75 e2                	jne    801f7b <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  801f99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  801fa4:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  801fac:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  801fb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fb8:	75 65                	jne    80201f <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  801fba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fbe:	75 14                	jne    801fd4 <insert_sorted_allocList+0x36>
  801fc0:	83 ec 04             	sub    $0x4,%esp
  801fc3:	68 b4 38 80 00       	push   $0x8038b4
  801fc8:	6a 62                	push   $0x62
  801fca:	68 d7 38 80 00       	push   $0x8038d7
  801fcf:	e8 78 0e 00 00       	call   802e4c <_panic>
  801fd4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	89 10                	mov    %edx,(%eax)
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	8b 00                	mov    (%eax),%eax
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	74 0d                	je     801ff5 <insert_sorted_allocList+0x57>
  801fe8:	a1 40 40 80 00       	mov    0x804040,%eax
  801fed:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff0:	89 50 04             	mov    %edx,0x4(%eax)
  801ff3:	eb 08                	jmp    801ffd <insert_sorted_allocList+0x5f>
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	a3 44 40 80 00       	mov    %eax,0x804044
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	a3 40 40 80 00       	mov    %eax,0x804040
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80200f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802014:	40                   	inc    %eax
  802015:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80201a:	e9 14 01 00 00       	jmp    802133 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	8b 50 08             	mov    0x8(%eax),%edx
  802025:	a1 44 40 80 00       	mov    0x804044,%eax
  80202a:	8b 40 08             	mov    0x8(%eax),%eax
  80202d:	39 c2                	cmp    %eax,%edx
  80202f:	76 65                	jbe    802096 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802031:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802035:	75 14                	jne    80204b <insert_sorted_allocList+0xad>
  802037:	83 ec 04             	sub    $0x4,%esp
  80203a:	68 f0 38 80 00       	push   $0x8038f0
  80203f:	6a 64                	push   $0x64
  802041:	68 d7 38 80 00       	push   $0x8038d7
  802046:	e8 01 0e 00 00       	call   802e4c <_panic>
  80204b:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	89 50 04             	mov    %edx,0x4(%eax)
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	8b 40 04             	mov    0x4(%eax),%eax
  80205d:	85 c0                	test   %eax,%eax
  80205f:	74 0c                	je     80206d <insert_sorted_allocList+0xcf>
  802061:	a1 44 40 80 00       	mov    0x804044,%eax
  802066:	8b 55 08             	mov    0x8(%ebp),%edx
  802069:	89 10                	mov    %edx,(%eax)
  80206b:	eb 08                	jmp    802075 <insert_sorted_allocList+0xd7>
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	a3 40 40 80 00       	mov    %eax,0x804040
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	a3 44 40 80 00       	mov    %eax,0x804044
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802086:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80208b:	40                   	inc    %eax
  80208c:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802091:	e9 9d 00 00 00       	jmp    802133 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802096:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80209d:	e9 85 00 00 00       	jmp    802127 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	8b 50 08             	mov    0x8(%eax),%edx
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	8b 40 08             	mov    0x8(%eax),%eax
  8020ae:	39 c2                	cmp    %eax,%edx
  8020b0:	73 6a                	jae    80211c <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8020b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b6:	74 06                	je     8020be <insert_sorted_allocList+0x120>
  8020b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020bc:	75 14                	jne    8020d2 <insert_sorted_allocList+0x134>
  8020be:	83 ec 04             	sub    $0x4,%esp
  8020c1:	68 14 39 80 00       	push   $0x803914
  8020c6:	6a 6b                	push   $0x6b
  8020c8:	68 d7 38 80 00       	push   $0x8038d7
  8020cd:	e8 7a 0d 00 00       	call   802e4c <_panic>
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	8b 50 04             	mov    0x4(%eax),%edx
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	89 50 04             	mov    %edx,0x4(%eax)
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e4:	89 10                	mov    %edx,(%eax)
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e9:	8b 40 04             	mov    0x4(%eax),%eax
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	74 0d                	je     8020fd <insert_sorted_allocList+0x15f>
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 40 04             	mov    0x4(%eax),%eax
  8020f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f9:	89 10                	mov    %edx,(%eax)
  8020fb:	eb 08                	jmp    802105 <insert_sorted_allocList+0x167>
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	a3 40 40 80 00       	mov    %eax,0x804040
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	8b 55 08             	mov    0x8(%ebp),%edx
  80210b:	89 50 04             	mov    %edx,0x4(%eax)
  80210e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802113:	40                   	inc    %eax
  802114:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802119:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80211a:	eb 17                	jmp    802133 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	8b 00                	mov    (%eax),%eax
  802121:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802124:	ff 45 f0             	incl   -0x10(%ebp)
  802127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80212d:	0f 8c 6f ff ff ff    	jl     8020a2 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802133:	90                   	nop
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80213c:	a1 38 41 80 00       	mov    0x804138,%eax
  802141:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802144:	e9 7c 01 00 00       	jmp    8022c5 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	8b 40 0c             	mov    0xc(%eax),%eax
  80214f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802152:	0f 86 cf 00 00 00    	jbe    802227 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802158:	a1 48 41 80 00       	mov    0x804148,%eax
  80215d:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802163:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802169:	8b 55 08             	mov    0x8(%ebp),%edx
  80216c:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	8b 50 08             	mov    0x8(%eax),%edx
  802175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802178:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  80217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217e:	8b 40 0c             	mov    0xc(%eax),%eax
  802181:	2b 45 08             	sub    0x8(%ebp),%eax
  802184:	89 c2                	mov    %eax,%edx
  802186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802189:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 50 08             	mov    0x8(%eax),%edx
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	01 c2                	add    %eax,%edx
  802197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219a:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80219d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021a1:	75 17                	jne    8021ba <alloc_block_FF+0x84>
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	68 49 39 80 00       	push   $0x803949
  8021ab:	68 83 00 00 00       	push   $0x83
  8021b0:	68 d7 38 80 00       	push   $0x8038d7
  8021b5:	e8 92 0c 00 00       	call   802e4c <_panic>
  8021ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bd:	8b 00                	mov    (%eax),%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	74 10                	je     8021d3 <alloc_block_FF+0x9d>
  8021c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c6:	8b 00                	mov    (%eax),%eax
  8021c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021cb:	8b 52 04             	mov    0x4(%edx),%edx
  8021ce:	89 50 04             	mov    %edx,0x4(%eax)
  8021d1:	eb 0b                	jmp    8021de <alloc_block_FF+0xa8>
  8021d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d6:	8b 40 04             	mov    0x4(%eax),%eax
  8021d9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e1:	8b 40 04             	mov    0x4(%eax),%eax
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	74 0f                	je     8021f7 <alloc_block_FF+0xc1>
  8021e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021eb:	8b 40 04             	mov    0x4(%eax),%eax
  8021ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021f1:	8b 12                	mov    (%edx),%edx
  8021f3:	89 10                	mov    %edx,(%eax)
  8021f5:	eb 0a                	jmp    802201 <alloc_block_FF+0xcb>
  8021f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fa:	8b 00                	mov    (%eax),%eax
  8021fc:	a3 48 41 80 00       	mov    %eax,0x804148
  802201:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802204:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80220a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802214:	a1 54 41 80 00       	mov    0x804154,%eax
  802219:	48                   	dec    %eax
  80221a:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  80221f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802222:	e9 ad 00 00 00       	jmp    8022d4 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	8b 40 0c             	mov    0xc(%eax),%eax
  80222d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802230:	0f 85 87 00 00 00    	jne    8022bd <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223a:	75 17                	jne    802253 <alloc_block_FF+0x11d>
  80223c:	83 ec 04             	sub    $0x4,%esp
  80223f:	68 49 39 80 00       	push   $0x803949
  802244:	68 87 00 00 00       	push   $0x87
  802249:	68 d7 38 80 00       	push   $0x8038d7
  80224e:	e8 f9 0b 00 00       	call   802e4c <_panic>
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 00                	mov    (%eax),%eax
  802258:	85 c0                	test   %eax,%eax
  80225a:	74 10                	je     80226c <alloc_block_FF+0x136>
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 00                	mov    (%eax),%eax
  802261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802264:	8b 52 04             	mov    0x4(%edx),%edx
  802267:	89 50 04             	mov    %edx,0x4(%eax)
  80226a:	eb 0b                	jmp    802277 <alloc_block_FF+0x141>
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	8b 40 04             	mov    0x4(%eax),%eax
  802272:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	8b 40 04             	mov    0x4(%eax),%eax
  80227d:	85 c0                	test   %eax,%eax
  80227f:	74 0f                	je     802290 <alloc_block_FF+0x15a>
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 40 04             	mov    0x4(%eax),%eax
  802287:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228a:	8b 12                	mov    (%edx),%edx
  80228c:	89 10                	mov    %edx,(%eax)
  80228e:	eb 0a                	jmp    80229a <alloc_block_FF+0x164>
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 00                	mov    (%eax),%eax
  802295:	a3 38 41 80 00       	mov    %eax,0x804138
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ad:	a1 44 41 80 00       	mov    0x804144,%eax
  8022b2:	48                   	dec    %eax
  8022b3:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	eb 17                	jmp    8022d4 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 00                	mov    (%eax),%eax
  8022c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8022c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c9:	0f 85 7a fe ff ff    	jne    802149 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8022dc:	a1 38 41 80 00       	mov    0x804138,%eax
  8022e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8022e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8022eb:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8022f2:	a1 38 41 80 00       	mov    0x804138,%eax
  8022f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fa:	e9 d0 00 00 00       	jmp    8023cf <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 40 0c             	mov    0xc(%eax),%eax
  802305:	3b 45 08             	cmp    0x8(%ebp),%eax
  802308:	0f 82 b8 00 00 00    	jb     8023c6 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 40 0c             	mov    0xc(%eax),%eax
  802314:	2b 45 08             	sub    0x8(%ebp),%eax
  802317:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80231a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80231d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802320:	0f 83 a1 00 00 00    	jae    8023c7 <alloc_block_BF+0xf1>
				differsize = differance ;
  802326:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802329:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802332:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802336:	0f 85 8b 00 00 00    	jne    8023c7 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80233c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802340:	75 17                	jne    802359 <alloc_block_BF+0x83>
  802342:	83 ec 04             	sub    $0x4,%esp
  802345:	68 49 39 80 00       	push   $0x803949
  80234a:	68 a0 00 00 00       	push   $0xa0
  80234f:	68 d7 38 80 00       	push   $0x8038d7
  802354:	e8 f3 0a 00 00       	call   802e4c <_panic>
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	74 10                	je     802372 <alloc_block_BF+0x9c>
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236a:	8b 52 04             	mov    0x4(%edx),%edx
  80236d:	89 50 04             	mov    %edx,0x4(%eax)
  802370:	eb 0b                	jmp    80237d <alloc_block_BF+0xa7>
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	8b 40 04             	mov    0x4(%eax),%eax
  802378:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	8b 40 04             	mov    0x4(%eax),%eax
  802383:	85 c0                	test   %eax,%eax
  802385:	74 0f                	je     802396 <alloc_block_BF+0xc0>
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 40 04             	mov    0x4(%eax),%eax
  80238d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802390:	8b 12                	mov    (%edx),%edx
  802392:	89 10                	mov    %edx,(%eax)
  802394:	eb 0a                	jmp    8023a0 <alloc_block_BF+0xca>
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 00                	mov    (%eax),%eax
  80239b:	a3 38 41 80 00       	mov    %eax,0x804138
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8023b8:	48                   	dec    %eax
  8023b9:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	e9 0c 01 00 00       	jmp    8024d2 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8023c6:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8023c7:	a1 40 41 80 00       	mov    0x804140,%eax
  8023cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d3:	74 07                	je     8023dc <alloc_block_BF+0x106>
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 00                	mov    (%eax),%eax
  8023da:	eb 05                	jmp    8023e1 <alloc_block_BF+0x10b>
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e1:	a3 40 41 80 00       	mov    %eax,0x804140
  8023e6:	a1 40 41 80 00       	mov    0x804140,%eax
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	0f 85 0c ff ff ff    	jne    8022ff <alloc_block_BF+0x29>
  8023f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f7:	0f 85 02 ff ff ff    	jne    8022ff <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8023fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802401:	0f 84 c6 00 00 00    	je     8024cd <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802407:	a1 48 41 80 00       	mov    0x804148,%eax
  80240c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80240f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802412:	8b 55 08             	mov    0x8(%ebp),%edx
  802415:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241b:	8b 50 08             	mov    0x8(%eax),%edx
  80241e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802421:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802427:	8b 40 0c             	mov    0xc(%eax),%eax
  80242a:	2b 45 08             	sub    0x8(%ebp),%eax
  80242d:	89 c2                	mov    %eax,%edx
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802438:	8b 50 08             	mov    0x8(%eax),%edx
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	01 c2                	add    %eax,%edx
  802440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802443:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802446:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80244a:	75 17                	jne    802463 <alloc_block_BF+0x18d>
  80244c:	83 ec 04             	sub    $0x4,%esp
  80244f:	68 49 39 80 00       	push   $0x803949
  802454:	68 af 00 00 00       	push   $0xaf
  802459:	68 d7 38 80 00       	push   $0x8038d7
  80245e:	e8 e9 09 00 00       	call   802e4c <_panic>
  802463:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	85 c0                	test   %eax,%eax
  80246a:	74 10                	je     80247c <alloc_block_BF+0x1a6>
  80246c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80246f:	8b 00                	mov    (%eax),%eax
  802471:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802474:	8b 52 04             	mov    0x4(%edx),%edx
  802477:	89 50 04             	mov    %edx,0x4(%eax)
  80247a:	eb 0b                	jmp    802487 <alloc_block_BF+0x1b1>
  80247c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80247f:	8b 40 04             	mov    0x4(%eax),%eax
  802482:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802487:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80248a:	8b 40 04             	mov    0x4(%eax),%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	74 0f                	je     8024a0 <alloc_block_BF+0x1ca>
  802491:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802494:	8b 40 04             	mov    0x4(%eax),%eax
  802497:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80249a:	8b 12                	mov    (%edx),%edx
  80249c:	89 10                	mov    %edx,(%eax)
  80249e:	eb 0a                	jmp    8024aa <alloc_block_BF+0x1d4>
  8024a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024a3:	8b 00                	mov    (%eax),%eax
  8024a5:	a3 48 41 80 00       	mov    %eax,0x804148
  8024aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024bd:	a1 54 41 80 00       	mov    0x804154,%eax
  8024c2:	48                   	dec    %eax
  8024c3:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8024c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024cb:	eb 05                	jmp    8024d2 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8024cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
  8024d7:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8024da:	a1 38 41 80 00       	mov    0x804138,%eax
  8024df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8024e2:	e9 7c 01 00 00       	jmp    802663 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f0:	0f 86 cf 00 00 00    	jbe    8025c5 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8024f6:	a1 48 41 80 00       	mov    0x804148,%eax
  8024fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8024fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802501:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802504:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802507:	8b 55 08             	mov    0x8(%ebp),%edx
  80250a:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 50 08             	mov    0x8(%eax),%edx
  802513:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802516:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 40 0c             	mov    0xc(%eax),%eax
  80251f:	2b 45 08             	sub    0x8(%ebp),%eax
  802522:	89 c2                	mov    %eax,%edx
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 50 08             	mov    0x8(%eax),%edx
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	01 c2                	add    %eax,%edx
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80253b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80253f:	75 17                	jne    802558 <alloc_block_NF+0x84>
  802541:	83 ec 04             	sub    $0x4,%esp
  802544:	68 49 39 80 00       	push   $0x803949
  802549:	68 c4 00 00 00       	push   $0xc4
  80254e:	68 d7 38 80 00       	push   $0x8038d7
  802553:	e8 f4 08 00 00       	call   802e4c <_panic>
  802558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255b:	8b 00                	mov    (%eax),%eax
  80255d:	85 c0                	test   %eax,%eax
  80255f:	74 10                	je     802571 <alloc_block_NF+0x9d>
  802561:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802564:	8b 00                	mov    (%eax),%eax
  802566:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802569:	8b 52 04             	mov    0x4(%edx),%edx
  80256c:	89 50 04             	mov    %edx,0x4(%eax)
  80256f:	eb 0b                	jmp    80257c <alloc_block_NF+0xa8>
  802571:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802574:	8b 40 04             	mov    0x4(%eax),%eax
  802577:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80257c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257f:	8b 40 04             	mov    0x4(%eax),%eax
  802582:	85 c0                	test   %eax,%eax
  802584:	74 0f                	je     802595 <alloc_block_NF+0xc1>
  802586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802589:	8b 40 04             	mov    0x4(%eax),%eax
  80258c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80258f:	8b 12                	mov    (%edx),%edx
  802591:	89 10                	mov    %edx,(%eax)
  802593:	eb 0a                	jmp    80259f <alloc_block_NF+0xcb>
  802595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	a3 48 41 80 00       	mov    %eax,0x804148
  80259f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b2:	a1 54 41 80 00       	mov    0x804154,%eax
  8025b7:	48                   	dec    %eax
  8025b8:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8025bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c0:	e9 ad 00 00 00       	jmp    802672 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ce:	0f 85 87 00 00 00    	jne    80265b <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8025d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d8:	75 17                	jne    8025f1 <alloc_block_NF+0x11d>
  8025da:	83 ec 04             	sub    $0x4,%esp
  8025dd:	68 49 39 80 00       	push   $0x803949
  8025e2:	68 c8 00 00 00       	push   $0xc8
  8025e7:	68 d7 38 80 00       	push   $0x8038d7
  8025ec:	e8 5b 08 00 00       	call   802e4c <_panic>
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	74 10                	je     80260a <alloc_block_NF+0x136>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802602:	8b 52 04             	mov    0x4(%edx),%edx
  802605:	89 50 04             	mov    %edx,0x4(%eax)
  802608:	eb 0b                	jmp    802615 <alloc_block_NF+0x141>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 40 04             	mov    0x4(%eax),%eax
  802610:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	8b 40 04             	mov    0x4(%eax),%eax
  80261b:	85 c0                	test   %eax,%eax
  80261d:	74 0f                	je     80262e <alloc_block_NF+0x15a>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 40 04             	mov    0x4(%eax),%eax
  802625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802628:	8b 12                	mov    (%edx),%edx
  80262a:	89 10                	mov    %edx,(%eax)
  80262c:	eb 0a                	jmp    802638 <alloc_block_NF+0x164>
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	a3 38 41 80 00       	mov    %eax,0x804138
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264b:	a1 44 41 80 00       	mov    0x804144,%eax
  802650:	48                   	dec    %eax
  802651:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	eb 17                	jmp    802672 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 00                	mov    (%eax),%eax
  802660:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802667:	0f 85 7a fe ff ff    	jne    8024e7 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  80266d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80267a:	a1 38 41 80 00       	mov    0x804138,%eax
  80267f:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802682:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802687:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80268a:	a1 44 41 80 00       	mov    0x804144,%eax
  80268f:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802692:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802696:	75 68                	jne    802700 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802698:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80269c:	75 17                	jne    8026b5 <insert_sorted_with_merge_freeList+0x41>
  80269e:	83 ec 04             	sub    $0x4,%esp
  8026a1:	68 b4 38 80 00       	push   $0x8038b4
  8026a6:	68 da 00 00 00       	push   $0xda
  8026ab:	68 d7 38 80 00       	push   $0x8038d7
  8026b0:	e8 97 07 00 00       	call   802e4c <_panic>
  8026b5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	89 10                	mov    %edx,(%eax)
  8026c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	74 0d                	je     8026d6 <insert_sorted_with_merge_freeList+0x62>
  8026c9:	a1 38 41 80 00       	mov    0x804138,%eax
  8026ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d1:	89 50 04             	mov    %edx,0x4(%eax)
  8026d4:	eb 08                	jmp    8026de <insert_sorted_with_merge_freeList+0x6a>
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026de:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e1:	a3 38 41 80 00       	mov    %eax,0x804138
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f0:	a1 44 41 80 00       	mov    0x804144,%eax
  8026f5:	40                   	inc    %eax
  8026f6:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  8026fb:	e9 49 07 00 00       	jmp    802e49 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802703:	8b 50 08             	mov    0x8(%eax),%edx
  802706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802709:	8b 40 0c             	mov    0xc(%eax),%eax
  80270c:	01 c2                	add    %eax,%edx
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	8b 40 08             	mov    0x8(%eax),%eax
  802714:	39 c2                	cmp    %eax,%edx
  802716:	73 77                	jae    80278f <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	85 c0                	test   %eax,%eax
  80271f:	75 6e                	jne    80278f <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802721:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802725:	74 68                	je     80278f <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802727:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80272b:	75 17                	jne    802744 <insert_sorted_with_merge_freeList+0xd0>
  80272d:	83 ec 04             	sub    $0x4,%esp
  802730:	68 f0 38 80 00       	push   $0x8038f0
  802735:	68 e0 00 00 00       	push   $0xe0
  80273a:	68 d7 38 80 00       	push   $0x8038d7
  80273f:	e8 08 07 00 00       	call   802e4c <_panic>
  802744:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80274a:	8b 45 08             	mov    0x8(%ebp),%eax
  80274d:	89 50 04             	mov    %edx,0x4(%eax)
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	8b 40 04             	mov    0x4(%eax),%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	74 0c                	je     802766 <insert_sorted_with_merge_freeList+0xf2>
  80275a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80275f:	8b 55 08             	mov    0x8(%ebp),%edx
  802762:	89 10                	mov    %edx,(%eax)
  802764:	eb 08                	jmp    80276e <insert_sorted_with_merge_freeList+0xfa>
  802766:	8b 45 08             	mov    0x8(%ebp),%eax
  802769:	a3 38 41 80 00       	mov    %eax,0x804138
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277f:	a1 44 41 80 00       	mov    0x804144,%eax
  802784:	40                   	inc    %eax
  802785:	a3 44 41 80 00       	mov    %eax,0x804144
  80278a:	e9 ba 06 00 00       	jmp    802e49 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	8b 50 0c             	mov    0xc(%eax),%edx
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	8b 40 08             	mov    0x8(%eax),%eax
  80279b:	01 c2                	add    %eax,%edx
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 40 08             	mov    0x8(%eax),%eax
  8027a3:	39 c2                	cmp    %eax,%edx
  8027a5:	73 78                	jae    80281f <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 40 04             	mov    0x4(%eax),%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	75 6e                	jne    80281f <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8027b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027b5:	74 68                	je     80281f <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8027b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027bb:	75 17                	jne    8027d4 <insert_sorted_with_merge_freeList+0x160>
  8027bd:	83 ec 04             	sub    $0x4,%esp
  8027c0:	68 b4 38 80 00       	push   $0x8038b4
  8027c5:	68 e6 00 00 00       	push   $0xe6
  8027ca:	68 d7 38 80 00       	push   $0x8038d7
  8027cf:	e8 78 06 00 00       	call   802e4c <_panic>
  8027d4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	89 10                	mov    %edx,(%eax)
  8027df:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 0d                	je     8027f5 <insert_sorted_with_merge_freeList+0x181>
  8027e8:	a1 38 41 80 00       	mov    0x804138,%eax
  8027ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f0:	89 50 04             	mov    %edx,0x4(%eax)
  8027f3:	eb 08                	jmp    8027fd <insert_sorted_with_merge_freeList+0x189>
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802800:	a3 38 41 80 00       	mov    %eax,0x804138
  802805:	8b 45 08             	mov    0x8(%ebp),%eax
  802808:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80280f:	a1 44 41 80 00       	mov    0x804144,%eax
  802814:	40                   	inc    %eax
  802815:	a3 44 41 80 00       	mov    %eax,0x804144
  80281a:	e9 2a 06 00 00       	jmp    802e49 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80281f:	a1 38 41 80 00       	mov    0x804138,%eax
  802824:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802827:	e9 ed 05 00 00       	jmp    802e19 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802834:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802838:	0f 84 a7 00 00 00    	je     8028e5 <insert_sorted_with_merge_freeList+0x271>
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 50 0c             	mov    0xc(%eax),%edx
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 40 08             	mov    0x8(%eax),%eax
  80284a:	01 c2                	add    %eax,%edx
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	8b 40 08             	mov    0x8(%eax),%eax
  802852:	39 c2                	cmp    %eax,%edx
  802854:	0f 83 8b 00 00 00    	jae    8028e5 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	8b 50 0c             	mov    0xc(%eax),%edx
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	8b 40 08             	mov    0x8(%eax),%eax
  802866:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802868:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80286b:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  80286e:	39 c2                	cmp    %eax,%edx
  802870:	73 73                	jae    8028e5 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802872:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802876:	74 06                	je     80287e <insert_sorted_with_merge_freeList+0x20a>
  802878:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80287c:	75 17                	jne    802895 <insert_sorted_with_merge_freeList+0x221>
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	68 68 39 80 00       	push   $0x803968
  802886:	68 f0 00 00 00       	push   $0xf0
  80288b:	68 d7 38 80 00       	push   $0x8038d7
  802890:	e8 b7 05 00 00       	call   802e4c <_panic>
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 10                	mov    (%eax),%edx
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	89 10                	mov    %edx,(%eax)
  80289f:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	74 0b                	je     8028b3 <insert_sorted_with_merge_freeList+0x23f>
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b0:	89 50 04             	mov    %edx,0x4(%eax)
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b9:	89 10                	mov    %edx,(%eax)
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c1:	89 50 04             	mov    %edx,0x4(%eax)
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	8b 00                	mov    (%eax),%eax
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	75 08                	jne    8028d5 <insert_sorted_with_merge_freeList+0x261>
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028d5:	a1 44 41 80 00       	mov    0x804144,%eax
  8028da:	40                   	inc    %eax
  8028db:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  8028e0:	e9 64 05 00 00       	jmp    802e49 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  8028e5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028ea:	8b 50 0c             	mov    0xc(%eax),%edx
  8028ed:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028f2:	8b 40 08             	mov    0x8(%eax),%eax
  8028f5:	01 c2                	add    %eax,%edx
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	8b 40 08             	mov    0x8(%eax),%eax
  8028fd:	39 c2                	cmp    %eax,%edx
  8028ff:	0f 85 b1 00 00 00    	jne    8029b6 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802905:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80290a:	85 c0                	test   %eax,%eax
  80290c:	0f 84 a4 00 00 00    	je     8029b6 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802912:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	85 c0                	test   %eax,%eax
  80291b:	0f 85 95 00 00 00    	jne    8029b6 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802921:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802926:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80292c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80292f:	8b 55 08             	mov    0x8(%ebp),%edx
  802932:	8b 52 0c             	mov    0xc(%edx),%edx
  802935:	01 ca                	add    %ecx,%edx
  802937:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80294e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802952:	75 17                	jne    80296b <insert_sorted_with_merge_freeList+0x2f7>
  802954:	83 ec 04             	sub    $0x4,%esp
  802957:	68 b4 38 80 00       	push   $0x8038b4
  80295c:	68 ff 00 00 00       	push   $0xff
  802961:	68 d7 38 80 00       	push   $0x8038d7
  802966:	e8 e1 04 00 00       	call   802e4c <_panic>
  80296b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802971:	8b 45 08             	mov    0x8(%ebp),%eax
  802974:	89 10                	mov    %edx,(%eax)
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	8b 00                	mov    (%eax),%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	74 0d                	je     80298c <insert_sorted_with_merge_freeList+0x318>
  80297f:	a1 48 41 80 00       	mov    0x804148,%eax
  802984:	8b 55 08             	mov    0x8(%ebp),%edx
  802987:	89 50 04             	mov    %edx,0x4(%eax)
  80298a:	eb 08                	jmp    802994 <insert_sorted_with_merge_freeList+0x320>
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	a3 48 41 80 00       	mov    %eax,0x804148
  80299c:	8b 45 08             	mov    0x8(%ebp),%eax
  80299f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a6:	a1 54 41 80 00       	mov    0x804154,%eax
  8029ab:	40                   	inc    %eax
  8029ac:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  8029b1:	e9 93 04 00 00       	jmp    802e49 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	8b 50 08             	mov    0x8(%eax),%edx
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c2:	01 c2                	add    %eax,%edx
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ca:	39 c2                	cmp    %eax,%edx
  8029cc:	0f 85 ae 00 00 00    	jne    802a80 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	8b 40 08             	mov    0x8(%eax),%eax
  8029de:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  8029e8:	39 c2                	cmp    %eax,%edx
  8029ea:	0f 84 90 00 00 00    	je     802a80 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 50 0c             	mov    0xc(%eax),%edx
  8029f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029fc:	01 c2                	add    %eax,%edx
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a11:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802a18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a1c:	75 17                	jne    802a35 <insert_sorted_with_merge_freeList+0x3c1>
  802a1e:	83 ec 04             	sub    $0x4,%esp
  802a21:	68 b4 38 80 00       	push   $0x8038b4
  802a26:	68 0b 01 00 00       	push   $0x10b
  802a2b:	68 d7 38 80 00       	push   $0x8038d7
  802a30:	e8 17 04 00 00       	call   802e4c <_panic>
  802a35:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	89 10                	mov    %edx,(%eax)
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	8b 00                	mov    (%eax),%eax
  802a45:	85 c0                	test   %eax,%eax
  802a47:	74 0d                	je     802a56 <insert_sorted_with_merge_freeList+0x3e2>
  802a49:	a1 48 41 80 00       	mov    0x804148,%eax
  802a4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a51:	89 50 04             	mov    %edx,0x4(%eax)
  802a54:	eb 08                	jmp    802a5e <insert_sorted_with_merge_freeList+0x3ea>
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a61:	a3 48 41 80 00       	mov    %eax,0x804148
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a70:	a1 54 41 80 00       	mov    0x804154,%eax
  802a75:	40                   	inc    %eax
  802a76:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802a7b:	e9 c9 03 00 00       	jmp    802e49 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	8b 50 0c             	mov    0xc(%eax),%edx
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	8b 40 08             	mov    0x8(%eax),%eax
  802a8c:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802a94:	39 c2                	cmp    %eax,%edx
  802a96:	0f 85 bb 00 00 00    	jne    802b57 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802a9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa0:	0f 84 b1 00 00 00    	je     802b57 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 40 04             	mov    0x4(%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	0f 85 a3 00 00 00    	jne    802b57 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ab4:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab9:	8b 55 08             	mov    0x8(%ebp),%edx
  802abc:	8b 52 08             	mov    0x8(%edx),%edx
  802abf:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802ac2:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802acd:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ad0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad3:	8b 52 0c             	mov    0xc(%edx),%edx
  802ad6:	01 ca                	add    %ecx,%edx
  802ad8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802aef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af3:	75 17                	jne    802b0c <insert_sorted_with_merge_freeList+0x498>
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	68 b4 38 80 00       	push   $0x8038b4
  802afd:	68 17 01 00 00       	push   $0x117
  802b02:	68 d7 38 80 00       	push   $0x8038d7
  802b07:	e8 40 03 00 00       	call   802e4c <_panic>
  802b0c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	89 10                	mov    %edx,(%eax)
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	85 c0                	test   %eax,%eax
  802b1e:	74 0d                	je     802b2d <insert_sorted_with_merge_freeList+0x4b9>
  802b20:	a1 48 41 80 00       	mov    0x804148,%eax
  802b25:	8b 55 08             	mov    0x8(%ebp),%edx
  802b28:	89 50 04             	mov    %edx,0x4(%eax)
  802b2b:	eb 08                	jmp    802b35 <insert_sorted_with_merge_freeList+0x4c1>
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	a3 48 41 80 00       	mov    %eax,0x804148
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b47:	a1 54 41 80 00       	mov    0x804154,%eax
  802b4c:	40                   	inc    %eax
  802b4d:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802b52:	e9 f2 02 00 00       	jmp    802e49 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	8b 50 08             	mov    0x8(%eax),%edx
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	8b 40 0c             	mov    0xc(%eax),%eax
  802b63:	01 c2                	add    %eax,%edx
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	8b 40 08             	mov    0x8(%eax),%eax
  802b6b:	39 c2                	cmp    %eax,%edx
  802b6d:	0f 85 be 00 00 00    	jne    802c31 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 40 04             	mov    0x4(%eax),%eax
  802b79:	8b 50 08             	mov    0x8(%eax),%edx
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 40 04             	mov    0x4(%eax),%eax
  802b82:	8b 40 0c             	mov    0xc(%eax),%eax
  802b85:	01 c2                	add    %eax,%edx
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	8b 40 08             	mov    0x8(%eax),%eax
  802b8d:	39 c2                	cmp    %eax,%edx
  802b8f:	0f 84 9c 00 00 00    	je     802c31 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	8b 50 08             	mov    0x8(%eax),%edx
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bad:	01 c2                	add    %eax,%edx
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802bc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bcd:	75 17                	jne    802be6 <insert_sorted_with_merge_freeList+0x572>
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	68 b4 38 80 00       	push   $0x8038b4
  802bd7:	68 26 01 00 00       	push   $0x126
  802bdc:	68 d7 38 80 00       	push   $0x8038d7
  802be1:	e8 66 02 00 00       	call   802e4c <_panic>
  802be6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	89 10                	mov    %edx,(%eax)
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	8b 00                	mov    (%eax),%eax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	74 0d                	je     802c07 <insert_sorted_with_merge_freeList+0x593>
  802bfa:	a1 48 41 80 00       	mov    0x804148,%eax
  802bff:	8b 55 08             	mov    0x8(%ebp),%edx
  802c02:	89 50 04             	mov    %edx,0x4(%eax)
  802c05:	eb 08                	jmp    802c0f <insert_sorted_with_merge_freeList+0x59b>
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	a3 48 41 80 00       	mov    %eax,0x804148
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c21:	a1 54 41 80 00       	mov    0x804154,%eax
  802c26:	40                   	inc    %eax
  802c27:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802c2c:	e9 18 02 00 00       	jmp    802e49 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 50 0c             	mov    0xc(%eax),%edx
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 40 08             	mov    0x8(%eax),%eax
  802c3d:	01 c2                	add    %eax,%edx
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	8b 40 08             	mov    0x8(%eax),%eax
  802c45:	39 c2                	cmp    %eax,%edx
  802c47:	0f 85 c4 01 00 00    	jne    802e11 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	8b 50 0c             	mov    0xc(%eax),%edx
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 40 08             	mov    0x8(%eax),%eax
  802c59:	01 c2                	add    %eax,%edx
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	8b 40 08             	mov    0x8(%eax),%eax
  802c63:	39 c2                	cmp    %eax,%edx
  802c65:	0f 85 a6 01 00 00    	jne    802e11 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6f:	0f 84 9c 01 00 00    	je     802e11 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 50 0c             	mov    0xc(%eax),%edx
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c81:	01 c2                	add    %eax,%edx
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 00                	mov    (%eax),%eax
  802c88:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8b:	01 c2                	add    %eax,%edx
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802ca7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cab:	75 17                	jne    802cc4 <insert_sorted_with_merge_freeList+0x650>
  802cad:	83 ec 04             	sub    $0x4,%esp
  802cb0:	68 b4 38 80 00       	push   $0x8038b4
  802cb5:	68 32 01 00 00       	push   $0x132
  802cba:	68 d7 38 80 00       	push   $0x8038d7
  802cbf:	e8 88 01 00 00       	call   802e4c <_panic>
  802cc4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccd:	89 10                	mov    %edx,(%eax)
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	74 0d                	je     802ce5 <insert_sorted_with_merge_freeList+0x671>
  802cd8:	a1 48 41 80 00       	mov    0x804148,%eax
  802cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce0:	89 50 04             	mov    %edx,0x4(%eax)
  802ce3:	eb 08                	jmp    802ced <insert_sorted_with_merge_freeList+0x679>
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	a3 48 41 80 00       	mov    %eax,0x804148
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cff:	a1 54 41 80 00       	mov    0x804154,%eax
  802d04:	40                   	inc    %eax
  802d05:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 00                	mov    (%eax),%eax
  802d0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802d2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d2e:	75 17                	jne    802d47 <insert_sorted_with_merge_freeList+0x6d3>
  802d30:	83 ec 04             	sub    $0x4,%esp
  802d33:	68 49 39 80 00       	push   $0x803949
  802d38:	68 36 01 00 00       	push   $0x136
  802d3d:	68 d7 38 80 00       	push   $0x8038d7
  802d42:	e8 05 01 00 00       	call   802e4c <_panic>
  802d47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4a:	8b 00                	mov    (%eax),%eax
  802d4c:	85 c0                	test   %eax,%eax
  802d4e:	74 10                	je     802d60 <insert_sorted_with_merge_freeList+0x6ec>
  802d50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d53:	8b 00                	mov    (%eax),%eax
  802d55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d58:	8b 52 04             	mov    0x4(%edx),%edx
  802d5b:	89 50 04             	mov    %edx,0x4(%eax)
  802d5e:	eb 0b                	jmp    802d6b <insert_sorted_with_merge_freeList+0x6f7>
  802d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6e:	8b 40 04             	mov    0x4(%eax),%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	74 0f                	je     802d84 <insert_sorted_with_merge_freeList+0x710>
  802d75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d78:	8b 40 04             	mov    0x4(%eax),%eax
  802d7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d7e:	8b 12                	mov    (%edx),%edx
  802d80:	89 10                	mov    %edx,(%eax)
  802d82:	eb 0a                	jmp    802d8e <insert_sorted_with_merge_freeList+0x71a>
  802d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d87:	8b 00                	mov    (%eax),%eax
  802d89:	a3 38 41 80 00       	mov    %eax,0x804138
  802d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da1:	a1 44 41 80 00       	mov    0x804144,%eax
  802da6:	48                   	dec    %eax
  802da7:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802dac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802db0:	75 17                	jne    802dc9 <insert_sorted_with_merge_freeList+0x755>
  802db2:	83 ec 04             	sub    $0x4,%esp
  802db5:	68 b4 38 80 00       	push   $0x8038b4
  802dba:	68 37 01 00 00       	push   $0x137
  802dbf:	68 d7 38 80 00       	push   $0x8038d7
  802dc4:	e8 83 00 00 00       	call   802e4c <_panic>
  802dc9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd2:	89 10                	mov    %edx,(%eax)
  802dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 0d                	je     802dea <insert_sorted_with_merge_freeList+0x776>
  802ddd:	a1 48 41 80 00       	mov    0x804148,%eax
  802de2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802de5:	89 50 04             	mov    %edx,0x4(%eax)
  802de8:	eb 08                	jmp    802df2 <insert_sorted_with_merge_freeList+0x77e>
  802dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ded:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802df2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df5:	a3 48 41 80 00       	mov    %eax,0x804148
  802dfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e04:	a1 54 41 80 00       	mov    0x804154,%eax
  802e09:	40                   	inc    %eax
  802e0a:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  802e0f:	eb 38                	jmp    802e49 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802e11:	a1 40 41 80 00       	mov    0x804140,%eax
  802e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1d:	74 07                	je     802e26 <insert_sorted_with_merge_freeList+0x7b2>
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	8b 00                	mov    (%eax),%eax
  802e24:	eb 05                	jmp    802e2b <insert_sorted_with_merge_freeList+0x7b7>
  802e26:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2b:	a3 40 41 80 00       	mov    %eax,0x804140
  802e30:	a1 40 41 80 00       	mov    0x804140,%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	0f 85 ef f9 ff ff    	jne    80282c <insert_sorted_with_merge_freeList+0x1b8>
  802e3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e41:	0f 85 e5 f9 ff ff    	jne    80282c <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  802e47:	eb 00                	jmp    802e49 <insert_sorted_with_merge_freeList+0x7d5>
  802e49:	90                   	nop
  802e4a:	c9                   	leave  
  802e4b:	c3                   	ret    

00802e4c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802e4c:	55                   	push   %ebp
  802e4d:	89 e5                	mov    %esp,%ebp
  802e4f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802e52:	8d 45 10             	lea    0x10(%ebp),%eax
  802e55:	83 c0 04             	add    $0x4,%eax
  802e58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802e5b:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802e60:	85 c0                	test   %eax,%eax
  802e62:	74 16                	je     802e7a <_panic+0x2e>
		cprintf("%s: ", argv0);
  802e64:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802e69:	83 ec 08             	sub    $0x8,%esp
  802e6c:	50                   	push   %eax
  802e6d:	68 9c 39 80 00       	push   $0x80399c
  802e72:	e8 d1 d4 ff ff       	call   800348 <cprintf>
  802e77:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802e7a:	a1 00 40 80 00       	mov    0x804000,%eax
  802e7f:	ff 75 0c             	pushl  0xc(%ebp)
  802e82:	ff 75 08             	pushl  0x8(%ebp)
  802e85:	50                   	push   %eax
  802e86:	68 a1 39 80 00       	push   $0x8039a1
  802e8b:	e8 b8 d4 ff ff       	call   800348 <cprintf>
  802e90:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802e93:	8b 45 10             	mov    0x10(%ebp),%eax
  802e96:	83 ec 08             	sub    $0x8,%esp
  802e99:	ff 75 f4             	pushl  -0xc(%ebp)
  802e9c:	50                   	push   %eax
  802e9d:	e8 3b d4 ff ff       	call   8002dd <vcprintf>
  802ea2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802ea5:	83 ec 08             	sub    $0x8,%esp
  802ea8:	6a 00                	push   $0x0
  802eaa:	68 bd 39 80 00       	push   $0x8039bd
  802eaf:	e8 29 d4 ff ff       	call   8002dd <vcprintf>
  802eb4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802eb7:	e8 aa d3 ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  802ebc:	eb fe                	jmp    802ebc <_panic+0x70>

00802ebe <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802ebe:	55                   	push   %ebp
  802ebf:	89 e5                	mov    %esp,%ebp
  802ec1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802ec4:	a1 20 40 80 00       	mov    0x804020,%eax
  802ec9:	8b 50 74             	mov    0x74(%eax),%edx
  802ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ecf:	39 c2                	cmp    %eax,%edx
  802ed1:	74 14                	je     802ee7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802ed3:	83 ec 04             	sub    $0x4,%esp
  802ed6:	68 c0 39 80 00       	push   $0x8039c0
  802edb:	6a 26                	push   $0x26
  802edd:	68 0c 3a 80 00       	push   $0x803a0c
  802ee2:	e8 65 ff ff ff       	call   802e4c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802ee7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802eee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802ef5:	e9 c2 00 00 00       	jmp    802fbc <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	01 d0                	add    %edx,%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	75 08                	jne    802f17 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802f0f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802f12:	e9 a2 00 00 00       	jmp    802fb9 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802f17:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802f25:	eb 69                	jmp    802f90 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802f27:	a1 20 40 80 00       	mov    0x804020,%eax
  802f2c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f35:	89 d0                	mov    %edx,%eax
  802f37:	01 c0                	add    %eax,%eax
  802f39:	01 d0                	add    %edx,%eax
  802f3b:	c1 e0 03             	shl    $0x3,%eax
  802f3e:	01 c8                	add    %ecx,%eax
  802f40:	8a 40 04             	mov    0x4(%eax),%al
  802f43:	84 c0                	test   %al,%al
  802f45:	75 46                	jne    802f8d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802f47:	a1 20 40 80 00       	mov    0x804020,%eax
  802f4c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f55:	89 d0                	mov    %edx,%eax
  802f57:	01 c0                	add    %eax,%eax
  802f59:	01 d0                	add    %edx,%eax
  802f5b:	c1 e0 03             	shl    $0x3,%eax
  802f5e:	01 c8                	add    %ecx,%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802f6d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f72:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	01 c8                	add    %ecx,%eax
  802f7e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802f80:	39 c2                	cmp    %eax,%edx
  802f82:	75 09                	jne    802f8d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802f84:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802f8b:	eb 12                	jmp    802f9f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f8d:	ff 45 e8             	incl   -0x18(%ebp)
  802f90:	a1 20 40 80 00       	mov    0x804020,%eax
  802f95:	8b 50 74             	mov    0x74(%eax),%edx
  802f98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9b:	39 c2                	cmp    %eax,%edx
  802f9d:	77 88                	ja     802f27 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802f9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fa3:	75 14                	jne    802fb9 <CheckWSWithoutLastIndex+0xfb>
			panic(
  802fa5:	83 ec 04             	sub    $0x4,%esp
  802fa8:	68 18 3a 80 00       	push   $0x803a18
  802fad:	6a 3a                	push   $0x3a
  802faf:	68 0c 3a 80 00       	push   $0x803a0c
  802fb4:	e8 93 fe ff ff       	call   802e4c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802fb9:	ff 45 f0             	incl   -0x10(%ebp)
  802fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fc2:	0f 8c 32 ff ff ff    	jl     802efa <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802fc8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fcf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802fd6:	eb 26                	jmp    802ffe <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802fd8:	a1 20 40 80 00       	mov    0x804020,%eax
  802fdd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802fe3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fe6:	89 d0                	mov    %edx,%eax
  802fe8:	01 c0                	add    %eax,%eax
  802fea:	01 d0                	add    %edx,%eax
  802fec:	c1 e0 03             	shl    $0x3,%eax
  802fef:	01 c8                	add    %ecx,%eax
  802ff1:	8a 40 04             	mov    0x4(%eax),%al
  802ff4:	3c 01                	cmp    $0x1,%al
  802ff6:	75 03                	jne    802ffb <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  802ff8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802ffb:	ff 45 e0             	incl   -0x20(%ebp)
  802ffe:	a1 20 40 80 00       	mov    0x804020,%eax
  803003:	8b 50 74             	mov    0x74(%eax),%edx
  803006:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803009:	39 c2                	cmp    %eax,%edx
  80300b:	77 cb                	ja     802fd8 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803013:	74 14                	je     803029 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803015:	83 ec 04             	sub    $0x4,%esp
  803018:	68 6c 3a 80 00       	push   $0x803a6c
  80301d:	6a 44                	push   $0x44
  80301f:	68 0c 3a 80 00       	push   $0x803a0c
  803024:	e8 23 fe ff ff       	call   802e4c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803029:	90                   	nop
  80302a:	c9                   	leave  
  80302b:	c3                   	ret    

0080302c <__udivdi3>:
  80302c:	55                   	push   %ebp
  80302d:	57                   	push   %edi
  80302e:	56                   	push   %esi
  80302f:	53                   	push   %ebx
  803030:	83 ec 1c             	sub    $0x1c,%esp
  803033:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803037:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80303b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80303f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803043:	89 ca                	mov    %ecx,%edx
  803045:	89 f8                	mov    %edi,%eax
  803047:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80304b:	85 f6                	test   %esi,%esi
  80304d:	75 2d                	jne    80307c <__udivdi3+0x50>
  80304f:	39 cf                	cmp    %ecx,%edi
  803051:	77 65                	ja     8030b8 <__udivdi3+0x8c>
  803053:	89 fd                	mov    %edi,%ebp
  803055:	85 ff                	test   %edi,%edi
  803057:	75 0b                	jne    803064 <__udivdi3+0x38>
  803059:	b8 01 00 00 00       	mov    $0x1,%eax
  80305e:	31 d2                	xor    %edx,%edx
  803060:	f7 f7                	div    %edi
  803062:	89 c5                	mov    %eax,%ebp
  803064:	31 d2                	xor    %edx,%edx
  803066:	89 c8                	mov    %ecx,%eax
  803068:	f7 f5                	div    %ebp
  80306a:	89 c1                	mov    %eax,%ecx
  80306c:	89 d8                	mov    %ebx,%eax
  80306e:	f7 f5                	div    %ebp
  803070:	89 cf                	mov    %ecx,%edi
  803072:	89 fa                	mov    %edi,%edx
  803074:	83 c4 1c             	add    $0x1c,%esp
  803077:	5b                   	pop    %ebx
  803078:	5e                   	pop    %esi
  803079:	5f                   	pop    %edi
  80307a:	5d                   	pop    %ebp
  80307b:	c3                   	ret    
  80307c:	39 ce                	cmp    %ecx,%esi
  80307e:	77 28                	ja     8030a8 <__udivdi3+0x7c>
  803080:	0f bd fe             	bsr    %esi,%edi
  803083:	83 f7 1f             	xor    $0x1f,%edi
  803086:	75 40                	jne    8030c8 <__udivdi3+0x9c>
  803088:	39 ce                	cmp    %ecx,%esi
  80308a:	72 0a                	jb     803096 <__udivdi3+0x6a>
  80308c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803090:	0f 87 9e 00 00 00    	ja     803134 <__udivdi3+0x108>
  803096:	b8 01 00 00 00       	mov    $0x1,%eax
  80309b:	89 fa                	mov    %edi,%edx
  80309d:	83 c4 1c             	add    $0x1c,%esp
  8030a0:	5b                   	pop    %ebx
  8030a1:	5e                   	pop    %esi
  8030a2:	5f                   	pop    %edi
  8030a3:	5d                   	pop    %ebp
  8030a4:	c3                   	ret    
  8030a5:	8d 76 00             	lea    0x0(%esi),%esi
  8030a8:	31 ff                	xor    %edi,%edi
  8030aa:	31 c0                	xor    %eax,%eax
  8030ac:	89 fa                	mov    %edi,%edx
  8030ae:	83 c4 1c             	add    $0x1c,%esp
  8030b1:	5b                   	pop    %ebx
  8030b2:	5e                   	pop    %esi
  8030b3:	5f                   	pop    %edi
  8030b4:	5d                   	pop    %ebp
  8030b5:	c3                   	ret    
  8030b6:	66 90                	xchg   %ax,%ax
  8030b8:	89 d8                	mov    %ebx,%eax
  8030ba:	f7 f7                	div    %edi
  8030bc:	31 ff                	xor    %edi,%edi
  8030be:	89 fa                	mov    %edi,%edx
  8030c0:	83 c4 1c             	add    $0x1c,%esp
  8030c3:	5b                   	pop    %ebx
  8030c4:	5e                   	pop    %esi
  8030c5:	5f                   	pop    %edi
  8030c6:	5d                   	pop    %ebp
  8030c7:	c3                   	ret    
  8030c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030cd:	89 eb                	mov    %ebp,%ebx
  8030cf:	29 fb                	sub    %edi,%ebx
  8030d1:	89 f9                	mov    %edi,%ecx
  8030d3:	d3 e6                	shl    %cl,%esi
  8030d5:	89 c5                	mov    %eax,%ebp
  8030d7:	88 d9                	mov    %bl,%cl
  8030d9:	d3 ed                	shr    %cl,%ebp
  8030db:	89 e9                	mov    %ebp,%ecx
  8030dd:	09 f1                	or     %esi,%ecx
  8030df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030e3:	89 f9                	mov    %edi,%ecx
  8030e5:	d3 e0                	shl    %cl,%eax
  8030e7:	89 c5                	mov    %eax,%ebp
  8030e9:	89 d6                	mov    %edx,%esi
  8030eb:	88 d9                	mov    %bl,%cl
  8030ed:	d3 ee                	shr    %cl,%esi
  8030ef:	89 f9                	mov    %edi,%ecx
  8030f1:	d3 e2                	shl    %cl,%edx
  8030f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030f7:	88 d9                	mov    %bl,%cl
  8030f9:	d3 e8                	shr    %cl,%eax
  8030fb:	09 c2                	or     %eax,%edx
  8030fd:	89 d0                	mov    %edx,%eax
  8030ff:	89 f2                	mov    %esi,%edx
  803101:	f7 74 24 0c          	divl   0xc(%esp)
  803105:	89 d6                	mov    %edx,%esi
  803107:	89 c3                	mov    %eax,%ebx
  803109:	f7 e5                	mul    %ebp
  80310b:	39 d6                	cmp    %edx,%esi
  80310d:	72 19                	jb     803128 <__udivdi3+0xfc>
  80310f:	74 0b                	je     80311c <__udivdi3+0xf0>
  803111:	89 d8                	mov    %ebx,%eax
  803113:	31 ff                	xor    %edi,%edi
  803115:	e9 58 ff ff ff       	jmp    803072 <__udivdi3+0x46>
  80311a:	66 90                	xchg   %ax,%ax
  80311c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803120:	89 f9                	mov    %edi,%ecx
  803122:	d3 e2                	shl    %cl,%edx
  803124:	39 c2                	cmp    %eax,%edx
  803126:	73 e9                	jae    803111 <__udivdi3+0xe5>
  803128:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80312b:	31 ff                	xor    %edi,%edi
  80312d:	e9 40 ff ff ff       	jmp    803072 <__udivdi3+0x46>
  803132:	66 90                	xchg   %ax,%ax
  803134:	31 c0                	xor    %eax,%eax
  803136:	e9 37 ff ff ff       	jmp    803072 <__udivdi3+0x46>
  80313b:	90                   	nop

0080313c <__umoddi3>:
  80313c:	55                   	push   %ebp
  80313d:	57                   	push   %edi
  80313e:	56                   	push   %esi
  80313f:	53                   	push   %ebx
  803140:	83 ec 1c             	sub    $0x1c,%esp
  803143:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803147:	8b 74 24 34          	mov    0x34(%esp),%esi
  80314b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80314f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803153:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803157:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80315b:	89 f3                	mov    %esi,%ebx
  80315d:	89 fa                	mov    %edi,%edx
  80315f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803163:	89 34 24             	mov    %esi,(%esp)
  803166:	85 c0                	test   %eax,%eax
  803168:	75 1a                	jne    803184 <__umoddi3+0x48>
  80316a:	39 f7                	cmp    %esi,%edi
  80316c:	0f 86 a2 00 00 00    	jbe    803214 <__umoddi3+0xd8>
  803172:	89 c8                	mov    %ecx,%eax
  803174:	89 f2                	mov    %esi,%edx
  803176:	f7 f7                	div    %edi
  803178:	89 d0                	mov    %edx,%eax
  80317a:	31 d2                	xor    %edx,%edx
  80317c:	83 c4 1c             	add    $0x1c,%esp
  80317f:	5b                   	pop    %ebx
  803180:	5e                   	pop    %esi
  803181:	5f                   	pop    %edi
  803182:	5d                   	pop    %ebp
  803183:	c3                   	ret    
  803184:	39 f0                	cmp    %esi,%eax
  803186:	0f 87 ac 00 00 00    	ja     803238 <__umoddi3+0xfc>
  80318c:	0f bd e8             	bsr    %eax,%ebp
  80318f:	83 f5 1f             	xor    $0x1f,%ebp
  803192:	0f 84 ac 00 00 00    	je     803244 <__umoddi3+0x108>
  803198:	bf 20 00 00 00       	mov    $0x20,%edi
  80319d:	29 ef                	sub    %ebp,%edi
  80319f:	89 fe                	mov    %edi,%esi
  8031a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031a5:	89 e9                	mov    %ebp,%ecx
  8031a7:	d3 e0                	shl    %cl,%eax
  8031a9:	89 d7                	mov    %edx,%edi
  8031ab:	89 f1                	mov    %esi,%ecx
  8031ad:	d3 ef                	shr    %cl,%edi
  8031af:	09 c7                	or     %eax,%edi
  8031b1:	89 e9                	mov    %ebp,%ecx
  8031b3:	d3 e2                	shl    %cl,%edx
  8031b5:	89 14 24             	mov    %edx,(%esp)
  8031b8:	89 d8                	mov    %ebx,%eax
  8031ba:	d3 e0                	shl    %cl,%eax
  8031bc:	89 c2                	mov    %eax,%edx
  8031be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031c2:	d3 e0                	shl    %cl,%eax
  8031c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031cc:	89 f1                	mov    %esi,%ecx
  8031ce:	d3 e8                	shr    %cl,%eax
  8031d0:	09 d0                	or     %edx,%eax
  8031d2:	d3 eb                	shr    %cl,%ebx
  8031d4:	89 da                	mov    %ebx,%edx
  8031d6:	f7 f7                	div    %edi
  8031d8:	89 d3                	mov    %edx,%ebx
  8031da:	f7 24 24             	mull   (%esp)
  8031dd:	89 c6                	mov    %eax,%esi
  8031df:	89 d1                	mov    %edx,%ecx
  8031e1:	39 d3                	cmp    %edx,%ebx
  8031e3:	0f 82 87 00 00 00    	jb     803270 <__umoddi3+0x134>
  8031e9:	0f 84 91 00 00 00    	je     803280 <__umoddi3+0x144>
  8031ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031f3:	29 f2                	sub    %esi,%edx
  8031f5:	19 cb                	sbb    %ecx,%ebx
  8031f7:	89 d8                	mov    %ebx,%eax
  8031f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031fd:	d3 e0                	shl    %cl,%eax
  8031ff:	89 e9                	mov    %ebp,%ecx
  803201:	d3 ea                	shr    %cl,%edx
  803203:	09 d0                	or     %edx,%eax
  803205:	89 e9                	mov    %ebp,%ecx
  803207:	d3 eb                	shr    %cl,%ebx
  803209:	89 da                	mov    %ebx,%edx
  80320b:	83 c4 1c             	add    $0x1c,%esp
  80320e:	5b                   	pop    %ebx
  80320f:	5e                   	pop    %esi
  803210:	5f                   	pop    %edi
  803211:	5d                   	pop    %ebp
  803212:	c3                   	ret    
  803213:	90                   	nop
  803214:	89 fd                	mov    %edi,%ebp
  803216:	85 ff                	test   %edi,%edi
  803218:	75 0b                	jne    803225 <__umoddi3+0xe9>
  80321a:	b8 01 00 00 00       	mov    $0x1,%eax
  80321f:	31 d2                	xor    %edx,%edx
  803221:	f7 f7                	div    %edi
  803223:	89 c5                	mov    %eax,%ebp
  803225:	89 f0                	mov    %esi,%eax
  803227:	31 d2                	xor    %edx,%edx
  803229:	f7 f5                	div    %ebp
  80322b:	89 c8                	mov    %ecx,%eax
  80322d:	f7 f5                	div    %ebp
  80322f:	89 d0                	mov    %edx,%eax
  803231:	e9 44 ff ff ff       	jmp    80317a <__umoddi3+0x3e>
  803236:	66 90                	xchg   %ax,%ax
  803238:	89 c8                	mov    %ecx,%eax
  80323a:	89 f2                	mov    %esi,%edx
  80323c:	83 c4 1c             	add    $0x1c,%esp
  80323f:	5b                   	pop    %ebx
  803240:	5e                   	pop    %esi
  803241:	5f                   	pop    %edi
  803242:	5d                   	pop    %ebp
  803243:	c3                   	ret    
  803244:	3b 04 24             	cmp    (%esp),%eax
  803247:	72 06                	jb     80324f <__umoddi3+0x113>
  803249:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80324d:	77 0f                	ja     80325e <__umoddi3+0x122>
  80324f:	89 f2                	mov    %esi,%edx
  803251:	29 f9                	sub    %edi,%ecx
  803253:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803257:	89 14 24             	mov    %edx,(%esp)
  80325a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80325e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803262:	8b 14 24             	mov    (%esp),%edx
  803265:	83 c4 1c             	add    $0x1c,%esp
  803268:	5b                   	pop    %ebx
  803269:	5e                   	pop    %esi
  80326a:	5f                   	pop    %edi
  80326b:	5d                   	pop    %ebp
  80326c:	c3                   	ret    
  80326d:	8d 76 00             	lea    0x0(%esi),%esi
  803270:	2b 04 24             	sub    (%esp),%eax
  803273:	19 fa                	sbb    %edi,%edx
  803275:	89 d1                	mov    %edx,%ecx
  803277:	89 c6                	mov    %eax,%esi
  803279:	e9 71 ff ff ff       	jmp    8031ef <__umoddi3+0xb3>
  80327e:	66 90                	xchg   %ax,%ax
  803280:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803284:	72 ea                	jb     803270 <__umoddi3+0x134>
  803286:	89 d9                	mov    %ebx,%ecx
  803288:	e9 62 ff ff ff       	jmp    8031ef <__umoddi3+0xb3>
