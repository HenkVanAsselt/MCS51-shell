; +-------------------------------------------------------------------------+
; | FILE: SERDRV.ASM                                                        |
; |                                                                         |
; | last edit: 27.05.1990 - J.P. Groeneweg                                  |
; |                                                                         |
; |                                                                         |
; | This file contains an interrupt driven buffer for the serial port       |
; +-------------------------------------------------------------------------+

$DEBUG

              NAME SERDRV               ; Name of module

              USING 3                   ; Program may use 
              USING 2                   ; all 4 register banks
              USING 1                   
              USING 0                   

; +-------------------------------------------------------------------------+
; | CONSTANTS                                                               |
; +-------------------------------------------------------------------------+


RxSeg          EQU  000H                ; Receive Buffer [0000..00FF]
TxSeg          EQU  001H                ; Transmit Buffer [0100..01FF]


               ?SERDRV?D SEGMENT DATA   ; Data segment starts here
               RSEG ?SERDRV?D

RxPtr:         DS 001H                  ; Rx Pointer
RxCount:       DS 001H                  ; Number of bytes in Rx buffer
TxPtr:         DS 001H                  ; Tx Retreive Pointer
TxCount:       DS 001H                  ; Number of bytes in Tx buffer

               ?SERDRV?B SEGMENT BIT
               RSEG ?SERDRV?B

Sending:       DS 001H                  ; Transmit in Progress Bit               
PUBLIC         RxData
RxData:        DS 001H                  ; Data in Receive Buffer ?
PUBLIC         RxOverflow                
RxOverflow:    DS 001H                  ; Rx Overflow flag

               ?SERDRV?C SEGMENT CODE   ; Code segment starts here
               RSEG ?SERDRV?C

; +--------------------------------------------------------------------------+
; | SERIAL_INT;                                                              |
; |                                                                          |
; | serial interrupt service routine                                         |
; +--------------------------------------------------------------------------+

SERIAL_INT:    PUSH A                   ; Save Accu
               PUSH DPL                 ; Save DPTR using DPL
               PUSH DPH                 ; and DPH
               JNB  TI,RECEIVE          ; Called on transmit ?
               CLR  Sending             ; Clear Tx in progress Bit
               MOV  A,TxCount
               CJNE A,#0,TRANSMIT ; If Data in Buffer, Transmit
               SJMP RECEIVE             ; No data => Skip TRANSMIT
TRANSMIT:      MOV  DPH,#TxSeg          ; Get Tx Buffer Pointer High Byte
               MOV  DPL,TxPtr
               MOVX A,@DPTR             ; Get byte from DATA Memory
               MOV  SBUF,A              ; Transmit character
               INC  TxPtr               ; Increase Pointer
               DEC  TxCount             ; Decrease number of Chars in buffer
               SETB Sending             ; Set Tx in progress Bit
RECEIVE:       CLR  TI                  ; Clear Transmit Interrupt Flag
               JNB  RI,END_SERIAL       ; Called on Receive ?
               MOV  DPH,#RxSeg          ; Get Rx Buffer Pointer
               MOV  A,RxCount           ; and put into DPTR
               ADD  A,RxPtr             ; Calculate Store Address
               MOV  DPL,A               ; Put in DPL
               MOV  A,SBUF              ; Read character from SBUF
               ANL  A,#01111111B        ; Remove parity 
               MOVX @DPTR,A             ; Store in Ringbuffer in DATA Memory
END_RX:        INC  RxCount             ; Increase Rx Character Counter
               SETB RxData              ; Indicate Data Available in Rx Buffer
               MOV  A,RxCount
               CJNE A,#0FEH,NO_RX_OVFLW   ; If equal then an overflow occured
               INC  RxPtr               ; Kill first char in Buffer
               DEC  RxCount
               SETB RxOverflow          ; Set Overflow flag
NO_RX_OVFLW:   CLR  RI                  ; Clear Receive Interrupt Flag
END_SERIAL:    POP  DPH                 ; Restore DPTR by POPping DPH
               POP  DPL                 ; and DPL
               POP A                    ; Restore Accu
               RETI                     ; Return from Interrupt
               
; +--------------------------------------------------------------------------+
; | READBUFFER;                                                              |
; | Reads a character from the serial Buffer                                 |
; +--------------------------------------------------------------------------+

PUBLIC         READBUFFER
READBUFFER:    PUSH DPH                 ; Save DPTR using
               PUSH DPL                 ; DPL and DPH
WAITINPUT:     MOV  A,RxCount           ; Get number of characters in Buffer
               CJNE A,#0,READBUFFER1    ; If zero, Buffer is empty
               SJMP WAITINPUT           ; Wait for Input
