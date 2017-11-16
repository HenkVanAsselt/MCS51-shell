;******************************************************
;
;THESE ARE EXAMPLE SUBROUTINES FOR THE 8051 MICRO-
;CONTROLLER FAMILY.  THEY ARE TAKEN FROM THE 1982
;INTEL MICROCONTROLLER USER'S MANUAL ON PAGES 9-1
;& 9-2.  AFTER ONLY FORMAT MODIFICATIONS FOR CROSS-16,
;THEY ARE PASSED ON AS EXAMPLES, FREE OF CHARGE, BY
;UNIVERSAL CROSS-ASSEMBLERS.

;ALSO INCLUDED, IS A LIST OF THE REGISTER AND BIT NAMES
;WITH THEIR CORRESPONDING ADDRESSES.  THESE MAY
;BE SPECIFIED AS PART OF THE ASSEMBLER CODE, OR
;MOVED TO THE END OF THE 8051 TABLE FOR GREATER
;TRANSPARENCY.

         CPU       "8051.TBL"
         HOF       "INT8"
;
;******************************************************
;
;MCS-51 INTERNAL REGISTERS
;
B:        EQU       0F0H      ;B REGISTER
ACC:      EQU       0E0H      ;ACCUMULATOR
PSW:      EQU       0D0H      ;PROGRAM STATUS WORD
IPC:      EQU       0B8H      ;INTERRUPT PRIORITY
P3:       EQU       0B0H      ;PORT 3
IEC:      EQU       0A8H      ;INTERRUPT ENABLE
P2:       EQU       0A0H      ;PORT 2
SBUF:     EQU       99H       ;SEND BUFFER
SCON:     EQU       98H       ;SERIAL CONTROL
P1:       EQU       90H       ;PORT 1
TH1:      EQU       8DH       ;TIMER 1 HIGH
TH0:      EQU       8CH       ;TIMER 0 HIGH
TL1:      EQU       8BH       ;TIMER 1 LOW
TL0:      EQU       8AH       ;TIMER 0 LOW
TMOD:     EQU       89H       ;TIMER MODE
TCON:     EQU       88H       ;TIMER CONTROL
PCON:     EQU       87H       ;POWER CONTROL REGISTER
DPH:      EQU       83H       ;DATA POINTER HIGH
DPL:      EQU       82H       ;DATA POINTER LOW
SP:       EQU       81H       ;STACK POINTER
P0:       EQU       80H       ;PORT 0
;
;MCS-51 INTERNAL BIT ADDRESSES
;
CY:       EQU       0D7H      ;CARRY FLAG
AC:       EQU       0D6H      ;AUXILIARY-CARRY FLAG
F0:       EQU       0D5H      ;USER FLAG 0
RS1:      EQU       0D4H      ;REGISTER SELECT MSB
RS0:      EQU       0D3H      ;REGISTER SELECT LSB
OV:       EQU       0D2H      ;OVERFLOW FLAG
P:        EQU       0D0H      ;PARITY FLAG
PS:       EQU       0BCH      ;PRIORITY SERIAL PORT
PT1:      EQU       0BBH      ;PRIORITY TIMER 1
PX1:      EQU       0BAH      ;PRIORITY EXTERNAL 1
PT0:      EQU       0B9H      ;PRIORITY TIMER 0
PX0:      EQU       0B8H      ;PRIORITY EXTERNAL 0
EA:       EQU       0AFH      ;ENABLE ALL INTERRUPT
ES:       EQU       0ACH      ;ENABLE SERIAL INTERRUPT
ET1:      EQU       0ABH      ;ENABLE TIMER 1 INTERRUPT
EX1:      EQU       0AAH      ;ENABLE EXTERNAL 1 INTERR
ET0:      EQU       0A9H      ;ENABLE TIMER 0 INTERRUPT
EX0:      EQU       0A8H      ;ENABLE EXTERNAL 0 INTERR
SM0:      EQU       09FH      ;SERIAL MODE 0
SM1:      EQU       09EH      ;SERIAL MODE 1
SM2:      EQU       09DH      ;SERIAL MODE 2
REN:      EQU       09CH      ;SERIAL RECEPTION ENABLE
TB8:      EQU       09BH      ;TRANSMITT BIT 8
RB8:      EQU       09AH      ;RECEIVE BIT 8
TI:       EQU       099H      ;TRANSMIT INTERRUPT FLAG
RI:       EQU       098H      ;RECEIVE INTERRUPT FLAG
TF1:      EQU       08FH      ;TIMER 1 OVERFLOW FLAG
TR1:      EQU       08EH      ;TIMER 1 RUN CONTROL BIT
TF0:      EQU       08DH      ;TIMER 0 OVERFLOW FLAG
TR0:      EQU       08CH      ;TIMER 0 RUN CONTROL BIT
IE1:      EQU       08BH      ;EXT INTERR. 1 EDGE FLAG
IT1:      EQU       08AH      ;EXT INTERR. 1 TYPE FLAG
IE0:      EQU       089H      ;EXT INTERR. 0 EDGE FLAG
IT0:      EQU       088H      ;EXT INTERR. 0 TYPE FLAG

;******************************************************
;
         ORG       0280H
;
;BINBCD  CONVERT 8-BIT BINARY VARIABLE IN ACCUMULATOR
;        TO 3-DIGIT PACKED BCD FORMAT.
;        HUNDREDS' PLACE LEFT IN VARIABLE 'HUND',
;        TENS' AND ONES' PLACES IN 'TENONE'.
;
HUND:    EQU       21H
TENONE:  EQU       22H
;
BINBCD:  MOV       B,#100    ;DIVIDED BY 100 TO
         DIV       AB        ;DETERMINE NUM OF HUNDREDS
         MOV       HUND,A
         MOV       A,#10     ;DIVIDE REMAIN. BY TEN TO
         XCH       A,B       ;DETERMINE NUMBER OF TENS
         DIV       AB        ;TEN'S DIGIT IN ACC,
                             ;REMAINDER IS ONE'S DIGIT
         SWAP      A         ;
         ADD       A,B       ;PACK BCD DIGITS IN ACC
         MOV       TENONE,A
         RET
;
;MULBCD  UNPACK TWO BCD DIGITS RECEIVED IN ACCUMULATOR,
;        FIND THEIR PRODUCT, AND RETURN PRODUCT
;        IN PACKED BCD FORMAT IN ACCUMULATOR
;
MULBCD:  MOV       B,#10H    ;DIVIDE INPUT BY 16
         DIV       AB        ;A & B HOLD SEP. DIGITS
                             ;(RIGHT JUSTIFIED IN REG).
         MUL       AB        ;A HOLDS PRODUCT IN BINARY
                             ;(0-99(DECIMAL) = 0 - 63H)
         MOV       B,#10     ;DIVIDE PRODUCT BY 10
         DIV       AB        ;A HOLDS NUMBER OF TENS,
                             ;B HOLDS REMAINDER
         SWAP      A
         ORL       A,B       ;PACK DIGITS
         RET

         END
