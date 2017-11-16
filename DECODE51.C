/*******************************************************************************
*                                                                              *
*        FILE: DECODE51.C                                                      *
*                                                                              *
*     PURPOSE: This file contains the function decode_51() to disassemble      *
*              8051 mnemonics                                                  *
*                                                                              *
* DESCRIPTION: -                                                               *
*                                                                              *
*     HISTORY: 920103 V0.1                                                     *
*                                                                              *
*******************************************************************************/

/*------------------------------------------------------------------------------
                        HEADER FILES
------------------------------------------------------------------------------*/
#include <stdio.h>
#include "51_dis.h"

/*-------------------------------------------------------------------
|   FUNCTION: decode_51()
|    PURPOSE: Get data for the opcode on the given address
| DESRIPTION: -
|    RETURNS: pointer to mnemonic string
|    VERSION: 911231 V0.1
---------------------------------------------------------------------*/
char *decode_51(BYTE    *obj_code,      /* Pointer to object code     */
                ADDRESS pc,             /* Address of opcode          */
                int     *length,        /* Instruction length         */
                BYTE    *byte1,         /* Instruction byte 1         */
                BYTE    *byte2,         /* Instruction byte 2         */
                BYTE    *byte3,         /* Instruction byte 3         */
                ADDRESS *bitaddress,    /* Bit Address                */
                ADDRESS *data_address,  /* Data Address               */
                ADDRESS *code_address,  /* Code Address               */
                int     *data)          /* Immediate data             */
{
  char *s = "";
  int len = 1;        /* Instruction length */
  BYTE b1, b2, b3;    /* Bytes 1,2 and 3    */
  ADDRESS b = -1;     /* Bit address        */
  ADDRESS c = -1;     /* Code address       */
  ADDRESS d = -1;     /* Data address       */
  int  i = -1;        /* Immediate Data     */

  b1 = obj_code[pc+0];
  b2 = obj_code[pc+1];
  b3 = obj_code[pc+2];

  switch (b1)  /* Opcode */
  {
    case 0x00: len=1; s="NOP             ";                   break;
    case 0x01: len=2; s="AJMP  c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0x02: len=3; s="LJMP  c         "; c=b2*256+b3;      break;
    case 0x03: len=1; s="RR    A         ";                   break;
    case 0x04: len=1; s="INC   A         ";                   break;
    case 0x05: len=2; s="INC   d         "; d=b2;             break;
    case 0x06: len=1; s="INC   @R0       ";                   break;
    case 0x07: len=1; s="INC   @R1       ";                   break;
    case 0x08: len=1; s="INC   R0        ";                   break;
    case 0x09: len=1; s="INC   R1        ";                   break;
    case 0x0A: len=1; s="INC   R2        ";                   break;
    case 0x0B: len=1; s="INC   R3        ";                   break;
    case 0x0C: len=1; s="INC   R4        ";                   break;
    case 0x0D: len=1; s="INC   R5        ";                   break;
    case 0x0E: len=1; s="INC   R6        ";                   break;
    case 0x0F: len=1; s="INC   R7        ";                   break;
    case 0x10: len=3; s="JBC   b,c       "; b=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0x11: len=2; s="ACALL c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0x12: len=3; s="LCALL c         "; c=b2*256+b3;      break;
    case 0x13: len=1; s="RRC   A         ";                   break;
    case 0x14: len=1; s="DEC   A         ";                   break;
    case 0x15: len=2; s="DEC   d         "; d=b2;             break;
    case 0x16: len=1; s="DEC   @R0       ";                   break;
    case 0x17: len=1; s="DEC   @R1       ";                   break;
    case 0x18: len=1; s="DEC   R0        ";                   break;
    case 0x19: len=1; s="DEC   R1        ";                   break;
    case 0x1A: len=1; s="DEC   R2        ";                   break;
    case 0x1B: len=1; s="DEC   R3        ";                   break;
    case 0x1C: len=1; s="DEC   R4        ";                   break;
    case 0x1D: len=1; s="DEC   R5        ";                   break;
    case 0x1E: len=1; s="DEC   R6        ";                   break;
    case 0x1F: len=1; s="DEC   R7        ";                   break;
    case 0x20: len=3; s="JB    b,c       "; b=b2;
      if (b3 < 0x7F) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0x21: len=2; s="AJMP  c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0x22: len=1; s="RET             ";                   break;
    case 0x23: len=1; s="RL    A         ";                   break;
    case 0x24: len=2; s="ADD   A,#i      "; i=b2;             break;
    case 0x25: len=2; s="ADD   A,d       "; d=b2;             break;
    case 0x26: len=1; s="ADD   A,@R0     ";                   break;
    case 0x27: len=1; s="ADD   A,@R1     ";                   break;
    case 0x28: len=1; s="ADD   A,R0      ";                   break;
    case 0x29: len=1; s="ADD   A,R1      ";                   break;
    case 0x2A: len=1; s="ADD   A,R2      ";                   break;
    case 0x2B: len=1; s="ADD   A,R3      ";                   break;
    case 0x2C: len=1; s="ADD   A,R4      ";                   break;
    case 0x2D: len=1; s="ADD   A,R5      ";                   break;
    case 0x2E: len=1; s="ADD   A,R6      ";                   break;
    case 0x2F: len=1; s="ADD   A,R7      ";                   break;
    case 0x30: len=3; s="JNB   b,c       "; b=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0x31: len=2; s="ACALL c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0x32: len=1; s="RETI            ";                   break;
    case 0x33: len=1; s="RLC   A         ";                   break;
    case 0x34: len=2; s="ADDC  A,#i      "; i=b2;             break;
    case 0x35: len=2; s="ADDC  A,d       "; d=b2;             break;
    case 0x36: len=1; s="ADDC  A,@R0     ";                   break;
    case 0x37: len=1; s="ADDC  A,@R1     ";                   break;
    case 0x38: len=1; s="ADDC  A,R0      ";                   break;
    case 0x39: len=1; s="ADDC  A,R1      ";                   break;
    case 0x3A: len=1; s="ADDC  A,R2      ";                   break;
    case 0x3B: len=1; s="ADDC  A,R3      ";                   break;
    case 0x3C: len=1; s="ADDC  A,R4      ";                   break;
    case 0x3D: len=1; s="ADDC  A,R5      ";                   break;
    case 0x3E: len=1; s="ADDC  A,R6      ";                   break;
    case 0x3F: len=1; s="ADDC  A,R7      ";                   break;
    case 0x40: len=2; s="JC    c         ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0x41: len=2; s="AJMP  c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0x42: len=2; s="ORL   d,A       "; d=b2;             break;
    case 0x43: len=3; s="ORL   d,#i      "; d=b2; i=b3;       break;
    case 0x44: len=2; s="ORL   A,#i      "; i=b2;             break;
    case 0x45: len=2; s="ORL   A,d       "; d=b2;             break;
    case 0x46: len=1; s="ORL   A,@R0     ";                   break;
    case 0x47: len=1; s="ORL   A,@R1     ";                   break;
    case 0x48: len=1; s="ORL   A,R0      ";                   break;
    case 0x49: len=1; s="ORL   A,R1      ";                   break;
    case 0x4A: len=1; s="ORL   A,R2      ";                   break;
    case 0x4B: len=1; s="ORL   A,R3      ";                   break;
    case 0x4C: len=1; s="ORL   A,R4      ";                   break;
    case 0x4D: len=1; s="ORL   A,R5      ";                   break;
    case 0x4E: len=1; s="ORL   A,R6      ";                   break;
    case 0x4F: len=1; s="ORL   A,R7      ";                   break;
    case 0x50: len=2; s="JNC   c         ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0x51: len=2; s="ACALL c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0x52: len=2; s="ANL   d,A       "; d=b2;             break;
    case 0x53: len=3; s="ANL   d,#i      "; d=b2; i=b3;       break;
    case 0x54: len=2; s="ANL   A,#i      "; i=b2;             break;
    case 0x55: len=2; s="ANL   A,d       "; d=b2;             break;
    case 0x56: len=1; s="ANL   A,@R0     ";                   break;
    case 0x57: len=1; s="ANL   A,@R1     ";                   break;
    case 0x58: len=1; s="ANL   A,R0      ";                   break;
    case 0x59: len=1; s="ANL   A,R1      ";                   break;
    case 0x5A: len=1; s="ANL   A,R2      ";                   break;
    case 0x5B: len=1; s="ANL   A,R3      ";                   break;
    case 0x5C: len=1; s="ANL   A,R4      ";                   break;
    case 0x5D: len=1; s="ANL   A,R5      ";                   break;
    case 0x5E: len=1; s="ANL   A,R6      ";                   break;
    case 0x5F: len=1; s="ANL   A,R7      ";                   break;
    case 0x60: len=2; s="JZ    c         ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0x61: len=2; s="AJMP  c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0x62: len=2; s="XRL   d,A       "; d=b2;             break;
    case 0x63: len=3; s="XRL   d,#i      "; d=b2; i=b3;       break;
    case 0x64: len=2; s="XRL   A,#i      "; i=b2;             break;
    case 0x65: len=2; s="XRL   A,d       "; d=b2;             break;
    case 0x66: len=1; s="XRL   A,@R0     ";                   break;
    case 0x67: len=1; s="XRL   A,@R1     ";                   break;
    case 0x68: len=1; s="XRL   A,R0      ";                   break;
    case 0x69: len=1; s="XRL   A,R1      ";                   break;
    case 0x6A: len=1; s="XRL   A,R2      ";                   break;
    case 0x6B: len=1; s="XRL   A,R3      ";                   break;
    case 0x6C: len=1; s="XRL   A,R4      ";                   break;
    case 0x6D: len=1; s="XRL   A,R5      ";                   break;
    case 0x6E: len=1; s="XRL   A,R6      ";                   break;
    case 0x6F: len=1; s="XRL   A,R7      ";                   break;
    case 0x70: len=2; s="JNZ   c         ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0x71: len=2; s="ACALL c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0x72: len=2; s="ORL   C,b       "; b=b2;             break;
    case 0x73: len=1; s="JMP   @A+DPTR   ";                   break;
    case 0x74: len=2; s="MOV   A,#i      "; i=b2;             break;
    case 0x75: len=3; s="MOV   d,#i      "; d=b2;i=b3;        break;
    case 0x76: len=2; s="MOV   @R0,#i    "; i=b2;             break;
    case 0x77: len=2; s="MOV   @R1,#i    "; i=b2;             break;
    case 0x78: len=2; s="MOV   R0,#i     "; i=b2;             break;
    case 0x79: len=2; s="MOV   R1,#i     "; i=b2;             break;
    case 0x7A: len=2; s="MOV   R2,#i     "; i=b2;             break;
    case 0x7B: len=2; s="MOV   R3,#i     "; i=b2;             break;
    case 0x7C: len=2; s="MOV   R4,#i     "; i=b2;             break;
    case 0x7D: len=2; s="MOV   R5,#i     "; i=b2;             break;
    case 0x7E: len=2; s="MOV   R6,#i     "; i=b2;             break;
    case 0x7F: len=2; s="MOV   R7,#i     "; i=b2;             break;
    case 0x80: len=2; s="SJMP  c         ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0x81: len=2; s="AJMP  c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0x82: len=2; s="ANL   C,b       "; b=b2;             break;
    case 0x83: len=1; s="MOVC  A,@A+PC   ";                   break;
    case 0x84: len=1; s="DIV   AB        ";                   break;
    case 0x85: len=3; s="MOV   d,d       "; d=b2; c=b3;       break;
    case 0x86: len=2; s="MOV   d,@R0     "; d=b2;             break;
    case 0x87: len=2; s="MOV   d,@R1     "; d=b2;             break;
    case 0x88: len=2; s="MOV   d,R0      "; d=b2;             break;
    case 0x89: len=2; s="MOV   d,R1      "; d=b2;             break;
    case 0x8A: len=2; s="MOV   d,R2      "; d=b2;             break;
    case 0x8B: len=2; s="MOV   d,R3      "; d=b2;             break;
    case 0x8C: len=2; s="MOV   d,R4      "; d=b2;             break;
    case 0x8D: len=2; s="MOV   d,R5      "; d=b2;             break;
    case 0x8E: len=2; s="MOV   d,R6      "; d=b2;             break;
    case 0x8F: len=2; s="MOV   d,R7      "; d=b2;             break;
    case 0x90: len=3; s="MOV   DPTR,#i   "; i=b2*256+b3;      break;
    case 0x91: len=2; s="ACALL c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0x92: len=2; s="MOV   d,C       "; d=b2;             break;
    case 0x93: len=1; s="MOVC  A,@A+DPTR ";                   break;
    case 0x94: len=2; s="SUBB  A,#i      "; i=b2;             break;
    case 0x95: len=2; s="SUBB  A,d       "; d=b2;             break;
    case 0x96: len=1; s="SUBB  A,@R0     ";                   break;
    case 0x97: len=1; s="SUBB  A,@R1     ";                   break;
    case 0x98: len=1; s="SUBB  A,R0      ";                   break;
    case 0x99: len=1; s="SUBB  A,R1      ";                   break;
    case 0x9A: len=1; s="SUBB  A,R2      ";                   break;
    case 0x9B: len=1; s="SUBB  A,R3      ";                   break;
    case 0x9C: len=1; s="SUBB  A,R4      ";                   break;
    case 0x9D: len=1; s="SUBB  A,R5      ";                   break;
    case 0x9E: len=1; s="SUBB  A,R6      ";                   break;
    case 0x9F: len=1; s="SUBB  A,R7      ";                   break;
    case 0xA0: len=2; s="ORL   C,/b      "; b=b2;             break;
    case 0xA1: len=2; s="AJMP  c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0xA2: len=2; s="MOV   C,b       "; b=b2;             break;
    case 0xA3: len=1; s="INC   DPTR      ";                   break;
    case 0xA4: len=1; s="MUL   AB        ";                   break;
    case 0xA5: len=1; s="Reserved        ";                   break;
    case 0xA6: len=2; s="MOV   @R0,d     "; d=b2;             break;
    case 0xA7: len=2; s="MOV   @R1,d     "; d=b2;             break;
    case 0xA8: len=2; s="MOV   R0,d      "; d=b2;             break;
    case 0xA9: len=2; s="MOV   R1,d      "; d=b2;             break;
    case 0xAA: len=2; s="MOV   R2,d      "; d=b2;             break;
    case 0xAB: len=2; s="MOV   R3,d      "; d=b2;             break;
    case 0xAC: len=2; s="MOV   R4,d      "; d=b2;             break;
    case 0xAD: len=2; s="MOV   R5,d      "; d=b2;             break;
    case 0xAE: len=2; s="MOV   R6,d      "; d=b2;             break;
    case 0xAF: len=2; s="MOV   R7,d      "; d=b2;             break;
    case 0xB0: len=2; s="ANL   C,/b      "; b=b2;             break;
    case 0xB1: len=2; s="ACALL c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0xB2: len=2; s="CPL   b         "; b=b2;             break;
    case 0xB3: len=1; s="CPL   C         ";                   break;
    case 0xB4: len=3; s="CJNE  A,#i,c    "; i=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xB5: len=3; s="CJNE  A,d,c     "; d=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xB6: len=3; s="CJNE  @R0,#i,c  "; i=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xB7: len=3; s="CJNE  @R1,#i,c  "; i=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xB8: len=3; s="CJNE  R0,#i,c   "; i=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xB9: len=3; s="CJNE  R1,#i,c   "; i=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xBA: len=3; s="CJNE  R2,#i,c   "; i=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xBB: len=3; s="CJNE  R3,#i,c   "; i=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xBC: len=3; s="CJNE  R4,#i,c   "; i=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xBD: len=3; s="CJNE  R5,#i,c   "; i=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xBE: len=3; s="CJNE  R6,#i,c   "; i=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xBF: len=3; s="CJNE  R7,#i,c   "; i=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xC0: len=2; s="PUSH  d         "; d=b2;             break;
    case 0xC1: len=2; s="AJMP  c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0xC2: len=2; s="CLR   b         "; b=b2;             break;
    case 0xC3: len=1; s="CLR   C         ";                   break;
    case 0xC4: len=1; s="SWAP  A         ";                   break;
    case 0xC5: len=2; s="XCH   A,d       "; d=b2;             break;
    case 0xC6: len=1; s="XCH   A,@R0     ";                   break;
    case 0xC7: len=1; s="XCH   A,@R1     ";                   break;
    case 0xC8: len=1; s="XCH   A,R0      ";                   break;
    case 0xC9: len=1; s="XCH   A,R1      ";                   break;
    case 0xCA: len=1; s="XCH   A,R2      ";                   break;
    case 0xCB: len=1; s="XCH   A,R3      ";                   break;
    case 0xCC: len=1; s="XCH   A,R4      ";                   break;
    case 0xCD: len=1; s="XCH   A,R5      ";                   break;
    case 0xCE: len=1; s="XCH   A,R6      ";                   break;
    case 0xCF: len=1; s="XCH   A,R7      ";                   break;
    case 0xD0: len=2; s="POP   d         "; d=b2;             break;
    case 0xD1: len=2; s="ACALL c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0xD2: len=2; s="SETB  b         "; b=b2;             break;
    case 0xD3: len=1; s="SETB  C         ";                   break;
    case 0xD4: len=1; s="DA    A         ";                   break;
    case 0xD5: len=3; s="DJNZ  d,c       "; d=b2;
      if (b3 < 0x80) c=pc+len+b3; else c = pc+len-(0xFF-b3+1);break;
    case 0xD6: len=1; s="XCHD  A,@R0     ";                   break;
    case 0xD7: len=1; s="XCHD  A,@R1     ";                   break;
    case 0xD8: len=2; s="DJNZ  R0,c      ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0xD9: len=2; s="DJNZ  R1,c      ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0xDA: len=2; s="DJNZ  R2,c      ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0xDB: len=2; s="DJNZ  R3,c      ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0xDC: len=2; s="DJNZ  R4,c      ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0xDD: len=2; s="DJNZ  R5,c      ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0xDE: len=2; s="DJNZ  R6,c      ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0xDF: len=2; s="DJNZ  R7,c      ";
      if (b2 < 0x80) c=pc+len+b2; else c = pc+len-(0xFF-b2+1);break;
    case 0xE0: len=1; s="MOVX  A,@DPTR   ";                   break;
    case 0xE1: len=2; s="AJMP  c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0xE2: len=1; s="MOVX  A,@R0     ";                   break;
    case 0xE3: len=1; s="MOVX  A,@R1     ";                   break;
    case 0xE4: len=1; s="CLR   A         ";                   break;
    case 0xE5: len=2; s="MOV   A,d       "; d=b2;             break;
    case 0xE6: len=1; s="MOV   A,@R0     ";                   break;
    case 0xE7: len=1; s="MOV   A,@R1     ";                   break;
    case 0xE8: len=1; s="MOV   A,R0      ";                   break;
    case 0xE9: len=1; s="MOV   A,R1      ";                   break;
    case 0xEA: len=1; s="MOV   A,R2      ";                   break;
    case 0xEB: len=1; s="MOV   A,R3      ";                   break;
    case 0xEC: len=1; s="MOV   A,R4      ";                   break;
    case 0xED: len=1; s="MOV   A,R5      ";                   break;
    case 0xEE: len=1; s="MOV   A,R6      ";                   break;
    case 0xEF: len=1; s="MOV   A,R7      ";                   break;
    case 0xF0: len=1; s="MOVX  @DPTR,A   ";                   break;
    case 0xF1: len=2; s="ACALL c         ";
      c=(b1>>5)*256+b2; pc+=2; c&=0x7FF; c|=(pc & 0xF800);    break;
    case 0xF2: len=1; s="MOVX  @R0,A     ";                   break;
    case 0xF3: len=1; s="MOVX  @R1,A     ";                   break;
    case 0xF4: len=1; s="CPL   A         ";                   break;
    case 0xF5: len=2; s="MOV   d,A       "; d=b2;             break;
    case 0xF6: len=1; s="MOV   @R0,A     ";                   break;
    case 0xF7: len=1; s="MOV   @R1,A     ";                   break;
    case 0xF8: len=1; s="MOV   R0,A      ";                   break;
    case 0xF9: len=1; s="MOV   R1,A      ";                   break;
    case 0xFA: len=1; s="MOV   R2,A      ";                   break;
    case 0xFB: len=1; s="MOV   R3,A      ";                   break;
    case 0xFC: len=1; s="MOV   R4,A      ";                   break;
    case 0xFD: len=1; s="MOV   R5,A      ";                   break;
    case 0xFE: len=1; s="MOV   R6,A      ";                   break;
    case 0xFF: len=1; s="MOV   R7,A      ";                   break;

    default:
      s = "";
      printf("Unknown opcode %02xh\n",b1);
      break;
  }

  *byte1        = b1;
  *byte2        = b2;
  *byte3        = b3;
  *length       = len;
  *bitaddress   = b;
  *code_address = c;
  *data_address = d;
  *data         = i;
  return(s);
}
