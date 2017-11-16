$DEBUG
;source text for IODRIVERS with different character writing (WRITC)
; and character reading (READC) routines
;870712 KSC Software Systems
;880430 corrected for use in version 2.0
;890418 corrected for conditional assembly of soft uart characteristics.
;890703 corrected for use in version 3.0
;891114 last correction for version 3.05b

; global settings of clock frequency and baudrate for SOFT uart:
; CLOCKRATE might be 11 (11.0592 MHz) or 12 (12.0 MHz)
; BAUDRATE might be 1200, 2400, 4800 and 9600 (last only exact enough at 11.0592 MHz)
; NO_OF_BITS might be 7 or 8
; NO_OF_STOPS might be 1 or 2


; !!!! NB! CHANGE THESE NEXT SETTINGS TO SUIT YOUR NEEDS   !!!

CLOCKRATE	GSET	11
BAUDRATE	GSET	1200
NO_OF_BITS	GSET	7
NO_OF_STOPS	GSET	1




IF	CLOCKRATE=11

 IF BAUDRATE=9600
 
  RATE	GSET	42
  
 ENDIF
 
 IF BAUDRATE=4800
 
  RATE	GSET	90
  
 ENDIF
 
 IF (BAUDRATE=2400)!(BAUDRATE=1200)
 
  RATE	GSET	186
  
 ENDIF

 IF     0	; dummy if statement
 ENDIF
  
ELSE

 IF BAUDRATE=9600
  RATE	GSET	46
 ENDIF
 
 IF BAUDRATE=4800
  RATE	GSET	98
 ENDIF
 
 IF (BAUDRATE=2400)!(BAUDRATE=1200)
  RATE	GSET	202
 ENDIF
 
ENDIF


LIBRARY	READC

; READC reads one character from a selected device or string
; at call:  I/O channel number in ?DEVICE; the character is returned in R2,
; the channels are:

;               O: The serial port SBUF, the character is ecchoed.

;               2: A soft-uart using one port bit INBIT;
;		   initially set to P3.2.
;                  For baudrate etc., see global setting at top of file.

;               3,4: Two user defined routines USRREAD0 and USRREAD1

;               5,6: Those routines are used by the procedure VAL and must not
;		     be changed.


PUBLIC ?READC

EXTRN  CODE    ( ?WRITC,READBUFFER )
;EXTRN   CODE    ( ?WRITC )
EXTRN	DATA	( ?AR0, ?AR4, ?DEVICE)
?READC?C	SEGMENT	CODE
RSEG	?READC?C

	
INBIT		BIT	P3.2	; defines Port3 bit 2 as soft uart in bit



?READC:	MOV     A,?DEVICE
        JZ      READ0
        DEC     A
        DEC     A
        JZ      READ2
        DEC     A
        JZ      USRREAD0
	DEC	A
        JZ      USRREAD1
        DEC     A
	JZ	READ5
	
READ6:  DEC	?AR4		; These routines are for the VAL procedure
	MOV	A,?AR4		; and must not be changed
	JZ	RETCR
	MOVX	A,@DPTR
	INC	DPTR
	MOV	R2,A
	RET

RETCR:	MOV	R2,#13
	RET

READ5:	DEC	?AR4		; These routines are for the VAL procedure
	MOV	A,?AR4		; and must not be changed
	JZ	RETCR

	MOV	R0,?AR0
	MOV	A,@R0
	INC	?AR0
	MOV	R2,A
	RET

READ0:	;LCALL    READBUFFER
        ;RET
        JNB	98H,READ0	; Serial uart
	CLR	98H
	MOV	A,SBUF
	MOV	R2,A
;	SUBB	A,#0DH   ; Skip echo to console
;	JZ	$+5
;	CALL	?WRITC
	RET

READ2:  SETB	EA
	JB	INBIT,READ2	; Soft uart; wait communication
	CLR	EA
	
IF	BAUDRATE=1200
	MOV	R5,#RATE
ELSE
	MOV	R5,#RATE/2	; half bit wait time
ENDIF

READ2A:	DJNZ	R5,READ2A
	JB	INBIT,READ2	; try again if error
	MOV	R2,#NO_OF_BITS
	CLR	C
