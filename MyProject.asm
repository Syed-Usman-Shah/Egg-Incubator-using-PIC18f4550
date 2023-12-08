
_StartSignal:

;MyProject.c,25 :: 		void StartSignal(){
;MyProject.c,26 :: 		TRISD.F0 = 0;    //Configure RD0 as output
	BCF         TRISD+0, 0 
;MyProject.c,27 :: 		PORTD.F0 = 0;    //RD0 sends 0 to the sensor
	BCF         PORTD+0, 0 
;MyProject.c,28 :: 		delay_ms(18);
	MOVLW       117
	MOVWF       R12, 0
	MOVLW       225
	MOVWF       R13, 0
L_StartSignal0:
	DECFSZ      R13, 1, 1
	BRA         L_StartSignal0
	DECFSZ      R12, 1, 1
	BRA         L_StartSignal0
;MyProject.c,29 :: 		PORTD.F0 = 1;    //RD0 sends 1 to the sensor
	BSF         PORTD+0, 0 
;MyProject.c,30 :: 		delay_us(30);
	MOVLW       49
	MOVWF       R13, 0
L_StartSignal1:
	DECFSZ      R13, 1, 1
	BRA         L_StartSignal1
	NOP
	NOP
;MyProject.c,31 :: 		TRISD.F0 = 1;    //Configure RD0 as input
	BSF         TRISD+0, 0 
;MyProject.c,32 :: 		}
L_end_StartSignal:
	RETURN      0
; end of _StartSignal

_CheckResponse:

;MyProject.c,34 :: 		void CheckResponse(){
;MyProject.c,35 :: 		Check = 0;
	CLRF        _Check+0 
;MyProject.c,36 :: 		delay_us(40);
	MOVLW       66
	MOVWF       R13, 0
L_CheckResponse2:
	DECFSZ      R13, 1, 1
	BRA         L_CheckResponse2
	NOP
;MyProject.c,37 :: 		if (PORTD.F0 == 0){
	BTFSC       PORTD+0, 0 
	GOTO        L_CheckResponse3
;MyProject.c,38 :: 		delay_us(80);
	MOVLW       133
	MOVWF       R13, 0
L_CheckResponse4:
	DECFSZ      R13, 1, 1
	BRA         L_CheckResponse4
;MyProject.c,39 :: 		if (PORTD.F0 == 1)   Check = 1;   delay_us(40);}
	BTFSS       PORTD+0, 0 
	GOTO        L_CheckResponse5
	MOVLW       1
	MOVWF       _Check+0 
L_CheckResponse5:
	MOVLW       66
	MOVWF       R13, 0
L_CheckResponse6:
	DECFSZ      R13, 1, 1
	BRA         L_CheckResponse6
	NOP
L_CheckResponse3:
;MyProject.c,40 :: 		}
L_end_CheckResponse:
	RETURN      0
; end of _CheckResponse

_ReadData:

