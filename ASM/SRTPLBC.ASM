;*****************************************************************************
;*									     *
;*     P L B C   S H O R T   F O R M   R O U T I N E S    T O    B E   	     *
;*									     *
;*	  L I N K E D  W I T H    S Y S T E M 5 1    P A S C A L	     *
;*									     *
;*				F O R					     *
;*			S O F T T R O N I C S '				     *
;*	P R O G R A M M A B L E    L O G I C   C O N T R O L L E R	     *
;*									     *
;*									     *
;*   This program implements two system51 Pascal command extensions.	     *
;*									     *
;*									     *
;*   File	  : SRTPLBC.ASM						     *
;*   Date	  : September, 1990 					     *
;*   Update SYSTEM51 V3.0                                                    *
;*									     *
;*****************************************************************************

$DEBUG

	name	plbc

	using 3
	using 2
	using 1
	using 0

;*****************************************************************************
; Constants
;*****************************************************************************
t2con		equ	0C8h
rcap2l		equ	0CAh
rcap2h		equ	0CBh


;*****************************************************************************
; Data reservation for parameters.  All in low internal ram space.
;
;*****************************************************************************
?plbc?d		segment	data		; low internal ram space
rseg	?plbc?d				; is direct and indirectly accessable


public	baud_				; put multiple vars at same address
baud_:					; setbaud
public	addri_
addri_:					; bytein, sysin
		ds	02h		; integer


public	bytein?ret
bytein?ret:				; function value return (byte)
		ds	01h

public kptable_
kptable_:       ds      20              ;keypad lookup table (not implemented)


;*****************************************************************************
;*****************************************************************************
;				C O D E
;*****************************************************************************
;*****************************************************************************
?plbc?c		segment	code

	rseg	?plbc?c



;*****************************************************************************
; function export BYTEIN(addri_:integer data):byte data;
;
; Get a full byte, made up of the values at 8 consequtive input addresses
; Is returned in bytein?ret
;*****************************************************************************
public	bytein
bytein:
read_inp:
	mov 	bytein?ret,#00
	mov 	R0,#08			; bit counter
	mov	DPL,addri_		; low
	mov	DPH,addri_+1;		; high
read_il:
	movx 	A,@DPTR
	orl 	A,bytein?ret		; get rest of tmp result
	rr 	A
	mov 	bytein?ret,A		; and store
	inc 	DPTR
	djnz 	R0,read_il
	ret


;*****************************************************************************
; Procedure export SETBAUD(baud_: integer data);
; Sets baudrate according to baud_, crystal of 11.0592 MHz assumed.
;
; Sets SCON, TMOD, TCON, T2CON. The values are the same as in MCS-BASIC.
;*****************************************************************************
public	setbaud
setbaud:				; these values are the same as
					; set by MCS-BASIC (p.131)
	mov	scon, #01011010b	; 8 bit uart, enable reception
					; and some dummy stuff
	mov	tmod, #10h		; 16 bits timer for timer 1
	mov	tcon, #01010100b	; start timer 1&0 enable interrupt 1
	mov	t2con,#00110100b	; use timer 2, start timer

; reload = 65536 - (xtal/(32*baud)) = ((-xtal/(32*20)) /(baud/20))
; This is only valid if MOD (xtal/32baud ) <0.5, else it had to be 65535 - ...
; this is true for all normal baudrates like 300 and such.
; baud := baud div 20;  to keep it all in integers
	mov	R4,#LOW(014h)
	mov	R5,#HIGH(014h)
	mov	R2,baud_
	mov	R3,baud_+01H
	lcall	?IDIV
	mov	baud_,R2
	mov	baud_+01H,R3
;   rl := -17280 div baud;  17280 is xtal/(32*20)
	mov	R4,baud_
	mov	R5,baud_+01H
	mov	R2,#LOW(04380h)
	mov	R3,#HIGH(04380h)
	lcall	?IDIV
	lcall	?INEG
	mov	rcap2l,R2	        ; low byte
	mov	rcap2h,R3       	; high byte
	ret


;=============================================================================

 EXTRN	CODE ( ?IDIV )		; only needed for setbaud
 EXTRN	CODE ( ?INEG )


;=============================================================================

end
;