
_msDelay:

;LiquidMachine.c,21 :: 		void msDelay(unsigned int msCnt)
;LiquidMachine.c,23 :: 		unsigned int ms=0;
	CLRF       msDelay_ms_L0+0
	CLRF       msDelay_ms_L0+1
	CLRF       msDelay_cc_L0+0
	CLRF       msDelay_cc_L0+1
;LiquidMachine.c,25 :: 		for(ms=0;ms<(msCnt);ms++)
	CLRF       msDelay_ms_L0+0
	CLRF       msDelay_ms_L0+1
L_msDelay0:
	MOVF       FARG_msDelay_msCnt+1, 0
	SUBWF      msDelay_ms_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay152
	MOVF       FARG_msDelay_msCnt+0, 0
	SUBWF      msDelay_ms_L0+0, 0
L__msDelay152:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay1
;LiquidMachine.c,27 :: 		for(cc=0;cc<155;cc++);//1ms
	CLRF       msDelay_cc_L0+0
	CLRF       msDelay_cc_L0+1
L_msDelay3:
	MOVLW      0
	SUBWF      msDelay_cc_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay153
	MOVLW      155
	SUBWF      msDelay_cc_L0+0, 0
L__msDelay153:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay4
	INCF       msDelay_cc_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay_cc_L0+1, 1
	GOTO       L_msDelay3
L_msDelay4:
;LiquidMachine.c,25 :: 		for(ms=0;ms<(msCnt);ms++)
	INCF       msDelay_ms_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay_ms_L0+1, 1
;LiquidMachine.c,28 :: 		}
	GOTO       L_msDelay0
L_msDelay1:
;LiquidMachine.c,29 :: 		}
L_end_msDelay:
	RETURN
; end of _msDelay

_usDelay:

;LiquidMachine.c,31 :: 		void usDelay(unsigned int usCnt)
;LiquidMachine.c,33 :: 		unsigned int us=0;
	CLRF       usDelay_us_L0+0
	CLRF       usDelay_us_L0+1
;LiquidMachine.c,35 :: 		for(us=0;us<usCnt;us++)
	CLRF       usDelay_us_L0+0
	CLRF       usDelay_us_L0+1
L_usDelay6:
	MOVF       FARG_usDelay_usCnt+1, 0
	SUBWF      usDelay_us_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__usDelay155
	MOVF       FARG_usDelay_usCnt+0, 0
	SUBWF      usDelay_us_L0+0, 0
L__usDelay155:
	BTFSC      STATUS+0, 0
	GOTO       L_usDelay7
;LiquidMachine.c,37 :: 		asm NOP;//0.5 uS
	NOP
;LiquidMachine.c,38 :: 		asm NOP;//0.5uS
	NOP
;LiquidMachine.c,35 :: 		for(us=0;us<usCnt;us++)
	INCF       usDelay_us_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       usDelay_us_L0+1, 1
;LiquidMachine.c,39 :: 		}
	GOTO       L_usDelay6
L_usDelay7:
;LiquidMachine.c,40 :: 		}
L_end_usDelay:
	RETURN
; end of _usDelay

_ATD_init:

;LiquidMachine.c,45 :: 		void ATD_init(void){
;LiquidMachine.c,46 :: 		ADCON0=0x41;//ON, Channel 0, Fosc/16== 500KHz, Dont Go
	MOVLW      65
	MOVWF      ADCON0+0
;LiquidMachine.c,47 :: 		ADCON1=0xCE;// RA0 Analog, others are Digital, Right Allignment,
	MOVLW      206
	MOVWF      ADCON1+0
;LiquidMachine.c,48 :: 		}
L_end_ATD_init:
	RETURN
; end of _ATD_init

_ATD_read:

;LiquidMachine.c,51 :: 		unsigned int ATD_read(void){
;LiquidMachine.c,52 :: 		ADCON0=ADCON0 | 0x04;//GO
	BSF        ADCON0+0, 2
;LiquidMachine.c,53 :: 		while(ADCON0&0x04);//wait until DONE
L_ATD_read9:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read10
	GOTO       L_ATD_read9
L_ATD_read10:
;LiquidMachine.c,54 :: 		return (ADRESH<<8)|ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;LiquidMachine.c,56 :: 		}
L_end_ATD_read:
	RETURN
; end of _ATD_read

_CCPPWM_init:

;LiquidMachine.c,59 :: 		void CCPPWM_init(void){ //Configure CCP1 and CCP2 at 2ms period with 50% duty cycle
;LiquidMachine.c,60 :: 		T2CON =  0b00000111;//enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS percount 2000uS to count 250 counts)
	MOVLW      7
	MOVWF      T2CON+0
;LiquidMachine.c,61 :: 		CCP2CON = 0x0C;//enable PWM for CCP2
	MOVLW      12
	MOVWF      CCP2CON+0
;LiquidMachine.c,62 :: 		CCP1CON = 0x0C;//enable PWM for CCP2
	MOVLW      12
	MOVWF      CCP1CON+0
;LiquidMachine.c,63 :: 		PR2 = 250;// 250 counts =8uS *250 =2ms period
	MOVLW      250
	MOVWF      PR2+0
;LiquidMachine.c,64 :: 		CCPR2L= 0;
	CLRF       CCPR2L+0
;LiquidMachine.c,65 :: 		CCPR1L= 0;
	CLRF       CCPR1L+0
;LiquidMachine.c,67 :: 		}
L_end_CCPPWM_init:
	RETURN
