; +---------------------------------------------------------------------------+
; | FILE: SERIAL.ASM                                                          |
; |                                                                           |
; | This file contains an INTERRUPT driven Transmit & Receive buffer for the  |
; | on-board serial channel of 8051 family processors                         |
; |                                                                           |
; | author    : J.P. Groeneweg                                                |
; | last edit : 30.08.1991                                                    |
; +---------------------------------------------------------------------------+

$DEBUG

               NAME SERIAL              ; Name of module
               
               USING 3                   
               USING 2
               USING 1
               USING 0
               
RxSeg          EQU 000H                 ; Receive Buffer [0000..00FF]
TxSeg          EQU 001H                 ; Transmit Buffer [0100..01FF]

               ?SERIAL?D SEGMENT DATA
               RSEG ?SERIAL?D
               
RxPtr:         DS 001H                  ; Receive Pointer
RxCount:       DS 001H                  ; Receive Counter
TxPtr:         DS 001H                  ; Transmit Pointer
TxCount:       DS 001H                  ; Transmit Counter

               ?SERIAL?B SEGMENT BIT
               RSEG ?SERIAL?B
               
PUBLIC         RxData                   ; Rx Data Available flag
PUBLIC         RxOverFlow               ; Rx Overflow flag
RxData:        DS 001H                  ; Size is 1 bit
RxOverFlow:    DS 001H                  ; Size is 1 bit

               ?SERIAL?C SEGMENT CODE
               RSEG ?SERIAL?C
               
; +---------------------------------------------------------------------------+
; | SERIAL_INT                                                                |
; |                                                                           |
; | This routine is the Serial Interrupt service routine                      |
; |                                                                           |
; | If the receive buffer overflows, RxOverFlow is set                        |
; | If a character is received, RxData is set                                 |
; +---------------------------------------------------------------------------+


SERIAL_INT:    PUSH A                   ; Save Accu
               PUSH DPL                 ; Save DPTR using DPL
               PUSH DPH                 ; and DPH
               JNB  TI,RECEIVE          ; Called on Tx or Rx
               INC  TxPtr               ; Increase Pointer
               DEC  TxCount             ; Decrease Counter
               MOV  A,TxCount           ; Compare Counter
               CJNE A,#000H,TRANSMIT    ; To zero (empty buffer)
               SJMP END_TX              ; If empty then don't transmit
TRANSMIT:      MOV  DPH,TxSeg           ; Get high byte of Tx Pointer
               MOV  DPL,TxPtr           ; and low byte
               MOVX A,@DPTR             ; Get Character from buffer 
               MOV  SBUF,A              ; Transmit character
END_TX:        CLR  TI                  ; Clear flag
RECEIVE:       JNB  RI,END_SERIAL       ; Called on Rx ?
               MOV  A,RxPtr             ; Get Pointer
               ADD  A,RxCount           ; Add Offset
               MOV  DPL,A               ; Load low address byte of Rx Pointer
               MOV  DPH,RxSeg           ; and high address byte
               MOV  A,SBUF              ; Read serial port
               ANL  A,#01111111B        ; Strip parity
               MOVX @DPTR,A             ; Store character in Buffer
               INC  RxCount             ; Increase Counter
               MOV  A,RxCount           ; Compare Counter
               CJNE A,#0FFH,NO_OVERFLOW ; To 0FFH (Buffer full)
OVERFLOW:      DEC  RxCount             ; Kill 1st character in buffer
               INC  RxPtr               ; By updating Counter & Pointer
               SETB RxOverFlow          ; Set Overflow flag
NO_OVERFLOW:   CLR  RI                  ; Clear flag
               SETB RxData              ; Set Data available flag
END_SERIAL:    POP  DPH                 ; Restore DPTR using
               POP  DPL                 ; DPH & DPL
               POP  A                   ; Restore Accu
               RETI                     ; Return from INTERRUPT
               
; +---------------------------------------------------------------------------+
; | WRITEBUFFER                                                               |
; |                                                                           |
; | Writes a character to the Transmit Buffer. If the Buffer is full, the     |
; | will wait until there is space in the buffer and then put the character   |
; | into the buffer. If no transmission is in progress, it will be            |
; | initiated by this routine                                                 |
; +---------------------------------------------------------------------------+

PUBLIC         WRITEBUFFER              ; Routine can be accessed by other files
WRITEBUFFER:   PUSH DPH                 ; Save DPTR using DPH
               PUSH DPL                 ; and DPL
WAIT_SPACE:    MOV  A,TxCount           ; Get Counter
               CJNE A,#0FFH,SPACE       ; compare to 0FFH (buffer full)
               SJMP WAIT_SPACE          ; If full, then wait for space 
