//***************************************
// HMC5883 IIC测试程序
// 使用单片机STC89C51 
// 晶振：11.0592M
// 显示：LCD1602
// 编译环境 Keil uVision2
// 参考宏晶网站24c04通信程序
// 时间：2011年3月1日
//****************************************
#include  <REG51.H>	
#include  <math.h>    //Keil library  
#include  <stdio.h>   //Keil library	
#include  <INTRINS.H>
#define   uchar unsigned char
#define   uint unsigned int	
//使用的端口，请按照以下接线
#define   DataPort P0	//LCD1602数据端口
sbit	SCL=P1^0;      //IIC时钟引脚定义
sbit	SDA=P1^1;      //IIC数据引脚定义
sbit    LCM_RS=P2^0;   //LCD1602命令端口		
sbit    LCM_RW=P2^1;   //LCD1602命令端口		
sbit    LCM_EN=P2^2;   //LCD1602命令端口 

#define	SlaveAddress   0x3C	  //定义器件在IIC总线中的从地址
typedef unsigned char BYTE;
typedef unsigned short WORD;

BYTE BUF[8];                         //接收数据缓存区      	
uchar ge,shi,bai,qian,wan;           //显示变量
int  dis_data;                       //变量

void delay(unsigned int k);
void InitLcd();
void Init_HMC5883(void);            //初始化5883

void WriteDataLCM(uchar dataW);
void WriteCommandLCM(uchar CMD,uchar Attribc);
void DisplayOneChar(uchar X,uchar Y,uchar DData);
void conversion(uint temp_data);

void  Single_Write_HMC5883(uchar REG_Address,uchar REG_data);   //单个写入数据
uchar Single_Read_HMC5883(uchar REG_Address);                   //单个读取内部寄存器数据
void  Multiple_Read_HMC5883();                                  //连续的读取内部寄存器数据
//以下是模拟iic使用函数-------------
void Delay5us();
void Delay5ms();
void HMC5883_Start();
void HMC5883_Stop();
void HMC5883_SendACK(bit ack);
bit  HMC5883_RecvACK();
void HMC5883_SendByte(BYTE dat);
BYTE HMC5883_RecvByte();
void HMC5883_ReadPage();
void HMC5883_WritePage();
//-----------------------------------

//*********************************************************
void conversion(uint temp_data)  
{  
    wan=temp_data/10000+0x30 ;
    temp_data=temp_data%10000;   //取余运算
	qian=temp_data/1000+0x30 ;
    temp_data=temp_data%1000;    //取余运算
    bai=temp_data/100+0x30   ;
    temp_data=temp_data%100;     //取余运算
    shi=temp_data/10+0x30    ;
    temp_data=temp_data%10;      //取余运算
    ge=temp_data+0x30; 	
}

/*******************************/
void delay(unsigned int k)	
{						
unsigned int i,j;				
for(i=0;i<k;i++)
{			
for(j=0;j<121;j++)			
{;}}						
}
/*******************************/
void WaitForEnable(void)	
{					
DataPort=0xff;		
LCM_RS=0;LCM_RW=1;_nop_();
LCM_EN=1;_nop_();_nop_();
while(DataPort&0x80);	
LCM_EN=0;				
}					
/*******************************/
void WriteCommandLCM(uchar CMD,uchar Attribc)
{					
if(Attribc)WaitForEnable();	
LCM_RS=0;LCM_RW=0;_nop_();
DataPort=CMD;_nop_();	
LCM_EN=1;_nop_();_nop_();LCM_EN=0;
}					
/*******************************/
void WriteDataLCM(uchar dataW)
{					
WaitForEnable();		
LCM_RS=1;LCM_RW=0;_nop_();
DataPort=dataW;_nop_();	
LCM_EN=1;_nop_();_nop_();LCM_EN=0;
}		
/***********************************/
void InitLcd()				
{			
WriteCommandLCM(0x38,1);	
WriteCommandLCM(0x08,1);	
WriteCommandLCM(0x01,1);	
WriteCommandLCM(0x06,1);	
WriteCommandLCM(0x0c,1);
}			
/***********************************/
void DisplayOneChar(uchar X,uchar Y,uchar DData)
{						
Y&=1;						
X&=15;						
if(Y)X|=0x40;					
X|=0x80;			
WriteCommandLCM(X,0);		
WriteDataLCM(DData);		
}						

/**************************************
延时5微秒(STC90C52RC@12M)
不同的工作环境,需要调整此函数，注意时钟过快时需要修改
当改用1T的MCU时,请调整此延时函数
**************************************/
void Delay5us()
{
             _nop_();_nop_();_nop_();_nop_();
             _nop_();_nop_();_nop_();_nop_();
	_nop_();_nop_();_nop_();_nop_();
	_nop_();_nop_();_nop_();_nop_();
              _nop_();_nop_();_nop_();_nop_();
	_nop_();_nop_();_nop_();_nop_();
	_nop_();_nop_();_nop_();_nop_();
             _nop_();_nop_();_nop_();_nop_();

}

/**************************************
延时5毫秒(STC90C52RC@12M)
不同的工作环境,需要调整此函数
当改用1T的MCU时,请调整此延时函数
**************************************/
void Delay5ms()
{
    WORD n = 560;

    while (n--);
}

/**************************************
起始信号
**************************************/
void HMC5883_Start()
{
    SDA = 1;                    //拉高数据线
    SCL = 1;                    //拉高时钟线
    Delay5us();                 //延时
    SDA = 0;                    //产生下降沿
    Delay5us();                 //延时
    SCL = 0;                    //拉低时钟线
}