; end of _CCPPWM_init

_motor1:

;LiquidMachine.c,69 :: 		void motor1(unsigned int speed2){
;LiquidMachine.c,70 :: 		CCPR2L=speed2;
	MOVF       FARG_motor1_speed2+0, 0
	MOVWF      CCPR2L+0
;LiquidMachine.c,71 :: 		}
L_end_motor1:
	RETURN
; end of _motor1

_motor2:

;LiquidMachine.c,72 :: 		void motor2(unsigned int speed1){
;LiquidMachine.c,73 :: 		CCPR1L=speed1;
	MOVF       FARG_motor2_speed1+0, 0
	MOVWF      CCPR1L+0
;LiquidMachine.c,74 :: 		}
L_end_motor2:
	RETURN
; end of _motor2

_Dist_CleanWaterTank:

;LiquidMachine.c,76 :: 		int Dist_CleanWaterTank(){
;LiquidMachine.c,79 :: 		int dist=0;
;LiquidMachine.c,80 :: 		TMR1H = 0;                  //Sets the Initial Value of Timer
	CLRF       TMR1H+0
;LiquidMachine.c,81 :: 		TMR1L = 0;                  //Sets the Initial Value of Timer
	CLRF       TMR1L+0
;LiquidMachine.c,83 :: 		PORTC=PORTC |0b01000000;               //TRIGGER HIGH
	BSF        PORTC+0, 6
;LiquidMachine.c,84 :: 		usDelay(10);               //10uS Delay
	MOVLW      10
	MOVWF      FARG_usDelay_usCnt+0
	MOVLW      0
	MOVWF      FARG_usDelay_usCnt+1
	CALL       _usDelay+0
;LiquidMachine.c,85 :: 		PORTC=PORTC &0b10111111;            //TRIGGER LOW
	MOVLW      191
	ANDWF      PORTC+0, 1
;LiquidMachine.c,87 :: 		while(!PORTC&0b10000000);           //Waiting for Echo
L_Dist_CleanWaterTank11:
	MOVF       PORTC+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	BTFSS      R1+0, 7
	GOTO       L_Dist_CleanWaterTank12
	GOTO       L_Dist_CleanWaterTank11
L_Dist_CleanWaterTank12:
;LiquidMachine.c,88 :: 		T1CON= T1CON|0b00000001;             //Timer Starts
	BSF        T1CON+0, 0
;LiquidMachine.c,89 :: 		while(PORTC&0b10000000);            //Waiting for Echo goes LOW
L_Dist_CleanWaterTank13:
	BTFSS      PORTC+0, 7
	GOTO       L_Dist_CleanWaterTank14
	GOTO       L_Dist_CleanWaterTank13
L_Dist_CleanWaterTank14:
;LiquidMachine.c,90 :: 		T1CON= T1CON&0b11111110;                //Timer Stops
	MOVLW      254
	ANDWF      T1CON+0, 1
;LiquidMachine.c,92 :: 		dist = (TMR1L | (TMR1H<<8));   //Reads Timer Value
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;LiquidMachine.c,93 :: 		dist = dist/58.82;                //Converts Time to Distance
	CALL       _int2double+0
	MOVLW      174
	MOVWF      R4+0
	MOVLW      71
	MOVWF      R4+1
	MOVLW      107
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2int+0
;LiquidMachine.c,94 :: 		return dist;
;LiquidMachine.c,95 :: 		}
L_end_Dist_CleanWaterTank:
	RETURN
; end of _Dist_CleanWaterTank

_Dist_DirtyWaterTank:

