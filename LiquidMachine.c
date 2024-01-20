sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;

sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;               // End LCD module connections
int dist_cleanwatertan;
 int dist_dirtywatertan ;
 int dist_waterleve;
  unsigned int myspeed;
  unsigned int k;
   char ddd[7];

void msDelay(unsigned int msCnt)
{
    unsigned int ms=0;
    unsigned int cc=0;
    for(ms=0;ms<(msCnt);ms++)
    {
      for(cc=0;cc<155;cc++);//1ms
    }
}

void usDelay(unsigned int usCnt)
{
    unsigned int us=0;

    for(us=0;us<usCnt;us++)
    {
      asm NOP;//0.5 uS
      asm NOP;//0.5uS
    }
}




void ATD_init(void){
ADCON0=0x41;//ON, Channel 0, Fosc/16== 500KHz, Dont Go
ADCON1=0xCE;// RA0 Analog, others are Digital, Right Allignment,
}


unsigned int ATD_read(void){
         ADCON0=ADCON0 | 0x04;//GO
         while(ADCON0&0x04);//wait until DONE
         return (ADRESH<<8)|ADRESL;

}


void CCPPWM_init(void){ //Configure CCP1 and CCP2 at 2ms period with 50% duty cycle
  T2CON =  0b00000111;//enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS percount 2000uS to count 250 counts)
  CCP2CON = 0x0C;//enable PWM for CCP2
  CCP1CON = 0x0C;//enable PWM for CCP2
  PR2 = 250;// 250 counts =8uS *250 =2ms period
  CCPR2L= 0;
  CCPR1L= 0;

}

void motor1(unsigned int speed2){
      CCPR2L=speed2;
}
void motor2(unsigned int speed1){
      CCPR1L=speed1;
}

int Dist_CleanWaterTank(){
//Trigger on RC6 ,, Echo on RC7

int dist=0;
TMR1H = 0;                  //Sets the Initial Value of Timer
TMR1L = 0;                  //Sets the Initial Value of Timer

PORTC=PORTC |0b01000000;               //TRIGGER HIGH
usDelay(10);               //10uS Delay
PORTC=PORTC &0b10111111;            //TRIGGER LOW

while(!PORTC&0b10000000);           //Waiting for Echo
T1CON= T1CON|0b00000001;             //Timer Starts
while(PORTC&0b10000000);            //Waiting for Echo goes LOW
T1CON= T1CON&0b11111110;                //Timer Stops

dist = (TMR1L | (TMR1H<<8));   //Reads Timer Value
dist = dist/58.82;                //Converts Time to Distance
return dist;
}

int Dist_DirtyWaterTank(){
//Trigger on RB6 ,, Echo on RB7

int dist=0;
TMR1H = 0;                  //Sets the Initial Value of Timer
TMR1L = 0;                  //Sets the Initial Value of Timer

PORTB=PORTB |0b01000000;               //TRIGGER HIGH
usDelay(10);               //10uS Delay
PORTB=PORTB &0b10111111;               //TRIGGER LOW

while(!PORTB&0b10000000);           //Waiting for Echo
T1CON= T1CON|0b00000001;               //Timer Starts
while(PORTB&0b10000000);            //Waiting for Echo goes LOW
T1CON= T1CON&0b11111110;              //Timer Stops

dist = (TMR1L | (TMR1H<<8));   //Reads Timer Value
dist = dist/58.82;                //Converts Time to Distance
return dist;
}


 void ManualMode(){
      Lcd_Cmd(_LCD_CLEAR);               // Clear display

  msDelay(100);


      Lcd_Out(3,1,"Manual Mode");
       motor1(250);
       msDelay(300);

      while(PORTD&0b000000001&& dist_cleanwatertan<21 && dist_dirtywatertan>8 ){
                    k = ATD_read();
                   msDelay(100);
                   myspeed= (((k>>2)*250)/255);// 0-250
                   if(myspeed<100){
                   myspeed=100;
                   }
                   dist_cleanwatertan=Dist_CleanWaterTank();
                   dist_dirtywatertan= Dist_DirtyWaterTank();
                   motor1(myspeed);
                   Lcd_Out(3,12,"     ");
                   msDelay(100);
                   Lcd_Out(3,12,".");
                   msDelay(100);
                   Lcd_Out(3,13,".");
                   msDelay(100);
                   Lcd_Out(3,14,".");
                   msDelay(100);
                   Lcd_Out(3,15,".");
                   msDelay(100);
      }
      motor1(0); //off the pump



 }


