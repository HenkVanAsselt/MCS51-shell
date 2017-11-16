
; +-------------------------------------------------------------------------+
; | FILE: PERIPH.ASM                                                        |
; |                                                                         |
; | last edit: 25.08.1990 - J.P. Groenweg                                   |
; |                                                                         |
; | This file contains assembly routines to interface peripherals           |
; |                                                                         |
; | Supported Peripherals:             Base Address:       Interrupt:       |
; |                                                                         |
; | 146818 Real Time Clock             8000h               External Int 0   |
; | HD44780 based LCD                  8100h               none             |
; | 74922 Key Encoder                  8200h               External Int 1   |
; | LTC1290 AD Convertor               I/O Mapped          none             |
; | AD7542 DA Convertor                8400h               none             |
; | 82C55 Port Expander                8300h               none             |
; +-------------------------------------------------------------------------+

$DEBUG

               NAME PERIPH
               
               USING 3
               USING 2
               USING 1
               USING 0

; +---------------------------------------------------------------------------+
; | CONSTANTS                                                                 |
; +---------------------------------------------------------------------------+

DISPCONTR      EQU 8100H               ; Display Control Register
DISPWRITE      EQU 8101H               ; Display Write Register
DISPBUSY       EQU 8102H               ; Display Address Read / Busy Read
DISPREAD       EQU 8103H               ; Display contents Read

CS             EQU P1.0                ; Chip Select for LTC1290 ADC
SCLK           EQU P1.3                ; Serial Clock for ADC
DIN            EQU P1.2                ; Data In line for ADC
DOUT           EQU P1.1                ; Data Out from ADC

RTCBASE        EQU 8000H               ; Base Address for RTC
KEYBASE        EQU 8200H               ; Base Address for 74922 Keyboard Enc.
DACBASE        EQU 8400H               ; Base Address for DA Convertor

; +---------------------------------------------------------------------------+
; | DATA                                                                      |
; +---------------------------------------------------------------------------+

               ?ADC_DRV?D SEGMENT DATA
               RSEG ?ADC_DRV?D

PUBLIC         Param0_                  ; Byte used for Parameter Passing
Param0_:       DS 01                    ; Size is 1 byte
PUBLIC         Param1_                  ; Byte used for Parameter Passing
Param1_:       DS 01                    ; Size is 1 byte
PUBLIC         Param2_                  ; Byte used for Parameter Passing
Param2_:       DS 01                    ; Size is 1 byte
PUBLIC         Param3_                  ; Byte used for Parameter Passing
Param3_:       DS 01                    ; Size is 1 byte
PUBLIC         Param4_                  ; Byte used for Parameter Passing
Param4_:       DS 01                    ; Size is 1 byte
PUBLIC         Param5_                  ; Byte used for Parameter Passing
Param5_:       DS 01                    ; Size is 1 byte
PUBLIC         Param6_                  ; Byte used for Parameter Passing
Param6_:       DS 01                    ; Size is 1 byte
PUBLIC         Param7_                  ; Byte used for Parameter Passing
Param7_:       DS 01                    ; Size is 1 byte
PUBLIC         KeyStatus
PUBLIC         RTCStatus
KeyStatus:     DS 01                    ; Keyboard status and Character Code
RTCStatus:     DS 01                    ; Real Time Clock Status

PUBLIC         GetTime?RET              ; All Function return values
GetTime?RET    EQU Param0_              ; use the same memory addresses
PUBLIC         GetAlarm?RET             ;
GetAlarm?RET   EQU Param0_              ; Because only one Function uses
PUBLIC         GetDate?RET              ; this memory at a certain time
GetDate?RET    EQU Param0_              ; no problems will occur
PUBLIC         ReadKey?RET              ;
ReadKey?RET    EQU Param0_              ; The reason is to save as much 
PUBLIC         ADCONVERT?RET            ; internal DATA memory as possible
ADCONVERT?RET  EQU Param0_              ;
                                         
; +---------------------------------------------------------------------------+
; | BIT ADRESSABLE DATA SEGMENT                                               |
; +---------------------------------------------------------------------------+

               ?PERIPH?B SEGMENT BIT
               RSEG ?PERIPH?B