;LiquidMachine.c,97 :: 		int Dist_DirtyWaterTank(){
;LiquidMachine.c,100 :: 		int dist=0;
;LiquidMachine.c,101 :: 		TMR1H = 0;                  //Sets the Initial Value of Timer
	CLRF       TMR1H+0
;LiquidMachine.c,102 :: 		TMR1L = 0;                  //Sets the Initial Value of Timer
	CLRF       TMR1L+0
;LiquidMachine.c,104 :: 		PORTB=PORTB |0b01000000;               //TRIGGER HIGH
	BSF        PORTB+0, 6
;LiquidMachine.c,105 :: 		usDelay(10);               //10uS Delay
	MOVLW      10
	MOVWF      FARG_usDelay_usCnt+0
	MOVLW      0
	MOVWF      FARG_usDelay_usCnt+1
	CALL       _usDelay+0
;LiquidMachine.c,106 :: 		PORTB=PORTB &0b10111111;               //TRIGGER LOW
	MOVLW      191
	ANDWF      PORTB+0, 1
;LiquidMachine.c,108 :: 		while(!PORTB&0b10000000);           //Waiting for Echo
L_Dist_DirtyWaterTank15:
	MOVF       PORTB+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	BTFSS      R1+0, 7
	GOTO       L_Dist_DirtyWaterTank16
	GOTO       L_Dist_DirtyWaterTank15
L_Dist_DirtyWaterTank16:
;LiquidMachine.c,109 :: 		T1CON= T1CON|0b00000001;               //Timer Starts
	BSF        T1CON+0, 0
;LiquidMachine.c,110 :: 		while(PORTB&0b10000000);            //Waiting for Echo goes LOW
L_Dist_DirtyWaterTank17:
	BTFSS      PORTB+0, 7
	GOTO       L_Dist_DirtyWaterTank18
	GOTO       L_Dist_DirtyWaterTank17
L_Dist_DirtyWaterTank18:
;LiquidMachine.c,111 :: 		T1CON= T1CON&0b11111110;              //Timer Stops
	MOVLW      254
	ANDWF      T1CON+0, 1
;LiquidMachine.c,113 :: 		dist = (TMR1L | (TMR1H<<8));   //Reads Timer Value
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;LiquidMachine.c,114 :: 		dist = dist/58.82;                //Converts Time to Distance
	CALL       _int2double+0
	MOVLW      174
	MOVWF      R4+0
	MOVLW      71
	MOVWF      R4+1
	MOVLW      107
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2int+0
;LiquidMachine.c,115 :: 		return dist;
;LiquidMachine.c,116 :: 		}
L_end_Dist_DirtyWaterTank:
	RETURN
; end of _Dist_DirtyWaterTank

_ManualMode:

;LiquidMachine.c,119 :: 		void ManualMode(){
;LiquidMachine.c,120 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,122 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,125 :: 		Lcd_Out(3,1,"Manual Mode");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,126 :: 		motor1(250);
	MOVLW      250
	MOVWF      FARG_motor1_speed2+0
	CLRF       FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,127 :: 		msDelay(300);
	MOVLW      44
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      1
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,129 :: 		while(PORTD&0b000000001&& dist_cleanwatertan<21 && dist_dirtywatertan>8 ){
L_ManualMode19:
	BTFSS      PORTD+0, 0
	GOTO       L_ManualMode20
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ManualMode164
	MOVLW      21
	SUBWF      _dist_cleanwatertan+0, 0
L__ManualMode164:
	BTFSC      STATUS+0, 0
	GOTO       L_ManualMode20
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ManualMode165
	MOVF       _dist_dirtywatertan+0, 0
	SUBLW      8
L__ManualMode165:
	BTFSC      STATUS+0, 0
	GOTO       L_ManualMode20
L__ManualMode130:
;LiquidMachine.c,130 :: 		k = ATD_read();
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _k+0
	MOVF       R0+1, 0
	MOVWF      _k+1
;LiquidMachine.c,131 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,132 :: 		myspeed= (((k>>2)*250)/255);// 0-250
	MOVF       _k+0, 0
	MOVWF      R0+0
	MOVF       _k+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVLW      250
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _myspeed+0
	MOVF       R0+1, 0
	MOVWF      _myspeed+1
;LiquidMachine.c,133 :: 		if(myspeed<100){
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ManualMode166
	MOVLW      100
	SUBWF      R0+0, 0
L__ManualMode166:
	BTFSC      STATUS+0, 0
	GOTO       L_ManualMode23
;LiquidMachine.c,134 :: 		myspeed=100;
	MOVLW      100
	MOVWF      _myspeed+0
	MOVLW      0
	MOVWF      _myspeed+1
;LiquidMachine.c,135 :: 		}
L_ManualMode23:
;LiquidMachine.c,136 :: 		dist_cleanwatertan=Dist_CleanWaterTank();
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,137 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,138 :: 		motor1(myspeed);
	MOVF       _myspeed+0, 0
	MOVWF      FARG_motor1_speed2+0
	MOVF       _myspeed+1, 0
	MOVWF      FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,139 :: 		Lcd_Out(3,12,"     ");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,140 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,141 :: 		Lcd_Out(3,12,".");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,142 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,143 :: 		Lcd_Out(3,13,".");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,144 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,145 :: 		Lcd_Out(3,14,".");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,146 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,147 :: 		Lcd_Out(3,15,".");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,148 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,149 :: 		}
	GOTO       L_ManualMode19
L_ManualMode20:
;LiquidMachine.c,150 :: 		motor1(0); //off the pump
	CLRF       FARG_motor1_speed2+0
	CLRF       FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,154 :: 		}
L_end_ManualMode:
	RETURN
; end of _ManualMode

_Large:

;LiquidMachine.c,157 :: 		void Large(){
;LiquidMachine.c,158 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,159 :: 		while(dist_cleanwatertan<21 && dist_dirtywatertan >8){
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large168
	MOVLW      21
	SUBWF      _dist_cleanwatertan+0, 0
L__Large168:
	BTFSC      STATUS+0, 0
	GOTO       L_Large25
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large169
	MOVF       _dist_dirtywatertan+0, 0
	SUBLW      8
L__Large169:
	BTFSC      STATUS+0, 0
	GOTO       L_Large25
L__Large136:
;LiquidMachine.c,160 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,161 :: 		Lcd_Out(3,1,"Large");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,162 :: 		motor1(150);
	MOVLW      150
	MOVWF      FARG_motor1_speed2+0
	CLRF       FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,163 :: 		msDelay(2000); //on 5.3v
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,164 :: 		dist_cleanwatertan=Dist_CleanWaterTank();
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,165 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,166 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large170
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Large170:
	BTFSS      STATUS+0, 0
	GOTO       L__Large135
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large171
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Large171:
	BTFSS      STATUS+0, 0
	GOTO       L__Large135
	GOTO       L_Large30
L__Large135:
	GOTO       L_Large25
L_Large30:
;LiquidMachine.c,167 :: 		motor1(250);
	MOVLW      250
	MOVWF      FARG_motor1_speed2+0
	CLRF       FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,168 :: 		msDelay(2000); //on 5.3v
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,169 :: 		dist_cleanwatertan=Dist_CleanWaterTank() ;
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,170 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,171 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large172
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Large172:
	BTFSS      STATUS+0, 0
	GOTO       L__Large134
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large173
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Large173:
	BTFSS      STATUS+0, 0
	GOTO       L__Large134
	GOTO       L_Large33
L__Large134:
	GOTO       L_Large25
L_Large33:
;LiquidMachine.c,172 :: 		msDelay(1500); //on 5.3v
	MOVLW      220
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      5
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,173 :: 		dist_cleanwatertan=Dist_CleanWaterTank() ;
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,174 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,175 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large174
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Large174:
	BTFSS      STATUS+0, 0
	GOTO       L__Large133
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large175
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Large175:
	BTFSS      STATUS+0, 0
	GOTO       L__Large133
	GOTO       L_Large36
L__Large133:
	GOTO       L_Large25
L_Large36:
;LiquidMachine.c,176 :: 		msDelay(1500); //on 5.3v
	MOVLW      220
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      5
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,177 :: 		dist_cleanwatertan=Dist_CleanWaterTank() ;
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,178 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,179 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large176
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Large176:
	BTFSS      STATUS+0, 0
	GOTO       L__Large132
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large177
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Large177:
	BTFSS      STATUS+0, 0
	GOTO       L__Large132
	GOTO       L_Large39
L__Large132:
	GOTO       L_Large25
L_Large39:
;LiquidMachine.c,180 :: 		motor1(100);
	MOVLW      100
	MOVWF      FARG_motor1_speed2+0
	MOVLW      0
	MOVWF      FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,181 :: 		msDelay(3000); //on 5.3v
	MOVLW      184
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      11
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,182 :: 		dist_cleanwatertan=Dist_CleanWaterTank() ;
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,183 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,184 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large178
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Large178:
	BTFSS      STATUS+0, 0
	GOTO       L__Large131
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Large179
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Large179:
	BTFSS      STATUS+0, 0
	GOTO       L__Large131
	GOTO       L_Large42
L__Large131:
	GOTO       L_Large25
L_Large42:
;LiquidMachine.c,186 :: 		}
L_Large25:
;LiquidMachine.c,187 :: 		motor1(0);
	CLRF       FARG_motor1_speed2+0
	CLRF       FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,189 :: 		}
L_end_Large:
	RETURN
; end of _Large

_Medium:

;LiquidMachine.c,191 :: 		void Medium (){
;LiquidMachine.c,192 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,193 :: 		while(dist_cleanwatertan<21 && dist_dirtywatertan >8){
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Medium181
	MOVLW      21
	SUBWF      _dist_cleanwatertan+0, 0
L__Medium181:
	BTFSC      STATUS+0, 0
	GOTO       L_Medium44
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Medium182
	MOVF       _dist_dirtywatertan+0, 0
	SUBLW      8
L__Medium182:
	BTFSC      STATUS+0, 0
	GOTO       L_Medium44
L__Medium141:
;LiquidMachine.c,194 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,195 :: 		Lcd_Out(3,1,"Medium");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,196 :: 		motor1(150);
	MOVLW      150
	MOVWF      FARG_motor1_speed2+0
	CLRF       FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,197 :: 		msDelay(2000); //on 5.3v
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,198 :: 		dist_cleanwatertan=Dist_CleanWaterTank();
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,199 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,200 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Medium183
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Medium183:
	BTFSS      STATUS+0, 0
	GOTO       L__Medium140
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Medium184
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Medium184:
	BTFSS      STATUS+0, 0
	GOTO       L__Medium140
	GOTO       L_Medium49
L__Medium140:
	GOTO       L_Medium44
L_Medium49:
;LiquidMachine.c,201 :: 		motor1(250);
	MOVLW      250
	MOVWF      FARG_motor1_speed2+0
	CLRF       FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,202 :: 		msDelay(2000); //on 5.3v
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,203 :: 		dist_cleanwatertan=Dist_CleanWaterTank() ;
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,204 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,205 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Medium185
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Medium185:
	BTFSS      STATUS+0, 0
	GOTO       L__Medium139
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Medium186
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Medium186:
	BTFSS      STATUS+0, 0
	GOTO       L__Medium139
	GOTO       L_Medium52
L__Medium139:
	GOTO       L_Medium44
L_Medium52:
;LiquidMachine.c,206 :: 		msDelay(2000); //on 5.3v
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,207 :: 		dist_cleanwatertan=Dist_CleanWaterTank() ;
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,208 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,209 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Medium187
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Medium187:
	BTFSS      STATUS+0, 0
	GOTO       L__Medium138
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Medium188
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Medium188:
	BTFSS      STATUS+0, 0
	GOTO       L__Medium138
	GOTO       L_Medium55
L__Medium138:
	GOTO       L_Medium44
L_Medium55:
;LiquidMachine.c,210 :: 		motor1(100);
	MOVLW      100
	MOVWF      FARG_motor1_speed2+0
	MOVLW      0
	MOVWF      FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,211 :: 		msDelay(2000); //on 5.3v
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,212 :: 		dist_cleanwatertan=Dist_CleanWaterTank() ;
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,213 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,214 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Medium189
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Medium189:
	BTFSS      STATUS+0, 0
	GOTO       L__Medium137
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Medium190
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Medium190:
	BTFSS      STATUS+0, 0
	GOTO       L__Medium137
	GOTO       L_Medium58
L__Medium137:
	GOTO       L_Medium44
L_Medium58:
;LiquidMachine.c,216 :: 		}
L_Medium44:
;LiquidMachine.c,217 :: 		motor1(0);
	CLRF       FARG_motor1_speed2+0
	CLRF       FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,218 :: 		}
