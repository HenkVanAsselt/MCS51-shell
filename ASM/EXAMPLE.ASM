; To become familiar with the segment feature you
; should assemble this file with and without the
; single object module swicth enabled.
;
;   a51  -o example         ;three object module files
                            ;     code.seg
                            ;     memory.seg
                            ;     rom2.seg
;
;   a51  example            ;one object module file
                            ;     example.obj


         ljmp loop
         .org  h'20         ;start assembly at location 20 hex.
         .segment .memory   ;declare a new segmemt for ram memory
                            ;allocation
         .memory            ;select segment .memory as active(locaton counter)
                            ;for the .code segment(created by the assembler) is
                            ;saved for when we switch back.
         .org  h'00         ;not really necessary as origin of 0 is assumed.
regbank0:
b0r0:    .rs   1            ;bank 0 register 0
b0r1:    .rs   1            ;bank 0 register 1
b0r2:    .rs   1            ;bank 0 register 2
b0r3:    .rs   1            ;bank 0 register 3
b0r4:    .rs   1            ;bank 0 register 4
b0r5:    .rs   1            ;bank 0 register 5
b0r6:    .rs   1            ;bank 0 register 6
b0r7:    .rs   1            ;bank 0 register 7
         .org 24
regbank1:
b1r0:    .rs   1            ;bank 1 register 0
b1r1:    .rs   1            ;bank 1 register 1
b1r2:    .rs   1            ;bank 1 register 2
b1r3:    .rs   1            ;bank 1 register 3
b1r4:    .rs   1            ;bank 1 register 4
b1r5:    .rs   1            ;bank 1 register 5
b1r6:    .rs   1            ;bank 1 register 6
b1r7:    .rs   1            ;bank 1 register 7
         .eject             ;lets start on a fresh page of paper.
         .code              ;switch back to code segment
                            ; origin is where we left off.
loop:    mov a,#h'22
         mov r0,#h'11
         add a,r0
         ljmp loop2         ;jump off page.
         .equ cr,13         ;equated identifiers are constant.
         .equ tab,9
         .set temp,23       ;set identifiers may be re-set.
         .set temp,24
         .set temp,25
         .db  1,2,3,4,5,'p'
         .db  6,7,"this is a test\r\n\0"
         .dw  1,h'1234
         .drw 1,h'1234
         .page              ;start on a new 256 byte boundary.
loop2:   ljmp loop
         .segment .rom2
         .rom2
         .org h'800
         .db  "this is possibly an external rom programmed seperately."
         .code
         .end loop          ;end of assembly, specifying start address.