PUBLIC         BitParam0_               ; General Purpose Data Bit
BitParam0_:    DS 01H                   ; Size is 1 bit
PUBLIC         KeyPressed?RET           ; 
KeyPressed?RET EQU BitParam0_           ; 


; +---------------------------------------------------------------------------+
; | CODE                                                                      |
; +---------------------------------------------------------------------------+
               ?PERIPH?C SEGMENT CODE
               RSEG ?PERIPH?C

; +---------------------------------------------------------------------------+
; | RTCBUSY                                                                   |
; |                                                                           |
; | This routine checks the Update In Progress flag of the RTC                |
; +---------------------------------------------------------------------------+

RTCBUSY:       PUSH DPL                 ; Save DPTR using DPL
               PUSH DPH                 ; and DPH
               PUSH A                   ; Save Accu
               MOV  DPTR,#RTCBASE+0AH   ; RTC Register A address
UPDATE:        MOVX A,@DPTR             ; Get Register A contents
               JB   ACC.7,UPDATE        ; If set, update is in progress => WAIT
               POP  A                   ; Restore Accu
               POP  DPH                 ; Restore DPTR using DPH
               POP  DPL                 ; and DPL
               RET                      ; and return to CALLer

; +---------------------------------------------------------------------------+
; | TIMEGET is used by GetTime & GetAlarm                                     | 
; |                                                                           |
; | Loads Param2_ with  @DPTR+0                                               |
; |       Param1_ with  @DPTR+2                                               |
; |       Param0_ with  @DPTR+4                                               |
; +---------------------------------------------------------------------------+

TIMEGET:       MOV  DPTR,#RTCBASE+00H   ; Seconds address of RTC
               CJNE A,#01,NO_ALARM      ; ALARM or TIME set ?
               INC  DPTR                ; IF ALARM then Increase DPTR
NO_ALARM:      CALL RTCBUSY             ; Make sure no update is in progress
               MOVX A,@DPTR             ; Get seconds from RTC
               MOV  Param2_,A           ; and store in Param2_
               INC  DPTR                ; Increase DPTR
               INC  DPTR                ; to Minutes adress of RTC
               MOVX A,@DPTR             ; Get Minutes from RTC
               MOV  Param1_,A           ; and store in Param1_
               INC  DPTR                ; Increase DPTR
               INC  DPTR                ; to Hours address of RTC
               MOVX A,@DPTR             ; Get Hours from RTC
               MOV  Param0_,A           ; and store in Param0_
               RET                      ; And return to CALLer

; +---------------------------------------------------------------------------+
; | FUNCTION export GetTime : Time DATA;                                      |
; |                                                                           |
; | This routine gets the time from the Real Time Clock                       |
; |                                                                           |
; | Param0_         Hours                                                     |
; | Param1_         Minutes                                                   |
; | Param2_         Seconds   (all are in binary format)                      |
; +---------------------------------------------------------------------------+

PUBLIC         GetTime
GetTime:       MOV  A,#00H              ; Indicate get TIME
               CALL TIMEGET             ; Get Param0_ .. Param2_ from RTC
               RET                      ; and return to CALLer

; +---------------------------------------------------------------------------+
; | FUNCTION export GetAlarm_: Time DATA;                                     |
; |                                                                           |
; | This routine gets the alarm from the Real Time Clock                      |
; |                                                                           |
; | Param0_         Hours                                                     |
; | Param1_         Minutes                                                   |
; | Param2_         Seconds   (all are in binary format)                      |
; +---------------------------------------------------------------------------+

PUBLIC         GetAlarm
GetAlarm:      MOV  A,#01H              ; Indicate get ALARM
               CALL TIMEGET             ; Get Param0_ .. Param2_ from RTC
               RET                      ; and return to CALLer


; +---------------------------------------------------------------------------+
; | TIMESET is used by SetTime & SetAlarm                                     | 
; |                                                                           |
; | Loads DPTR+0 with Param2_                                                 |
; |       DPTR+2 with Param1_                                                 |
; |       DPTR+4 with Param0_                                                |
; +---------------------------------------------------------------------------+

