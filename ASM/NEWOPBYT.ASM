;************************************************************************
;
; The following is an example of a program that uses the new OPBYTES
; available in version 1.1 of MCS BASIC-52. This code is by no means
; optimized, but is is menat to demonstrate how the user can define
; "customized" commands and statements in version 1.1 of MCS BASIC-52
;
; The new command defined here is DISPLAY. What it does is display a
; region of external data memory to the console device. The syntax :
;
;	    DISPLAY [expr],[expr]
;
; Where the first expression is the starting address and the last
; expression is the ending address. In this example the DISPLAY is
; treated like a command which means that it cannot be executed in
; RUN mode.
;
; The output for the DISPLAY command is as follows:
;
;  ADDRESS then 16 Bytes of Characters, i.e.
;
;  1000H 00H 22H 33H 27H ...
;
;******************************************************************************

;------------------------------------------------------------------------------

    ORG 2002H

    DB	5AH	    ; Tell Basic that expansion option is present.

;------------------------------------------------------------------------------

    ORG 2048H

    SETB    45	    ; Set the bit that says so
    RET

;------------------------------------------------------------------------------

    ORG 2070H

    MOV DPTR,#VECTOR_TABLE  ; Set up DPTR to jump table
    RET

;------------------------------------------------------------------------------

    ORG 2078H

    MOV DPTR,#USER_TABLE    ; Set up DPTR to expansion table
    RET

;------------------------------------------------------------------------------

VECTOR_TABLE:
    DW	DO_DISPLAY	    ; This is the address of display

USER_TABLE:
    DB	10H		    ; Token for DISPLAY
    DB	'DISPLAY'	    ; ASCII representation
    DB	0FFH		    ; End of table (short one)

;------------------------------------------------------------------------------

DO_DISPLAY:

    JNB     47,DUMMY	    ; Make sure that MCS BASIC-52 is in the command
			    ; mode. Bit 47 is set if it is.

    MOV     A,#57	    ; Evaluate the first expression after the keyword
    LCALL   30H 	    ; DISPLAY. MCS BASIC-52 will handle any errors. The
			    ; value of the expression will be on the Argument
			    ; Stack.

    MOV     A,#64	    ; Get the character after the expression and bump
    LCALL   30H 	    ; the BASIC text pointer.

    CJNE    A,#',',C_ERROR  ; Make sure it is a comma. If not show error-msg.

    MOV     A,#57	    ; Evaluate the next expression (the ending address)
    LCALL   30H 	    ; and put it on the argument stack.

    MOV     A,#1	    ; Convert the last expression (end address) on
    LCALL   30H 	    ; stack to an integer and put is in R3:R1
    MOV     18H,R1	    ; Save address in the user reserved locations 18H
    MOV     19H,R3	    ; and 19H. This is reserved as register bank 3.

    MOV     A,#1	    ; Convert the last expression (start address) on
    LCALL   30H 	    ; stack to an integer and put is in R3:R1
    MOV     1AH,R1	    ; Save address in the user reserved locations 1AH
    MOV     1BH,R3	    ; and 1BH. This is reserved as register bank 3.

LOOP1:
    CLR     C		    ; Check if the starting or current address <=
    MOV     A,18H	    ; the ending address
    SUBB    A,1AH
    MOV     A,19H
    SUBB    A,18H
    JNC     LOOP2	    ; Carry not set? then continue with loop2.

    CLR     A		    ; If the carry is set, it is over. Go to the
    LJUMP   30H 	    ; command mode (if display was a statement
			    ; instead of a command, this routine would exit
			    ; with a RET).

LOOP2:
    MOV     A,#7	    ; Send a CR/LF
    LCALL   30H

    MOV     R1,1AH	    ; Output of starting address
    MOV     R3,1BH
    CLR     36H 	    ; Don't suppress leading zero's
    MOV     A,#98H
    LCALL   30H

LOOP3:
    MOV     DPL,1AH	    ; Now set up to read 16 bytes, put address in
    MOV     DPH,1BH	    ; DPTR

    MOVX    A,@DPTR	    ; Read the byte from external RAM
    INC     DPTR	    ; and bump to the next location

    MOV     1AH,DPL	    ; Save the address
    MOV     1BH,DPH

    MOV     R1,A	    ; Output the byte
    MOV     R3,#0	    ; The high byte is always zero
    SETB    36H 	    ; Suppress leading zero's
    MOV     A,#98H
    LCALL   30H

    MOV     A,1AH	    ; Check if on a 16 byte boundary
    ANL     A,#0FH
    JNZ     LOOP3	    ; Loop3 until on a 16 byte boundary
    SJMP    LOOP1	    ; Loop1 will ouput next 16 bytes

;-----------------------------------------------------------------------------

DUMMY:

    MOV     A,#7	    ; Send a CR/LF
    LCALL   30H

    MOV     R3,#HIGH D_MSG  ; Display the error message
    MOV     R1,#LOW D_MSG
    SETB    52		    ; Print from ROM
    MOV     A,#6
    LCALL   30H

    CLR     A		    ; Go back to command mode
    LJMP    30H

;------------------------------------------------------------------------------

C_ERROR:

    MOV     A,#7	    ; Send a CR/LF
    LCALL   30H

    MOV     R3,#HIGH C_MSG  ; Display the error message
    MOV     R1,#LOW C_MSG
    SETB    52		    ; Print from ROM
    MOV     A,#6
    LCALL   30H

    CLR     A		    ; Go back to command mode
    LJMP    30H

;------------------------------------------------------------------------------

D_MSG:	DB  'DISPLAY is a command, not a statement"'
C_MSG:	DB  'You need a comma to make DISPLAY work"'

;------------------------------------------------------------------------------

    END