void Large(){
     Lcd_Cmd(_LCD_CLEAR);               // Clear display
     while(dist_cleanwatertan<21 && dist_dirtywatertan >8){
         msDelay(100);
         Lcd_Out(3,1,"Large");
         motor1(150);
         msDelay(2000); //on 5.3v
         dist_cleanwatertan=Dist_CleanWaterTank();
         dist_dirtywatertan= Dist_DirtyWaterTank();
         if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
         motor1(250);
         msDelay(2000); //on 5.3v
         dist_cleanwatertan=Dist_CleanWaterTank() ;
         dist_dirtywatertan= Dist_DirtyWaterTank();
         if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
         msDelay(1500); //on 5.3v
         dist_cleanwatertan=Dist_CleanWaterTank() ;
         dist_dirtywatertan= Dist_DirtyWaterTank();
         if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
         msDelay(1500); //on 5.3v
         dist_cleanwatertan=Dist_CleanWaterTank() ;
         dist_dirtywatertan= Dist_DirtyWaterTank();
         if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
         motor1(100);
         msDelay(3000); //on 5.3v
         dist_cleanwatertan=Dist_CleanWaterTank() ;
         dist_dirtywatertan= Dist_DirtyWaterTank();
         if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
         break;
      }
     motor1(0);

}

void Medium (){
    Lcd_Cmd(_LCD_CLEAR);               // Clear display
    while(dist_cleanwatertan<21 && dist_dirtywatertan >8){
        msDelay(100);
        Lcd_Out(3,1,"Medium");
        motor1(150);
        msDelay(2000); //on 5.3v
        dist_cleanwatertan=Dist_CleanWaterTank();
        dist_dirtywatertan= Dist_DirtyWaterTank();
        if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
        motor1(250);
        msDelay(2000); //on 5.3v
        dist_cleanwatertan=Dist_CleanWaterTank() ;
        dist_dirtywatertan= Dist_DirtyWaterTank();
        if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
       msDelay(2000); //on 5.3v
        dist_cleanwatertan=Dist_CleanWaterTank() ;
        dist_dirtywatertan= Dist_DirtyWaterTank();
        if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
        motor1(100);
        msDelay(2000); //on 5.3v
        dist_cleanwatertan=Dist_CleanWaterTank() ;
        dist_dirtywatertan= Dist_DirtyWaterTank();
        if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
        break;
    }
    motor1(0);
}

 void Small(){
      while(dist_cleanwatertan<21 && dist_dirtywatertan >8){
         Lcd_Cmd(_LCD_CLEAR);               // Clear display
         msDelay(100);
         Lcd_Out(3,1,"Small");
         motor1(150);
         msDelay(2000); //on 5.3v
         dist_cleanwatertan=Dist_CleanWaterTank();
         dist_dirtywatertan= Dist_DirtyWaterTank();
         if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
         motor1(250);
         msDelay(2500); //on 5.3v
         dist_cleanwatertan=Dist_CleanWaterTank() ;
         dist_dirtywatertan= Dist_DirtyWaterTank();
         if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
          motor1(100);
         msDelay(2500); //on 5.3v
         dist_cleanwatertan=Dist_CleanWaterTank() ;
         dist_dirtywatertan= Dist_DirtyWaterTank();
         if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
         break;
      }

      motor1(0);
 }