TIMESET:       PUSH A                   ; Save Accu (Time or Alarm set Param)
               MOV  DPTR,#RTCBASE+0BH   ; RTC register 0B address
               MOVX A,@DPTR             ; Read register 0B value
               ORL  A,#10000110B        ; Disable update cycle, binary format
               MOVX @DPTR,A             ; and 24 hour mode
               MOV  DPTR,#RTCBASE+00H   ; Seconds address of RTC
               POP  A                   ; Restore Accu
               CJNE A,#01,NO_ALARM2     ; ALARM or TIME set ?
               INC  DPTR                ; IF ALARM then Increase DPTR
NO_ALARM2:     MOV  A,Param2_           ; Get Seconds parameter
               MOVX @DPTR,A             ; Store Seconds
               INC  DPTR                ; Increase DPTR
               INC  DPTR                ; to Minutes adress of RTC
               MOV  A,Param1_           ; Get Minutes Parameter
               MOVX @DPTR,A             ; Store Minutes
               INC  DPTR                ; Increase DPTR
               INC  DPTR                ; to Hours address of RTC
               MOV  A,Param0_           ; Get Hours Parameter
               MOVX @DPTR,A             ; Store Hours
               MOV  DPTR,#RTCBASE+0BH   ; RTC register 0B address
               MOVX A,@DPTR             ; Read register 0B value
               ANL  A,#01111111B        ; Clear SET bit (enable update cycle)
               MOVX @DPTR,A             ; Write register
               RET                      ; And return to CALLer
                       
; +---------------------------------------------------------------------------+
; | PROCEDURE export SetTime(Param0_ : Time DATA);                            |
; |                                                                           |
; | This routine sets the time of the Real Time Clock                         |
; |                                                                           |
; | Param0_         Hours                                                     |
; | Param0_+1       Minutes                                                   |
; | Param0_+2       Seconds   (all are in binary format)                      |
; +---------------------------------------------------------------------------+

PUBLIC         SetTime
SetTime:       MOV  A,#00H              ; Indicate Set TIME
               CALL TIMESET             ; Store Param0_ .. Param2_ in RTC
               RET                      ; and return to CALLer

; +---------------------------------------------------------------------------+
; | PROCEDURE export SetAlarm(Param0_ : Time DATA);                           |
; |                                                                           |
; | This routine sets the alarm of the Real Time Clock                        |
; |                                                                           |
; | Param0_         Hours                                                     |
; | Param0_+1       Minutes                                                   |
; | Param0_+2       Seconds   (all are in binary format)                      |
; +---------------------------------------------------------------------------+

PUBLIC         SetAlarm
SetAlarm:      MOV  A,#01H              ; Indicate Set ALARM
               CALL TIMESET             ; Store Param0_ .. Param2_ in RTC
               RET                      ; and return to CALLer

; +---------------------------------------------------------------------------+
; | PROCEDURE export SetDate(Param0_ : Date DATA);                            |
; |                                                                           |
; | This routine sets the alarm of the Real Time Clock                        |
; |                                                                           |
; | Param0_         Day                                                       |
; | Param0_+1       Month                                                     |
; | Param0_+2       Year      (all are in binary format)                      |
; +---------------------------------------------------------------------------+

PUBLIC         SetDate
SetDate:       MOV  DPTR,#RTCBASE+0BH   ; RTC Register 0B
               MOVX A,@DPTR             ; Read Register value
               ORL  A,#100000110B       ; Disable update cycle, binary format
               MOVX @DPTR,A             ; and 24 hour mode
               MOV  DPTR,#RTCBASE+07H   ; Day register
               MOV  A,Param0_           ; Get Day parameter
               MOVX @DPTR,A             ; Store in RTC Day register
               INC  DPTR                ; Increase DPTR to Month register
               MOV  A,Param1_           ; Get Month parameter
               MOVX @DPTR,A             ; Store in RTC Month register
               INC  DPTR                ; Increase DPTR to Year register
               MOV  A,Param2_           ; Get Year parameter
               MOVX @DPTR,A             ; Store in RTC Year register
               MOV  DPTR,#RTCBASE+0BH   ; RTC Register 0B
               MOVX A,@DPTR             ; Read value
               ANL  A,#01111111B        ; Clear SET bit (enable update)
               MOVX @DPTR,A             ; Write to register
               RET                      ; And return to CALLer
               