/**************************************
停止信号
**************************************/
void HMC5883_Stop()
{
    SDA = 0;                    //拉低数据线
    SCL = 1;                    //拉高时钟线
    Delay5us();                 //延时
    SDA = 1;                    //产生上升沿
    Delay5us();                 //延时
}

/**************************************
发送应答信号
入口参数:ack (0:ACK 1:NAK)
**************************************/
void HMC5883_SendACK(bit ack)
{
    SDA = ack;                  //写应答信号
    SCL = 1;                    //拉高时钟线
    Delay5us();                 //延时
    SCL = 0;                    //拉低时钟线
    Delay5us();                 //延时
}

/**************************************
接收应答信号
**************************************/
bit HMC5883_RecvACK()
{
    SCL = 1;                    //拉高时钟线
    Delay5us();                 //延时
    CY = SDA;                   //读应答信号
    SCL = 0;                    //拉低时钟线
    Delay5us();                 //延时

    return CY;
}

/**************************************
向IIC总线发送一个字节数据
**************************************/
void HMC5883_SendByte(BYTE dat)
{
    BYTE i;

    for (i=0; i<8; i++)         //8位计数器
    {
        dat <<= 1;              //移出数据的最高位
        SDA = CY;               //送数据口
        SCL = 1;                //拉高时钟线
        Delay5us();             //延时
        SCL = 0;                //拉低时钟线
        Delay5us();             //延时
    }
    HMC5883_RecvACK();
}

/**************************************
从IIC总线接收一个字节数据
**************************************/
BYTE HMC5883_RecvByte()
{
    BYTE i;
    BYTE dat = 0;

    SDA = 1;                    //使能内部上拉,准备读取数据,
    for (i=0; i<8; i++)         //8位计数器
    {
        dat <<= 1;
        SCL = 1;                //拉高时钟线
        Delay5us();             //延时
        dat |= SDA;             //读数据               
        SCL = 0;                //拉低时钟线
        Delay5us();             //延时
    }
    return dat;
}

//***************************************************

void Single_Write_HMC5883(uchar REG_Address,uchar REG_data)
{
    HMC5883_Start();                  //起始信号
    HMC5883_SendByte(SlaveAddress);   //发送设备地址+写信号
    HMC5883_SendByte(REG_Address);    //内部寄存器地址，请参考中文pdf 
    HMC5883_SendByte(REG_data);       //内部寄存器数据，请参考中文pdf
    HMC5883_Stop();                   //发送停止信号
}

//********单字节读取内部寄存器*************************
uchar Single_Read_HMC5883(uchar REG_Address)
{  uchar REG_data;
    HMC5883_Start();                          //起始信号
    HMC5883_SendByte(SlaveAddress);           //发送设备地址+写信号
    HMC5883_SendByte(REG_Address);                   //发送存储单元地址，从0开始	
    HMC5883_Start();                          //起始信号
    HMC5883_SendByte(SlaveAddress+1);         //发送设备地址+读信号
    REG_data=HMC5883_RecvByte();              //读出寄存器数据
	HMC5883_SendACK(1);   
	HMC5883_Stop();                           //停止信号
    return REG_data; 
}
//******************************************************
//
//连续读出HMC5883内部角度数据，地址范围0x3~0x5
//
//******************************************************
void Multiple_read_HMC5883(void)
{   uchar i;
    HMC5883_Start();                          //起始信号
    HMC5883_SendByte(SlaveAddress);           //发送设备地址+写信号
    HMC5883_SendByte(0x03);                   //发送存储单元地址，从0x3开始	
    HMC5883_Start();                          //起始信号
    HMC5883_SendByte(SlaveAddress+1);         //发送设备地址+读信号
	 for (i=0; i<6; i++)                      //连续读取6个地址数据，存储中BUF
    {
        BUF[i] = HMC5883_RecvByte();          //BUF[0]存储数据
        if (i == 5)
        {
           HMC5883_SendACK(1);                //最后一个数据需要回NOACK
        }
        else
        {
          HMC5883_SendACK(0);                //回应ACK
       }
   }
    HMC5883_Stop();                          //停止信号
    Delay5ms();
}

//初始化HMC5883，根据需要请参考pdf进行修改****
void Init_HMC5883()
{
     Single_Write_HMC5883(0x02,0x00);  //
}
//*********************************************************
//主程序********
//*********************************************************
void main()
{ // bit sign_bit;
   unsigned int i;
   int x,y,z;
   double angle;

   delay(500);			
   InitLcd();
   Init_HMC5883();
  while(1)            //循环
  { 
    Multiple_Read_HMC5883();      //连续读出数据，存储在BUF中
//---------显示X轴
    x=BUF[0] << 8 | BUF[1]; //Combine MSB and LSB of X Data output register
    z=BUF[2] << 8 | BUF[3]; //Combine MSB and LSB of Z Data output register
    y=BUF[4] << 8 | BUF[5]; //Combine MSB and LSB of Y Data output register

    angle= atan2((double)y,(double)x) * (180 / 3.14159265) + 180; // angle in degrees
    angle*=10;
    conversion(angle);       //计算数据和显示
	DisplayOneChar(2,0,'A'); 
    DisplayOneChar(3,0,':'); 
    DisplayOneChar(4,0,qian); 
    DisplayOneChar(5,0,bai); 
    DisplayOneChar(6,0,shi); 
    DisplayOneChar(7,0,'.'); 
	DisplayOneChar(8,0,ge); 

    for (i=0;i<10000;i++);   //延时                   
  }
} 