L_end_Medium:
	RETURN
; end of _Medium

_Small:

;LiquidMachine.c,220 :: 		void Small(){
;LiquidMachine.c,221 :: 		while(dist_cleanwatertan<21 && dist_dirtywatertan >8){
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Small192
	MOVLW      21
	SUBWF      _dist_cleanwatertan+0, 0
L__Small192:
	BTFSC      STATUS+0, 0
	GOTO       L_Small60
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Small193
	MOVF       _dist_dirtywatertan+0, 0
	SUBLW      8
L__Small193:
	BTFSC      STATUS+0, 0
	GOTO       L_Small60
L__Small145:
;LiquidMachine.c,222 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,223 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,224 :: 		Lcd_Out(3,1,"Small");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,225 :: 		motor1(150);
	MOVLW      150
	MOVWF      FARG_motor1_speed2+0
	CLRF       FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,226 :: 		msDelay(2000); //on 5.3v
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,227 :: 		dist_cleanwatertan=Dist_CleanWaterTank();
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,228 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,229 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Small194
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Small194:
	BTFSS      STATUS+0, 0
	GOTO       L__Small144
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Small195
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Small195:
	BTFSS      STATUS+0, 0
	GOTO       L__Small144
	GOTO       L_Small65
L__Small144:
	GOTO       L_Small60
L_Small65:
;LiquidMachine.c,230 :: 		motor1(250);
	MOVLW      250
	MOVWF      FARG_motor1_speed2+0
	CLRF       FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,231 :: 		msDelay(2500); //on 5.3v
	MOVLW      196
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      9
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,232 :: 		dist_cleanwatertan=Dist_CleanWaterTank() ;
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,233 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,234 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Small196
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Small196:
	BTFSS      STATUS+0, 0
	GOTO       L__Small143
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Small197
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Small197:
	BTFSS      STATUS+0, 0
	GOTO       L__Small143
	GOTO       L_Small68
L__Small143:
	GOTO       L_Small60
L_Small68:
;LiquidMachine.c,235 :: 		motor1(100);
	MOVLW      100
	MOVWF      FARG_motor1_speed2+0
	MOVLW      0
	MOVWF      FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,236 :: 		msDelay(2500); //on 5.3v
	MOVLW      196
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      9
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,237 :: 		dist_cleanwatertan=Dist_CleanWaterTank() ;
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,238 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,239 :: 		if(dist_cleanwatertan  >21 || dist_dirtywatertan <8) {break;}
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Small198
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      21
L__Small198:
	BTFSS      STATUS+0, 0
	GOTO       L__Small142
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Small199
	MOVLW      8
	SUBWF      _dist_dirtywatertan+0, 0
L__Small199:
	BTFSS      STATUS+0, 0
	GOTO       L__Small142
	GOTO       L_Small71
L__Small142:
	GOTO       L_Small60
L_Small71:
;LiquidMachine.c,241 :: 		}
L_Small60:
;LiquidMachine.c,243 :: 		motor1(0);
	CLRF       FARG_motor1_speed2+0
	CLRF       FARG_motor1_speed2+1
	CALL       _motor1+0
;LiquidMachine.c,244 :: 		}
L_end_Small:
	RETURN
; end of _Small

_main:

;LiquidMachine.c,247 :: 		void main()
;LiquidMachine.c,252 :: 		int i=0;
	CLRF       main_i_L0+0
	CLRF       main_i_L0+1
;LiquidMachine.c,254 :: 		ATD_init();
	CALL       _ATD_init+0