; +---------------------------------------------------------------------------+
; | FUNCTION export GetDate : Date DATA;                                      |
; |                                                                           |
; | This routine gets the time from the Real Time Clock                       |
; |                                                                           |
; | GetDate?RET+0   Day                                                       |
; | GetDate?RET+1   Month                                                     |
; | GetDate?RET+2   Year      (all are in binary format)                      |
; +---------------------------------------------------------------------------+

PUBLIC         GetDate
GetDate:       CALL RTCBUSY             ; Make sure RTC is not in update cycle
               MOV  DPTR,#RTCBASE+07H   ; RTC Day register address
               MOVX A,@DPTR             ; Read Day from RTC
               MOV  GetDate?RET+0,A     ; Store in Day parameter
               INC  DPTR                ; Set DPTR to Month address
               MOVX A,@DPTR             ; Read Month from RTC
               MOV  GetDate?RET+1,A     ; Store in Month parameter
               INC  DPTR                ; Set DPTR to Year address
               MOVX A,@DPTR             ; Read Year from RTC
               MOV  GetDate?RET+2,A     ; Store in Year parameter
               RET                      ; And return to CALLer
                       
; +---------------------------------------------------------------------------+
; | INTERRUPT0                                                                |
; |                                                                           |
; | Interrupt 0 service routine                                               |
; | Determines which Interrupt Caused the Interrupt Call                      |
; +---------------------------------------------------------------------------+

INTERRUPT0:    PUSH DPL                 ; Save DPTR using DPL
               PUSH DPH                 ; and DPH
               PUSH A                   ; Save  Accu
               MOV  DPTR,#RTCBASE+0CH   ; RTC Register 0C
               MOVX A,@DPTR             ; Read Register
               SWAP A                   ; Swap LSN(ibble) & MSN(ibble)
               MOV  RTCStatus,A         ; Store in Status 
               POP  A                   ; Restore Accu
               POP  DPH                 ; Restore DPTR using DPH
               POP  DPL                 ; and DPL
               RETI                     ; Return from Interrupt

; +---------------------------------------------------------------------------+
; | BUSYCHECK                                                                 |
; |                                                                           |
; | This routine waits until the busy flag is of LCD is low                   |
; |                                                                           |
; | CAUTION: The routine destroys DPTR contents                               |
; +---------------------------------------------------------------------------+
                                                                                 
BUSYCHECK:     PUSH A                   ; Save Accu to stack
               MOV  DPTR,#DISPBUSY      ; Busy / Address Read Register
WAITBUSY:      MOVX A,@DPTR             ; Read Busy flag and Address
               MOVX A,@DPTR             ; Double check
               JB   ACC.7,WAITBUSY      ; If High then check again
               POP  A                   ; Restore Accu
               RET                      ; And return to CALLer
               
; +---------------------------------------------------------------------------+
; | PROCEDURE export ClrScr;                                                  |
; |                                                                           |
; | This routine clears the LCD and sets the cursor to position (1,1)         |
; +---------------------------------------------------------------------------+

PUBLIC         ClrScr
ClrScr:        CALL BUSYCHECK           ; Check LCD busy flag
               MOV  DPTR,#DISPCONTR     ; Display Controll register
               MOV  A,#00000001B        ; Clear display code
               MOVX @DPTR,A             ; Write register
               RET                      ; And return to CALLer
               
; +---------------------------------------------------------------------------+
; | PROCEDURE export GotoXY(Param0_,Param1_:BYTE DATA);                       |
; |                                                                           |
; | This routine moves the cursor on the LCD to position Param0_,Param1_      |
; +---------------------------------------------------------------------------+