;MyProject.c,42 :: 		char ReadData(){
;MyProject.c,44 :: 		for(j = 0; j < 8; j++){
	CLRF        R3 
L_ReadData7:
	MOVLW       8
	SUBWF       R3, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_ReadData8
;MyProject.c,45 :: 		while(!PORTD.F0); //Wait until PORTD.F0 goes HIGH
L_ReadData10:
	BTFSC       PORTD+0, 0 
	GOTO        L_ReadData11
	GOTO        L_ReadData10
L_ReadData11:
;MyProject.c,46 :: 		delay_us(30);
	MOVLW       49
	MOVWF       R13, 0
L_ReadData12:
	DECFSZ      R13, 1, 1
	BRA         L_ReadData12
	NOP
	NOP
;MyProject.c,47 :: 		if(PORTD.F0 == 0)
	BTFSC       PORTD+0, 0 
	GOTO        L_ReadData13
;MyProject.c,48 :: 		i&= ~(1<<(7 - j));  //Clear bit (7-b)
	MOVF        R3, 0 
	SUBLW       7
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       R1 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
L__ReadData31:
	BZ          L__ReadData32
	RLCF        R0, 1 
	BCF         R0, 0 
	ADDLW       255
	GOTO        L__ReadData31
L__ReadData32:
	COMF        R0, 1 
	MOVF        R0, 0 
	ANDWF       R2, 1 
	GOTO        L_ReadData14
L_ReadData13:
;MyProject.c,49 :: 		else {i|= (1 << (7 - j));  //Set bit (7-b)
	MOVF        R3, 0 
	SUBLW       7
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       R1 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
L__ReadData33:
	BZ          L__ReadData34
	RLCF        R0, 1 
	BCF         R0, 0 
	ADDLW       255
	GOTO        L__ReadData33
L__ReadData34:
	MOVF        R0, 0 
	IORWF       R2, 1 
;MyProject.c,50 :: 		while(PORTD.F0);}  //Wait until PORTD.F0 goes LOW
L_ReadData15:
	BTFSS       PORTD+0, 0 
	GOTO        L_ReadData16
	GOTO        L_ReadData15
L_ReadData16:
L_ReadData14:
;MyProject.c,44 :: 		for(j = 0; j < 8; j++){
	INCF        R3, 1 
;MyProject.c,51 :: 		}
	GOTO        L_ReadData7
L_ReadData8:
;MyProject.c,52 :: 		return i;
	MOVF        R2, 0 
	MOVWF       R0 
;MyProject.c,53 :: 		}
L_end_ReadData:
	RETURN      0
; end of _ReadData

_main:

;MyProject.c,57 :: 		void main() {
;MyProject.c,58 :: 		ADCON0 = 0x00;
	CLRF        ADCON0+0 
;MyProject.c,59 :: 		ADCON1 = 0x0f;                    // Configure all PORTB pins as digital
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,60 :: 		TRISD.F1 = 0;
	BCF         TRISD+0, 1 
;MyProject.c,61 :: 		TRISC=0x00;
	CLRF        TRISC+0 
;MyProject.c,62 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;MyProject.c,63 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);        // cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,64 :: 		Lcd_Cmd(_LCD_CLEAR);            // clear LCD
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,65 :: 		while(1){
L_main17:
;MyProject.c,66 :: 		StartSignal();
	CALL        _StartSignal+0, 0
;MyProject.c,67 :: 		CheckResponse();
	CALL        _CheckResponse+0, 0
;MyProject.c,68 :: 		if(Check == 1){
	MOVF        _Check+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main19
;MyProject.c,69 :: 		RH_byte1 = ReadData();
	CALL        _ReadData+0, 0
	MOVF        R0, 0 
	MOVWF       _RH_byte1+0 
;MyProject.c,70 :: 		RH_byte2 = ReadData();
	CALL        _ReadData+0, 0
	MOVF        R0, 0 
	MOVWF       _RH_byte2+0 
;MyProject.c,71 :: 		T_byte1 = ReadData();
	CALL        _ReadData+0, 0
	MOVF        R0, 0 
	MOVWF       _T_byte1+0 
;MyProject.c,72 :: 		T_byte2 = ReadData();
	CALL        _ReadData+0, 0
	MOVF        R0, 0 
	MOVWF       _T_byte2+0 
;MyProject.c,73 :: 		Sum = ReadData();
	CALL        _ReadData+0, 0
	MOVF        R0, 0 
	MOVWF       _Sum+0 
	MOVLW       0
	MOVWF       _Sum+1 
;MyProject.c,74 :: 		if(Sum == ((RH_byte1+RH_byte2+T_byte1+T_byte2) & 0XFF)){
	MOVF        _RH_byte2+0, 0 
	ADDWF       _RH_byte1+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _T_byte1+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _T_byte2+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        _Sum+1, 0 
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main36
	MOVF        R2, 0 
	XORWF       _Sum+0, 0 
L__main36:
	BTFSS       STATUS+0, 2 
	GOTO        L_main20
;MyProject.c,75 :: 		Temp = T_byte1;
	MOVF        _T_byte1+0, 0 
	MOVWF       _Temp+0 
	MOVLW       0
	MOVWF       _Temp+1 
;MyProject.c,76 :: 		RH = RH_byte1;
	MOVF        _RH_byte1+0, 0 
	MOVWF       _RH+0 
	MOVLW       0
	MOVWF       _RH+1 
;MyProject.c,77 :: 		Lcd_Out(1, 6, "Temp:   C");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,78 :: 		Lcd_Out(2, 2, "Humidity:   %");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,79 :: 		LCD_Chr(1, 12, 48 + ((Temp / 10) % 10));
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _Temp+0, 0 
	MOVWF       R0 
	MOVF        _Temp+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,80 :: 		LCD_Chr(1, 13, 48 + (Temp % 10));
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _Temp+0, 0 
	MOVWF       R0 
	MOVF        _Temp+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,81 :: 		LCD_Chr(2, 12, 48 + ((RH / 10) % 10));
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _RH+0, 0 
	MOVWF       R0 
	MOVF        _RH+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,82 :: 		LCD_Chr(2, 13, 48 + (RH % 10));
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _RH+0, 0 
	MOVWF       R0 
	MOVF        _RH+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,83 :: 		}
	GOTO        L_main21
L_main20:
;MyProject.c,85 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);        // cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,86 :: 		Lcd_Cmd(_LCD_CLEAR);             // clear LCD
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,87 :: 		Lcd_Out(1, 1, "Check sum error");}
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_main21:
;MyProject.c,88 :: 		}
	GOTO        L_main22
