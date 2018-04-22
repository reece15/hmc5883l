	.module AVR_GY-27.c
	.area text(rom, con, rel)
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-27\AVR_GY-27.c
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-27\delay.h
	.dbfunc e delay_1us _delay_1us fV
	.even
_delay_1us::
	.dbline -1
	.dbline 15
; /*-----------------------------------------------------------------------
; 延时函数
; 编译器：ICC-AVR v6.31A 
; 目标芯片 : M16
; 时钟: 8.0000Mhz
; -----------------------------------------------------------------------*/
; #ifndef __delay_h
; #define __delay_h
; void delay_nus(unsigned int n);
; void delay_nms(unsigned int n);
; void delay_1us(void);
; void delay_1ms(void) ; 
; 
; void delay_1us(void)                 //1us延时函数
;   {
	.dbline 16
;    asm("nop");
	nop
	.dbline 17
;    asm("nop");
	nop
	.dbline 18
;    asm("nop");
	nop
	.dbline 19
;    asm("nop");
	nop
	.dbline 20
;    asm("nop");
	nop
	.dbline -2
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e delay_nus _delay_nus fV
;              i -> R20,R21
;              n -> R10,R11
	.even
_delay_nus::
	xcall push_xgset300C
	movw R10,R16
	.dbline -1
	.dbline 24
;   }
; 
; void delay_nus(unsigned int n)       //N us延时函数
;   {
	.dbline 25
;    unsigned int i=0;
	clr R20
	clr R21
	.dbline 26
;    for (i=0;i<n;i++)
	xjmp L6
L3:
	.dbline 27
;    delay_1us();
	xcall _delay_1us
L4:
	.dbline 26
	subi R20,255  ; offset = 1
	sbci R21,255
L6:
	.dbline 26
	cp R20,R10
	cpc R21,R11
	brlo L3
X0:
	.dbline -2
L2:
	.dbline 0 ; func end
	xjmp pop_xgset300C
	.dbsym r i 20 i
	.dbsym r n 10 i
	.dbend
	.dbfunc e delay_1ms _delay_1ms fV
;              i -> R16,R17
	.even
_delay_1ms::
	.dbline -1
	.dbline 31
;   }
;   
; void delay_1ms(void)                 //1ms延时函数
;   {
	.dbline 33
;    unsigned int i;
;    for (i=0;i<500;i++);
	clr R16
	clr R17
	xjmp L11
L8:
	.dbline 33
L9:
	.dbline 33
	subi R16,255  ; offset = 1
	sbci R17,255
L11:
	.dbline 33
	cpi R16,244
	ldi R30,1
	cpc R17,R30
	brlo L8
X1:
	.dbline -2
L7:
	.dbline 0 ; func end
	ret
	.dbsym r i 16 i
	.dbend
	.dbfunc e delay_nms _delay_nms fV
;              i -> R20,R21
;              n -> R10,R11
	.even
_delay_nms::
	xcall push_xgset300C
	movw R10,R16
	.dbline -1
	.dbline 37
;   }
;   
; void delay_nms(unsigned int n)       //N ms延时函数
;   {
	.dbline 38
;    unsigned int i=0;
	clr R20
	clr R21
	.dbline 39
;    for (i=0;i<n;i++)
	xjmp L16
L13:
	.dbline 40
;    delay_1ms();
	xcall _delay_1ms
L14:
	.dbline 39
	subi R20,255  ; offset = 1
	sbci R21,255
L16:
	.dbline 39
	cp R20,R10
	cpc R21,R11
	brlo L13
X2:
	.dbline -2
L12:
	.dbline 0 ; func end
	xjmp pop_xgset300C
	.dbsym r i 20 i
	.dbsym r n 10 i
	.dbend
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-27\I2C.h
	.dbfunc e I2C_Write _I2C_Write fc
;          Wdata -> R10
;     RegAddress -> R12
	.even
_I2C_Write::
	st -y,R10
	st -y,R12
	mov R10,R18
	mov R12,R16
	.dbline -1
	.dbline 41
; #include <macros.h>
; #include "delay.h"
; 
; //使用AVR内部硬件iic，引脚定义
; //PC0->SCL  ;  PC1->SDA
; //I2C 状态定义
; //MT 主方式传输 MR 主方式接受
; #define START			0x08
; #define RE_START		0x10
; #define MT_SLA_ACK		0x18
; #define MT_SLA_NOACK 	0x20
; #define MT_DATA_ACK		0x28
; #define MT_DATA_NOACK	0x30
; #define MR_SLA_ACK		0x40
; #define MR_SLA_NOACK	0x48
; #define MR_DATA_ACK		0x50
; #define MR_DATA_NOACK	0x58	
; 	                            
; #define RD_DEVICE_ADDR  0x3D	   
; #define WD_DEVICE_ADDR  0x3C	   
; 
; //常用TWI操作(主模式写和读)
; #define Start()			(TWCR=(1<<TWINT)|(1<<TWSTA)|(1<<TWEN))		//启动I2C
; #define Stop()			(TWCR=(1<<TWINT)|(1<<TWSTO)|(1<<TWEN))		//停止I2C
; #define Wait()			{while(!(TWCR&(1<<TWINT)));}				//等待中断发生
; #define TestAck()		(TWSR&0xf8)									//观察返回状态
; #define SetAck			(TWCR|=(1<<TWEA))							//做出ACK应答
; #define SetNoAck		(TWCR&=~(1<<TWEA))							//做出Not Ack应答
; #define Twi()			(TWCR=(1<<TWINT)|(1<<TWEN))				    //启动I2C
; #define Write8Bit(x)	{TWDR=(x);TWCR=(1<<TWINT)|(1<<TWEN);}		//写数据到TWDR
; 
; unsigned char I2C_Write(unsigned char RegAddress,unsigned char Wdata);
; unsigned char I2C_Read(unsigned RegAddress);
; 
; /*********************************************
; I2C总线写一个字节
; 返回0:写成功
; 返回1:写失败
; **********************************************/
; unsigned char I2C_Write(unsigned char RegAddress,unsigned char Wdata)
; {
	.dbline 42
; 	  Start();						//I2C启动
	ldi R24,164
	out 0x36,R24
	.dbline 43
; 	  Wait();
L18:
	.dbline 43
L19:
	.dbline 43
	in R2,0x36
	sbrs R2,7
	rjmp L18
X3:
	.dbline 43
	.dbline 43
	.dbline 44
; 	  if(TestAck()!=START) 
	in R24,0x1
	andi R24,248
	cpi R24,8
	breq L21
X4:
	.dbline 45
; 		return 1;					//ACK
	ldi R16,1
	xjmp L17
L21:
	.dbline 47
; 	  
; 	  Write8Bit(WD_DEVICE_ADDR);	//写I2C从器件地址和写方式
	.dbline 47
	ldi R24,60
	out 0x3,R24
	.dbline 47
	ldi R24,132
	out 0x36,R24
	.dbline 47
	.dbline 47
	.dbline 48
; 	  Wait();
L23:
	.dbline 48
L24:
	.dbline 48
	in R2,0x36
	sbrs R2,7
	rjmp L23
X5:
	.dbline 48
	.dbline 48
	.dbline 49
; 	  if(TestAck()!=MT_SLA_ACK) 
	in R24,0x1
	andi R24,248
	cpi R24,24
	breq L26
X6:
	.dbline 50
; 		return 1;					//ACK
	ldi R16,1
	xjmp L17
L26:
	.dbline 52
; 	  
; 	  Write8Bit(RegAddress);		//写器件相应寄存器地址
	.dbline 52
	out 0x3,R12
	.dbline 52
	ldi R24,132
	out 0x36,R24
	.dbline 52
	.dbline 52
	.dbline 53
; 	  Wait();
L28:
	.dbline 53
L29:
	.dbline 53
	in R2,0x36
	sbrs R2,7
	rjmp L28
X7:
	.dbline 53
	.dbline 53
	.dbline 54
; 	  if(TestAck()!=MT_DATA_ACK) 
	in R24,0x1
	andi R24,248
	cpi R24,40
	breq L31
X8:
	.dbline 55
; 	  	return 1;				    //ACK
	ldi R16,1
	xjmp L17
L31:
	.dbline 57
; 	  
; 	  Write8Bit(Wdata);			 	//写数据到器件相应寄存器
	.dbline 57
	out 0x3,R10
	.dbline 57
	ldi R24,132
	out 0x36,R24
	.dbline 57
	.dbline 57
	.dbline 58
; 	  Wait();
L33:
	.dbline 58
L34:
	.dbline 58
	in R2,0x36
	sbrs R2,7
	rjmp L33
X9:
	.dbline 58
	.dbline 58
	.dbline 59
; 	  if(TestAck()!=MT_DATA_ACK) 
	in R24,0x1
	andi R24,248
	cpi R24,40
	breq L36
X10:
	.dbline 60
; 	  	return 1;				    //ACK	 
	ldi R16,1
	xjmp L17
L36:
	.dbline 61
; 	  Stop();  						//I2C停止
	ldi R24,148
	out 0x36,R24
	.dbline 62
;  	delay_nms(10);				//延时  
	ldi R16,10
	ldi R17,0
	xcall _delay_nms
	.dbline 63
; 	  return 0;
	clr R16
	.dbline -2
L17:
	.dbline 0 ; func end
	ld R12,y+
	ld R10,y+
	ret
	.dbsym r Wdata 10 c
	.dbsym r RegAddress 12 c
	.dbend
	.dbfunc e I2C_Read _I2C_Read fc
;           temp -> R10
;     RegAddress -> R16,R17
	.even
_I2C_Read::
	st -y,R10
	.dbline -1
	.dbline 74
; }
; 
; /*********************************************
; I2C总线读一个字节
; 返回0:读成功
; 返回1:读失败
; **********************************************/
; 
; unsigned char I2C_Read(unsigned RegAddress)
; 
;  {
	.dbline 77
; 	 unsigned  char  temp;
; 
; 	   Start();//I2C启动
	ldi R24,164
	out 0x36,R24
	.dbline 78
; 	   Wait();
L39:
	.dbline 78
L40:
	.dbline 78
	in R2,0x36
	sbrs R2,7
	rjmp L39
X11:
	.dbline 78
	.dbline 78
	.dbline 79
; 	   if (TestAck()!=START) 
	in R24,0x1
	andi R24,248
	cpi R24,8
	breq L42
X12:
	.dbline 80
; 	   	  return 1;			 		//ACK	   
	ldi R16,1
	xjmp L38
L42:
	.dbline 82
; 	   
; 	   Write8Bit(WD_DEVICE_ADDR);	//写I2C从器件地址和写方式
	.dbline 82
	ldi R24,60
	out 0x3,R24
	.dbline 82
	ldi R24,132
	out 0x36,R24
	.dbline 82
	.dbline 82
	.dbline 83
; 	   Wait(); 
L44:
	.dbline 83
L45:
	.dbline 83
	in R2,0x36
	sbrs R2,7
	rjmp L44
X13:
	.dbline 83
	.dbline 83
	.dbline 84
; 	   if (TestAck()!=MT_SLA_ACK) 
	in R24,0x1
	andi R24,248
	cpi R24,24
	breq L47
X14:
	.dbline 85
; 	   	  return 1;				    //ACK
	ldi R16,1
	xjmp L38
L47:
	.dbline 87
; 	   
; 	   Write8Bit(RegAddress);		//写器件相应寄存器地址
	.dbline 87
	out 0x3,R16
	.dbline 87
	ldi R24,132
	out 0x36,R24
	.dbline 87
	.dbline 87
	.dbline 88
; 	   Wait();
L49:
	.dbline 88
L50:
	.dbline 88
	in R2,0x36
	sbrs R2,7
	rjmp L49
X15:
	.dbline 88
	.dbline 88
	.dbline 89
; 	   if (TestAck()!=MT_DATA_ACK) 
	in R24,0x1
	andi R24,248
	cpi R24,40
	breq L52
X16:
	.dbline 90
; 	   	  return 1;
	ldi R16,1
	xjmp L38
L52:
	.dbline 92
; 
; 	    Start();	   				   	//I2C重新启动
	ldi R24,164
	out 0x36,R24
	.dbline 93
; 	   Wait();
L54:
	.dbline 93
L55:
	.dbline 93
	in R2,0x36
	sbrs R2,7
	rjmp L54
X17:
	.dbline 93
	.dbline 93
	.dbline 94
; 	   if (TestAck()!=RE_START)  
	in R24,0x1
	andi R24,248
	cpi R24,16
	breq L57
X18:
	.dbline 95
; 	   	return 1;
	ldi R16,1
	xjmp L38
L57:
	.dbline 96
; 	   Write8Bit(RD_DEVICE_ADDR);	//写I2C从器件地址和读方式
	.dbline 96
	ldi R24,61
	out 0x3,R24
	.dbline 96
	ldi R24,132
	out 0x36,R24
	.dbline 96
	.dbline 96
	.dbline 97
; 	   Wait();
L59:
	.dbline 97
L60:
	.dbline 97
	in R2,0x36
	sbrs R2,7
	rjmp L59
X19:
	.dbline 97
	.dbline 97
	.dbline 98
; 	   if(TestAck()!=MR_SLA_ACK)  
	in R24,0x1
	andi R24,248
	cpi R24,64
	breq L62
X20:
	.dbline 99
; 	   	  return 1;				   //ACK
	ldi R16,1
	xjmp L38
L62:
	.dbline 101
; 	   
; 	   Twi();	 				   //启动主I2C读方式
	ldi R24,132
	out 0x36,R24
	.dbline 102
; 	   Wait();
L64:
	.dbline 102
L65:
	.dbline 102
	in R2,0x36
	sbrs R2,7
	rjmp L64
X21:
	.dbline 102
	.dbline 102
	.dbline 103
; 	   if(TestAck()!=MR_DATA_NOACK) 
	in R24,0x1
	andi R24,248
	cpi R24,88
	breq L67
X22:
	.dbline 104
; 	   	 return 1;					//ACK	
	ldi R16,1
	xjmp L38
L67:
	.dbline 106
; 	   
; 	   temp=TWDR;//读取I2C接收数据
	in R10,0x3
	.dbline 107
;        Stop();//I2C停止
	ldi R24,148
	out 0x36,R24
	.dbline 108
; 	   return temp;
	mov R16,R10
	.dbline -2
L38:
	.dbline 0 ; func end
	ld R10,y+
	ret
	.dbsym r temp 10 c
	.dbsym r RegAddress 16 i
	.dbend
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-27\1602.h
	.dbfunc e LCD_init _LCD_init fV
	.even
_LCD_init::
	.dbline -1
	.dbline 44
; /* 用法：
;    LCD_init();
;    LCD_write_string(列,行,"字符串");
;    LCD_write_char(列,行,'字符'); 
;  ---------------------------------------------------------------
; 下面是AVR与LCD连接信息
;   PC6 ->RS
;   PC7 ->EN
;   地  ->RW
;   PA4 ->D4
;   PA5 ->D5
;   PA6 ->D6
;   PA7 ->D7
; 使用端口：1602:PC6,PC7,PA4~PA7 	
; 要使用本驱动，改变下面配置信息即可
; -----------------------------------------------------------------*/
; #define LCD_EN_PORT    PORTC   //以下2个要设为同一个口
; #define LCD_EN_DDR     DDRC
; #define LCD_RS_PORT    PORTC   //以下2个要设为同一个口
; #define LCD_RS_DDR     DDRC
; #define LCD_DATA_PORT  PORTA   //以下3个要设为同一个口
; #define LCD_DATA_DDR   DDRA    //默认情况下连线必须使用高四位端口,如果不是请注意修改
; #define LCD_DATA_PIN   PINA
; #define LCD_RS         (1<<PC6) //0x20   portC6       out
; #define LCD_EN         (1<<PC7) //0x40   portC7       out
; #define LCD_DATA       ((1<<PA4)|(1<<PA5)|(1<<PA6)|(1<<PA7)) //0xf0   portA 4/5/6/7 out
; /*--------------------------------------------------------------------------------------------------
; 函数说明
; --------------------------------------------------------------------------------------------------*/
; void LCD_init(void);
; void LCD_en_write(void);
; void LCD_write_command(unsigned  char command) ;
; void LCD_write_data(unsigned char data);
; void LCD_set_xy (unsigned char x, unsigned char y);
; void LCD_write_string(unsigned char X,unsigned char Y,unsigned char *s);
; void LCD_write_char(unsigned char X,unsigned char Y,unsigned char data);
; 
; //-----------------------------------------------------------------------------------------
; 
; #include <macros.h>
; #include "delay.h"
; 
; void LCD_init(void)         //液晶初始化
; {
	.dbline 45
;   LCD_DATA_DDR|=LCD_DATA;   //数据口方向为输出
	in R24,0x1a
	ori R24,240
	out 0x1a,R24
	.dbline 46
;   LCD_EN_DDR|=LCD_EN;       //设置EN方向为输出
	sbi 0x14,7
	.dbline 47
;   LCD_RS_DDR|=LCD_RS;       //设置RS方向为输出
	sbi 0x14,6
	.dbline 48
;   LCD_write_command(0x28); 
	ldi R16,40
	xcall _LCD_write_command
	.dbline 49
;   LCD_en_write();
	xcall _LCD_en_write
	.dbline 50
;   delay_nus(40);
	ldi R16,40
	ldi R17,0
	xcall _delay_nus
	.dbline 51
;   LCD_write_command(0x28);  //4位显示
	ldi R16,40
	xcall _LCD_write_command
	.dbline 52
;   LCD_write_command(0x0c);  //显示开
	ldi R16,12
	xcall _LCD_write_command
	.dbline 53
;   LCD_write_command(0x01);  //清屏
	ldi R16,1
	xcall _LCD_write_command
	.dbline 54
;   delay_nms(10);
	ldi R16,10
	ldi R17,0
	xcall _delay_nms
	.dbline -2
L69:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e LCD_en_write _LCD_en_write fV
	.even
_LCD_en_write::
	.dbline -1
	.dbline 58
; }
; 
; void LCD_en_write(void)  //液晶使能
; {
	.dbline 59
;   LCD_EN_PORT|=LCD_EN;
	sbi 0x15,7
	.dbline 60
;   delay_nus(1);
	ldi R16,1
	ldi R17,0
	xcall _delay_nus
	.dbline 61
;   LCD_EN_PORT&=~LCD_EN;
	cbi 0x15,7
	.dbline -2
L70:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e LCD_write_command _LCD_write_command fV
;        command -> R20
	.even
_LCD_write_command::
	st -y,R20
	mov R20,R16
	.dbline -1
	.dbline 65
; }
; 
; void LCD_write_command(unsigned char command) //写指令
; {
	.dbline 67
;   //连线为高4位的写法
;   delay_nus(16);
	ldi R16,16
	ldi R17,0
	xcall _delay_nus
	.dbline 68
;   LCD_RS_PORT&=~LCD_RS;        //RS=0
	cbi 0x15,6
	.dbline 69
;   LCD_DATA_PORT&=0X0f;         //清高四位
	in R24,0x1b
	andi R24,15
	out 0x1b,R24
	.dbline 70
;   LCD_DATA_PORT|=command&0xf0; //写高四位
	mov R24,R20
	andi R24,240
	in R2,0x1b
	or R2,R24
	out 0x1b,R2
	.dbline 71
;   LCD_en_write();
	xcall _LCD_en_write
	.dbline 72
;   command=command<<4;          //低四位移到高四位
	mov R24,R20
	andi R24,#0x0F
	swap R24
	mov R20,R24
	.dbline 73
;   LCD_DATA_PORT&=0x0f;         //清高四位
	in R24,0x1b
	andi R24,15
	out 0x1b,R24
	.dbline 74
;   LCD_DATA_PORT|=command&0xf0; //写低四位
	mov R24,R20
	andi R24,240
	in R2,0x1b
	or R2,R24
	out 0x1b,R2
	.dbline 75
;   LCD_en_write();
	xcall _LCD_en_write
	.dbline -2
L71:
	.dbline 0 ; func end
	ld R20,y+
	ret
	.dbsym r command 20 c
	.dbend
	.dbfunc e LCD_write_data _LCD_write_data fV
;           data -> R20
	.even
_LCD_write_data::
	st -y,R20
	mov R20,R16
	.dbline -1
	.dbline 92
;  
; /*
;   //连线为低四位的写法
;   delay_nus(16);
;   LCD_RS_PORT&=~LCD_RS;        //RS=0
;   LCD_DATA_PORT&=0xf0;         //清高四位
;   LCD_DATA_PORT|=(command>>4)&0x0f; //写高四位
;   LCD_en_write();
;   LCD_DATA_PORT&=0xf0;         //清高四位
;   LCD_DATA_PORT|=command&0x0f; //写低四位
;   LCD_en_write(); 
; */
;   
; }
; 
; void LCD_write_data(unsigned char data) //写数据
; {
	.dbline 94
;   //连线为高4位的写法
;   delay_nus(16);
	ldi R16,16
	ldi R17,0
	xcall _delay_nus
	.dbline 95
;   LCD_RS_PORT|=LCD_RS;       //RS=1
	sbi 0x15,6
	.dbline 96
;   LCD_DATA_PORT&=0X0f;       //清高四位
	in R24,0x1b
	andi R24,15
	out 0x1b,R24
	.dbline 97
;   LCD_DATA_PORT|=data&0xf0;  //写高四位
	mov R24,R20
	andi R24,240
	in R2,0x1b
	or R2,R24
	out 0x1b,R2
	.dbline 98
;   LCD_en_write();
	xcall _LCD_en_write
	.dbline 99
;   data=data<<4;               //低四位移到高四位
	mov R24,R20
	andi R24,#0x0F
	swap R24
	mov R20,R24
	.dbline 100
;   LCD_DATA_PORT&=0X0f;        //清高四位
	in R24,0x1b
	andi R24,15
	out 0x1b,R24
	.dbline 101
;   LCD_DATA_PORT|=data&0xf0;   //写低四位
	mov R24,R20
	andi R24,240
	in R2,0x1b
	or R2,R24
	out 0x1b,R2
	.dbline 102
;   LCD_en_write();
	xcall _LCD_en_write
	.dbline -2
L72:
	.dbline 0 ; func end
	ld R20,y+
	ret
	.dbsym r data 20 c
	.dbend
	.dbfunc e LCD_set_xy _LCD_set_xy fV
;        address -> R20
;              y -> R10
;              x -> R22
	.even
_LCD_set_xy::
	xcall push_xgsetF00C
	mov R10,R18
	mov R22,R16
	.dbline -1
	.dbline 121
;   
; /*
;   //连线为低四位的写法 
;   delay_nus(16);
;   LCD_RS_PORT|=LCD_RS;       //RS=1
;   LCD_DATA_PORT&=0Xf0;       //清高四位
;   LCD_DATA_PORT|=(data>>4)&0x0f;  //写高四位
;   LCD_en_write();
;  
;   LCD_DATA_PORT&=0Xf0;        //清高四位
;   LCD_DATA_PORT|=data&0x0f;   //写低四位
;   LCD_en_write();
; */
;   
; }
; 
; 
; void LCD_set_xy( unsigned char x, unsigned char y )  //写地址函数
; {
	.dbline 123
;     unsigned char address;
;     if (y == 0) address = 0x80 + x;
	tst R10
	brne L74
X23:
	.dbline 123
	mov R20,R22
	subi R20,128    ; addi 128
	xjmp L75
L74:
	.dbline 124
;     else   address = 0xc0 + x;
	mov R20,R22
	subi R20,64    ; addi 192
L75:
	.dbline 125
;     LCD_write_command( address);
	mov R16,R20
	xcall _LCD_write_command
	.dbline -2
L73:
	.dbline 0 ; func end
	xjmp pop_xgsetF00C
	.dbsym r address 20 c
	.dbsym r y 10 c
	.dbsym r x 22 c
	.dbend
	.dbfunc e LCD_write_string _LCD_write_string fV
;              s -> R20,R21
;              Y -> R12
;              X -> R10
	.even
_LCD_write_string::
	xcall push_xgset303C
	mov R12,R18
	mov R10,R16
	ldd R20,y+6
	ldd R21,y+7
	.dbline -1
	.dbline 129
; }
;   
; void LCD_write_string(unsigned char X,unsigned char Y,unsigned char *s) //列x=0~15,行y=0,1
; {
	.dbline 130
;     LCD_set_xy( X, Y ); //写地址    
	mov R18,R12
	mov R16,R10
	xcall _LCD_set_xy
	xjmp L78
L77:
	.dbline 132
;     while (*s)  // 写显示字符
;     {
	.dbline 133
;       LCD_write_data( *s );
	movw R30,R20
	ldd R16,z+0
	xcall _LCD_write_data
	.dbline 134
;       s ++;
	subi R20,255  ; offset = 1
	sbci R21,255
	.dbline 135
;     }
L78:
	.dbline 131
	movw R30,R20
	ldd R2,z+0
	tst R2
	brne L77
X24:
	.dbline -2
L76:
	.dbline 0 ; func end
	xjmp pop_xgset303C
	.dbsym r s 20 pc
	.dbsym r Y 12 c
	.dbsym r X 10 c
	.dbend
	.dbfunc e LCD_write_char _LCD_write_char fV
;           data -> y+2
;              Y -> R12
;              X -> R10
	.even
_LCD_write_char::
	st -y,R10
	st -y,R12
	mov R12,R18
	mov R10,R16
	.dbline -1
	.dbline 140
;       
; }
; 
; void LCD_write_char(unsigned char X,unsigned char Y,unsigned char data) //列x=0~15,行y=0,1
; {
	.dbline 141
;   LCD_set_xy( X, Y ); //写地址
	mov R18,R12
	mov R16,R10
	xcall _LCD_set_xy
	.dbline 142
;   LCD_write_data( data);
	ldd R16,y+2
	xcall _LCD_write_data
	.dbline -2
L80:
	.dbline 0 ; func end
	ld R12,y+
	ld R10,y+
	ret
	.dbsym l data 2 c
	.dbsym r Y 12 c
	.dbsym r X 10 c
	.dbend
	.area data(ram, con, rel)
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-27\1602.h
_display::
	.blkb 2
	.area idata
	.byte 0,0
	.area data(ram, con, rel)
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-27\1602.h
	.blkb 2
	.area idata
	.byte 0,0
	.area data(ram, con, rel)
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-27\1602.h
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-27\1602.h
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-27\AVR_GY-27.c
	.dbsym e display _display A[5:5]c
	.area text(rom, con, rel)
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-27\AVR_GY-27.c
	.dbfunc e conversion _conversion fV
;              i -> R20,R21
	.even
_conversion::
	st -y,R20
	st -y,R21
	movw R20,R16
	.dbline -1
	.dbline 28
; /*****************************************
; * 基于AVR单片机GY-27模块通信程序 		 *
; * HMC5883L+ADXL345 通信程序              *
; * 功    能：IIC通信读取数据并显示        *
; * 时钟频率：内部1M 						 *
; * 设    计：广运电子					 *
; * 修改日期：2011年4月20日				 *
; * 编译环境：ICC-AVR7.14					 *
; * 实验环境：ATmega16+1602    			 *
; * 使用端口：PC0,PC1,PC6,PC7,PA4~PA7 	 *
; * 参    考：莫锦攀实验程序24c02读取实验  *
; *****************************************/
; #include <iom16v.h>
; #include "I2C.h"
; #include "1602.h"
; #include "delay.h"
; #include  "math.h"  
; #include  "stdio.h"  
; void conversion(unsigned int i);
; unsigned char display[5]={0,0,0,0,0};//显示数据
; 
; /*********************************************
; 数据转换,十六进制数据转换成10进制
; 输入十六进制范围：0x0000-0x270f（0-9999）
; 结果分成个十百千位，以ascii存入显示区
; **********************************************/
; void conversion(unsigned int i)  
; {  
	.dbline 29
;  	display[0]=i/10000+0x30 ;
	ldi R18,10000
	ldi R19,39
	movw R16,R20
	xcall div16u
	movw R24,R16
	adiw R24,48
	sts _display,R24
	.dbline 30
;     i=i%10000;    //取余运算
	ldi R18,10000
	ldi R19,39
	movw R16,R20
	xcall mod16u
	movw R20,R16
	.dbline 31
; 	display[1]=i/1000+0x30 ;
	ldi R18,1000
	ldi R19,3
	xcall div16u
	movw R24,R16
	adiw R24,48
	sts _display+1,R24
	.dbline 32
;     i=i%1000;    //取余运算
	ldi R18,1000
	ldi R19,3
	movw R16,R20
	xcall mod16u
	movw R20,R16
	.dbline 33
;     display[2]=i/100+0x30 ;
	ldi R18,100
	ldi R19,0
	xcall div16u
	movw R24,R16
	adiw R24,48
	sts _display+2,R24
	.dbline 34
;     i=i%100;    //取余运算
	ldi R18,100
	ldi R19,0
	movw R16,R20
	xcall mod16u
	movw R20,R16
	.dbline 35
;     display[3]=i/10+0x30 ;
	ldi R18,10
	ldi R19,0
	xcall div16u
	movw R24,R16
	adiw R24,48
	sts _display+3,R24
	.dbline 36
;    i=i%10;     //取余运算
	ldi R18,10
	ldi R19,0
	movw R16,R20
	xcall mod16u
	movw R20,R16
	.dbline 37
;     display[4]=i+0x30;  
	movw R24,R20
	adiw R24,48
	sts _display+4,R24
	.dbline -2
L81:
	.dbline 0 ; func end
	ld R21,y+
	ld R20,y+
	ret
	.dbsym r i 20 i
	.dbend
	.dbfunc e display_angle _display_angle fV
;           temp -> y+8
;          angle -> y+4
;              y -> R10,R11
;              x -> R12,R13
	.even
_display_angle::
	xcall push_xgset00FC
	sbiw R28,12
	.dbline -1
	.dbline 42
; }
; //*******************************
; //显示角度
; void display_angle(void)
; {   float temp;
	.dbline 46
;       int x,y;
; 	 double angle;
; 
;      x=I2C_Read(0x03);
	ldi R16,3
	ldi R17,0
	xcall _I2C_Read
	mov R12,R16
	clr R13
	.dbline 47
;      x=(x<<8)+I2C_Read(0x04);
	ldi R16,4
	ldi R17,0
	xcall _I2C_Read
	mov R13,R12
	mov R12,R16
	.dbline 49
; 	 
; 	 y=I2C_Read(0x07);
	ldi R16,7
	ldi R17,0
	xcall _I2C_Read
	mov R10,R16
	clr R11
	.dbline 50
;      y=(y<<8)+I2C_Read(0x08);
	ldi R16,8
	ldi R17,0
	xcall _I2C_Read
	mov R14,R16
	mov R11,R10
	mov R10,R14
	.dbline 53
; 	
; 	 
;      angle= atan2((double)y,(double)x) * (180 / 3.14159265) + 180; // angle in degrees
	movw R16,R12
	xcall int2fp
	std y+0,R16
	std y+1,R17
	std y+2,R18
	std y+3,R19
	movw R16,R10
	xcall int2fp
	xcall _atan2f
	movw R2,R16
	movw R4,R18
	ldi R16,<L87
	ldi R17,>L87
	xcall elpm32
	st -y,R5
	st -y,R4
	st -y,R3
	st -y,R2
	xcall fpmule2
	movw R2,R16
	movw R4,R18
	ldi R16,<L88
	ldi R17,>L88
	xcall elpm32
	st -y,R19
	st -y,R18
	st -y,R17
	st -y,R16
	movw R16,R2
	movw R18,R4
	xcall fpadd2
	std y+4,R16
	std y+5,R17
	std y+6,R18
	std y+7,R19
	.dbline 54
;      angle*=10;
	ldi R16,<L89
	ldi R17,>L89
	xcall elpm32
	movw R24,R28
	adiw R24,4
	st -y,R25
	st -y,R24
	xcall fpmule1
	std y+4,R16
	std y+5,R17
	std y+6,R18
	std y+7,R19
	.dbline 56
; 
;     conversion(angle);          //转换出显示需要的数据
	ldd R16,y+4
	ldd R17,y+5
	ldd R18,y+6
	ldd R19,y+7
	xcall fpint
	xcall _conversion
	.dbline 57
; 	LCD_write_char(0,0,'A');   //第0行，第0列 显示A
	ldi R24,65
	std y+0,R24
	clr R18
	clr R16
	xcall _LCD_write_char
	.dbline 58
; 	LCD_write_char(1,0,'n');   //
	ldi R24,110
	std y+0,R24
	clr R18
	ldi R16,1
	xcall _LCD_write_char
	.dbline 59
; 	LCD_write_char(2,0,'g');   //
	ldi R24,103
	std y+0,R24
	clr R18
	ldi R16,2
	xcall _LCD_write_char
	.dbline 60
; 	LCD_write_char(3,0,'l');   //
	ldi R24,108
	std y+0,R24
	clr R18
	ldi R16,3
	xcall _LCD_write_char
	.dbline 61
; 	LCD_write_char(4,0,'e');   //
	ldi R24,101
	std y+0,R24
	clr R18
	ldi R16,4
	xcall _LCD_write_char
	.dbline 62
;     LCD_write_char(5,0,':'); 
	ldi R24,58
	std y+0,R24
	clr R18
	ldi R16,5
	xcall _LCD_write_char
	.dbline 63
;     LCD_write_char(6,0,display[1]);  
	lds R2,_display+1
	std y+0,R2
	clr R18
	ldi R16,6
	xcall _LCD_write_char
	.dbline 64
;     LCD_write_char(7,0,display[2]); 
	lds R2,_display+2
	std y+0,R2
	clr R18
	ldi R16,7
	xcall _LCD_write_char
	.dbline 65
;     LCD_write_char(8,0,display[3]); 
	lds R2,_display+3
	std y+0,R2
	clr R18
	ldi R16,8
	xcall _LCD_write_char
	.dbline 66
;     LCD_write_char(9,0,'.'); 
	ldi R24,46
	std y+0,R24
	clr R18
	ldi R16,9
	xcall _LCD_write_char
	.dbline 67
; 	LCD_write_char(10,0,display[4]); 
	lds R2,_display+4
	std y+0,R2
	clr R18
	ldi R16,10
	xcall _LCD_write_char
	.dbline 68
; 	LCD_write_char(11,0,0xdf); 
	ldi R24,223
	std y+0,R24
	clr R18
	ldi R16,11
	xcall _LCD_write_char
	.dbline -2
L86:
	.dbline 0 ; func end
	adiw R28,12
	xjmp pop_xgset00FC
	.dbsym l temp 8 D
	.dbsym l angle 4 D
	.dbsym r y 10 I
	.dbsym r x 12 I
	.dbend
	.dbfunc e main _main fV
;              i -> <dead>
	.even
_main::
	.dbline -1
	.dbline 76
; 	
; }
; 
; /*******************************
; 主程序
; *******************************/
; void main(void)
; {	
	.dbline 78
; 	unsigned char i;		
; 	 delay_nms(50);          //lcd上电延时
	ldi R16,50
	ldi R17,0
	xcall _delay_nms
	.dbline 79
; 	 LCD_init();             //lcd初始化
	xcall _LCD_init
	xjmp L96
L95:
	.dbline 81
;      
; 	while(1){               //循环  
	.dbline 82
; 	I2C_Write(0x02,0x00);   //模式寄存器写0
	clr R18
	ldi R16,2
	xcall _I2C_Write
	.dbline 83
; 	delay_nms(50); 
	ldi R16,50
	ldi R17,0
	xcall _delay_nms
	.dbline 84
; 	display_angle();       //显示角度
	xcall _display_angle
	.dbline 85
; 	delay_nms(50); 	
	ldi R16,50
	ldi R17,0
	xcall _delay_nms
	.dbline 86
;     }
L96:
	.dbline 81
	xjmp L95
X25:
	.dbline -2
L94:
	.dbline 0 ; func end
	ret
	.dbsym l i 1 c
	.dbend
	.area lit(rom, con, rel)
L89:
	.word 0x0,0x4120
L88:
	.word 0x0,0x4334
L87:
	.word 0x2ee1,0x4265
; }
; 