PUBLIC         GotoXY                   ; Public routine
GotoXY:        MOV  A,Param0_           ; Get X coordinate
               DEC  A                   ; Correct 1,1 <=> 0,0 coordinates
               MOV  R2,Param1_          ; Get Y coordinate
               CJNE R2,#002H,GotoXY0    ; Is Y second line ?
               ADD  A,#040H             ; Yes => Add Offset
GotoXY0:       CJNE R2,#003H,GotoXY1    ; Is Y third line ?
               ADD  A,#014H             ; Yes => Add Offset
GotoXY1:       CJNE R2,#004H,GotoXY2    ; Is Y fourth line ?
               ADD  A,#054H             ; Yes => Add Offset 
GotoXY2:       ORL  A,#10000000B        ; Set bit 8 (Function set DD RAM Addr)
               CALL BUSYCHECK           ; Check Busy flag
               MOV  DPTR,#DISPCONTR     ; LCD Control Register
               MOVX @DPTR,A             ; Write value to Control Register
               RET                      ; And return to PASCAL program
               
; +---------------------------------------------------------------------------+
; | PROCEDURE export Cursor(Param0_:BYTE DATA);                               |
; |                                                                           |
; | This routine defines the cursor:                                          |
; |                                                                           |
; | Cursor(0);      No Cursor, No BLINK                                       |
; | Cursor(1);      No Cursor, BLINK                                          |
; | Cursor(2);      Cursor, No BLINK                                          |
; | Cursor(3);      Cursor, BLINK                                             |
; +---------------------------------------------------------------------------+
               
PUBLIC         Cursor                   ; Public routine
Cursor:        MOV  A,Param0_           ; Get Parameter
               ANL  A,#00000011B        ; Isolate two LSB(its)
               ORL  A,#00001100B        ; Cursor Display Control for HD44780
               CALL BUSYCHECK           ; Check Busy flag
               MOV  DPTR,#DISPCONTR     ; LCD Control Register
               MOVX @DPTR,A             ; Write value to Control Register
               RET                      ; And return to PASCAL program
              
; +---------------------------------------------------------------------------+
; | PROCEDURE export DefChr(Param0_,Param1_,Param2_,Param3_,Param4_,          |
; |                         Param5_,Param6_,Param7_: BYTE DATA)               |
; |                                                                           |
; | This routine redefines a user definable character on the LCD              |
; |                                                                           |
; | Param0_            : Character code                                       |
; | Param1_ .. Param7_ : Character mask                                       |
; +---------------------------------------------------------------------------+

PUBLIC         DefChr
DefChr:        MOV  A,R0                ; Save R0
               PUSH A                   ; using Accu
               MOV  DPTR,#DISPBUSY      ; Busy / Address flag
LOOPBUSY:      MOVX A,@DPTR             ; Read busy flag & address
               MOVX A,@DPTR             ; Double check
               JB   ACC.7,LOOPBUSY      ; Loop until busy flag = 0
               ANL  A,#01111111B        ; Isolate address bits
               PUSH A                   ; Save address to stack
               MOV  A,Param0_           ; Get character code
               RLC  A                   ; Multiply by 8
               RLC  A                   ; using RLC
               RLC  A                   ;
               ANL  A,#00111000B        ; Isolate Character code bits
               ORL  A,#01000000B        ; Set CG RAM address
               CALL BUSYCHECK           ; Check LCD busy flag
               MOV  DPTR,#DISPCONTR     ; Display Control Register
               MOVX @DPTR,A             ; Write register
               MOV  R0,#Param1_         ; Get first mask byte address
DefChrLOOP:    CALL BUSYCHECK           ; Check LCD busy flag
               MOV  DPTR,#DISPWRITE     ; Display Write Address 
               MOV  A,@R0               ; Get mask byte
               MOVX @DPTR,A             ; Write mask byte
               INC  R0                  ; Increase Pointer
               CJNE R0,#Param7_+1,DefChrLOOP ; Repeat for next mask bytes
               CALL BUSYCHECK           ; Check busy flag
               MOV  DPTR,#DISPWRITE     ; Display write register
               CLR  A                   ; Clear Accu 
               MOVX @DPTR,A             ; to Clear cursor Line on Defined Char
               POP  A                   ; restore display address
               ORL  A,#10000000B        ; Address set code
               CALL BUSYCHECK           ; Check LCD busy flag
               MOV  DPTR,#DISPCONTR     ; Display Controll register
               MOVX @DPTR,A             ; Write register
               POP  A                   ; Restore R0 
               MOV  R0,A                ; using Accu
               RET                      ; And return to CALLer
               