L_main19:
;MyProject.c,90 :: 		Lcd_Out(1, 3, "No response");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,91 :: 		Lcd_Out(2, 1, "from the sensor");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,92 :: 		}
L_main22:
;MyProject.c,93 :: 		delay_ms(1000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main23:
	DECFSZ      R13, 1, 1
	BRA         L_main23
	DECFSZ      R12, 1, 1
	BRA         L_main23
	DECFSZ      R11, 1, 1
	BRA         L_main23
	NOP
;MyProject.c,99 :: 		if(Temp > 35)
	MOVLW       0
	MOVWF       R0 
	MOVF        _Temp+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main37
	MOVF        _Temp+0, 0 
	SUBLW       35
L__main37:
	BTFSC       STATUS+0, 0 
	GOTO        L_main24
;MyProject.c,101 :: 		portc.f2=1;
	BSF         PORTC+0, 2 
;MyProject.c,102 :: 		portc.f1=0;
	BCF         PORTC+0, 1 
;MyProject.c,103 :: 		}
L_main24:
;MyProject.c,104 :: 		if(Temp < 20)
	MOVLW       0
	SUBWF       _Temp+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main38
	MOVLW       20
	SUBWF       _Temp+0, 0 
L__main38:
	BTFSC       STATUS+0, 0 
	GOTO        L_main25
;MyProject.c,106 :: 		portc.f2=0;
	BCF         PORTC+0, 2 
;MyProject.c,107 :: 		portc.f1=1;
	BSF         PORTC+0, 1 
;MyProject.c,108 :: 		}
L_main25:
;MyProject.c,109 :: 		if(RH<50)
	MOVLW       0
	SUBWF       _RH+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main39
	MOVLW       50
	SUBWF       _RH+0, 0 
L__main39:
	BTFSC       STATUS+0, 0 
	GOTO        L_main26
;MyProject.c,111 :: 		portc.f7=0;
	BCF         PORTC+0, 7 
;MyProject.c,112 :: 		}
L_main26:
;MyProject.c,113 :: 		if(RH>80)
	MOVLW       0
	MOVWF       R0 
	MOVF        _RH+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main40
	MOVF        _RH+0, 0 
	SUBLW       80
L__main40:
	BTFSC       STATUS+0, 0 
	GOTO        L_main27
;MyProject.c,115 :: 		portc.f7=1;
	BSF         PORTC+0, 7 
;MyProject.c,116 :: 		}
L_main27:
;MyProject.c,117 :: 		}
	GOTO        L_main17
;MyProject.c,118 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
