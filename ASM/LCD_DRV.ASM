; +---------------------------------------------------------------------------+
; | FILE: LCD_DRV.ASM                                                         |
; |                                                                           |
; | This file contains most of the routines to control a HD44780 based        |
; | LCD module. The Write(Ln) and Reset commands are implemented in IODRIVER  |
; +---------------------------------------------------------------------------+

$DEBUG

               NAME LCD_DRV
               
               USING 3
               USING 2
               USING 1
               USING 0
               
; +---------------------------------------------------------------------------+
; | CONSTANTS                                                                 |
; +---------------------------------------------------------------------------+
               
DISPCONTR      EQU 8100H                ; Definitions for UCM Terminal board
DISPWRITE      EQU 8101H
DISPBUSY       EQU 8102H
DISPREAD       EQU 8103H

; +---------------------------------------------------------------------------+
; | DATA RESERVATION AREA                                                     |
; +---------------------------------------------------------------------------+

               ?LCD_DRV?D SEGMENT DATA  ; Internal RAM memory
               RSEG ?LCD_DRV?D
               
PUBLIC         Param1_                  ; Space for parameter passing
Param1_:       DS 1                     ; Size is 1 byte
PUBLIC         Param2_                  ; Space for parameter passing
Param2_:       DS 1                     ; Size is 1 byte

               ?LCD_DRV?X SEGMENT XDATA ; External RAM memory
               RSEG ?LCD_DRV?X
               
; +---------------------------------------------------------------------------+
; | PROGRAM CODE AREA                                                         |
; +---------------------------------------------------------------------------+
                                                                               
               ?LCD_DRV?C SEGMENT CODE  ; ROM memory
               RSEG ?LCD_DRV?C
               
; +---------------------------------------------------------------------------+
; | BUSYCHECK                                                                 |
; |                                                                           |
; | This routine waits until the busy flag is low                             |
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
; | PROCEDURE export GotoXY(Param1_,Param2_:BYTE DATA);                       |
; |                                                                           |
; | This routine moves the cursor on the LCD to position Param1_,Param2_      |
; +---------------------------------------------------------------------------+

PUBLIC         GotoXY                   ; Public routine
GotoXY:        MOV  A,Param1_           ; Get X coordinate
               DEC  A                   ; Correct 1,1 <=> 0,0 coordinates
               MOV  R2,Param2_          ; Get Y coordinate
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
; | PROCEDURE export Cursor(Param1_:BYTE DATA);                               |
; |                                                                           |
; | This turns the cursor ON (Param1_ = 1) or OFF (Param1_ = 0)               |
; +---------------------------------------------------------------------------+
               
PUBLIC         Cursor                   ; Public routine
Cursor:        MOV  A,Param1_           ; Get Parameter
               RLC  A                   ; Shift bit 0 to bit 1 using RLC
               ANL  A,#00000010B        ; Isolate second bit
               ORL  A,#00001100B        ; Cursor Display Control for HD44780
               CALL BUSYCHECK           ; Check Busy flag
               MOV  DPTR,#DISPCONTR     ; LCD Control Register
               MOVX @DPTR,A             ; Write value to Control Register
               RET                      ; And return to PASCAL program
               
END                                     ; END of Assembly file                