; +---------------------------------------------------------------------------+
; | FUNCTION export ReadKey : CHAR DATA                                       |
; |                                                                           |
; | Returns the Character Code from the last Key that was Pressed             |
; | If this Key has been read before, bit 7 is set                            |
; +---------------------------------------------------------------------------+

KeyTable:      DB   'C1470258E369. <>'  ; ASCII codes for KeyPad

PUBLIC         ReadKey
ReadKey:       MOV  A,KeyStatus         ; Get Status and ScanCode
               ANL  A,#00001111B        ; Filter ScanCode
               MOV  DPTR,#KeyTable      ; DPTR points to KeyTable
               MOVC A,@A+DPTR           ; Get ASCII value
               MOV  B,A                 ; Save ASCII in B register
               MOV  A,KeyStatus         ; Get Status and ScanCode
               ANL  A,#10000000B        ; Filter Status
               ORL  A,B                 ; Status + ASCII in Accu
               MOV  ReadKey?RET,A       ; Store in ReadKey?RET
               MOV  A,KeyStatus         ; Get Status and ScanCode
               ORL  A,#10000000B        ; Set Status to 'Char already Read'
               MOV  KeyStatus,A         ; Store Status and ScanCode
               RET                      ; And Return to CALLer

; +---------------------------------------------------------------------------+
; | FUNCTION export KeyPressed : BOOLEAN DATA                                 |
; |                                                                           |
; | Returns TRUE if a key has been pressed, otherwise FALSE                   |
; +---------------------------------------------------------------------------+

PUBLIC         KeyPressed
KeyPressed:    MOV  A,KeyStatus         ; Read Keyboard Status byte
               RLC  A                   ; Rotate Bit 7 into Carry
               CPL  C                   ; Complement value
               MOV  KeyPressed?RET,C    ; Store Return value
               RET                      ; And return to CALLer
                
; +---------------------------------------------------------------------------+
; | INTERRUPT1                                                                |
; |                                                                           |
; | Interrupt 1 service routine                                               |
; | Reads the ScanCode from the 74922 KeyBoard Encoder                        |
; +---------------------------------------------------------------------------+

INTERRUPT1:    PUSH DPL                 ; Save DPTR using DPL 
               PUSH DPH                 ; and DPH
               PUSH A                   ; Save Accu
               MOV  DPTR,#KEYBASE       ; KeyBoard Base Address
               MOVX A,@DPTR             ; Read ScanCode
               ANL  A,#00001111B        ; Filter undefined MSB(its)
               MOV  KeyStatus,A         ; Store ScanCode in KeyStatus
               POP  A                   ; Restore Accu
               POP  DPH                 ; Restore DPTR using DPH
               POP  DPL                 ; and DPL
               RETI                     ; And Return from Interrupt

; +---------------------------------------------------------------------------+
; | FUNCTION export ADCONVERT(Param0_:BYTE DATA):WORD DATA;                   |
; |                                                                           |
; | This routine controls the LTC1290 AD converter. The input channel is      |
; | selected using the Param0_ parameter. Param0_ is in the range 0..7        |
; |                                                                           |
; | The output of the routine is an unsigned 16 bit WORD, ADCONVERT?RET       |
; | The value of the word is in the range 0000..0FFF                          |
; |                                                                           |
; | NOTE: The Param0_ parameter selects the channel for the next conversion   |
; |       The channel for the current conversion was selected in the previous |
; |       call to this routine                                                |
; +---------------------------------------------------------------------------+