;LiquidMachine.c,255 :: 		CCPPWM_init(void);
	CALL       _CCPPWM_init+0
;LiquidMachine.c,260 :: 		TRISA = 0b00000001;     //declare as output
	MOVLW      1
	MOVWF      TRISA+0
;LiquidMachine.c,261 :: 		TRISB = 0b10000000;     //declare as output
	MOVLW      128
	MOVWF      TRISB+0
;LiquidMachine.c,262 :: 		TRISC = 0b10011000;
	MOVLW      152
	MOVWF      TRISC+0
;LiquidMachine.c,263 :: 		TRISD = 0b11111111;
	MOVLW      255
	MOVWF      TRISD+0
;LiquidMachine.c,265 :: 		PORTA = 0x00;               // Initial value of PORTA;
	CLRF       PORTA+0
;LiquidMachine.c,266 :: 		PORTB = 0x00;           //declare initial state
	CLRF       PORTB+0
;LiquidMachine.c,267 :: 		PORTD=0b00000000;
	CLRF       PORTD+0
;LiquidMachine.c,269 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;LiquidMachine.c,270 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,271 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,274 :: 		T1CON = 0x10;                 //Initialize Timer Module
	MOVLW      16
	MOVWF      T1CON+0
;LiquidMachine.c,277 :: 		while(1){
L_main72:
;LiquidMachine.c,279 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,285 :: 		dist_cleanwatertan=Dist_CleanWaterTank() ;
	CALL       _Dist_CleanWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_cleanwatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_cleanwatertan+1
;LiquidMachine.c,286 :: 		dist_dirtywatertan= Dist_DirtyWaterTank();
	CALL       _Dist_DirtyWaterTank+0
	MOVF       R0+0, 0
	MOVWF      _dist_dirtywatertan+0
	MOVF       R0+1, 0
	MOVWF      _dist_dirtywatertan+1
;LiquidMachine.c,288 :: 		if((PORTD&0b10000000) && (!PORTD&0b010000000) && (!PORTD&0b00100000) ){
	BTFSS      PORTD+0, 7
	GOTO       L_main76
	MOVF       PORTD+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	BTFSS      R1+0, 7
	GOTO       L_main76
	MOVF       PORTD+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	BTFSS      R1+0, 5
	GOTO       L_main76
L__main150:
;LiquidMachine.c,289 :: 		i=1; //small
	MOVLW      1
	MOVWF      main_i_L0+0
	MOVLW      0
	MOVWF      main_i_L0+1
;LiquidMachine.c,290 :: 		}
	GOTO       L_main77
L_main76:
;LiquidMachine.c,291 :: 		else if((PORTD&0b10000000) && (PORTD&0b010000000) && (!PORTD&0b00100000) ){
	BTFSS      PORTD+0, 7
	GOTO       L_main80
	BTFSS      PORTD+0, 7
	GOTO       L_main80
	MOVF       PORTD+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	BTFSS      R1+0, 5
	GOTO       L_main80
L__main149:
;LiquidMachine.c,292 :: 		i=2;  //med
	MOVLW      2
	MOVWF      main_i_L0+0
	MOVLW      0
	MOVWF      main_i_L0+1
;LiquidMachine.c,293 :: 		}
	GOTO       L_main81
L_main80:
;LiquidMachine.c,294 :: 		else if((PORTD&0b10000000) && (PORTD&0b010000000) && (PORTD&0b00100000) ){
	BTFSS      PORTD+0, 7
	GOTO       L_main84
	BTFSS      PORTD+0, 7
	GOTO       L_main84
	BTFSS      PORTD+0, 5
	GOTO       L_main84
L__main148:
;LiquidMachine.c,295 :: 		i=3;     //large
	MOVLW      3
	MOVWF      main_i_L0+0
	MOVLW      0
	MOVWF      main_i_L0+1
;LiquidMachine.c,296 :: 		}else{i=0;}
	GOTO       L_main85
L_main84:
	CLRF       main_i_L0+0
	CLRF       main_i_L0+1
L_main85:
L_main81:
L_main77:
;LiquidMachine.c,299 :: 		if((dist_cleanwatertan>20)){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _dist_cleanwatertan+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main201
	MOVF       _dist_cleanwatertan+0, 0
	SUBLW      20
L__main201:
	BTFSC      STATUS+0, 0
	GOTO       L_main86
;LiquidMachine.c,301 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,303 :: 		Lcd_Out(1,1,"No Liquid");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,304 :: 		Lcd_Out(2,1,"Fill it");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,306 :: 		}
	GOTO       L_main87
L_main86:
;LiquidMachine.c,307 :: 		else if(dist_dirtywatertan<9){
	MOVLW      128
	XORWF      _dist_dirtywatertan+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main202
	MOVLW      9
	SUBWF      _dist_dirtywatertan+0, 0
L__main202:
	BTFSC      STATUS+0, 0
	GOTO       L_main88
;LiquidMachine.c,309 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,312 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,313 :: 		Lcd_Out(1,1,"DirtyTank!!") ;
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,315 :: 		if(PORTD&0b00010000){
	BTFSS      PORTD+0, 4
	GOTO       L_main89
;LiquidMachine.c,316 :: 		TRISC = 0b10011000;
	MOVLW      152
	MOVWF      TRISC+0
;LiquidMachine.c,317 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,318 :: 		while(PORTD&0b00010000){
L_main90:
	BTFSS      PORTD+0, 4
	GOTO       L_main91
;LiquidMachine.c,319 :: 		Lcd_Out(2,1,"PumpOn");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,320 :: 		TRISC = 0b10011000;
	MOVLW      152
	MOVWF      TRISC+0
;LiquidMachine.c,321 :: 		motor2(100);
	MOVLW      100
	MOVWF      FARG_motor2_speed1+0
	MOVLW      0
	MOVWF      FARG_motor2_speed1+1
	CALL       _motor2+0
;LiquidMachine.c,322 :: 		}
	GOTO       L_main90
L_main91:
;LiquidMachine.c,323 :: 		TRISC = 0b10011100;
	MOVLW      156
	MOVWF      TRISC+0
;LiquidMachine.c,324 :: 		}
L_main89:
;LiquidMachine.c,326 :: 		}else{
	GOTO       L_main92
L_main88:
;LiquidMachine.c,329 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,330 :: 		Lcd_Out(1,1,"Welcome");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr14_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,334 :: 		if(PORTD&0b00000001){
	BTFSS      PORTD+0, 0
	GOTO       L_main93
;LiquidMachine.c,337 :: 		ManualMode();
	CALL       _ManualMode+0
;LiquidMachine.c,339 :: 		}
	GOTO       L_main94
L_main93:
;LiquidMachine.c,340 :: 		else if(PORTD&0b00000010){
	BTFSS      PORTD+0, 1
	GOTO       L_main95
;LiquidMachine.c,342 :: 		if(i==3){
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main203
	MOVLW      3
	XORWF      main_i_L0+0, 0
L__main203:
	BTFSS      STATUS+0, 2
	GOTO       L_main96
;LiquidMachine.c,343 :: 		Large();
	CALL       _Large+0
;LiquidMachine.c,344 :: 		}
	GOTO       L_main97
L_main96:
;LiquidMachine.c,345 :: 		else if (i==2){
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main204
	MOVLW      2
	XORWF      main_i_L0+0, 0
L__main204:
	BTFSS      STATUS+0, 2
	GOTO       L_main98
;LiquidMachine.c,346 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,347 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,348 :: 		Lcd_Out(2,1,"Small Cup");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr15_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,349 :: 		msDelay(2000);
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,350 :: 		Medium ();
	CALL       _Medium+0
;LiquidMachine.c,351 :: 		}
	GOTO       L_main99
L_main98:
;LiquidMachine.c,352 :: 		else if (i==1){
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main205
	MOVLW      1
	XORWF      main_i_L0+0, 0
L__main205:
	BTFSS      STATUS+0, 2
	GOTO       L_main100
;LiquidMachine.c,353 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,354 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,356 :: 		Lcd_Out(2,1,"Small Cup");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr16_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,357 :: 		msDelay(2000);
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,358 :: 		Small();
	CALL       _Small+0
;LiquidMachine.c,359 :: 		}
	GOTO       L_main101
L_main100:
;LiquidMachine.c,361 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,362 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,363 :: 		Lcd_Out(2,1,"No Cup");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr17_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,364 :: 		msDelay(2000);//////////////////////////JHHHHHH
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,365 :: 		}
L_main101:
L_main99:
L_main97:
;LiquidMachine.c,366 :: 		}
	GOTO       L_main102
L_main95:
;LiquidMachine.c,367 :: 		else if(PORTD&0b00000100){
	BTFSS      PORTD+0, 2
	GOTO       L_main103
;LiquidMachine.c,368 :: 		if(i==2 || i==3){
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main206
	MOVLW      2
	XORWF      main_i_L0+0, 0
L__main206:
	BTFSC      STATUS+0, 2
	GOTO       L__main147
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main207
	MOVLW      3
	XORWF      main_i_L0+0, 0
L__main207:
	BTFSC      STATUS+0, 2
	GOTO       L__main147
	GOTO       L_main106
L__main147:
;LiquidMachine.c,369 :: 		Medium ();
	CALL       _Medium+0
;LiquidMachine.c,370 :: 		}
	GOTO       L_main107
L_main106:
;LiquidMachine.c,371 :: 		else if (i==1){
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main208
	MOVLW      1
	XORWF      main_i_L0+0, 0
L__main208:
	BTFSS      STATUS+0, 2
	GOTO       L_main108
;LiquidMachine.c,372 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,373 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,374 :: 		Lcd_Out(2,1,"Small Cup");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr18_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,375 :: 		msDelay(2000);
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,376 :: 		Small();
	CALL       _Small+0
;LiquidMachine.c,377 :: 		}
	GOTO       L_main109
L_main108:
;LiquidMachine.c,379 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,380 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,381 :: 		Lcd_Out(2,1,"No cup");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr19_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,382 :: 		msDelay(2000);
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,383 :: 		}
L_main109:
L_main107:
;LiquidMachine.c,384 :: 		}
	GOTO       L_main110