READ2B:	CALL	ONEBIT
IF	BAUDRATE=1200
	CALL	ONEBIT
ENDIF
	RRC	A
	MOV	C,INBIT
	DJNZ	R2,READ2B
	RRC	A
	
IF	NO_OF_BITS=7
	CLR	C
	RRC	A		; 8 shifts total needed
ENDIF
	CALL	ONEBIT		;first stop bit detected
	MOV	R2,A
	SETB	EA
	RET

ONEBIT:	MOV	R5,#RATE
ONEBIT1:
	DJNZ	R5,ONEBIT1
	RET

USRREAD0:CALL READBUFFER               ; You are supposed to put your user0-code here
	RET
	
USRREAD1:		; and ditto user1-code.
	RET

LIBEND



; WRITC writes one character to a selected device or string
; at call: the character must be in R2, I/O channel number in ?DEVICE
; the channels are:

;               O: The serial port SBUF

;               1: A parallel memory mapped display like a SANYO LCM 5xx
;		   connected at external RAM address DISPLAY
;		   initially set to 62xxH for data and 61xxH for read busy

;               2: A soft-uart using one port bit OUTBIT;
;		   initially set to P3.5.
;		   Baud rate settings according to file header

;               3,4: Two user defined routines USRWRIT0 and USRWRIT1

;               5,6: Those routines are used by the procedure STR and must not
;		     be changed.



LIBRARY	WRITC

PUBLIC	?WRITC, ?DEVICE, ?AR0, ?AR4
?WRITC?C	SEGMENT	CODE
?WRITC?D	SEGMENT	DATA

EXTRN  CODE    ( WRITEBUFFER )

RSEG	?WRITC?D

?DEVICE:
	DS	1
?AR0:	DS	1
?AR4:	DS	1

RSEG	?WRITC?C


OUTBIT		EQU	P3.5	; defines Port3 bit 5 as soft uart out bit

DISPLAY		XDATA	8101H	; defines address of a optional
				;parallel display; P2.1 connected to RS
				
DISPBUSY	XDATA	8102H	; P2.0 connected to R/W


?WRITC:	MOV     A,?DEVICE
        JZ      WRIT0
        DEC     A
        JZ      WRIT1
        DEC     A
        JZ      WRIT2
        DEC     A
        JZ      USRWRIT0
	DEC	A
        JZ      USRWRIT1
        DEC     A
	JZ	WRIT5
	
WRIT6:	MOV	A,R2	; For string operation, external RAM
	MOVX	@DPTR,A
	INC	DPTR
	INC	?AR4
	RET
	
WRIT5:	MOV	A,R2	; For string operation, internal RAM
	MOV	R0,?AR0
	MOV	@R0,A
	INC	?AR0
	INC	?AR4
	RET

WRIT0:	JNB	TI,WRIT0	; using SBUF
	MOV	A,R2
	MOV	SBUF,A
	CLR	TI
	RET

WRIT1:	PUSH	DPH	; using parallel display like SANYO 522
	PUSH	DPL
	MOV	DPTR,#DISPBUSY
WRIT10:	MOVX	A,@DPTR
	MOVX	A,@DPTR
	JB	ACC.7,WRIT10
	MOV	DPTR,#DISPLAY
	MOV	A,R2
	MOVX	@DPTR,A
	POP	DPL
	POP	DPH
	RET

WRIT2:	;soft uart
	CLR	EA		; don't let interrupts spoil your UART.
	CLR	OUTBIT	; startbit
	CALL	ONEBIT
IF	BAUDRATE=1200
	CALL	ONEBIT
ENDIF
	MOV	R4,#NO_OF_BITS
WRIT20:	MOV	A,R2
	RRC	A
	MOV	R2,A
	MOV	OUTBIT,C	; databit
	CALL	ONEBIT
IF	BAUDRATE=1200
	CALL	ONEBIT
ENDIF
	DJNZ	R4,WRIT20
	SETB	OUTBIT
	CALL	ONEBIT
IF	BAUDRATE=1200
	CALL	ONEBIT