PUBLIC         ADCONVERT
ADCONVERT:     MOV  A,R0                ; Save R0
               PUSH A                   ; using Accu
               SETB DOUT                ; Data Out (DOUT) goes High
               CLR  SCLK                ; Serial Clock (SCLK) goes Low
               SETB CS                  ; Chip Select (CS) goes High
CONT:          MOV  A,Param0_           ; Get Channel number for next conversion
               ANL  A,#00000111B        ; Isolate bit 0..2
               CLR  C                   ; Clear Carry for RRC operation
               RRC  A                   ; Move LSB into Carry
               JNC  CONT1               ; If C not set, skip set ODD/SIGN bit
               ORL  A,#00000100B        ; set ODD/SIGN bit
CONT1:         SWAP A                   ; Swap High & Low Nibble
               ORL  A,#10001110B        ; Non-differential, 12 bit, MSB first
               CLR  CS                  ; Enable ADC (CS goes Low)
               MOV  R0,#04H             ; Counter for 4 MSB(its)
               NOP                      ; Delay for deglitching
LOOP:          MOV  C,DOUT              ; Read first databit
               RLC  A                   ; Rotate Data into Accu and Command out
               MOV  DIN,C               ; Command bit on DIN
               SETB SCLK                ; Generate a pulse
               CLR  SCLK                ; on SCLK
               DJNZ R0,LOOP             ; Repeat until all 4 bits done
               PUSH A                   ; Save Accu
               ANL  A,#00001111B        ; Strip Command bits in Accu
               MOV  ADCONVERT?RET+1,A   ; Save 4 MSB(its) of data
               POP  A                   ; Restore Accu with 4 LS Commandbits
               MOV  R0,#08H             ; Read 8 databits
LOOP2:         MOV  C,DOUT              ; Read databit
               RLC  A                   ; Rotate Data into Accu and Command out
               MOV  DIN,C               ; Command bit on DIN
               SETB SCLK                ; Generate a pulse
               CLR  SCLK                ; on SCLK
               DJNZ R0,LOOP2            ; Repeat until all 8 bits done
               MOV  ADCONVERT?RET,A     ; Save 8 LSB(its) of data
               SETB SCLK                ; Generate a last
               CLR  SCLK                ; pulse on SCLK
               SETB CS                  ; Disable ADC (CS goes High)
               MOV  R0,#0BH             ; Delay Counter
DELAY:         DJNZ R0,DELAY            ; Repeat Delay
               POP  A                   ; Restore R0
               MOV  R0,A                ; using Accu
               RET                      ; Return to CALLer

; +---------------------------------------------------------------------------+
; | PROCEDURE DACONVERT(Param0_:WORD DATA);                                   |
; |                                                                           |
; | Outputs the analog value of the Param0_ WORD on the output of the         |
; | AD7542 DA converter                                                       |
; +---------------------------------------------------------------------------+

PUBLIC         DACONVERT
DACONVERT:     MOV  DPTR,#DACBASE      ; Set DPTR to address for D0..D3 on DAC
               MOV  A,Param0_          ; Get D0..D7
               MOVX @DPTR,A            ; Write D0..D3 to DAC
               SWAP A                  ; Swap Nibbles in D0..D7
               INC  DPTR               ; Set DPTR to address for D4..D7 on DAC
               MOVX @DPTR,A            ; Write D4..D7 to DAC
               MOV  A,Param1_          ; Get D8..D15
               INC  DPTR               ; Set DPTR to address for D8..D11 on DAC
               MOVX @DPTR,A            ; Write D8..D11 on DAC
               INC  DPTR               ; Set DPTR to 'LOAD DAC' address
               MOVX @DPTR,A            ; Output loaded value
               RET

; +---------------------------------------------------------------------------+
; | CODE DEFINITIONS AT ABSOLUTE ADRESSES                                     |
; +---------------------------------------------------------------------------+

               CSEG
               ORG  0003H               ; External Interrupt 0 Service Address
               LJMP INTERRUPT0          ; Jump to Service Routine
               ORG  0013H               ; External Interrupt 1 Service Address
               LJMP INTERRUPT1          ; Jump to Service Routine

END
               