L_main103:
;LiquidMachine.c,385 :: 		else if(PORTD&0b00001000){
	BTFSS      PORTD+0, 3
	GOTO       L_main111
;LiquidMachine.c,386 :: 		if(i==1 || i==2 || i==3){
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main209
	MOVLW      1
	XORWF      main_i_L0+0, 0
L__main209:
	BTFSC      STATUS+0, 2
	GOTO       L__main146
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main210
	MOVLW      2
	XORWF      main_i_L0+0, 0
L__main210:
	BTFSC      STATUS+0, 2
	GOTO       L__main146
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main211
	MOVLW      3
	XORWF      main_i_L0+0, 0
L__main211:
	BTFSC      STATUS+0, 2
	GOTO       L__main146
	GOTO       L_main114
L__main146:
;LiquidMachine.c,387 :: 		Small();
	CALL       _Small+0
;LiquidMachine.c,388 :: 		}
	GOTO       L_main115
L_main114:
;LiquidMachine.c,389 :: 		else if (i==0) {
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main212
	MOVLW      0
	XORWF      main_i_L0+0, 0
L__main212:
	BTFSS      STATUS+0, 2
	GOTO       L_main116
;LiquidMachine.c,390 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,391 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,392 :: 		Lcd_Out(2,1,"No cup");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr20_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,393 :: 		msDelay(2000);
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,394 :: 		}
L_main116:
L_main115:
;LiquidMachine.c,395 :: 		}
	GOTO       L_main117