READBUFFER1:   MOV  DPH,#RxSeg          ; Get Rx Buffer Pointer
               MOV  DPL,RxPtr           ; and put in DPTR
               MOVX A,@DPTR             ; Put character in Accu
               MOV  R2,A                ; Put Character in R2
               CLR  EA
               INC  RxPtr               ; Increase Pointer
               DEC  RxCount             ; Decrease counter
               SETB EA
               MOV  A,RxCount
               CJNE A,#0,NOT_EMPTY; Is last Character in buffer read ?
               CLR  RxData              ; Indicate Empty Rx buffer
NOT_EMPTY:     CLR  RxOverflow          ; Clear Overflow flag
               POP  DPL                 ; Restore DPTR using
               POP  DPH                 ; DPL and DPH
               RET                      ; And return to CALLer
               
; +--------------------------------------------------------------------------+
; | WRITEBUFFER;                                                             |
; | Puts a character in to the Transmit Buffer. If no transmission is in     |
; | progress, transmission will be initiated                                 |
; +--------------------------------------------------------------------------+

PUBLIC         WRITEBUFFER

WRITEBUFFER:   PUSH DPH                 ; Save DPTR
               PUSH DPL                 ; using DPL and DPH
               MOV  DPH,#TxSeg          ; Get Tx Buffer and put
WAIT_SPACE:    MOV  A,TxCount
               CJNE A,#010H,SPACE ;
               CPL  P1.0
               CPL  P1.0
               SETB EA
               SJMP WAIT_SPACE
SPACE:         MOV  A,TxPtr             ; Get Tx Read Pointer
               ADD  A,TxCount
               MOV  DPL,A
NO_TX_OVFLW:   MOV  A,R2                ; Put character in Accu
               MOVX @DPTR,A             ; Store character in Buffer
               INC  TxCount             ; Increment Pointer     
               JB   Sending,NO_INITIATE
INITIATE:      SETB TI                  ; Inintiate transmission
NO_INITIATE:   POP  DPL                 ; Restore DPTR using
               POP  DPH                 ; DPH and DPL
               RET                      ; And retrun to CALLer               

; +--------------------------------------------------------------------------+
; | INITBUFFER;                                                              |
; | Initializes timer 1 for mode 2; baudrate is set to 9600 baud             |
; | Initializes the UART for 1 startbit, 8 databits, 1 stopbit               |
; | Initializes the serial buffers                                           |
; | Initializes the serial interrupt by setting ES                           |
; |                                                                          |
; | NOTE: Don't use the Pascal serial procedures because they will interfere |
; |       with the interrupt driven procedures. So don't use:                |
; |       Reset(serial), WriteLn(serial) and ReadLn(serial)                  |
; |       Instead use: Reset(user1), WriteLn(user1) and ReadLn(user1)        |
; +--------------------------------------------------------------------------+

               PUBLIC INITBUFFER

INITBUFFER:    CLR  TI                  ; Clear Transmit Interrupt Register
               CLR  RI                  ; Clear Receive Interrupt Register
               MOV  A,TMOD              ; Reconfigure TMOD register
               ANL  A,#0FH              ; For timer 1 at mode 2:
               ADD  A,#20H              ; 8 bit,auto reload
               MOV  TMOD,A              ; Load register
               CLR  SM0                 ; Set serial port at 8 bit UART
               SETB SM1                 ; with variable baudrate
               MOV  TH1,#250            ; Load auto-reload value (9600Bd)
               SETB TR1                 ; Start Timer 1
               MOV  A,PCON              ; Get Power Control Register
               ORL  A,#80H              ; Set double baudrate bit
               MOV  PCON,A              ; Store register
               SETB REN                 ; Enable receive part of UART
               MOV  TxPtr,#000H         ; Reset all Buffer Pointers
               MOV  TxCount,#000H       ; to the start of the Buffers
               MOV  RxPtr,#000H         ; Initial value of the Pointers:
               MOV  RxCount,#000H       ; xx00; xx is defined in Tx/RxSeg
               CLR  1                   ; Clear EOF bit
               CLR  RxData              ; No data in Rx Buffer
               CLR  RxOverflow          ; No Rx Overflow occurred
               CLR  Sending             ; No Tx in progress 
               SETB ES                  ; Enable Serial Interrupt Service
               SETB EA                  ; Globally enable all Interrupts
               RET                      ; And return to CALLer
               

; +---------------------------------------------------------------------------+
; | INTERRUPT VECTOR DECLARATION AREA                                         |
; |                                                                           |
; | Make sure no other files overlap this specific area of code               |
; | Also don't declare a serial interrupt procedure in Pascal because this    |
; | will interfere with this area                                             |
; +---------------------------------------------------------------------------+

               CSEG                     ; Place interrupt Jump
               ORG  023H                ; at SERIAL INTERRUPT Address
               LJMP SERIAL_INT          ; Execute Serial Interrupt
           

END                                     ; END of Assembly file