void main()
{



 int i=0;

ATD_init();
CCPPWM_init(void);




TRISA = 0b00000001;     //declare as output
TRISB = 0b10000000;     //declare as output
TRISC = 0b10011000;
TRISD = 0b11111111;

PORTA = 0x00;               // Initial value of PORTA;
PORTB = 0x00;           //declare initial state
PORTD=0b00000000;

Lcd_Init();                        // Initialize LCD
Lcd_Cmd(_LCD_CLEAR);               // Clear display
Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off


T1CON = 0x10;                 //Initialize Timer Module


while(1){

Lcd_Cmd(_LCD_CLEAR);





dist_cleanwatertan=Dist_CleanWaterTank() ;
dist_dirtywatertan= Dist_DirtyWaterTank();

 if((PORTD&0b10000000) && (!PORTD&0b010000000) && (!PORTD&0b00100000) ){
 i=1; //small
 }
 else if((PORTD&0b10000000) && (PORTD&0b010000000) && (!PORTD&0b00100000) ){
 i=2;  //med
 }
 else if((PORTD&0b10000000) && (PORTD&0b010000000) && (PORTD&0b00100000) ){
 i=3;     //large
 }else{i=0;}


if((dist_cleanwatertan>20)){

 Lcd_Cmd(_LCD_CLEAR);               // Clear display

Lcd_Out(1,1,"No Liquid");
Lcd_Out(2,1,"Fill it");

}
else if(dist_dirtywatertan<9){

 Lcd_Cmd(_LCD_CLEAR);               // Clear display


msDelay(100);
Lcd_Out(1,1,"DirtyTank!!") ;

if(PORTD&0b00010000){
TRISC = 0b10011000;
Lcd_Cmd(_LCD_CLEAR);               // Clear display
       while(PORTD&0b00010000){
        Lcd_Out(2,1,"PumpOn");
        TRISC = 0b10011000;
        motor2(100);
           }
        TRISC = 0b10011100;
     }

}else{


Lcd_Cmd(_LCD_CLEAR);
Lcd_Out(1,1,"Welcome");



if(PORTD&0b00000001){


      ManualMode();

     }
     else if(PORTD&0b00000010){

        if(i==3){
          Large();
          }
        else if (i==2){
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          msDelay(100);
          Lcd_Out(2,1,"Small Cup");
          msDelay(2000);
          Medium ();
          }
        else if (i==1){
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          msDelay(100);

          Lcd_Out(2,1,"Small Cup");
          msDelay(2000);
          Small();
          }
        else{
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          msDelay(100);
          Lcd_Out(2,1,"No Cup");
          msDelay(2000);//////////////////////////JHHHHHH
          }
     }
     else if(PORTD&0b00000100){
        if(i==2 || i==3){
          Medium ();
          }
        else if (i==1){
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          msDelay(100);
          Lcd_Out(2,1,"Small Cup");
          msDelay(2000);
          Small();
          }
        else{
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          msDelay(100);
          Lcd_Out(2,1,"No cup");
          msDelay(2000);
          }
        }
     else if(PORTD&0b00001000){
        if(i==1 || i==2 || i==3){
           Small();
           }
        else if (i==0) {
           Lcd_Cmd(_LCD_CLEAR);               // Clear display
           msDelay(100);
           Lcd_Out(2,1,"No cup");
           msDelay(2000);
           }
     }
     else if(PORTC&0b00010000){
          if(i==1){
             Small();
             }
          else if (i==2){
             Medium ();
             }
          else if (i==3){
             Large();
             }
          else{
             Lcd_Cmd(_LCD_CLEAR);               // Clear display
             msDelay(100);
             Lcd_Out(2,1,"No cup");
             msDelay(2000);
             }
     }
     else if(PORTD&0b00010000){
     Lcd_Cmd(_LCD_CLEAR);               // Clear display
        while(PORTD&0b00010000){
        Lcd_Out(2,1,"PumpOn");
        TRISC = 0b10011000;
        motor2(100);
           }
       TRISC = 0b10011100;
     }
    else{

       TRISC = 0b10011100;
       }
    }




   msDelay(200);
   }

   }