ENDIF
IF	NO_OF_STOPS=2
	CALL	ONEBIT		; 2 stop bits
 IF BAUDRATE=1200
 	CALL	ONEBIT
 ENDIF
ENDIF
	SETB	EA
	RET
	
ONEBIT:	MOV	R5,#RATE
	DJNZ	R5,$
	RET

USRWRIT0:CALL WRITEBUFFER                              ; To be filled out by user
	RET

USRWRIT1:				; To be filled out by user
	RET

LIBEND

LIBRARY RESET

PUBLIC ?RESET

DISPCONTR       EQU 8100H
DISPWRITE       EQU 8101H
DISPBUSY        EQU 8102H

EXTRN  CODE    ( INITBUFFER )

?RESET?C	SEGMENT	CODE

RSEG	?RESET?C

?RESET: MOV	A,R3
	JZ	RESET0
	DEC     A
	JZ      RESET1
        DEC     A
        DEC     A
        JZ      USRRST0
	RET

TESTBSY:PUSH    DPH
        PUSH    DPL
        MOV     DPTR,#DISPBUSY
TESTBS1:MOVX    A,@DPTR
        MOVX    A,@DPTR
        JB      ACC.7,TESTBS1
        POP     DPL
        POP     DPH
        RET
        

RESET0:	; this code resets SBUF to polling, 9600 Baud @11.0592 MHz CPU clock
	; and resets eof-bit (1)

        ;LCALL    INITBUFFER
        ;RET
	MOV	A,TMOD
	ANL	A,#0FH
	ADD	A,#20H
	MOV	TMOD,A
	CLR	SM0
	SETB	SM1
	MOV	TH1,#250
	SETB	TR1
	MOV	A,PCON
	ORL	A,#80H
	MOV	PCON,A
	SETB	REN
	SETB	TI
	CLR	1
	RET

RESET1: MOV     DPTR,#DISPCONTR
        CALL    TESTBSY
        MOV     A,#00111000B
        MOVX    @DPTR,A
        CALL    TESTBSY
        MOV     A,#00001111B
        MOVX    @DPTR,A
        CALL    TESTBSY
        MOV     A,#00000001B
        MOVX    @DPTR,A
        MOV     R0,#31;
LOOP:   MOV     DPTR,#DISPCONTR
        CALL    TESTBSY
        MOV     A,#01000000B
        ORL     A,R0
        MOVX    @DPTR,A
        MOV     DPTR,#DISPWRITE
        CALL    TESTBSY
        MOV     A,#00011011B
        MOVX    @DPTR,A
        DJNZ    R0,LOOP

        RET

USRRST0:CALL    INITBUFFER
        RET

LIBEND

LIBRARY EOF

EOF?C	SEGMENT CODE

RSEG	EOF?C

PUBLIC ?EOF

?EOF:	MOV	A,R3
	JZ	EOF0
	RET
	
EOF0:	MOV	C,1
	RET

LIBEND
	
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  These two last library modules MUST be the last input for the LINK51.
;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

LIBRARY ISTACK

PUBLIC	?INITISTACK

EXTRN DATA ( ?STACKPTR )

?ISTACK?I	SEGMENT	IDATA
?ISTACK?C	SEGMENT CODE

RSEG	?ISTACK?I

?ISTACKSTART:
	DS	1	; stack in upper part of internal memory
	
RSEG	?ISTACK?C

?INITISTACK:
	MOV	?STACKPTR,#?ISTACKSTART
	POP	0
	POP	1
	MOV	SP,?STACKPTR
	PUSH	1
	PUSH	0
	RET
	

LIBEND

LIBRARY	STACK
PUBLIC	?STACKPTR
PUBLIC	?INITSTACK
?STACK?D	SEGMENT	DATA
?STACK?C	SEGMENT	CODE

RSEG	?STACK?D

?STACKPTR:
	DS	1	; initial value for transfer
?STACKSTART:
	DS	1	; stack: rest of data memory

RSEG	?STACK?C

?INITSTACK:
	MOV	?STACKPTR,#?STACKSTART
	POP	0
	POP	1
	MOV	SP,?STACKPTR
	PUSH	1
	PUSH	0
	RET
	
	
LIBEND

END


