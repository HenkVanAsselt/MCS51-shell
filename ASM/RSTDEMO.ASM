;******************************************************************************
;
; Example of a cold start option
;
;******************************************************************************

    ORG     2001H

    DB	    0AAH	; Tell BASIC that reset is external

;------------------------------------------------------------------------------

    ORG     2090H	; BASIC will CALL this location upon reset.

    ; At this point BASIC has initialized the following locations:
    ; SMOD  = 5AH
    ; TMOD  = 10H
    ; TCON  = 54H
    ; T2CON = 34H

    ;
    ; First clear the internal memory
    ;
    MOV     R0,#0FFH	; Load R0 with top of internal memory.
    CLR     A		; Accu = 0
RESET1:
    MOV     @R0,A	; Loop until all internal memory is cleared
    DJNZ    R0,RESET1

    ;
    ; Now set up the stack pointer and the stack pointer holding register
    ;
    MOV     SP,#4DH	; 4DH is the initialized value of the stack
    MOV     3EH,#4DH	; This is the SP holding register

    ;
    ; Now clear the external RAM. Int his example assume that 1FFFH bytes
    ; of RAM are available. The user must clear at least the first 512
    ; bytes of RAM for a cold start reset.
    ;
    MOV     R3,#HIGH 1FFFH
    MOV     R1,#LOW  1FFFH
    MOV     DPTR,#0FFFFH

RESET2:
    INC     DPTR	; DPTR=0 the first time this loop is entered.
    CLR     A
    MOVX    @DPTR,A	; Clear the RAM, a memory test program could be in
			; this loop

    MOV     A,R3	; Now test for the memory limits
    CJNE    A,DPH,RESET2
    MOV     A,R1
    CJNE    A,DPL,RESET2

    ;
    ;	Now set up the memory pointers.
    ;	First MTOP
    ;
    MOV     DPTR,#10AH	    ; Location of MTOP in external RAM
    MOV     A,#HIGH 1FFFH   ; Save MTOP
    MOVX    @DPTR,A
    INC     DPTR	    ; Now save the low byte
    MOV     A,#LOW  1FFFH
    MOVX    @DPTR,A

    ;
    ;	Setup the VARTOP pointer, with no strings.
    ;	Now VARTOP = MEMTOP
    ;
    MOV     DPTR,#104H	    ; Location of VARTOP in external RAM
    MOV     A,#HIGH 1FFFH   ; Save VARTOP
    MOVX    @DPTR,A
    INC     DPTR	    ; Now save the low byte
    MOV     A,#LOW  1FFFH
    MOVX    @DPTR,A

    ;
    ; Now save the matrix pointer DIMUSE. This pointer is described
    ; in the appendix. With no program in RAM, DIMUSE = 528 after RESET.
    ;
    MOV     DPTR,#108H	    ; Location of DIMUSE in external RAM
    MOV     A,#HIGH 528
    MOVX    @DPTR,A
    INC     DPTR	    ; Now save the low byte
    MOV     A,#LOW 528
    MOVX    @DPTR,A

    ;
    ; Now save the variable pointer VARUSE. This pointer is also described
    ; in the appendix. After reset, VARUSE = VARTOP
    ;
    MOV     DPTR,#106H	    ; Location of VARUSE in external RAM
    MOV     A,#HIGH 1FFFH
    MOVX    @DPTR,A
    INC     DPTR	    ; Now save the low byte
    MOV     A,#LOW 1FFFH
    MOVX    @DPTR,A

    ;
    ; Now setup basics control stack and argument stack
    ;
    MOV     9H,#0FEH	    ; Initialize the argument stack
    MOV     11H,#0FEH	    ; Initialize the control stack

    ;
    ; Now tell BASIC that no program is in RAM. This is not needed if the
    ; user has a program in RAM.
    ;
    MOV     DPTR,#512	    ; Location of the start of a user program
    MOV     A,#01H	    ; End of file character
    MOVX    @DPTR,A

    ;
    ; Now push the crystal avalue on to the stack and let basic calculate
    ; all crystal dependent parameters.
    ;
    SJMP    RESET3

XTAL:
    DB	88H		    ; This is the floating point value for an
    DB	00H		    ; 11.0592 MHz crystal.
    DB	00H
    DB	92H
    DB	05H
    DB	11H

RESET3:
    MOV     DPTR,#XTAL	    ; Set up to push crystal value
    MOV     A,9 	    ; Get the argument stack
    CLR     C
    SUBB    A,#6	    ; Decrement argument stack by one FP number
    MOV     9,A
    MOV     R0,A	    ; Save the calculated address in R0
    MOV     P2,#1	    ; Argument stack page address
    MOV     R1,#6	    ; Number of bytes to transfer

RESET4:
    CLR     A		    ; Transfer ROM crystal value to the
    MOVC    A,@A+DPTR	    ; argument stack of basic
    MOVX    @R0,A
    INC     DPTR	    ; Bump the pointers
    DEC     R0
    DJNZ    R1,RESET4	    ; Loop until the transfer is complete.|

    ;
    ; Now call BASIC to do all the crystal calculations
    ;
    MOV     A,#58	    ; Opbyte for crystal calulations
    LCALL   30H 	    ; Go...

    ;
    ;	Now tell BASIC where start of the user basic program is by
    ;	loading the start address. If the program is in EPROM,
    ;	13H would be 'HIGH 8011H' and 14H would be 'LOW 8011H'.
    ;	Anyway, address 13H:14H must point to the start of the BASIC
    ;	program.
    ;
    MOV     13H,#HIGH 512   ; This tells BASIC that the start of
    MOV     14H,#LOW  512   ; the program is in location 512

    ;
    ;	Now the serial port must be initialized. The user can set up the serial
    ;	port to any desired configuration. However, this demo will show the
    ;	auto baud routine.
    ;
    MOV     R3,#00H	    ; Initialize the auto baud counters
    MOV     R1,#00H
    MOV     R0,#04H
    JB	    RXD,$	    ; Loop until a startbit is received.
RESET5:
    DJNZ    R0,$	    ; Wast 8 clocks initially, six clocks in
			    ; the loop (16) total.
    CLR     C		    ; 1 clock (1)
    MOV     A,R1	    ; 1 clock (2)
    SUBB    A,#1	    ; 1 clock (3)
    MOV     R1,A	    ; 1 clock (4)
    MOV     A,R3	    ; 1 clock (5)
    SUBB    A,#00H	    ; 1 clock (6) Now R3:R1 = R3:R1 - 1
    MOV     R3,A	    ; 1 clock (7)
    MOV     R0,#3	    ; 1 clock (8)
    JNB     RXD,RESET3	    ; 2 clocks (10), Wait for end of space
    JB	    RXD,$	    ; Wait for the space (20H) to end.
    JNB     RXD,$	    ; Wait for the stop bit.
    MOV     RCAP2H,R3	    ; Load the timer 2 holding registers.
    MOV     RCAP2L,R1

    ;
    ;	Now you can add a custom sign on message
    ;
    MOV     R3,#HIGH MSG    ; Put address of message in R3:R1
    MOV     R1,#LOW  MSG
    SETB    52		    ; Print from ROM
    MOV     A,#6	    ; OPBYTE to print text string
    LCALL   30H
    MOV     A,#7	    ; and print CR/LF
    LCALL   30H

    ;
    ;	Go to the command mode
    ;
    CLR     A
    JMP     30H

;------------------------------------------------------------------------------

MSG:	DB 'Custom sign on message' ; Message
	DB 22H			    ; Message terminator

;------------------------------------------------------------------------------

    END
