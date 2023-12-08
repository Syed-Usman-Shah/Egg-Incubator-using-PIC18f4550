#line 1 "C:/Users/Hp/Desktop/mikro/MyProject.c"

unsigned long i=0,i1=0,i2=0;

long t=0,t1=0,t2=0;
int b=0,b_1=0,b_2=0;
int x=0,x1=0,x2=0;

sbit LCD_RS at RB5_bit;
sbit LCD_EN at RB4_bit;
sbit LCD_D4 at RB3_bit;
sbit LCD_D5 at RB2_bit;
sbit LCD_D6 at RB1_bit;
sbit LCD_D7 at RB0_bit;

sbit LCD_RS_Direction at TRISB5_bit;
sbit LCD_EN_Direction at TRISB4_bit;
sbit LCD_D4_Direction at TRISB3_bit;
sbit LCD_D5_Direction at TRISB2_bit;
sbit LCD_D6_Direction at TRISB1_bit;
sbit LCD_D7_Direction at TRISB0_bit;

 unsigned char Check, T_byte1, T_byte2,
 RH_byte1, RH_byte2, Ch ;
 unsigned Temp, RH, Sum ;
void StartSignal(){
 TRISD.F0 = 0;
 PORTD.F0 = 0;
 delay_ms(18);
 PORTD.F0 = 1;
 delay_us(30);
 TRISD.F0 = 1;
 }

 void CheckResponse(){
 Check = 0;
 delay_us(40);
 if (PORTD.F0 == 0){
 delay_us(80);
 if (PORTD.F0 == 1) Check = 1; delay_us(40);}
 }

 char ReadData(){
 char i, j;
 for(j = 0; j < 8; j++){
 while(!PORTD.F0);
 delay_us(30);
 if(PORTD.F0 == 0)
 i&= ~(1<<(7 - j));
 else {i|= (1 << (7 - j));
 while(PORTD.F0);}
 }
 return i;
 }



void main() {
 ADCON0 = 0x00;
 ADCON1 = 0x0f;
 TRISD.F1 = 0;
 TRISC=0x00;
 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 while(1){
 StartSignal();
 CheckResponse();
 if(Check == 1){
 RH_byte1 = ReadData();
 RH_byte2 = ReadData();
 T_byte1 = ReadData();
 T_byte2 = ReadData();
 Sum = ReadData();
 if(Sum == ((RH_byte1+RH_byte2+T_byte1+T_byte2) & 0XFF)){
 Temp = T_byte1;
 RH = RH_byte1;
 Lcd_Out(1, 6, "Temp:   C");
 Lcd_Out(2, 2, "Humidity:   %");
 LCD_Chr(1, 12, 48 + ((Temp / 10) % 10));
 LCD_Chr(1, 13, 48 + (Temp % 10));
 LCD_Chr(2, 12, 48 + ((RH / 10) % 10));
 LCD_Chr(2, 13, 48 + (RH % 10));
 }
 else{
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, "Check sum error");}
 }
 else {
 Lcd_Out(1, 3, "No response");
 Lcd_Out(2, 1, "from the sensor");
 }
 delay_ms(1000);





 if(Temp > 35)
 {
 portc.f2=1;
 portc.f1=0;
 }
 if(Temp < 20)
 {
 portc.f2=0;
 portc.f1=1;
 }
 if(RH<50)
 {
 portc.f7=0;
 }
 if(RH>80)
 {
 portc.f7=1;
 }
 }
}