SPACE:         MOV  A,TxPtr             ; Get pointer
               ADD  A,TxCount           ; Add offset
               MOV  DPL,A               ; Load low address byte
               MOV  DPH,TxSeg           ; and high address byte
               MOV  A,R2                ; get character
               MOVX @DPTR,A             ; and store in buffer
               INC  TxCount             ; Increase counter
               MOV  A,TxCount           ; Compare counter
               CJNE A,#001H,NO_INITIATE ; to 001H (initiate transmission)
INITIATE:      MOV  A,R2                ; Get character
               MOV  SBUF,A              ; Transmit character
NO_INITIATE:   POP  DPL                 ; Restore DPTR using DPL
               POP  DPH                 ; and DPH
               RET                      ; Return to CALLer
               
; +---------------------------------------------------------------------------+
; | READBUFFER                                                                |
; |                                                                           |
; | Reads a character from the Receive Buffer. If the Buffer is empty, the    |
; | routine will wait until a character is received.                          |
; | The RxOverFlow flag is cleared by this routine                            |
; +---------------------------------------------------------------------------+

PUBLIC         READBUFFER               ; Routine can be accessed by other files
READBUFFER:    PUSH DPH                 ; Save DPTR using DPH
               PUSH DPL                 ; and DPL
WAIT_INPUT:    MOV  A,RxCount           ; Get Receive Counter
               CJNE A,#000H,INPUT       ; If no Data available
               SJMP WAIT_INPUT          ; then wait for input
INPUT:         MOV  DPH,RxSeg           ; Get high address byte of Pointer
               MOV  DPL,RxPtr           ; Get low address byte of Pointer
               MOVX A,@DPTR             ; Get character from buffer
               MOV  R2,A                ; Put in R2 (Pass it to SYSTEM51)
               INC  RxPtr               ; Increase Pointer
               DEC  RxCount             ; Decrease Counter
               MOV  A,RxCount           ; Compare Counter
               CJNE A,#000H,INPUT_AVAIL ; To zero (data avilable ?)
               CLR  RxData              ; If zero (no data) then clear flag
INPUT_AVAIL:   CLR  RxOverFlow          ; Clear Overflow flag
               POP  DPL                 ; Restore DPTR using DPL
               POP  DPH                 ; and DPH
               RET                      ; Return to CALLer

; +---------------------------------------------------------------------------+            
; | INITBUFFER                                                                |
; |                                                                           |
; | Initializes timer 1 for mode 2, baudrate is set to 9600 baud              |
; | Initializes UART for 1 startbit, 8 databits, 1 stopbit                    |
; | Initializes the serial Rx & Tx Buffers                                    |
; | Initializes the SERIAL INTERRUPT by setting ES                            |
; |                                                                           |
; | NOTE: Don't use the Pascal serial procedures because they will interfere  |
; |       with the interrupt driven routines. So don't use:                   |
; |       Reset(serial); WriteLn(serial,...); ReadLn(serial,...)              |
; |       Instead use:                                                        |
; |       Reset(user1); WriteLn(user1,...); ReadLn(user1,...);                |
; +---------------------------------------------------------------------------+

PUBLIC         INITBUFFER               ; Routine can be accessed by other files
INITBUFFER:    CLR  TI                  ; Clear Transmit Interrupt flag
               CLR  RI                  ; Clear Receive Interrupt flag
               MOV  A,TMOD              ; Reconfigure TMOD register
               ANL  A,#0FH              ; For Timer 1 at mode 2;
               ADD  A,#20H              ; 8 bit, auto reload
               MOV  TMOD,A              ; Store new configuration
               CLR  SM0                 ; Set serial port to 8 bit UART
               SETB SM1                 ; with variable baudrate
               MOV  TH1,#0FDH           ; Load auto-reload value (9600Bd)
               SETB TR1                 ; Start timer 1
               MOV  PCON,#00000000B     ; No doubled baudrate in CMOS ÊP's
               SETB REN                 ; Enable Receive part of UART
               MOV  TxPtr,#000H         ; Reset all Buffer Pointers
               MOV  TxCount,#000H       ; to the start of the buffers
               MOV  RxPtr,#000H         ; Initial value of the Pointers:
               MOV  RxCount,#000H       ; xx00H; xx is defined in TxSeg/RxSeg
               CLR  1                   ; Clear SYSTEM51 EOF bit
               CLR  RxData              ; Clear Rx Data Available flag
               CLR  RxOverFlow          ; Clear Rx Overflaw flag
               SETB ES                  ; Enable serial Interrupt
               SETB EA                  ; Globally enable Interrupts
               RET

; +---------------------------------------------------------------------------+            
; | INTERRUPT VECTOR DECLARATION AREA                                         |
; |                                                                           |
; | Make sure no other files overlap this specific area of code               |
; | So don't declare a serial interrupt in Pascal !!!                         |
; +---------------------------------------------------------------------------+            
               
               CSEG                     
               ORG  0023H               ; Serial Interrupt Address
               LJMP SERIAL_INT          ; Jump to service routine
               
END                                     ; END of Assembly file
               