L_main111:
;LiquidMachine.c,396 :: 		else if(PORTC&0b00010000){
	BTFSS      PORTC+0, 4
	GOTO       L_main118
;LiquidMachine.c,397 :: 		if(i==1){
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main213
	MOVLW      1
	XORWF      main_i_L0+0, 0
L__main213:
	BTFSS      STATUS+0, 2
	GOTO       L_main119
;LiquidMachine.c,398 :: 		Small();
	CALL       _Small+0
;LiquidMachine.c,399 :: 		}
	GOTO       L_main120
L_main119:
;LiquidMachine.c,400 :: 		else if (i==2){
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main214
	MOVLW      2
	XORWF      main_i_L0+0, 0
L__main214:
	BTFSS      STATUS+0, 2
	GOTO       L_main121
;LiquidMachine.c,401 :: 		Medium ();
	CALL       _Medium+0
;LiquidMachine.c,402 :: 		}
	GOTO       L_main122
L_main121:
;LiquidMachine.c,403 :: 		else if (i==3){
	MOVLW      0
	XORWF      main_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main215
	MOVLW      3
	XORWF      main_i_L0+0, 0
L__main215:
	BTFSS      STATUS+0, 2
	GOTO       L_main123
;LiquidMachine.c,404 :: 		Large();
	CALL       _Large+0
;LiquidMachine.c,405 :: 		}
	GOTO       L_main124
L_main123:
;LiquidMachine.c,407 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,408 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,409 :: 		Lcd_Out(2,1,"No cup");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr21_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,410 :: 		msDelay(2000);
	MOVLW      208
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      7
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,411 :: 		}
L_main124:
L_main122:
L_main120:
;LiquidMachine.c,412 :: 		}
	GOTO       L_main125
L_main118:
;LiquidMachine.c,413 :: 		else if(PORTD&0b00010000){
	BTFSS      PORTD+0, 4
	GOTO       L_main126
;LiquidMachine.c,414 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LiquidMachine.c,415 :: 		while(PORTD&0b00010000){
L_main127:
	BTFSS      PORTD+0, 4
	GOTO       L_main128
;LiquidMachine.c,416 :: 		Lcd_Out(2,1,"PumpOn");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr22_LiquidMachine+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LiquidMachine.c,417 :: 		TRISC = 0b10011000;
	MOVLW      152
	MOVWF      TRISC+0
;LiquidMachine.c,418 :: 		motor2(100);
	MOVLW      100
	MOVWF      FARG_motor2_speed1+0
	MOVLW      0
	MOVWF      FARG_motor2_speed1+1
	CALL       _motor2+0
;LiquidMachine.c,419 :: 		}
	GOTO       L_main127
L_main128:
;LiquidMachine.c,420 :: 		TRISC = 0b10011100;
	MOVLW      156
	MOVWF      TRISC+0
;LiquidMachine.c,421 :: 		}
	GOTO       L_main129
L_main126:
;LiquidMachine.c,424 :: 		TRISC = 0b10011100;
	MOVLW      156
	MOVWF      TRISC+0
;LiquidMachine.c,425 :: 		}
L_main129:
L_main125:
L_main117:
L_main110:
L_main102:
L_main94:
;LiquidMachine.c,426 :: 		}
L_main92:
L_main87:
;LiquidMachine.c,431 :: 		msDelay(200);
	MOVLW      200
	MOVWF      FARG_msDelay_msCnt+0
	CLRF       FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;LiquidMachine.c,432 :: 		}
	GOTO       L_main72
;LiquidMachine.c,434 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
