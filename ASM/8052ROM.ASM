
;MCS51 Disassembler, 911230 V0.1 (C) HvA
  CPU "8051.tbl"
  HOF "INT16"

;Source: 8052ROM.HEX.HEX
;Output: 8052ROM.HEX.DIS - Created on 92-03-01 22:27:31

;****************************************
;  BIT ADDRESSES
;****************************************
ONTIME_executed     EQU  00010H  ;1 = 'ONTIME' statement is executed
BASIC_int_in_prog   EQU  00011H  ;1 = basic interrupt in progress
ONEX1_exe           EQU  00012H  ;1 = 'ONEX1' statement is executed
ONERR_exe           EQU  00013H  ;1 = 'ONERR' statement is executed
ONTIME_exe          EQU  00014H  ;1 = 'ONTIME' interrupt in progress
line_edit           EQU  00015H  ;1 = line is edited
ext_int_pending     EQU  00016H  ;1 = external interrupt pending
enable_cont         EQU  00017H  ;1 = 'CONT' command will work
P0.0                EQU  00080H  
P0.1                EQU  00081H  
P0.2                EQU  00082H  
P0.3                EQU  00083H  
P0.7                EQU  00087H  
IT0                 EQU  00088H  
IE0                 EQU  00089H  
IT1                 EQU  0008AH  
IE1                 EQU  0008BH  
TR0                 EQU  0008CH  
TF0                 EQU  0008DH  
T2                  EQU  00090H  
RI                  EQU  00098H  
TI                  EQU  00099H  
P2.0                EQU  000A0H  
EX0                 EQU  000A8H  
P3.0                EQU  000B0H  
PX0                 EQU  000B8H  
CP/!R               EQU  000C8H  
TR2                 EQU  000CAH  
EXEN2               EQU  000CBH  
TCLK                EQU  000CCH  
RCLK                EQU  000CDH  
P                   EQU  000D0H  
ACC.0               EQU  000E0H  
B.0                 EQU  000F0H  
get_flag            EQU  00018H  ;1 = flag for 'GET' operator
print_list_exe      EQU  00019H  ;1 = 'PRINT@' or 'LIST@' evoked
trap_timer1         EQU  0001AH  ;Trap 'TIMER1' interrrupt
LP_CON_out_ctrl     EQU  0001BH  ;1 = LP CON output control
user_CON_out_ctrl   EQU  0001CH  ;1 = user def CON output control
array_init          EQU  0001DH  ;Basic array initialization bit
user_CON_in_ctrl    EQU  0001EH  ;1 = user def CON input control
trap_serial_port    EQU  0001FH  ;Trap serial port interrupt
STOP_CTRLC_found    EQU  00020H  ;STOP or CTRL encountered
user_idle_break     EQU  00021H  ;User idle break bit
input_exe           EQU  00022H  ;1 = input instruction in progress
reserved            EQU  00023H  ;Reserved
arg_stack_value     EQU  00024H  ;1 = argument stack has a value
RETI_exe            EQU  00025H  ;RETI instruction executed
trap_ext0           EQU  00026H  ;Trap external interrupt 0
valid_@_driver      EQU  00027H  ;1 = valid '...@' driver by user
soft_trap_test      EQU  00028H  ;Software trap test
find_eop            EQU  00029H  ;1 = Find the end of program
DIM_statement       EQU  0002AH  ;1 = DIM statement
int_stat_save       EQU  0002BH  ;Interrupt status save bit
input_trap          EQU  0002CH  ;Input trap
exp_present         EQU  0002DH  ;1 = expansion present
CLOCK1_exe          EQU  0002EH  ;1 = 'CLOCK1' executed, else cleared
command_mode        EQU  0002FH  ;1 = basic command mode
disable_CTRLC       EQU  00030H  ;1 = disable CONTROL-C
enable_fake_DMA     EQU  00031H  ;1 = enable 'fake' DMA
output_trap         EQU  00032H  ;Output trap
intelligent_prom    EQU  00033H  ;1 = 'INTELLIGENT' PROM programming
ROM_text            EQU  00034H  ;1 = print text string from ROM
XOFF_found          EQU  00035H  ;1 = 'CONTROL-S' (XOFF) encountered
hex_no_zero         EQU  00036H  ;1 = no zeros in 'HEX mode' print
hex_mode            EQU  00037H  ;1 = 'HEX mode' print
P0.4                EQU  00084H  
P0.5                EQU  00085H  
P0.6                EQU  00086H  
TF1                 EQU  0008FH  
TR1                 EQU  0008EH  
T2EX                EQU  00091H  
PWM_OUT             EQU  00092H  
ALE_DISABLE         EQU  00093H  
PGM_PULSE           EQU  00094H  
PGM_ENABLE          EQU  00095H  
NOT_DMA_ACK         EQU  00096H  
LP_OUT              EQU  00097H  
SM0                 EQU  0009FH  
SM1                 EQU  0009EH  
SM2                 EQU  0009DH  
REN                 EQU  0009CH  
TB8                 EQU  0009BH  
RB8                 EQU  0009AH  
P2.1                EQU  000A1H  
P2.2                EQU  000A2H  
P2.3                EQU  000A3H  
P2.4                EQU  000A4H  
P2.5                EQU  000A5H  
P2.6                EQU  000A6H  
P2.7                EQU  000A7H  
EA                  EQU  000AFH  
ET2                 EQU  000ADH  
ES                  EQU  000ACH  
ET1                 EQU  000ABH  
EX1                 EQU  000AAH  
ET0                 EQU  000A9H  
P3.1                EQU  000B1H  
P3.2                EQU  000B2H  
P3.3                EQU  000B3H  
P3.4                EQU  000B4H  
P3.5                EQU  000B5H  
P3.6                EQU  000B6H  
P3.7                EQU  000B7H  
PT2                 EQU  000BDH  
PS                  EQU  000BCH  
PT1                 EQU  000BBH  
PX1                 EQU  000BAH  
PT0                 EQU  000B9H  
TF2                 EQU  000CFH  
EXF2                EQU  000CEH  
C/!T2               EQU  000C9H  
CY                  EQU  000D7H  
AC                  EQU  000D6H  
F0                  EQU  000D5H  
RS1                 EQU  000D4H  
RS0                 EQU  000D3H  
OV                  EQU  000D2H  
ACC.1               EQU  000E1H  
ACC.2               EQU  000E2H  
ACC.3               EQU  000E3H  
ACC.4               EQU  000E4H  
ACC.5               EQU  000E5H  
ACC.6               EQU  000E6H  
ACC.7               EQU  000E7H  
B.1                 EQU  000F1H  
B.2                 EQU  000F2H  
B.3                 EQU  000F3H  
B.4                 EQU  000F4H  
B.5                 EQU  000F5H  
B.6                 EQU  000F6H  
B.7                 EQU  000F7H  
;****************************************
;  EXTERNAL DATA DEFINITIONS
;****************************************
X_0000              EQU  00000H  ;Not used, reserved
X_0003              EQU  00003H  ;Not used, reserved
X_005f              EQU  0005FH  ;Used for 'POWER-UP' trap (=0A5h)
X_0101              EQU  00101H  ;Location to save error character code
X_0104              EQU  00104H  ;Top of variable storage (H)
X_0001              EQU  00001H  ;Not used, reserved
X_0002              EQU  00002H  ;Not used, reserved
X_0004              EQU  00004H  ;Length of the current edited line
X_0005              EQU  00005H  ;'LN NUM' in bin. of current edited line (H)
X_0006              EQU  00006H  ;'LN NUM' in bin. of current edited line (L)
X_005e              EQU  0005EH  ;Used for 'RUN' trap mode (=34h)
X_00ff              EQU  000FFH  ;Control stack overflow
X_0100              EQU  00100H  ;Location to save 'GET' character
X_0102              EQU  00102H  ;Location to go to on user 'ONERR' (H)
X_0103              EQU  00103H  ;Location to go to on user 'ONERR' (L)
X_0105              EQU  00105H  ;Top of variable storage (L)
X_0106              EQU  00106H  ;FP storage allocation (H)
X_0107              EQU  00107H  ;FP storage allocation (L)
X_0108              EQU  00108H  ;Memory allocated for matrices (H)
X_0109              EQU  00109H  ;Memory allocated for matrices (L)
X_010a              EQU  0010AH  ;Top of memory assigned to basic (H)
X_010b              EQU  0010BH  ;Top of memory assigned to basic (L)
X_010c              EQU  0010CH  ;Random number seed (H)
X_010d              EQU  0010DH  ;Random number seed (L)
X_0120              EQU  00120H  ;Location to go to on 'ONEX1' interrupt (H)
X_0121              EQU  00121H  ;Location to go to on 'ONEX1' interrupt (L)
X_0122              EQU  00122H  ;Number of bytes allocated for strings (H)
X_0123              EQU  00123H  ;Number of bytes allocated for strings (L)
X_0124              EQU  00124H  ;Software serial port baudrate (H)
X_0125              EQU  00125H  ;Software serial port baudrate (L)
X_0126              EQU  00126H  ;Line number for 'ONTIME' interrupt (H)
X_0127              EQU  00127H  ;Line number for 'ONTIME' interrupt (L)
X_0128              EQU  00128H  ;'NORMAL' PROM programmer timeout (H)
X_0129              EQU  00129H  ;'NORMAL' PROM programmer timeout (L)
X_012A              EQU  0012AH  ;'INTELLIGENT' PROM programmer time out (H)
X_012b              EQU  0012BH  ;'INTELLIGENT' PROM programmer time out (L)
X_012C              EQU  0012CH  ;Reserved
;****************************************
;  INTERNAL DATA DEFINITIONS
;****************************************
BASIC_text_ptr_L    EQU  00008H  
arg_stack_ptr       EQU  00009H  
BASIC_text_ptr_H    EQU  0000AH  
READ_text_ptr_L     EQU  00010H  
ctrl_stack_ptr      EQU  00011H  
READ_text_ptr_H     EQU  00012H  
BAS_prog_start_H    EQU  00013H  
BAS_prog_start_L    EQU  00014H  
NULL_count          EQU  00015H  
Printhead_pos       EQU  00016H  
FP_out_format       EQU  00017H  
timer1_reload_loc_H  EQU  00040H  
timer1_reload_loc_L  EQU  00041H  
BAS_txtptr_saveloc_H  EQU  00042H  
BAS_txtptr_saveloc_L  EQU  00043H  
Clock_ms            EQU  00047H  
Clock_sec_H         EQU  00048H  
Clock_sec_L         EQU  00049H  
Timer0_reload       EQU  0004AH  
ONTIME_user_H       EQU  0004BH  
ONTIME_user_L       EQU  0004CH  
P0                  EQU  00080H  
SP                  EQU  00081H  
DPL                 EQU  00082H  
DPH                 EQU  00083H  
PCON                EQU  00087H  
TCON                EQU  00088H  
TMOD                EQU  00089H  
TL0                 EQU  0008AH  
TL1                 EQU  0008BH  
TH0                 EQU  0008CH  
TH1                 EQU  0008DH  
P1                  EQU  00090H  
SCON                EQU  00098H  
SBUF                EQU  00099H  
P2                  EQU  000A0H  
IE                  EQU  000A8H  
P3                  EQU  000B0H  
IP                  EQU  000B8H  
T2CON               EQU  000C8H  
RCAP2L              EQU  000CAH  
RCAP2H              EQU  000CBH  
TL2                 EQU  000CCH  
TH2                 EQU  000CDH  
PSW                 EQU  000D0H  
ACC                 EQU  000E0H  
B                   EQU  000F0H  

                  ;***
                  ;*** RESET address
                  ;***
Start:            AJMP  Default_regs                       
                  ADDC  A,@R1                              

                  ;***
                  ;*** External interrupt 0 interrupt address
                  ;***
Ext0_int:         JB    enable_fake_DMA,L_0033             
                  PUSH  L_00D0                             

; phase error, pc = 0008 label = ‹F‰†hÿ>þ new pc = 000A

L_0008:           LJMP  XTRN_ext0_int                      
L_000A:           RR    A                                  

                  ;***
                  ;*** Timer 0 overflow interrupt address
                  ;***
Tim0_int:         PUSH  L_00D0                             

; phase error, pc = 000D label = ‹F‰†hÿ>þ new pc = 000E

                  JB    CLOCK1_exe,L_0020                  
L_000E:           ADD   A,R6                               
L_000F:           JBC   02h,0052h                          
                  INC   R3                                 

                  ;***
                  ;*** External interrupt 1 interrupt address
                  ;***

; phase error, pc = 0013 label = ‹F‰†hÿ>þ new pc = 0014

Ext1_int:         JB    ONEX1_exe,L_0041                   
L_0014:           LCALL 2BC0h                              
                  POP   X_0002                             
                  JC    002Eh                              

                  ;***
                  ;*** Timer 1 overflow interrupt address
                  ;***
Tim1_int:         PUSH  L_00D0                             
                  LJMP  L_1F78                             
L_0020:           LJMP  L_18FC                             

                  ;***
                  ;*** Timer 2 overflow interrupt address
                  ;***
Tim2_int:         PUSH  L_00D0                             
                  JB    trap_serial_port,serial_int        
                  LJMP  XTRN_tim2_int                      
                  PUSH  L_00D0                             
                  LJMP  L_402B                             
call_BAS_entry:   LJMP  test_RB0                           
L_0033:           JB    trap_ext0,L_003E                   
                  CLR   NOT_DMA_ACK                        
L_0038:           JNB   P3.2,L_0038                        
                  SETB  NOT_DMA_ACK                        
                  RETI                                     
L_003E:           LJMP  L_2040                             

; phase error, pc = 0041 label = ‹F‰†hÿ>þ new pc = 0042

L_0041:           SETB  ext_int_pending                    
L_0042:           DEC   @R0                                
L_0043:           RETI                                     
serial_int:       LJMP  L_2050                             
opbyte_00_entry:  DFB   L=1 17h                            
                  DFB   L=1 7eh                            
opbyte_01_entry:  DFB   L=1 12h                            
                  DFB   L=1 0eh                            
opbyte_02_entry:  DFB   L=1 0fh                            
                  DFB   L=1 e0h                            
opbyte_03_entry:  DFB   L=2 0fd6h                          
opbyte_04_entry:  DFB   L=1 04h                            
                  DFB   L=1 95h                            
opbyte_05_entry:  DFB   L=1 06h                            
                  DFB   L=1 d2h                            
opbyte_06_entry:  DFB   L=1 06h                            
                  DFB   L=1 b9h                            
opbyte_07_entry:  DFB   L=2 069fh                          
opbyte_08_entry:  DFB   L=2 1397h                          
opbyte_09_entry:  DFB   L=2 1316h                          
opbyte_0a_entry:  DFB   L=2 119bh                          
opbyte_0b_entry:  DFB   L=2 1738h                          
opbyte_0c_entry:  DFB   L=1 13h                            
                  DFB   L=1 f5h                            
opbyte_0d_entry:  DFB   L=2 1713h                          
opbyte_0e_entry:  DFB   L=2 1483h                          
opbyte_0f_entry:  DFB   L=2 146fh                          
opbyte_10_entry:  DFB   L=2 1478h                          
opbyte_11_entry:  DFB   L=2 138ch                          
opbyte_12_entry:  DFB   L=2 13c6h                          
opbyte_13_entry:  DFB   L=2 13d2h                          
opbyte_14_entry:  DFB   L=2 13d6h                          
opbyte_15_entry:  DFB   L=2 13cch                          
opbyte_16_entry:  DFB   L=2 13c1h                          
opbyte_17_entry:  DFB   L=2 13b0h                          
opbyte_18_entry:  DFB   L=2 137ah                          
opbyte_19_entry:  DFB   L=2 1358h                          
opbyte_1a_entry:  DFB   L=1 13h                            
                  DFB   L=1 80h                            
opbyte_1b_entry:  DFB   L=2 1481h                          
opbyte_1c_entry:  DFB   L=2 1158h                          

; phase error, pc = 0081 label = ‹F‰†hÿ>þ new pc = 0082

L_0081:           ACALL 00BBh                              

; phase error, pc = 0082 label = ‹F‰†hÿ>þ new pc = 0083

L_0082:           CJNE  R3,#011h,00E1h                     
L_0083:           ACALL 005Ch                              
opbyte_1f_entry:  DFB   L=2 1278h                          
opbyte_20_entry:  DFB   L=1 13h                            
                  DFB   L=1 98h                            
opbyte_21_entry:  DFB   L=1 13h                            
                  DFB   L=1 12h                            

; phase error, pc = 008B label = ‹F‰†hÿ>þ new pc = 008C

L_008B:           ACALL 00CBh                              
L_008C:           XCH   A,R3                               
L_008D:           LCALL AB13h                              
                  AJMP  0513h                              
                  MOV   R1,L_0014                          
                  XRL   A,R2                               
opbyte_27_entry:  DFB   L=2 13dch                          
opbyte_28_entry:  DFB   L=1 14h                            
                  DFB   L=1 94h                            
opbyte_29_entry:  DFB   L=1 17h                            
                  DFB   L=1 08h                            
opbyte_2a_entry:  DFB   L=2 1718h                          
opbyte_2b_entry:  DFB   L=2 0fdch                          
opbyte_2c_entry:  DFB   L=2 163ah                          
opbyte_2d_entry:  DFB   L=2 1720h                          
opbyte_2e_entry:  DFB   L=2 14a4h                          
opbyte_2f_entry:  DFB   L=2 14a8h                          
opbyte_30_entry:  DFB   L=2 14ach                          
opbyte_31_entry:  DFB   L=2 14b2h                          
opbyte_32_entry:  DFB   L=2 14b8h                          
opbyte_33_entry:  DFB   L=2 14beh                          
opbyte_34_entry:  DFB   L=1 14h                            
                  DFB   L=1 c2h                            
opbyte_35_entry:  DFB   L=2 14c6h                          
opbyte_36_entry:  DFB   L=2 14cah                          
opbyte_37_entry:  DFB   L=2 14d0h                          
opbyte_38_entry:  DFB   L=2 14d4h                          
opbyte_39_entry:  DFB   L=2 0f46h                          
opbyte_3a_entry:  DFB   L=2 1647h                          
opbyte_3b_entry:  DFB   L=2 14dbh                          
opbyte_3c_entry:  DFB   L=2 15a5h                          
opbyte_3d_entry:  DFB   L=2 1085h                          
opbyte_3e_entry:  DFB   L=1 0dh                            
                  DFB   L=1 68h                            
opbyte_3f_entry:  DFB   L=2 0ed0h                          
opbyte_40_entry:  DFB   L=2 0ed8h                          
opbyte_41_entry:  DFB   L=2 078bh                          
opbyte_42_entry:  DFB   L=1 08h                            
                  DFB   L=1 08h                            
opbyte_43_entry:  DFB   L=1 01h                            
                  DFB   L=1 0fh                            
opbyte_44_entry:  DFB   L=2 0e0ah                          
opbyte_45_entry:  DFB   L=2 080ah                          
opbyte_46_entry:  DFB   L=2 0803h                          
opbyte_47_entry:  DFB   L=1 05h                            
                  DFB   L=1 04h                            
opbyte_48_entry:  DFB   L=2 0c06h                          
opbyte_49_entry:  DFB   L=2 0606h                          
opbyte_4a_entry:  DFB   L=2 0606h                          
opbyte_4b_entry:  DFB   L=2 060fh                          
opbyte_4c_entry:  DFB   L=2 0f0fh                          
opbyte_4d_entry:  DFB   L=1 0fh                            
                  DFB   L=1 0fh                            
opbyte_4e_entry:  DFB   L=2 0f0fh                          
opbyte_4f_entry:  DFB   L=2 0f0fh                          
                  DFB   L=1 0fh                            
                  DFB   L=1 0fh                            
                  DFB   L=1 0fh                            
                  DFB   L=1 0fh                            
                  DFB   L=1 0fh                            
STOP_str:         DFB   "STOP"                             
TRY_str:          DFB   "TRY AGAIN"                        
READY_str:        DFB   "READY"                            
-_str:            DFB   "                                  
                  DFB   "-                                 
                  DFB   "                                  
IN_LINE_str:      DFB   "I                                 
                  DFB   "N                                 
                  DFB   "                                  
                  DFB   "L                                 
                  DFB   "I                                 
                  DFB   "N                                 
                  DFB   "E                                 
                  DFB   "                                  
                  DFB   """                                
                  DFB   08h                                
                  DFB   08h                                
                  DFB   10h                                
                  DFB   "3"                                
                  DFB   0bh                                
                  DFB   0bh                                
                  DFB   06h                                
                  DFB   "V"                                
                  DFB   18h                                
                  DFB   "8"                                
                  DFB   04h                                
                  DFB   "a"                                
                  DFB   17h                                
                  DFB   "j"                                
                  DFB   17h                                
                  DFB   "v"                                
                  DFB   05h                                
                  DFB   "6"                                
                  DFB   04h                                
                  DFB   "Z"                                
                  DFB   09h                                
                  DFB   "q"                                
                  DFB   06h                                
                  DFB   89h                                
                  DFB   0ah                                
                  DFB   "y"                                
                  DFB   0ah                                
                  DFB   adh                                
                  DFB   16h                                
                  DFB   "}"                                
                  DFB   0ch                                
                  DFB   ","                                
                  DFB   19h                                
                  DFB   "%"                                
                  DFB   19h                                
                  DFB   "*"                                
                  DFB   0ah                                
                  DFB   80h                                
                  DFB   0ch                                
                  DFB   "0"                                
                  DFB   0eh                                
                  DFB   "f"                                
                  DFB   0dh                                
                  DFB   "d"                                
                  DFB   06h                                
                  DFB   06h                                
                  DFB   16h                                
                  DFB   f0h                                
                  DFB   19h                                
                  DFB   12h                                
                  DFB   0ch                                
                  DFB   "."                                
                  DFB   08h                                
                  DFB   "^"                                
                  DFB   0eh                                
                  DFB   "Y"                                
                  DFB   14h                                
                  DFB   04h                                
                  DFB   0bh                                
                  DFB   11h                                
                  DFB   0fh                                
                  DFB   08h                                
                  DFB   0bh                                
                  DFB   d1h                                
                  DFB   0eh                                
                  DFB   ffh                                
                  DFB   0bh                                
                  DFB   "b"                                
                  DFB   13h                                
                  DFB   fah                                
                  DFB   0ch                                
                  DFB   eeh                                
                  DFB   0dh                                
                  DFB   f8h                                
                  DFB   0bh                                
                  DFB   e6h                                
                  DFB   0eh                                
                  DFB   efh                                
                  DFB   0bh                                
                  DFB   13h                                
                  DFB   0ah                                
                  DFB   89h                                
                  DFB   0bh                                
                  DFB   "0"                                
                  DFB   0ah                                
                  DFB   "?"                                
                  DFB   0ah                                
                  DFB   ffh                                
                  DFB   0bh                                
                  DFB   04h                                
                  DFB   17h                                
                  DFB   "~"                                
                  DFB   18h                                
                  DFB   "U"                                
                  DFB   0fh                                
                  DFB   e8h                                
                  DFB   0fh                                
                  DFB   ech                                
                  DFB   05h                                
                  DFB   0ch                                
                  DFB   07h                                
                  DFB   beh                                
LET_token:        DFB   80h,LET"                           
CLEAR_token:      DFB   81h,CLEAR"                         
PUSH_token:       DFB   82h,PUSH"                          
GOTO_token:       DFB   83h,GOTO"                          
PWM_token:        DFB   84h,PWM"                           
PH0._token:       DFB   85h,PH0."                          
UI_token:         DFB   86h,UI"                            
UO_token:         DFB   87h,UO"                            
POP_token:        DFB   88h,POP"                           
PRINT_token:      DFB   89h,PRINT"                         
P._token:         DFB   89h,P."                            
?_token:          DFB   89h,?"                             
CALL_token:       DFB   8ah,CALL"                          
DIM_token:        DFB   8bh,DIM"                           
STRING_token:     DFB   8ch,STRING"                        
BAUD_token:       DFB   8dh,BAUD"                          
CLOCK_token:      DFB   8eh,CLOCK"                         
PH1._token:       DFB   8fh,PH1."                          
STOP_token:       DFB   90h,STOP"                          
ONTIME_token:     DFB   91h,ONTIME"                        
ONEX1_token:      DFB   92h,ONEX1"                         
RETI_token:       DFB   93h,RETI"                          
DO_token:         DFB   94h,DO"                            
RESTORE_token:    DFB   95h,RESTORE"                       
REM_token:        DFB   96h,REM"                           
NEXT_token:       DFB   97h,NEXT"                          
ONERR_token:      DFB   98h,ONERR"                         
ON_token:         DFB   99h,ON"                            
INPUT_token:      DFB   9ah,INPUT"                         
READ_token:       DFB   9bh,READ"                          
DATA_token:       DFB   9ch,DATA"                          
RETURN_token:     DFB   9dh,RETURN"                        
IF_token:         DFB   9eh,IF"                            
GOSUB_token:      DFB   9fh,GOSUB"                         
FOR_token:        DFB   a0h,FOR"                           
WHILE_token:      DFB   a1h,WHILE"                         
UNTIL_token:      DFB   a2h,UNTIL"                         
END_token:        DFB   a3h,END"                           
TAB_token:        DFB   a4h,TAB"                           
THEN_token:       DFB   a5h,THEN"                          
TO_token:         DFB   a6h,TO"                            
STEP_token:       DFB   a7h,STEP"                          
ELSE_token:       DFB   a8h,ELSE"                          
SPC_token:        DFB   a9h,SPC"                           
CR_token:         DFB   aah,CR"                            
IDLE_token:       DFB   abh,IDLE"                          
ST@_token:        DFB   ach,ST@"                           
LD@_token:        DFB   adh,LD@"                           
PGM_token:        DFB   aeh,PGM"                           
RROM_token:       DFB   afh,RROM"                          
(_token:          DFB   e0h,("                             
PWR_token:        DFB   e1h,**"                            
MUL_token:        DFB   e2h,*"                             
PLUS_token:       DFB   e3h,+"                             
DIV_token:        DFB   e4h,/"                             
MIN_token:        DFB   e5h,-"                             
XOR_token:        DFB   e6h,.XOR."                         
AND_token:        DFB   e7h,.AND."                         
OR_token:         DFB   e8h,.OR."                          
EQ_token:         DFB   eah,="                             
GE_token:         DFB   ebh,>="                            
                  DFB   ech                                
LE_token:         DFB   "<=",edh                           
                  DFB   "<                                 
                  DFB   ">"                                
LT_token:         DFB   eeh,<"                             
                  DFB   efh                                
                  DFB   ">"                                
ABS_token:        DFB   b0h,ABS"                           
INT_token:        DFB   b1h,INT"                           
SGN_token:        DFB   b2h,SGN"                           
NOT_token:        DFB   b3h,NOT"                           
COS_token:        DFB   b4h,COS"                           
TAN_token:        DFB   b5h,TAN"                           
SIN_token:        DFB   b6h,SIN"                           
SQR_token:        DFB   b7h,SQR"                           
CBY_token:        DFB   b8h,CBY"                           
EXP_token:        DFB   b9h,EXP"                           
ATN_token:        DFB   bah,ATN"                           
LOG_token:        DFB   bbh,LOG"                           
DBY_token:        DFB   bch,DBY"                           
XBY_token:        DFB   bdh,XBY"                           
PI_token:         DFB   beh,PI"                            
RND_token:        DFB   bfh,RND"                           
GET_token:        DFB   c0h,GET"                           
FREE_token:       DFB   c1h,FREE"                          
LEN_token:        DFB   c2h,LEN"                           
XTAL_token:       DFB   c3h,XTAL"                          
MTOP_token:       DFB   c4h,MTOP"                          
IE_token:         DFB   c6h,IE"                            
IP_token:         DFB   c7h,IP"                            
TIMER0_token:     DFB   c8h,TIMER0"                        
TIMER1_token:     DFB   c9h,TIMER1"                        
TIMER2_token:     DFB   cah,TIMER2"                        
TIME_token:       DFB   c5h,TIME"                          
T2CON_token:      DFB   cbh,T2CON"                         
TCON_token:       DFB   cch,TCON"                          
TMOD_token:       DFB   cdh,TMOD"                          
RCAP2_token:      DFB   ceh,RCAP2"                         
PORT1_token:      DFB   cfh,PORT1"                         
PCON_token:       DFB   d0h,PCON"                          
ASC(_token:       DFB   d1h,ASC("                          
USING(_token:     DFB   d2h,USING("                        
U.(token:         DFB   d2h,U.("                           
CHR(_token:       DFB   d3h,CHR("                          
RUN_token:        DFB   f0h,RUN"                           
LIST_token:       DFB   f1h,LIST"                          
NULL_token:       DFB   f2h,NULL"                          
NEW_token:        DFB   f3h,NEW"                           
CONT_token:       DFB   f4h,CONT"                          
PROG_token:       DFB   f5h,PROG"                          
XFER_token:       DFB   f6h,XFER"                          
RAM_token:        DFB   f7h,RAM"                           
ROM_token:        DFB   f8h,ROM"                           
FPROG_token:      DFB   f9h,FPROG"                         
EXTRA_IGN_msg:    DFB   ffh,EXTRA IGNORED"                 
A_STACK_msg:      DFB   "A-STACK"                          
C_STACK_msg:      DFB   "C-STACK"                          
Default_regs:     MOV   L_0098,#05Ah                       
                  MOV   L_0089,#010h                       
                  MOV   L_0088,#054h                       
                  MOV   L_00C8,#034h                       
                  MOV   DPTR,#02001h                       
Check_asm_rst:    CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  CJNE  A,#0aah,Clear_256B_ram             
                  LCALL user_asm_reset                     
Clear_256B_ram:   MOV   R0,#0ffh                           
                  CLR   A                                  
L_03A1:           MOV   @R0,A                              
                  DJNZ  R0,L_03A1                          
Set_mem_vars:     MOV   L_003E,#04Dh                       
                  MOV   L_003E,L_0081                      
                  MOV   L_0013,#080h                       
                  MOV   L_0014,#011h                       
EPROM_prg_mode:   MOV   DPTR,#08000h                       
                  MOVX  A,@DPTR                            
                  CLR   C                                  
                  SUBB  A,#031h                            
                  MOV   L_0045,A                           
                  CLR   ACC.2                              
                  MOV   R7,A                               
EPROM_RCAP2:      INC   DPTR                               
                  ACALL L_05B4                             
                  LCALL L_088B                             
EPROM_MTOP:       INC   DPTR                               
                  ACALL L_05B4                             
                  MOV   DPTR,#05fh                         
                  MOVX  A,@DPTR                            
                  MOV   DPTR,#00h                          
                  CJNE  A,#0a5h,L_03D7                     
                  MOV   A,L_0045                           
                  CLR   ACC.0                              
                  XRL   A,#04h                             
                  JZ    L_0400                             
L_03D7:           CJNE  R7,#02h,L_03DC                     
                  SJMP  L_03DF                             
L_03DC:           CJNE  R7,#03h,L_03E3                     
L_03DF:           ACALL L_0677                             
                  SJMP  L_03F4                             
L_03E3:           MOV   R3,L_0083                          
                  MOV   R1,L_0082                          
                  INC   DPTR                               
                  MOV   A,#05ah                            
                  MOVX  @DPTR,A                            
                  MOVX  A,@DPTR                            
                  CJNE  A,#05ah,L_03F4                     
                  CLR   A                                  
                  MOVX  @DPTR,A                            
                  CJNE  R3,#0e0h,L_03E3                    
L_03F4:           CJNE  R3,#03h,L_03F7                     
L_03F7:           JC    Default_regs                       
                  MOV   DPTR,#010ah                        
                  ACALL L_05FD                             
                  ACALL L_0656                             
L_0400:           ACALL L_0669                             
                  LCALL L_1642                             
                  MOV   A,L_0045                           
                  CJNE  A,#05h,L_040D                      
                  LCALL L_4039                             
L_040D:           JNC   Auto_Baudrate                      
                  JNB   ACC.0,Show_signon_msg              
                  MOV   DPTR,#08010h                       
                  MOVX  A,@DPTR                            
                  CJNE  A,#055h,Show_signon_msg            
                  LJMP  L_0808                             
Auto_Baudrate:    CLR   A                                  
                  MOV   R3,A                               
                  MOV   R1,A                               
                  MOV   R0,#04h                            
L_0421:           JB    P3.0,L_0421                        
L_0424:           DJNZ  R0,L_0424                          
                  LCALL L_157A                             
                  MOV   R0,#02h                            
                  JNB   P3.0,L_0424                        
L_042E:           JB    P3.0,L_042E                        
L_0431:           JNB   P3.0,L_0431                        
                  LCALL L_088B                             
Show_signon_msg:  MOV   DPTR,#01fd3h                       
                  ACALL Show_ROM_msg                       
                  LJMP  L_1776                             
L_043F:           MOV   R7,#00h                            
                  MOV   R6,#01h                            
                  MOV   R2,#07fh                           
                  MOV   R0,#0ffh                           
                  ACALL L_0498                             
                  INC   R6                                 
                  MOV   A,L_00CB                           
                  ACALL L_0498                             
                  MOV   A,L_00CA                           
                  MOV   R6,#03h                            
                  MOV   R1,#09h                            
                  MOV   R3,#01h                            
                  ACALL L_0498                             
                  SJMP  L_0491                             
                  MOV   DPTR,#012ah                        
                  SETB  intelligent_prom                   
                  SJMP  L_0466                             
                  MOV   DPTR,#0128h                        
                  CLR   intelligent_prom                   
L_0466:           ACALL L_057C                             
                  CLR   PGM_ENABLE                         
                  LCALL L_0EE4                             
                  JNZ   L_043F                             
                  MOV   R4,#0feh                           
                  SETB  array_init                         
                  ACALL L_0555                             
                  LCALL L_184E                             
                  MOV   A,R4                               
                  CPL   A                                  
                  LCALL L_149C                             
                  LCALL L_19A1                             
                  ACALL L_0516                             
                  ACALL Send_CRLF                          
                  MOV   R0,L_000E                          
                  MOV   R2,L_000F                          
                  MOV   A,#055h                            
                  INC   R6                                 
                  CJNE  R6,#00h,L_048F                     
                  INC   R7                                 
L_048F:           ACALL L_049B                             
L_0491:           SETB  PGM_ENABLE                         
                  AJMP  L_053A                             
               ;***
               ;*** SUBROUTINE
               ;***
Get_Xbyte_R3R1:   MOV   L_00A0,R3                          
                  MOVX  A,@R1                              
               ;***
               ;*** SUBROUTINE
               ;***
L_0498:           LCALL inc_R2R0                           
               ;***
               ;*** SUBROUTINE
               ;***
L_049B:           MOV   R5,#01h                            
L_049D:           MOV   R4,A                               
                  ACALL A_to_Ext_R2R0                      
                  ACALL L_04F0                             
                  JB    intelligent_prom,L_04B1            
L_04A5:           XRL   A,R4                               
                  JNZ   L_04C8                             
                  LCALL L_1632                             
                  JNZ   Get_Xbyte_R3R1                     
                  ANL   L_00D0,#0E7h                       
L_04B0:           RET                                      
L_04B1:           XRL   A,R4                               
                  JNZ   L_04C3                             
                  MOV   A,R4                               
                  ACALL A_to_Ext_R2R0                      
L_04B7:           ACALL L_04E0                             
                  ACALL L_04E0                             
                  ACALL L_04E0                             
                  DJNZ  R5,L_04B7                          
                  ACALL L_04F0                             
                  SJMP  L_04A5                             
L_04C3:           INC   R5                                 
                  MOV   A,R4                               
                  CJNE  R5,#019h,L_049D                    
L_04C8:           SETB  PGM_ENABLE                         
                  MOV   L_00D0,#00h                        
                  JNB   command_mode,L_04B0                
Show_prgrmmng:    MOV   DPTR,#01f9ah                       
L_04D3:           LJMP  L_1889                             
               ;***
               ;*** SUBROUTINE
               ;***
A_to_Ext_R2R0:    MOV   L_0080,R0                          
                  MOV   L_00A0,R2                          
                  ACALL L_0505                             
                  CLR   ALE_DISABLE                        
                  MOV   L_0080,A                           
               ;***
               ;*** SUBROUTINE
               ;***
L_04E0:           NOP                                      
                  NOP                                      
                  NOP                                      
                  NOP                                      
                  NOP                                      
                  NOP                                      
                  ACALL L_0505                             
                  CLR   PGM_PULSE                          
                  ACALL L_0527                             
L_04EC:           JNB   TF1,L_04EC                         
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_04F0:           SETB  PGM_PULSE                          
                  ACALL L_0505                             
L_04F4:           JNB   P3.2,L_04F4                        
                  MOV   L_0080,#0FFh                       
                  CLR   P3.7                               
                  ACALL L_0505                             
                  MOV   A,L_0080                           
                  SETB  P3.7                               
                  SETB  ALE_DISABLE                        
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0505:           MOV   L_000F,#0Ch                        
L_0508:           DJNZ  L_000F,L_0508                      
                  RET                                      
                  CLR   PGM_ENABLE                         
                  MOV   L_00D0,#018h                       
                  ACALL Get_Xbyte_R3R1                     
                  SETB  PGM_ENABLE                         
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0516:           ACALL L_0584                             
                  INC   DPTR                               
                  MOV   R3,L_0013                          
                  MOV   R1,L_0014                          
                  CLR   C                                  
                  MOV   A,L_0082                           
                  SUBB  A,R1                               
                  MOV   R6,A                               
                  MOV   A,L_0083                           
                  SUBB  A,R3                               
                  MOV   R7,A                               
               ;***
               ;*** SUBROUTINE
               ;***
ret_1:            RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0527:           ACALL ret_1                              
               ;***
               ;*** SUBROUTINE
               ;***
L_0529:           CLR   TR1                                
                  MOV   L_0040,L_008D                      
                  MOV   L_0041,L_008B                      
                  CLR   TF1                                
                  SETB  TR1                                
                  RET                                      
                  CLR   enable_cont                        
                  ACALL L_053D                             
L_053A:           LJMP  L_1077                             
               ;***
               ;*** SUBROUTINE
               ;***
L_053D:           LCALL L_0EE4                             
                  MOV   R4,#01h                            
                  JNC   L_0548                             
                  LCALL L_0E91                             
                  MOV   R4,A                               
L_0548:           ACALL L_0555                             
                  CJNE  R4,#00h,ret_2                      
                  INC   DPTR                               
                  MOV   L_0083,L_0013                      
                  MOV   L_0082,L_0014                      
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0555:           MOV   DPTR,#08010h                       
L_0558:           MOVX  A,@DPTR                            
                  CJNE  A,#055h,L_0565                     
                  DJNZ  R4,L_055F                          
ret_2:            RET                                      
L_055F:           INC   DPTR                               
                  ACALL L_05A6                             
                  INC   DPTR                               
                  SJMP  L_0558                             
L_0565:           JBC   array_init,ret_2                   
L_0568:           MOV   DPTR,#01fc9h                       
                  AJMP  L_04D3                             
               ;***
               ;*** SUBROUTINE
               ;***
[DPTR]_to_R2R0:   MOVX  A,@DPTR                            
                  MOV   R2,A                               
                  INC   DPTR                               
                  MOVX  A,@DPTR                            
                  MOV   R0,A                               
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
R3R1_to_DPTR:     XCH   A,R3                               
                  XCH   A,L_0083                           
                  XCH   A,R3                               
                  XCH   A,R1                               
                  XCH   A,L_0082                           
                  XCH   A,R1                               
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_057C:           MOVX  A,@DPTR                            
                  MOV   L_0040,A                           
                  INC   DPTR                               
                  MOVX  A,@DPTR                            
                  MOV   L_0041,A                           
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0584:           SETB  find_eop                           
               ;***
               ;*** SUBROUTINE
               ;***
L_0586:           LCALL L_0E9E                             
L_0589:           LCALL L_0AA7                             
                  JZ    L_05A0                             
                  INC   DPTR                               
                  JB    find_eop,L_059C                    
                  ACALL L_05C6                             
                  ACALL L_05BC                             
                  MOVX  A,@DPTR                            
                  JB    DIM_statement,L_05A0               
                  JC    L_05A0                             
L_059C:           ACALL L_05D8                             
                  SJMP  L_0589                             
L_05A0:           CLR   find_eop                           
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_05A3:           MOV   DPTR,#0200h                        
               ;***
               ;*** SUBROUTINE
               ;***
L_05A6:           SETB  find_eop                           
                  SJMP  L_0589                             
               ;***
               ;*** SUBROUTINE
               ;***
L_05AA:           MOVX  A,@DPTR                            
                  PUSH  L_00E0                             
                  INC   DPTR                               
                  MOVX  A,@DPTR                            
                  MOV   L_0082,A                           
                  POP   L_0083                             
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_05B4:           MOVX  A,@DPTR                            
                  MOV   R3,A                               
                  INC   DPTR                               
                  MOVX  A,@DPTR                            
                  MOV   R1,A                               
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_05BA:           ACALL L_05BC                             
               ;***
               ;*** SUBROUTINE
               ;***
L_05BC:           XCH   A,L_0082                           
                  JNZ   L_05C2                             
                  DEC   L_0083                             
L_05C2:           DEC   A                                  
                  XCH   A,L_0082                           
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_05C6:           CLR   DIM_statement                      
                  MOVX  A,@DPTR                            
                  CJNE  A,X_0003,L_05D6                    
                  INC   DPTR                               
                  MOVX  A,@DPTR                            
                  ACALL L_05BC                             
                  CJNE  A,X_0001,L_05D6                    
                  CPL   C                                  
                  CPL   DIM_statement                      
L_05D6:           CPL   C                                  
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_05D8:           ADD   A,L_0082                           
                  MOV   L_0082,A                           
                  JNC   ret_3                              
                  INC   L_0083                             
ret_3:            RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_05E1:           ACALL L_0694                             
                  ACALL L_05A3                             
                  MOV   A,#06h                             
                  ACALL L_05D8                             
                  ACALL R3R1_to_DPTR                       
                  MOV   DPTR,#0108h                        
                  ACALL L_05FF                             
                  ACALL L_05B4                             
                  MOV   DPTR,#0122h                        
                  ACALL L_05AA                             
                  LCALL L_0A05                             
                  MOV   DPTR,#0104h                        
               ;***
               ;*** SUBROUTINE
               ;***
L_05FD:           ACALL L_05FF                             
               ;***
               ;*** SUBROUTINE
               ;***
L_05FF:           MOV   A,R3                               
                  MOVX  @DPTR,A                            
                  INC   DPTR                               
                  MOV   A,R1                               
                  MOVX  @DPTR,A                            
                  INC   DPTR                               
                  RET                                      
                  LCALL L_0E88                             
                  MOV   DPTR,#0122h                        
                  ACALL L_05FF                             
                  INC   R6                                 
                  MOV   L_003F,R6                          
                  AJMP  L_065E                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0613:           MOV   DPTR,#0104h                        
                  ACALL L_05AA                             
                  ACALL L_05BA                             
L_061A:           MOVX  A,@DPTR                            
                  JZ    L_063D                             
                  INC   DPTR                               
                  CJNE  A,L_0007,L_0630                    
                  MOVX  A,@DPTR                            
                  CJNE  A,X_0006,L_0630                    
               ;***
               ;*** SUBROUTINE
               ;***
L_0625:           MOV   A,L_0082                           
                  SUBB  A,#02h                             
                  MOV   R0,A                               
                  MOV   A,L_0083                           
                  SUBB  A,#00h                             
                  MOV   R2,A                               
                  RET                                      
L_0630:           MOV   A,L_0082                           
                  CLR   C                                  
                  SUBB  A,#09h                             
                  MOV   L_0082,A                           
                  JNC   L_061A                             
                  DEC   L_0083                             
                  SJMP  L_061A                             
L_063D:           LCALL L_0DF2                             
                  CLR   C                                  
                  ACALL L_0625                             
                  MOV   A,R0                               
                  SUBB  A,#06h                             
                  MOV   R1,A                               
                  MOV   A,R2                               
                  SUBB  A,#00h                             
                  MOV   R3,A                               
                  MOV   DPTR,#0106h                        
                  ACALL L_05FF                             
                  ACALL L_05C6                             
                  JC    L_0686                             
                  SETB  C                                  
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0656:           MOV   DPTR,#0200h                        
                  MOV   A,#01h                             
                  MOVX  @DPTR,A                            
               ;***
               ;*** SUBROUTINE
               ;***
L_065C:           CLR   line_edit                          
               ;***
               ;*** SUBROUTINE
               ;***
L_065E:           ACALL L_05E1                             
                  MOV   DPTR,#010ah                        
                  ACALL L_05B4                             
                  ACALL L_05A3                             
                  ACALL L_0677                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0669:           MOV   DPTR,#0feh                         
                  CLR   A                                  
               ;***
               ;*** SUBROUTINE
               ;***
L_066D:           MOVX  @DPTR,A                            
                  MOV   L_0011,#0FEh                       
                  MOV   L_0009,#0FEh                       
                  CLR   enable_cont                        
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0677:           INC   DPTR                               
                  CLR   A                                  
                  MOVX  @DPTR,A                            
                  MOVX  A,@DPTR                            
                  JNZ   L_0686                             
                  MOV   A,R3                               
                  CJNE  A,L_0083,L_0677                    
                  MOV   A,R1                               
                  CJNE  A,L_0082,L_0677                    
                  RET                                      
L_0686:           LJMP  Show_mem_alloc                     
                  LCALL L_0EE4                             
                  JNC   L_065E                             
                  LCALL L_0EDA                             
                  CJNE  A,#049h,L_0669                     
               ;***
               ;*** SUBROUTINE
               ;***
L_0694:           JNB   ONEX1_exe,L_0699                   
                  CLR   EX1                                
L_0699:           ANL   L_0022,#020h                       
                  RETI                                     
               ;***
               ;*** SUBROUTINE
               ;***
L_069D:           ACALL Send_CRLF                          
               ;***
               ;*** SUBROUTINE
               ;***
Send_CRLF:        MOV   R5,#0dh                            
                  ACALL send_[R5]                          
                  MOV   R5,#0ah                            
                  AJMP  send_[R5]                          
               ;***
               ;*** SUBROUTINE
               ;***
Show_ROM_msg:     ACALL Send_CRLF                          
               ;***
               ;*** SUBROUTINE
               ;***
Get_DPTR_char:    CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  CLR   ACC.7                              
                  CJNE  A,#022h,L_06B1                     
                  RET                                      
L_06B1:           SETB  ROM_text                           
L_06B3:           MOV   R5,A                               
                  ACALL send_[R5]                          
                  INC   DPTR                               
                  SJMP  L_06BD                             
               ;***
               ;*** SUBROUTINE
               ;***
CON_line_output:  ACALL R3R1_to_DPTR                       
               ;***
               ;*** SUBROUTINE
               ;***
L_06BB:           MOV   R4,#0dh                            
               ;***
               ;*** SUBROUTINE
               ;***
L_06BD:           JBC   ROM_text,Get_DPTR_char             
                  MOVX  A,@DPTR                            
                  JZ    ret_4                              
                  CJNE  A,X_0004,L_06C7                    
ret_4:            RET                                      
L_06C7:           CJNE  A,#0dh,L_06B3                      
                  LJMP  L_187F                             
L_06CD:           CJNE  A,#04h,L_06E6                      
                  ACALL Send_CRLF                          
               ;***
               ;*** SUBROUTINE
               ;***
CON_line_input:   MOV   L_00A0,#00h                        
                  MOV   R0,#07h                            
L_06D7:           ACALL Tst_output_trap                    
                  MOV   R5,A                               
                  CJNE  A,#07fh,L_06CD                     
                  CJNE  R0,#07h,L_06F8                     
L_06E0:           MOV   R5,#07h                            
L_06E2:           ACALL send_[R5]                          
                  SJMP  L_06D7                             
L_06E6:           MOVX  @R0,A                              
                  CJNE  A,#0dh,L_06EC                      
                  AJMP  Send_CRLF                          

; phase error, pc = 06EC label = ‹F‰†hÿ>þ new pc = 06ED

L_06EC:           CJNE  A,#020h,L_06EF                     

; phase error, pc = 06ED label = ‹F‰†hÿ>þ new pc = 06EF

L_06ED:           JB    00h,0730h                          
L_06EF:           JC    L_06E2                             
                  INC   R0                                 
                  CJNE  R0,#056h,L_06E2                    
                  DEC   R0                                 
                  SJMP  L_06E0                             
L_06F8:           DEC   R0                                 
                  MOV   R5,#08h                            
                  ACALL send_[R5]                          
                  ACALL L_0709                             
                  MOV   R5,#08h                            
                  SJMP  L_06E2                             
                  MOV   R6,#00h                            
                  NOP                                      
                  JNC   L_076F                             

; phase error, pc = 0708 label = ‹F‰†hÿ>þ new pc = 0709

                  AJMP  L_027D                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0709:           MOV   R5,#020h                           
               ;***
               ;*** SUBROUTINE
               ;***
send_[R5]:        PUSH  L_00E0                             
                  PUSH  L_0083                             
                  PUSH  L_0082                             
Tst_XOFF:         JNB   XOFF_found,L_0718                  
                  ACALL L_0787                             
                  SJMP  Tst_XOFF                           
L_0718:           MOV   A,R5                               
                  JNB   input_trap,Tst_user_CON            
                  LCALL L_2040                             
                  AJMP  Tst_CR                             
Tst_user_CON:     JNB   user_CON_out_ctrl,L_0729           
                  LCALL USER_con_output                    
                  AJMP  Tst_CR                             
L_0729:           JNB   valid_@_driver,Tst_LP_CON_out      
                  JNB   print_list_exe,Tst_LP_CON_out      
                  LCALL USER_output_vec                    
                  AJMP  Tst_CR                             
Tst_LP_CON_out:   JNB   LP_CON_out_ctrl,Wait_for_TI        
                  MOV   DPTR,#0124h                        
                  ACALL L_057C                             
                  CLR   LP_OUT                             
                  ACALL L_0527                             
                  MOV   A,R5                               
                  SETB  C                                  
                  MOV   R5,#09h                            
L_0744:           RRC   A                                  
L_0745:           JNB   TF1,L_0745                         
                  MOV   L_0097,C                           
                  ACALL L_0527                             
                  DJNZ  R5,L_0744                          
L_074E:           JNB   TF1,L_074E                         
                  ACALL L_0527                             
L_0753:           JNB   TF1,L_0753                         
                  MOV   R5,A                               
                  SJMP  Tst_CR                             
Wait_for_TI:      JNB   TI,Wait_for_TI                     
                  CLR   TI                                 
                  MOV   L_0099,R5                          
Tst_CR:           CJNE  R5,#0dh,Tst_LF                     
                  MOV   L_0016,#00h                        
Tst_LF:           CJNE  R5,#0ah,Tst_BS                     
                  MOV   A,L_0015                           
                  JZ    Tst_BS                             
L_076D:           MOV   R5,#00h                            
L_076F:           ACALL send_[R5]                          
                  DEC   A                                  
                  JNZ   L_076D                             
Tst_BS:           CJNE  R5,#08h,Tst_space                  
                  DEC   L_0016                             
Tst_space:        CJNE  R5,#020h,L_077C                    
L_077C:           JC    Pop_regs                           
                  INC   L_0016                             
Pop_regs:         POP   L_0082                             
                  POP   L_0083                             
                  POP   L_00E0                             
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0787:           ACALL L_07C6                             
                  JNC   ret_5                              
               ;***
               ;*** SUBROUTINE
               ;***
Tst_output_trap:  JNB   output_trap,No_output_trap         
                  LCALL L_2060                             
                  SJMP  Tst_XOFF                           
No_output_trap:   JNB   user_CON_in_ctrl,L_079B            
                  LCALL USER_con_status                    
                  SJMP  Tst_XOFF                           
L_079B:           JNB   RI,L_079B                          
                  MOV   A,L_0099                           
                  CLR   RI                                 
                  CLR   ACC.7                              
Tst_XOFF:         CJNE  A,#013h,Tst_XON                    
                  SETB  XOFF_found                         
Tst_XON:          CJNE  A,#011h,Tst_CTRLC                  
                  CLR   XOFF_found                         
Tst_CTRLC:        CJNE  A,#03h,L_07B5                      
                  JNB   disable_CTRLC,L_07DA               
                  RET                                      
L_07B5:           CLR   soft_trap_test                     
                  CJNE  A,#017h,L_07BC                     
                  SETB  soft_trap_test                     
L_07BC:           SETB  C                                  
ret_5:            RET                                      
                  SETB  array_init                         
                  ACALL L_053D                             
                  JBC   array_init,L_0808                  
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_07C6:           JNB   output_trap,L_07CC                 
                  LJMP  L_2068                             
L_07CC:           JNB   user_CON_in_ctrl,L_07D2            
                  LJMP  L_4036                             
L_07D2:           MOV   C,RI                               
                  RET                                      
L_07D5:           MOV   DPTR,#01962h                       
                  ACALL Get_DPTR_char                      
L_07DA:           CLR   XOFF_found                         
                  LCALL init_D23h_D26h                     
                  ACALL Send_CRLF                          
                  JBC   soft_trap_test,L_07D5              
                  JNB   command_mode,L_0866                
                  AJMP  L_053A                             
               ;***
               ;*** SUBROUTINE
               ;***
L_07E9:           MOV   A,L_0048                           
                  MOV   R1,L_0049                          
                  CJNE  A,L_0048,L_07E9                    
                  XCH   A,R1                               
                  SUBB  A,L_004C                           
                  MOV   A,R1                               
                  SUBB  A,L_004B                           
                  RET                                      
L_07F7:           ACALL L_07E9                             
                  JC    L_083B                             
                  SETB  ONTIME_exe                         
                  CLR   ONTIME_executed                    
                  MOV   C,BASIC_int_in_prog                
                  MOV   L_002B,C                           
                  MOV   DPTR,#0126h                        
                  SJMP  L_0844                             
L_0808:           LCALL L_065C                             
                  ACALL L_0BD3                             
                  ACALL L_0AA7                             
                  JZ    L_085B                             
                  ACALL L_0EBB                             
                  ACALL L_0F26                             
L_0815:           ACALL L_0C3F                             
L_0817:           CLR   command_mode                       
L_0819:           MOV   L_003E,L_0081                      
                  JB    command_mode,L_0825                
                  MOV   L_000A,L_0042                      
                  MOV   L_0008,L_0043                      
L_0825:           LCALL L_0787                             
                  JB    command_mode,L_084F                
                  ANL   C,/get_flag                        
                  JNC   L_0835                             
                  MOV   DPTR,#0100h                        
                  MOVX  @DPTR,A                            
                  SETB  get_flag                           
L_0835:           JB    ONTIME_exe,L_084F                  
                  JB    ONTIME_executed,L_07F7             
L_083B:           JNB   ext_int_pending,L_084F             
                  JB    BASIC_int_in_prog,L_084F           
                  MOV   DPTR,#0120h                        
L_0844:           MOV   R4,#02h                            
                  ACALL L_0B38                             
                  SETB  BASIC_int_in_prog                  
L_084A:           LCALL [DPTR]_to_R2R0                     
                  AJMP  L_0AFB                             
L_084F:           ACALL L_08FB                             
                  ACALL L_0F1A                             
                  JNC   L_0819                             
                  JNB   command_mode,L_085B                
                  LJMP  L_1794                             
L_085B:           LJMP  goto_CMD_mode                      
                  ACALL L_0F1A                             
                  MOV   L_000A,L_0042                      
                  MOV   L_0008,L_0043                      
L_0866:           SETB  enable_cont                        
                  MOV   DPTR,#0ech                         
                  SETB  STOP_CTRLC_found                   
                  LJMP  L_18A7                             
L_0870:           CJNE  A,#0c8h,L_0878                     
                  MOV   L_008C,R3                          
                  MOV   L_008A,R1                          
                  RET                                      
L_0878:           CJNE  A,#0c9h,L_0880                     
                  MOV   L_008D,R3                          
                  MOV   L_008B,R1                          
                  RET                                      
L_0880:           CJNE  A,#0cah,L_0888                     
                  MOV   L_00CD,R3                          
                  MOV   L_00CC,R1                          
                  RET                                      
L_0888:           CJNE  A,#0ceh,L_0890                     
               ;***
               ;*** SUBROUTINE
               ;***
L_088B:           MOV   L_00CB,R3                          
                  MOV   L_00CA,R1                          
                  RET                                      
L_0890:           ACALL L_09D8                             
                  CJNE  A,#0cbh,L_0898                     
                  MOV   L_00C8,R1                          
                  RET                                      
L_0898:           CJNE  A,#0c6h,L_089E                     
                  MOV   L_00A8,R1                          
                  RET                                      
L_089E:           CJNE  A,#0c7h,L_08A4                     
                  MOV   L_00B8,R1                          
                  RET                                      
L_08A4:           CJNE  A,#0cch,L_08AA                     
                  MOV   L_0088,R1                          
                  RET                                      
L_08AA:           CJNE  A,#0cdh,L_08B0                     
                  MOV   L_0089,R1                          
                  RET                                      
L_08B0:           CJNE  A,#0cfh,L_08E2                     
                  MOV   L_0090,R1                          
                  RET                                      
L_08B6:           MOV   L_000F,A                           
                  ACALL L_0EDA                             
                  ACALL L_09CB                             
                  MOV   A,L_000F                           
                  CJNE  A,#0c3h,L_08C4                     
                  LJMP  L_1647                             
L_08C4:           ACALL L_0E93                             
                  MOV   A,L_000F                           
                  CJNE  A,#0c4h,L_08D4                     
                  MOV   DPTR,#010ah                        
                  LCALL L_05FF                             
                  LJMP  L_065E                             
L_08D4:           CJNE  A,#0c5h,L_0870                     
                  MOV   C,EA                               
                  CLR   EA                                 
                  MOV   L_0048,R3                          
                  MOV   L_0049,R1                          
                  MOV   L_00AF,C                           
                  RET                                      
L_08E2:           CJNE  A,#0d0h,L_093B                     
                  MOV   L_0087,R1                          
                  RET                                      
L_08E8:           CJNE  A,#0d1h,L_08B6                     
                  ACALL L_0ECE                             
                  CJNE  A,#024h,L_093B                     
                  ACALL L_0A21                             
                  ACALL L_0DB0                             
                  LCALL L_149F                             
                  ACALL L_09E0                             
                  AJMP  L_0924                             
               ;***
               ;*** SUBROUTINE
               ;***
L_08FB:           ACALL L_0ED0                             
                  JNB   exp_present,L_090E                 
                  CJNE  A,#020h,L_0903                     
L_0903:           JNC   L_090E                             
                  LCALL get_user_vect                      
                  ACALL L_0EDA                             
                  ANL   A,#0fh                             
                  SJMP  get_tabel_addr                     
L_090E:           CJNE  A,#0c3h,L_0911                     
L_0911:           JNC   L_08E8                             
                  JNB   ACC.7,L_0971                       
                  CJNE  A,#0bch,L_091F                     
                  ACALL L_09DC                             
                  ACALL L_09D8                             
                  MOV   @R1,A                              
                  RET                                      
L_091F:           CJNE  A,#0bdh,L_0928                     
                  ACALL L_09DC                             
L_0924:           MOV   L_00A0,R3                          
                  MOVX  @R1,A                              
                  RET                                      
L_0928:           CJNE  A,#0abh,L_092B                     
L_092B:           JC    L_0936                             
                  CJNE  A,#0b0h,L_0930                     
L_0930:           JNC   L_093B                             
                  ADD   A,#0f9h                            
                  SJMP  L_0953                             
L_0936:           CJNE  A,#0a4h,L_0939                     
L_0939:           JC    L_093E                             
L_093B:           LJMP  L_187F                             
L_093E:           JNB   command_mode,L_0953                
                  CJNE  A,#090h,L_0944                     
L_0944:           JC    L_0953                             
                  CJNE  A,#0a0h,L_094B                     
                  SJMP  L_0953                             
L_094B:           CJNE  A,#097h,L_0950                     
                  SJMP  L_0953                             
L_0950:           CJNE  A,#096h,L_093B                     
L_0953:           ACALL L_0EDA                             
                  MOV   DPTR,#0121h                        
                  CJNE  A,#080h,L_095D                     
                  SJMP  L_08FB                             
L_095D:           ANL   A,#03fh                            
               ;***
               ;*** SUBROUTINE
               ;***
get_tabel_addr:   RL    A                                  
                  ADD   A,L_0082                           
                  MOV   L_0082,A                           
                  CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  PUSH  L_00E0                             
                  INC   DPTR                               
                  CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  POP   L_0083                             
                  MOV   L_0082,A                           
               ;***
               ;*** SUBROUTINE
               ;***
L_096F:           CLR   A                                  
                  JMP   @A+DPTR                            
L_0971:           ACALL L_0EC2                             
                  JC    L_09C5                             
                  CLR   line_edit                          
                  LCALL R3R1_to_DPTR                       

; phase error, pc = 097A label = ‹F‰†hÿ>þ new pc = 097B

                  MOV   R7,#0eah                           
Wait_for_RI:      MOV   A,R2                               
                  ACALL L_0CE8                             
                  ACALL L_0ED0                             
                  CJNE  A,#022h,L_0994                     
                  MOV   R7,L_003F                          
L_0985:           ACALL L_0EDA                             
                  ACALL L_0EE4                             
                  JZ    L_093B                             
                  MOVX  @DPTR,A                            
                  CJNE  A,#022h,L_09B5                     
               ;***
               ;*** SUBROUTINE
               ;***
L_098F:           MOV   A,#0dh                             
                  MOVX  @DPTR,A                            
                  AJMP  L_0EDA                             
L_0994:           PUSH  L_0083                             
                  PUSH  L_0082                             
                  ACALL L_0EC2                             
                  JC    L_093B                             
                  POP   X_0000                             
                  POP   X_0002                             
               ;***
               ;*** SUBROUTINE
               ;***
L_09A0:           MOV   R7,L_003F                          
L_09A2:           LCALL L_1581                             
                  CJNE  A,#0dh,L_09A9                      
                  RET                                      
L_09A9:           DJNZ  R7,L_09B0                          
                  MOV   A,#0dh                             
                  MOVX  @R0,A                              
                  AJMP  L_0E51                             
L_09B0:           LCALL inc_R2R0                           
                  SJMP  L_09A2                             
L_09B5:           DJNZ  R7,L_09BD                          
                  ACALL L_098F                             
                  ACALL L_0E51                             
                  AJMP  L_0EEF                             
L_09BD:           INC   DPTR                               
                  SJMP  L_0985                             
Show_bad_arg:     MOV   DPTR,#01822h                       
                  AJMP  L_0C11                             
L_09C5:           ACALL L_09C9                             
                  AJMP  L_0FD6                             
               ;***
               ;*** SUBROUTINE
               ;***
L_09C9:           ACALL L_0F04                             
               ;***
               ;*** SUBROUTINE
               ;***
L_09CB:           PUSH  X_0002                             
                  PUSH  X_0000                             
                  MOV   R7,#0eah                           
                  ACALL L_0F44                             
                  POP   X_0001                             
                  POP   X_0003                             
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_09D8:           CJNE  R3,#00h,Show_bad_arg               
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_09DC:           ACALL L_0EDA                             
                  ACALL L_0CE2                             
               ;***
               ;*** SUBROUTINE
               ;***
L_09E0:           ACALL L_09CB                             
                  LCALL L_148C                             
                  MOV   A,R6                               
                  CJNE  R7,#00h,Show_bad_arg               
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_09EA:           ACALL L_0E98                             
                  ACALL L_09D8                             
                  INC   R1                                 
                  MOV   A,R1                               
                  JZ    Show_bad_arg                       
                  MOV   DPTR,#0104h                        
                  MOV   L_003F,L_00F0                      
                  ACALL L_0A13                             
                  MOV   DPTR,#010ah                        
                  LCALL L_159B                             
                  MOV   L_003F,L_0082                      
                  DEC   L_0083                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0A05:           CLR   C                                  
                  MOV   A,R1                               
                  SUBB  A,L_0082                           
                  MOV   R1,A                               
                  MOV   A,R3                               
                  SUBB  A,L_0083                           
                  MOV   R3,A                               
                  ORL   A,R1                               
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0A10:           MOV   L_00F0,#06h                        
               ;***
               ;*** SUBROUTINE
               ;***
L_0A13:           LCALL L_05AA                             
                  MOV   A,R1                               
                  MUL   AB                                 
                  ADD   A,L_0082                           
                  MOV   R1,A                               
                  MOV   A,L_00F0                           
                  ADDC  A,L_0083                           
                  MOV   R3,A                               
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0A21:           ACALL L_09EA                             
                  PUSH  X_0003                             
                  PUSH  X_0001                             
                  MOV   R7,#02ch                           
                  ACALL L_0CE8                             
                  ACALL L_0E91                             
                  MOV   A,R1                               
                  CJNE  A,L_003F,L_0A31                    
L_0A31:           JNC   Show_bad_arg                       
                  DEC   R1                                 
                  POP   L_00E0                             
                  ADD   A,R1                               
                  MOV   R1,A                               
                  POP   X_0003                             
                  JNC   L_0A3D                             
                  INC   R3                                 
L_0A3D:           AJMP  L_0CE6                             
                  ACALL L_09C9                             
                  PUSH  X_0003                             
                  PUSH  X_0001                             
                  ACALL L_0FD6                             
                  MOV   R7,#0a6h                           
                  ACALL L_0F44                             
                  ACALL L_0ED0                             
                  CJNE  A,#0a7h,L_0A56                     
                  ACALL L_0EDA                             
                  ACALL L_0F46                             
                  SJMP  L_0A59                             
L_0A56:           LCALL L_142E                             
L_0A59:           MOV   A,#0efh                            
                  ACALL L_0BB4                             
                  ACALL L_0BC0                             
                  MOV   R3,#00h                            
                  MOV   R1,X_0000                          
                  ACALL L_0FD6                             
                  ACALL L_0FD6                             
                  ACALL L_0EA5                             
                  MOV   R0,X_0001                          
                  ACALL L_0B3C                             
                  POP   L_0008                             
                  POP   L_000A                             
                  MOV   R4,#01h                            
                  ACALL L_0B3C                             
L_0A75:           ACALL L_0EBB                             
                  AJMP  L_0819                             
L_0A79:           ACALL L_0F46                             
                  ACALL L_0EC9                             
                  JNC   L_0A79                             
                  RET                                      
L_0A80:           ACALL L_0F04                             
                  ACALL L_0FD4                             
                  ACALL L_0EC9                             
                  JNC   L_0A80                             
L_0A88:           RET                                      
                  ACALL L_0ACA                             
                  MOV   R1,A                               
                  ACALL L_0ED0                             
                  CJNE  A,#0a5h,L_0A93                     
                  ACALL L_0EDA                             
L_0A93:           CJNE  R1,#00h,L_0AA1                     
L_0A96:           MOV   R7,#0a8h                           
                  ACALL L_0EF1                             
                  JZ    L_0A88                             
                  ACALL L_0EDA                             
                  CJNE  A,#0a8h,L_0A96                     
L_0AA1:           ACALL L_0F38                             
                  JNC   L_0AFB                             
                  AJMP  L_08FB                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0AA7:           MOVX  A,@DPTR                            
                  DEC   A                                  
                  JB    ACC.7,L_0ADA                       
                  RET                                      
                  ACALL L_0AF5                             
L_0AAF:           ACALL L_0EBB                             
                  JBC   RETI_exe,L_0ABC                    
                  JNB   line_edit,L_0ABA                   
                  LCALL L_065C                             
L_0ABA:           AJMP  L_0817                             
L_0ABC:           JBC   ONTIME_exe,L_0AC4                  
                  ANL   L_0022,#0BDh                       
                  AJMP  L_0819                             
L_0AC4:           MOV   C,int_stat_save                    
                  MOV   L_0011,C                           
                  AJMP  L_0819                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0ACA:           ACALL L_0F46                             
                  LCALL L_123A                             
                  JZ    ret_6                              
                  MOV   A,#0ffh                            
ret_6:            RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0AD4:           ACALL L_0E9E                             
L_0AD6:           MOVX  A,@DPTR                            
                  MOV   R7,A                               
                  DJNZ  R7,L_0ADF                          
L_0ADA:           MOV   DPTR,#01fb5h                       
                  AJMP  L_0C11                             
L_0ADF:           JB    ACC.7,L_0ADA                       
                  INC   DPTR                               
                  MOVX  A,@DPTR                            
                  CJNE  A,X_0002,L_0AEF                    
                  INC   DPTR                               
                  DEC   R7                                 
                  MOVX  A,@DPTR                            
                  CJNE  A,X_0000,L_0AEF                    
                  INC   DPTR                               
                  RET                                      
L_0AEF:           MOV   A,R7                               
                  LCALL L_05D8                             
                  SJMP  L_0AD6                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0AF5:           ACALL L_0F33                             
L_0AF7:           ACALL L_0AD4                             
                  AJMP  L_0F1A                             
L_0AFB:           ACALL L_0AD4                             
                  AJMP  L_0AAF                             
                  ACALL L_0ACA                             
                  CPL   A                                  
                  SJMP  L_0B06                             
                  ACALL L_0ACA                             
L_0B06:           MOV   R4,#03h                            
                  MOV   R5,A                               
                  SJMP  L_0B17                             
                  ACALL L_0F33                             
                  MOV   L_0015,R0                          
                  AJMP  L_085B                             
                  SETB  RETI_exe                           
                  MOV   R4,#02h                            
                  MOV   R5,#055h                           
L_0B17:           ACALL L_0B4E                             
                  MOVX  A,@R0                              
                  MOV   L_0083,A                           
                  INC   R0                                 
                  MOVX  A,@R0                              
                  MOV   L_0082,A                           
                  INC   R0                                 
                  MOVX  A,@DPTR                            
                  CJNE  A,#01h,L_0B27                      
                  AJMP  L_085B                             
L_0B27:           MOV   A,R5                               
                  JZ    L_0AAF                             
                  MOV   L_0011,R0                          
                  CPL   A                                  
                  JNZ   L_0AAF                             
                  RET                                      
                  ACALL L_0AF5                             
L_0B32:           MOV   R4,#02h                            
                  ACALL L_0B38                             
                  AJMP  L_0A75                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0B38:           MOV   A,#0fdh                            
                  ACALL L_0BB4                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0B3C:           MOV   L_00A0,#00h                        
                  MOV   A,L_0008                           
                  MOVX  @R0,A                              
                  DEC   R0                                 
                  MOV   A,L_000A                           
                  MOVX  @R0,A                              
                  DEC   R0                                 
                  MOV   A,R4                               
                  MOVX  @R0,A                              
                  RET                                      
L_0B4A:           MOV   A,#03h                             
                  ACALL L_0BB4                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0B4E:           MOV   R0,L_0011                          
                  MOV   L_00A0,#00h                        
                  MOVX  A,@R0                              
                  CJNE  A,X_0004,L_0B59                    
                  INC   R0                                 
                  RET                                      
L_0B59:           JZ    L_0BC4                             
                  CJNE  A,#01h,L_0B4A                      
                  ACALL L_0BB2                             
                  SJMP  L_0B4E                             
                  MOV   R4,#01h                            
                  ACALL L_0B4E                             
                  MOV   L_000F,R0                          
                  MOV   R1,#0bh                            
L_0B6A:           MOVX  A,@R0                              
                  MOV   @R1,A                              
                  INC   R1                                 
                  INC   R0                                 
                  CJNE  R1,#0fh,L_0B6A                     
                  ACALL L_0D68                             
                  JNC   L_0B79                             
                  MOV   R2,L_000B                          
                  MOV   R0,L_000C                          
L_0B79:           MOV   A,R2                               
                  CJNE  A,L_000B,L_0BC4                    
                  MOV   A,R0                               
                  CJNE  A,L_000C,L_0BC4                    
                  ACALL L_0FE0                             
                  MOV   A,#0eh                             
                  ADD   A,L_000F                           
                  MOV   R0,A                               
                  MOV   R2,#00h                            
                  MOV   L_00A0,R2                          
                  MOVX  A,@R0                              
                  INC   R0                                 
                  PUSH  L_00E0                             
                  ACALL L_0FE0                             
                  PUSH  X_0000                             
                  LCALL calc_ADD                           
                  LCALL L_1417                             
                  MOV   R3,L_000B                          
                  MOV   R1,L_000C                          
                  ACALL L_0FD6                             
                  MOV   R2,#00h                            
                  POP   X_0000                             
                  ACALL L_0FE0                             
                  LCALL L_1997                             
                  POP   L_00E0                             
                  JZ    L_0BAE                             
                  CPL   C                                  
L_0BAE:           ORL   C,F0                               
                  JC    L_0BC9                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0BB2:           MOV   A,#011h                            
               ;***
               ;*** SUBROUTINE
               ;***
L_0BB4:           ADD   A,L_0011                           
                  CJNE  A,#061h,L_0BB9                     
L_0BB9:           JC    L_0BC4                             
                  XCH   A,L_0011                           
                  DEC   A                                  
                  MOV   R0,A                               
L_0BBF:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0BC0:           ACALL L_0F1A                             
                  JNC   L_0BBF                             
L_0BC4:           MOV   DPTR,#037fh                        
                  AJMP  L_0C11                             
L_0BC9:           MOV   L_000D,L_000A                      
                  MOV   L_000E,L_0008                      
                  AJMP  L_0819                             
                  ACALL L_0BD9                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0BD3:           ACALL L_0E9E                             
                  ACALL L_0EBB                             
                  ACALL L_0F26                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0BD9:           XCH   A,L_000A                           
                  XCH   A,L_0012                           
                  XCH   A,L_000A                           
                  XCH   A,L_0008                           
                  XCH   A,L_0010                           
                  XCH   A,L_0008                           
                  RET                                      
L_0BE6:           ACALL L_0BD9                             
L_0BE8:           ACALL L_0EC9                             
                  JC    L_0C02                             
L_0BEC:           ACALL L_0F46                             
                  ACALL L_0ED0                             
                  CJNE  A,#02ch,L_0BF5                     
                  SJMP  L_0BF7                             
L_0BF5:           ACALL L_0F1A                             
L_0BF7:           ACALL L_0BD9                             
                  ACALL L_0F04                             
                  ACALL L_0FD4                             
                  ACALL L_0EC9                             
                  JNC   L_0BE6                             
L_0C01:           RET                                      
L_0C02:           CJNE  A,#09ch,L_0C09                     
                  ACALL L_0EDA                             
                  SJMP  L_0BEC                             
L_0C09:           CJNE  A,#01h,L_0C14                      
L_0C0C:           ACALL L_0BD9                             
                  MOV   DPTR,#01f81h                       
L_0C11:           LJMP  L_1889                             
L_0C14:           ACALL L_0EEF                             
                  ACALL L_0F1A                             
                  JC    L_0C0C                             
                  SJMP  L_0BE8                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0C1C:           ACALL L_0ED0                             
                  CJNE  A,#023h,L_0C25                     
                  SETB  LP_CON_out_ctrl                    
                  AJMP  L_0ECE                             
L_0C25:           CJNE  A,#040h,L_0C01                     
                  SETB  print_list_exe                     
                  AJMP  L_0ECE                             
                  SETB  hex_no_zero                        
                  SETB  hex_mode                           
                  ACALL L_0C1C                             
                  ACALL L_0C3B                             
               ;***
               ;*** SUBROUTINE
               ;***
init_D23h_D26h:   ANL   L_0023,#0F5h                       
                  ANL   L_0026,#03Fh                       
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0C3B:           ACALL L_0EE4                             
                  JC    L_0C46                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0C3F:           LJMP  Send_CRLF                          
L_0C42:           ACALL L_0EC9                             
                  JC    L_0C3F                             
L_0C46:           ACALL L_0EAC                             
                  JNC   L_0C42                             
                  CJNE  A,#0a4h,L_0C55                     
                  ACALL L_0E98                             
                  SUBB  A,L_0016                           
                  JC    L_0C42                             
                  SJMP  L_0C5A                             
L_0C55:           CJNE  A,#0a9h,L_0C62                     
                  ACALL L_0E98                             
L_0C5A:           JZ    L_0C42                             
                  LCALL L_0709                             
                  DEC   A                                  
                  SJMP  L_0C5A                             
L_0C62:           CJNE  A,#0d3h,L_0C78                     
                  ACALL L_0ECE                             
                  CJNE  A,#024h,L_0C70                     
                  ACALL L_0FFC                             
                  ACALL L_0E93                             
                  SJMP  L_0C74                             
L_0C70:           ACALL L_0E91                             
                  ACALL L_0CE6                             
L_0C74:           MOV   R5,X_0001                          
                  SJMP  L_0C7F                             
L_0C78:           CJNE  A,#0aah,L_0C84                     
                  ACALL L_0EDA                             
                  MOV   R5,#0dh                            
L_0C7F:           LCALL send_[R5]                          
                  SJMP  L_0C42                             
L_0C84:           CJNE  A,#0d2h,L_0CDA                     
                  ACALL L_0ECE                             
                  CJNE  A,#046h,L_0CA2                     
                  MOV   L_0017,#0F0h                       
                  ACALL L_0ECE                             
                  ACALL L_0EDA                             
                  ANL   A,#0fh                             
                  JZ    L_0C9E                             
                  CJNE  A,#03h,L_0C9A                      
L_0C9A:           JNC   L_0C9E                             
                  MOV   A,#03h                             
L_0C9E:           ORL   L_0017,A                           
                  SJMP  L_0CCC                             
L_0CA2:           CJNE  A,#030h,L_0CAC                     
                  MOV   L_0017,#00h                        
                  ACALL L_0EDA                             
                  SJMP  L_0CCC                             
L_0CAC:           CJNE  A,#023h,L_0CCC                     
                  ACALL L_0CD0                             
                  MOV   L_0017,R7                          
                  CJNE  A,#02eh,L_0CC7                     
                  ACALL L_0ECE                             
                  ACALL L_0CD0                             
                  MOV   A,R7                               
                  ADD   A,L_0017                           
                  ADD   A,#0f7h                            
                  JNC   L_0CC3                             
L_0CC1:           AJMP  L_093B                             
L_0CC3:           MOV   A,R7                               
                  SWAP  A                                  
                  ORL   L_0017,A                           
L_0CC7:           MOV   A,L_0017                           
                  SWAP  A                                  
                  MOV   L_0017,A                           
L_0CCC:           ACALL L_0CE6                             
                  AJMP  L_0C42                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0CD0:           MOV   R7,#00h                            
L_0CD2:           CJNE  A,#023h,ret_7                      
                  INC   R7                                 
                  ACALL L_0ECE                             
                  SJMP  L_0CD2                             
L_0CDA:           ACALL L_0EE6                             
                  JNC   ret_7                              
                  CJNE  A,#0a8h,L_0D15                     
ret_7:            RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0CE2:           MOV   R7,#0e0h                           
                  ACALL L_0F44                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0CE6:           MOV   R7,#029h                           
               ;***
               ;*** SUBROUTINE
               ;***
L_0CE8:           ACALL L_0ED8                             
                  CJNE  A,L_0007,L_0CC1                    
                  RET                                      
                  ACALL L_0E91                             
                  ACALL L_0ED8                             
                  CJNE  A,#083h,L_0CF9                     
                  ACALL L_0D00                             
                  AJMP  L_0A75                             
L_0CF9:           CJNE  A,#09fh,L_0CC1                     
                  ACALL L_0D00                             
                  AJMP  L_0B32                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0D00:           CJNE  R1,#00h,L_0D09                     
                  ACALL L_0F33                             
                  ACALL L_0EEF                             
                  AJMP  L_0AF7                             
L_0D09:           MOV   R7,#02ch                           
                  ACALL L_0EF1                             
                  CJNE  A,#02ch,L_0CC1                     
                  DEC   R1                                 
                  ACALL L_0EDA                             
                  SJMP  L_0D00                             
L_0D15:           ACALL L_0EC2                             
                  JC    L_0D1E                             
                  LCALL CON_line_output                    
                  AJMP  L_0C42                             
L_0D1E:           ACALL L_0F46                             
                  MOV   A,#048h                            
                  CJNE  A,L_0016,L_0D25                    
L_0D25:           JNC   L_0D29                             
                  ACALL L_0C3F                             
L_0D29:           JNB   hex_mode,L_0D40                    
                  LCALL L_11ED                             
                  JC    L_0D40                             
                  LCALL ABS_tos                            
                  JNZ   L_0D3D                             
                  ACALL L_0E93                             
                  LCALL L_19A9                             
                  AJMP  L_0C42                             
L_0D3D:           LCALL L_138C                             
L_0D40:           LCALL L_19A1                             
                  MOV   A,#01h                             
                  AJMP  L_0C5A                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0D47:           ACALL L_0ECE                             
                  LCALL L_1FED                             
                  JC    L_0D5A                             
                  CJNE  A,#05fh,L_0D52                     
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0D52:           CJNE  A,#041h,L_0D55                     
L_0D55:           JC    ret_8                              
                  CJNE  A,#05bh,L_0D5A                     
L_0D5A:           CPL   C                                  
ret_8:            RET                                      
L_0D5C:           JNB   F0,L_0D9D                          
L_0D5F:           MOV   DPTR,#01758h                       
                  AJMP  L_0C11                             
L_0D64:           SETB  F0                                 
                  SJMP  L_0D6A                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0D68:           CLR   F0                                 
L_0D6A:           ACALL L_0ED0                             
                  ACALL L_0D52                             
                  JNC   L_0D74                             
                  JB    F0,L_0D5F                          
                  RET                                      
L_0D74:           MOV   R7,A                               
                  CLR   A                                  
                  MOV   R5,A                               
L_0D77:           MOV   R6,A                               
                  ACALL L_0D47                             
                  JC    L_0D83                             
                  XCH   A,R7                               
                  ADD   A,R5                               
                  XCH   A,R7                               
                  MOV   R5,#01ah                           
                  SJMP  L_0D77                             
L_0D83:           CLR   line_edit                          
                  CJNE  A,#0e0h,L_0DB7                     
                  ORL   X_0006,#080h                       
                  LCALL L_0613                             
                  PUSH  X_0002                             
                  PUSH  X_0000                             
                  JNC   L_0D5C                             
                  JB    F0,L_0DBF                          
                  MOV   R1,#0ah                            
                  MOV   R3,#00h                            
                  ACALL L_0DCF                             
L_0D9D:           ACALL L_0E9A                             
                  CJNE  R3,#00h,L_0D5F                     
                  POP   L_0082                             
                  POP   L_0083                             
                  MOVX  A,@DPTR                            
                  DEC   A                                  
                  SUBB  A,R1                               
                  JC    L_0D5F                             
                  LCALL L_05BA                             
                  ACALL L_0A10                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0DB0:           XCH   A,R1                               
                  XCH   A,R0                               
                  XCH   A,R1                               
                  XCH   A,R3                               
                  XCH   A,R2                               
                  XCH   A,R3                               
                  RET                                      
L_0DB7:           JB    F0,L_0D5F                          
                  LCALL L_0613                             
                  CLR   C                                  
                  RET                                      
L_0DBF:           ACALL L_0E9A                             
                  CJNE  R3,#00h,L_0D5F                     
                  POP   X_0000                             
                  POP   X_0002                             
                  ACALL L_0DCF                             
                  ACALL L_0EC9                             
                  JNC   L_0D64                             
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0DCF:           INC   R1                                 
                  MOV   A,R1                               
                  JZ    L_0D5F                             
                  MOV   R4,A                               
                  MOV   DPTR,#0108h                        
                  ACALL L_0A10                             
                  MOV   R7,L_0083                          
                  MOV   R6,L_0082                          
                  MOV   DPTR,#0106h                        
                  LCALL L_159B                             
                  MOV   DPTR,#0108h                        
                  LCALL L_05FF                             
                  MOV   L_0082,R0                          
                  MOV   L_0083,R2                          
                  MOV   A,R4                               
                  MOVX  @DPTR,A                            
                  LCALL L_05BA                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0DF2:           MOV   A,R7                               
                  MOVX  @DPTR,A                            
                  INC   DPTR                               
Show_array_size:  MOV   A,R6                               
                  MOVX  @DPTR,A                            
                  RET                                      
                  ACALL L_0EAC                             
                  ACALL L_0EC9                             
                  JNC   L_0E05                             
                  ACALL L_0C3F                             
L_0E00:           MOV   R5,#03fh                           
                  LCALL send_[R5]                          
L_0E05:           SETB  input_exe                          
                  LCALL CON_line_input                     
                  CLR   input_exe                          
                  MOV   L_000F,#00h                        
                  MOV   L_000E,#07h                        
L_0E12:           ACALL L_0EC2                             
                  JC    L_0E23                             
                  ACALL L_0DB0                             
                  MOV   R3,L_000F                          
                  MOV   R1,L_000E                          
                  ACALL L_09A0                             
                  ACALL L_0EC9                             
                  JNC   L_0E00                             
                  RET                                      
L_0E23:           LCALL L_1847                             
                  LCALL L_194E                             
                  JNZ   L_0E43                             
                  LCALL L_184E                             
                  ACALL L_0F04                             
                  ACALL L_0FD4                             
                  LCALL L_1847                             
                  ACALL L_0EC9                             
                  JC    L_0E4C                             
                  MOVX  A,@DPTR                            
                  CJNE  A,#02ch,L_0E43                     
                  INC   DPTR                               
                  LCALL L_184E                             
                  SJMP  L_0E12                             
L_0E43:           MOV   DPTR,#0f1h                         
                  LCALL Show_ROM_msg                       
                  LJMP  L_183E                             
L_0E4C:           MOVX  A,@DPTR                            
                  CJNE  A,#0dh,L_0E51                      
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0E51:           MOV   DPTR,#0369h                        
                  LCALL Show_ROM_msg                       
                  AJMP  L_0C3F                             
                  ACALL L_0E88                             
                  MOV   L_004B,R3                          
                  MOV   L_004C,R1                          
                  MOV   DPTR,#0126h                        
                  SETB  ONTIME_executed                    
                  AJMP  L_0DF2                             
                  ACALL L_0F33                             
                  CJNE  R2,#00h,L_0E75                     
                  MOV   A,R0                               
                  JB    ACC.7,L_0E75                       
                  ADD   A,R0                               
                  MOV   DPTR,#04100h                       
                  MOV   L_0082,A                           
L_0E75:           ACALL L_096F                             
                  ANL   L_00D0,#0E7h                       
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0E7B:           ACALL L_0E91                             
                  LCALL L_1672                             
                  MOV   L_0040,R3                          
                  MOV   L_0041,R1                          
                  MOV   R7,#02ch                           
                  ACALL L_0CE8                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0E88:           ACALL L_0F46                             
                  MOV   R7,#02ch                           
                  ACALL L_0F44                             
                  LJMP  L_148C                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0E91:           ACALL L_0F46                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0E93:           LCALL L_120E                             
                  MOV   A,R1                               
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0E98:           ACALL L_0EDA                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0E9A:           ACALL L_0CE2                             
                  SJMP  L_0E93                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0E9E:           MOV   L_0013,L_0083                      
                  MOV   L_0014,L_0082                      
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0EA5:           MOV   L_000A,L_0083                      
                  MOV   L_0008,L_0082                      
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0EAC:           ACALL L_0ED0                             
                  CJNE  A,#022h,L_0F24                     
                  ACALL L_0EA5                             
                  INC   DPTR                               
                  MOV   R4,#022h                           
                  LCALL L_06BD                             
                  INC   DPTR                               
                  CLR   C                                  
               ;***
               ;*** SUBROUTINE
               ;***
L_0EBB:           MOV   L_0083,L_000A                      
                  MOV   L_0082,L_0008                      
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0EC2:           ACALL L_0ED0                             
                  CJNE  A,#024h,L_0F24                     
                  AJMP  L_09EA                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0EC9:           ACALL L_0ED0                             
                  CJNE  A,#02ch,L_0F24                     
               ;***
               ;*** SUBROUTINE
               ;***
L_0ECE:           ACALL L_0EDA                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0ED0:           SETB  RS0                                
                  MOV   L_00A0,R2                          
                  MOVX  A,@R0                              
                  CLR   RS0                                
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0ED8:           ACALL L_0ED0                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0EDA:           SETB  RS0                                
                  INC   R0                                 
                  CJNE  R0,#00h,L_0EE1                     
                  INC   R2                                 
L_0EE1:           CLR   RS0                                
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0EE4:           ACALL L_0ED0                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0EE6:           CJNE  A,#0dh,L_0EEB                      
                  CLR   A                                  
                  RET                                      
L_0EEB:           CJNE  A,#03ah,L_0F24                     
L_0EEE:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0EEF:           MOV   R7,#0dh                            
               ;***
               ;*** SUBROUTINE
               ;***
L_0EF1:           ACALL L_0EE4                             
                  JNC   L_0EEE                             
                  CJNE  A,L_0007,L_0EF9                    
                  RET                                      
L_0EF9:           ACALL L_0EDA                             
                  SJMP  L_0EF1                             
L_0EFD:           ACALL L_0EDA                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0EFF:           ACALL L_0EE4                             
                  JNZ   L_0EFD                             
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0F04:           ACALL L_0D68                             
                  SJMP  L_0F35                             
                  ACALL L_0BC0                             
                  MOV   R4,#03h                            
                  ACALL L_0B38                             
                  AJMP  L_0819                             
L_0F10:           CJNE  A,#03ah,L_0F15                     
                  AJMP  L_0EDA                             
L_0F15:           CJNE  A,#0a8h,L_0F85                     
                  ACALL L_0EFF                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0F1A:           ACALL L_0ED0                             
                  CJNE  A,#0dh,L_0F10                      
                  ACALL L_0ECE                             
                  CJNE  A,#01h,L_0F26                      
L_0F24:           SETB  C                                  
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0F26:           XCH   A,L_0008                           
                  ADD   A,#03h                             
                  XCH   A,L_0008                           
                  JBC   CY,L_0F30                          
                  RET                                      
L_0F30:           INC   L_000A                             
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0F33:           ACALL L_0F38                             
L_0F35:           JC    L_0F85                             
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0F38:           ACALL L_0EA5                             
                  LCALL L_19A5                             
                  ACALL L_0EBB                             
                  MOV   L_0083,R2                          
                  MOV   L_0082,R0                          
L_0F43:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_0F44:           ACALL L_0CE8                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0F46:           MOV   R2,#0cdh                           
               ;***
               ;*** SUBROUTINE
               ;***
L_0F48:           PUSH  X_0002                             
                  CLR   arg_stack_value                    
L_0F4C:           MOV   A,L_0081                           
                  ADD   A,#0ch                             
                  JNC   L_0F55                             
                  LJMP  Show_I_stack                       
L_0F55:           MOV   A,L_0009                           
                  SUBB  A,#038h                            
                  JNC   L_0F5E                             
                  LJMP  L_1205                             
L_0F5E:           JB    arg_stack_value,L_0F74             
                  ACALL L_0D68                             
                  JNC   L_0F72                             
                  ACALL L_0FF2                             
                  JNC   L_0F74                             
                  ACALL L_0ED0                             
                  CJNE  A,#0e0h,L_0F74                     
                  MOV   A,#0ceh                            
                  SJMP  L_0FC7                             
L_0F72:           ACALL L_0FE0                             
L_0F74:           ACALL L_0ED0                             
                  CJNE  A,#0e0h,L_0F79                     
L_0F79:           JNC   L_0F89                             
                  CJNE  A,#0b0h,L_0F7E                     
L_0F7E:           JNC   L_0FBB                             
                  POP   X_0002                             
                  JB    arg_stack_value,L_0F43             
L_0F85:           CLR   C                                  
                  LJMP  Show_badsyntax                     
L_0F89:           ANL   A,#01fh                            
                  JB    arg_stack_value,L_0F93             
                  CJNE  A,#05h,L_0FCD                      
                  MOV   A,#09h                             
L_0F93:           ADD   A,#0ceh                            
                  MOV   R2,A                               
                  MOV   DPTR,#00h                          
                  MOVC  A,@A+DPTR                          
                  MOV   R4,A                               
                  POP   L_00E0                             
                  MOV   R5,A                               
                  MOVC  A,@A+DPTR                          
                  CJNE  A,X_0004,L_0FA6                    
                  CJNE  A,#0ch,L_0F43                      
                  SETB  C                                  
L_0FA6:           JNC   L_0F43                             
                  PUSH  X_0005                             
                  PUSH  X_0002                             
                  ACALL L_0EDA                             
                  ACALL L_0F48                             
L_0FB0:           POP   L_00E0                             
L_0FB2:           MOV   DPTR,#057h                         
                  ADD   A,#032h                            
                  ACALL get_tabel_addr                     
                  AJMP  L_0F4C                             
L_0FBB:           ACALL L_0EDA                             
                  ADD   A,#02eh                            
                  JB    arg_stack_value,L_0F85             
                  CJNE  A,#0ech,L_0FC5                     
L_0FC5:           JNC   L_0FB2                             
L_0FC7:           PUSH  L_00E0                             
                  ACALL L_0CE2                             
                  SJMP  L_0FB0                             
L_0FCD:           CJNE  A,#03h,L_0F85                      
                  ACALL L_0EDA                             
                  AJMP  L_0F4C                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0FD4:           ACALL L_0DB0                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0FD6:           LCALL L_123A                             
                  LJMP  L_145D                             
                  MOV   R2,#01h                            
                  MOV   R0,#013h                           
               ;***
               ;*** SUBROUTINE
               ;***
L_0FE0:           LCALL L_11F6                             
                  SETB  arg_stack_value                    
                  LJMP  L_145D                             
                  ACALL L_0E91                             
                  SJMP  L_0FD6                             
                  ACALL L_0E91                             
                  ACALL L_0DB0                             
                  SJMP  L_0FE0                             
               ;***
               ;*** SUBROUTINE
               ;***
L_0FF2:           ACALL L_0ED0                             
                  CJNE  A,#0d1h,L_100A                     
                  ACALL L_0ECE                             
                  CJNE  A,#024h,L_1001                     
               ;***
               ;*** SUBROUTINE
               ;***
L_0FFC:           ACALL L_0A21                             
                  LJMP  L_13AB                             
L_1001:           LCALL L_149C                             
                  LCALL L_0EDA                             
                  LJMP  L_0CE6                             
L_100A:           LCALL L_0EA5                             
                  LCALL L_194E                             
                  CJNE  A,#0ffh,L_1015                     
                  SETB  C                                  
L_1014:           RET                                      
L_1015:           JNZ   L_101D                             
                  CLR   C                                  
                  SETB  arg_stack_value                    
               ;***
               ;*** SUBROUTINE
               ;***
L_101A:           LJMP  L_0EBB                             
L_101D:           ANL   A,#0bh                             
                  JZ    L_1014                             
Show_div_by_0:    MOV   DPTR,#01748h                       
                  JNB   ACC.0,L_102A                       
Show_Arr_undfl:   MOV   DPTR,#017feh                       
L_102A:           JNB   ACC.1,L_1030                       
Show_Arr_overfl:  MOV   DPTR,#01f89h                       
L_1030:           LJMP  L_1889                             
                  LCALL L_0C1C                             
                  ACALL L_13B6                             
                  LCALL L_0F38                             
                  CLR   A                                  
                  MOV   R3,A                               
                  MOV   R1,A                               
                  JC    L_1054                             
L_1040:           LCALL L_184E                             
                  LCALL L_0ED8                             
                  CJNE  A,#0e5h,L_1050                     
                  ACALL L_123A                             
                  LCALL L_0F33                             
                  ACALL L_149F                             
L_1050:           MOV   R3,L_000F                          
                  MOV   R1,L_000E                          
L_1054:           LCALL L_0586                             
                  JZ    L_1077                             
L_1059:           ACALL L_101A                             
                  INC   DPTR                               
                  ACALL L_163D                             
                  ACALL L_11F3                             
                  JC    L_1077                             
                  LCALL L_0787                             
                  ACALL L_11F6                             
                  LCALL L_0EA5                             
                  ACALL L_1088                             
                  ACALL L_101A                             
                  ACALL L_1079                             
                  INC   DPTR                               
                  MOVX  A,@DPTR                            
                  DJNZ  L_00E0,L_1059                      
                  ACALL L_123A                             
L_1077:           AJMP  goto_CMD_mode                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1079:           MOV   DPTR,#07h                          
                  LCALL L_06BB                             
                  LCALL L_0EA5                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1082:           LJMP  Send_CRLF                          
                  LCALL R3R1_to_DPTR                       
               ;***
               ;*** SUBROUTINE
               ;***
L_1088:           MOV   R3,#00h                            
                  MOV   R1,#07h                            
                  INC   DPTR                               
                  ACALL L_101A                             
                  LCALL [DPTR]_to_R2R0                     
                  LCALL L_19A3                             
                  LCALL L_0EA5                             
                  INC   DPTR                               
L_1099:           CJNE  R1,#0dh,L_109C                     
L_109C:           JC    L_10C0                             
                  INC   DPTR                               
                  MOVX  A,@DPTR                            
                  MOV   R6,A                               
                  JB    ACC.7,L_10C8                       
                  CJNE  A,#020h,L_10A7                     
L_10A7:           JNC   L_10AC                             
                  CJNE  A,#0dh,L_10C8                      
L_10AC:           CJNE  A,#022h,L_10B8                     
                  ACALL L_110C                             
L_10B1:           ACALL L_110E                             
                  CJNE  A,#022h,L_10B1                     
                  SJMP  L_1099                             
L_10B8:           CJNE  A,#03ah,L_10C4                     
                  ACALL L_110A                             
                  MOV   A,R6                               
                  ACALL L_110C                             
L_10C0:           ACALL L_110A                             
                  SJMP  L_1099                             
L_10C4:           ACALL L_1110                             
                  SJMP  L_1099                             
L_10C8:           ACALL L_101A                             
                  MOV   C,exp_present                      
                  MOV   L_00D5,C                           
L_10CE:           MOV   DPTR,#0173h                        
                  JNB   F0,L_10D7                          
                  LCALL get_user_lookup                    
L_10D7:           CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  INC   DPTR                               
                  CJNE  A,#0ffh,L_10E2                     
                  JBC   F0,L_10CE                          
                  AJMP  goto_CMD_mode                      
L_10E2:           CJNE  A,X_0006,L_10D7                    
                  CJNE  A,#0b0h,L_10E8                     
L_10E8:           JNC   L_10EC                             
                  ACALL L_110A                             
L_10EC:           CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  JB    ACC.7,L_10F8                       
                  JZ    L_10F8                             
                  ACALL L_110C                             
                  INC   DPTR                               
                  SJMP  L_10EC                             
L_10F8:           LCALL L_0EA5                             
                  MOV   A,R6                               
                  XRL   A,#096h                            
                  JNZ   L_1104                             
L_1100:           ACALL L_110E                             
                  SJMP  L_1100                             

; phase error, pc = 1104 label = ‹F‰†hÿ>þ new pc = 1105

L_1104:           JNC   L_1099                             
L_1105:           MOVC  A,@A+DPTR                          
                  ACALL L_110A                             
                  SJMP  L_1099                             
               ;***
               ;*** SUBROUTINE
               ;***
L_110A:           MOV   A,#020h                            
               ;***
               ;*** SUBROUTINE
               ;***
L_110C:           AJMP  L_162F                             
               ;***
               ;*** SUBROUTINE
               ;***
L_110E:           INC   DPTR                               
                  MOVX  A,@DPTR                            
               ;***
               ;*** SUBROUTINE
               ;***
L_1110:           CJNE  A,#0dh,L_110C                      
                  AJMP  L_161B                             
                  MOV   R6,#00h                            
                  ANL   A,@R1                              
                  RET                                      
                  XRL   A,@R0                              
                  ADD   A,R0                               
                  MOV   R7,#01h                            
                  ADDC  A,@R1                              
                  ANL   A,@R1                              
                  DEC   @R0                                
                  DEC   @R0                                
                  MOV   R7,#00h                            
                  DEC   A                                  
                  SUBB  A,@R0                              
                  MOV   DPTR,#0427fh                       
                  AJMP  L_1040                             
                  SUBB  A,@R0                              
                  ADD   A,R0                               
                  MOV   L_0080,#00h                        
                  XRL   A,#062h                            
                  XRL   A,L_0010                           
                  SJMP  L_1136                             
                  SUBB  A,R1                               
L_1136:           MOV   L_0020,R0                          
                  DEC   A                                  
                  SJMP  L_113B                             
L_113B:           ACALL L_1235                             
                  SUBB  A,R1                               
                  DEC   R1                                 
                  SJMP  L_1142                             

; phase error, pc = 1141 label = ‹F‰†hÿ>þ new pc = 1142

                  ORL   A,L_0031                           
L_1142:           ACALL 1133h                              
                  RLC   A                                  
                  AJMP  L_1400                             
                  NOP                                      
                  NOP                                      
                  NOP                                      
                  JBC   L_00FF,L_10CE                      
                  NOP                                      
                  NOP                                      
                  NOP                                      
                  NOP                                      
                  JB    L_007C,L_1154                      
L_1154:           NOP                                      
                  NOP                                      
                  INC   A                                  
                  RRC   A                                  
               ;***
               ;*** SUBROUTINE
               ;***
L_1158:           ACALL L_117D                             
                  ACALL calc_ADD                           
               ;***
               ;*** SUBROUTINE
               ;***
L_115C:           ACALL PI_tos                             
                  ACALL L_11A0                             
                  MOV   A,L_0046                           
                  ANL   A,#01h                             
                  XRL   L_0045,A                           
                  ACALL L_1417                             
                  ACALL L_117D                             
                  ACALL L_11F3                             
                  JC    L_1172                             
                  ACALL PI_tos                             
                  ACALL calc_SUB                           
L_1172:           ACALL ABS_tos                            
                  MOV   DPTR,#016c5h                       
                  ACALL L_1186                             
                  ACALL L_11C5                             
                  AJMP  L_11E7                             
               ;***
               ;*** SUBROUTINE
               ;***
L_117D:           ACALL PI_tos                             
               ;***
               ;*** SUBROUTINE
               ;***
L_117F:           MOV   DPTR,#0114ch                       
                  ACALL L_141E                             
                  AJMP  calc_DIV                           
               ;***
               ;*** SUBROUTINE
               ;***
L_1186:           ACALL L_1415                             
                  ACALL calc_MUL                           
                  ACALL L_1433                             
                  ACALL L_141E                             
L_118E:           ACALL L_143A                             
                  ACALL calc_MUL                           
                  ACALL L_141E                             
                  ACALL calc_ADD                           
                  CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  CJNE  A,#0ffh,L_118E                     
               ;***
               ;*** SUBROUTINE
               ;***
calc_MUL:         LCALL L_1999                             
                  AJMP  L_101D                             
               ;***
               ;*** SUBROUTINE
               ;***
L_11A0:           ACALL L_1457                             
                  ACALL calc_DIV                           
                  ACALL ABS_tos                            
                  MOV   L_0045,A                           
                  ACALL L_1415                             
                  ACALL L_120E                             
                  PUSH  X_0003                             
                  MOV   L_0046,R1                          
                  ACALL INT_tos                            
                  ACALL calc_SUB                           
                  ACALL L_1441                             
                  ACALL calc_MUL                           
                  POP   X_0003                             
                  RET                                      
                  ACALL L_1417                             
                  ACALL L_115C                             
                  ACALL L_1445                             
                  ACALL L_1158                             
                  AJMP  calc_DIV                           
               ;***
               ;*** SUBROUTINE
               ;***
L_11C5:           ACALL argstack_to_A                      
                  MOV   R3,#01h                            
                  AJMP  L_136C                             
                  ACALL ABS_tos                            
                  MOV   L_0045,A                           
                  ACALL argstack_to_A                      
                  ADD   A,#07fh                            
                  MOV   L_002A,C                           
                  JNC   L_11D9                             
                  ACALL L_1267                             
L_11D9:           MOV   DPTR,#01115h                       
                  ACALL L_1186                             
                  JNB   DIM_statement,L_11E7               
                  ACALL L_138C                             
                  ACALL L_117D                             
                  ACALL calc_ADD                           
L_11E7:           MOV   A,L_0045                           
                  JZ    ret_9                              
                  AJMP  L_138C                             
               ;***
               ;*** SUBROUTINE
               ;***
L_11ED:           ACALL L_1417                             
                  ACALL L_13B6                             
                  ACALL L_1445                             
               ;***
               ;*** SUBROUTINE
               ;***
L_11F3:           LJMP  L_1997                             
               ;***
               ;*** SUBROUTINE
               ;***
L_11F6:           MOV   A,#0fah                            
                  ADD   A,L_0009                           
                  CJNE  A,#032h,L_11FD                     
L_11FD:           JC    L_1205                             
                  MOV   L_0009,A                           
                  MOV   R1,A                               
                  MOV   R3,#01h                            
ret_9:            RET                                      
L_1205:           MOV   DPTR,#0377h                        
                  AJMP  L_1030                             
               ;***
               ;*** SUBROUTINE
               ;***
L_120A:           ACALL L_141E                             
                  ACALL calc_MUL                           
               ;***
               ;*** SUBROUTINE
               ;***
L_120E:           CLR   A                                  
                  MOV   R3,A                               
                  MOV   R1,A                               
                  MOV   R0,L_0009                          
                  MOV   L_00A0,#01h                        
                  MOVX  A,@R0                              
                  CLR   C                                  
                  SUBB  A,#081h                            
                  MOV   R4,A                               
                  DEC   R0                                 
                  MOVX  A,@R0                              
                  JNZ   L_1275                             
                  JC    L_123A                             
                  INC   R4                                 
                  MOV   A,R0                               
                  SUBB  A,#05h                             
                  MOV   R0,A                               
L_1226:           INC   R0                                 
                  MOVX  A,@R0                              
                  SWAP  A                                  
                  LCALL L_19A7                             
                  JC    L_1275                             
                  DJNZ  R4,L_1232                          
                  SJMP  L_123A                             
L_1232:           MOVX  A,@R0                              

; phase error, pc = 1233 label = ‹F‰†hÿ>þ new pc = 1235

                  LCALL L_19A7                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1235:           MOV   @R1,L_0040                         
                  ADDC  A,R5                               
                  DJNZ  R4,L_1226                          
               ;***
               ;*** SUBROUTINE
               ;***
L_123A:           MOV   A,#06h                             
                  SJMP  L_123F                             
               ;***
               ;*** SUBROUTINE
               ;***
argstack_to_A:    CLR   A                                  
L_123F:           MOV   R0,L_0009                          
                  MOV   R2,#01h                            
                  MOV   L_00A0,R2                          
                  ADD   A,R0                               
                  JC    L_1205                             
                  MOV   L_0009,A                           
                  MOVX  A,@R0                              
L_124B:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_124C:           ACALL L_142E                             
                  ACALL L_11A0                             
                  CJNE  R3,#00h,L_1275                     
                  ACALL L_1457                             
                  ACALL L_123A                             

; phase error, pc = 1257 label = ‹F‰†hÿ>þ new pc = 1258

                  ACALL L_1433                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1258:           RLC   A                                  
                  ACALL L_142E                             
L_125B:           MOV   A,L_0046                           
                  JNZ   L_126D                             
                  MOV   A,L_0045                           
                  JZ    L_124B                             
                  MOV   DPTR,#011eh                        
                  MOVX  @DPTR,A                            
               ;***
               ;*** SUBROUTINE
               ;***
L_1267:           ACALL L_142E                             
                  ACALL L_1445                             
                  AJMP  calc_DIV                           
L_126D:           DEC   L_0046                             
                  ACALL L_143A                             
                  ACALL calc_MUL                           
                  SJMP  L_125B                             
L_1275:           LJMP  Show_bad_arg                       
                  ACALL ABS_tos                            
                  JNZ   L_1275                             
                  ACALL L_1457                             
                  ACALL L_1433                             
                  MOV   R0,#019h                           
                  MOVX  A,@R0                              
                  JZ    L_12A9                             
                  ADD   A,#080h                            
                  JNC   L_128E                             
                  RR    A                                  
                  ANL   A,#07fh                            
                  SJMP  L_1295                             
L_128E:           CPL   A                                  
                  INC   A                                  
                  RR    A                                  
                  ANL   A,#07fh                            
                  CPL   A                                  
                  INC   A                                  
L_1295:           ADD   A,#080h                            
                  MOVX  @R0,A                              
L_1298:           ACALL L_1441                             
                  ACALL L_143A                             
                  ACALL calc_DIV                           
                  ACALL L_143A                             
                  ACALL calc_ADD                           
                  ACALL L_117F                             
                  ACALL L_1307                             
                  JNB   F0,L_1298                          
L_12A9:           AJMP  L_143A                             
               ;***
               ;*** SUBROUTINE
               ;***
L_12AB:           ACALL ABS_tos                            
                  JNZ   L_1275                             
                  MOV   L_0046,A                           
                  INC   R0                                 
                  MOVX  A,@R0                              
                  JZ    L_1275                             
                  CJNE  A,#081h,L_12B8                     
L_12B8:           MOV   L_002A,C                           
                  JC    L_12BE                             
                  ACALL L_1267                             
L_12BE:           ACALL L_1417                             
                  ACALL L_142E                             
                  ACALL L_11F3                             
                  JNC   L_12E3                             
                  ACALL argstack_to_A                      
                  ADD   A,#085h                            
                  JNC   L_12DA                             
                  ACALL Get_e_const                        
                  MOV   A,#01h                             
L_12D0:           ADD   A,L_0046                           
                  JC    L_1275                             
                  MOV   L_0046,A                           
                  ACALL calc_MUL                           
                  SJMP  L_12BE                             
L_12DA:           MOV   DPTR,#017e6h                       
                  ACALL L_141E                             
                  MOV   A,#0bh                             
                  SJMP  L_12D0                             
L_12E3:           ACALL L_1457                             
                  ACALL L_142E                             
                  ACALL calc_SUB                           
                  ACALL L_1441                             
                  ACALL L_142E                             
                  ACALL calc_ADD                           
                  ACALL calc_DIV                           
                  MOV   DPTR,#016a0h                       
                  ACALL L_1186                             
                  INC   DPTR                               
                  ACALL L_141E                             
                  ACALL calc_MUL                           
                  MOV   A,L_0046                           
                  ACALL L_149C                             
                  ACALL calc_SUB                           
                  ACALL L_11C5                             
                  JNB   DIM_statement,ABS_tos              
L_1306:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1307:           ACALL L_143A                             
                  ACALL L_1445                             
                  ACALL L_1417                             
                  ACALL L_1433                             
                  LJMP  L_1997                             
                  ACALL Get_e_const                        
                  ACALL L_1445                             
calc_EXP:         ACALL L_124C                             
                  MOV   DPTR,#011fh                        
                  MOVX  A,@DPTR                            
                  JZ    L_1306                             
                  ACALL L_1441                             
                  ACALL L_143A                             
                  ACALL argstack_to_A                      
                  JZ    L_1328                             
                  ACALL L_12AB                             
L_1328:           ACALL calc_MUL                           
                  ACALL Get_e_const                        
                  ACALL L_1445                             
                  ACALL L_124C                             
                  MOV   L_0046,#00h                        
                  ACALL L_142E                             
                  ACALL L_1417                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1337:           ACALL L_1433                             
L_1339:           ACALL L_1441                             
                  ACALL calc_MUL                           
                  INC   L_0046                             
                  MOV   A,L_0046                           
                  ACALL L_149C                             
                  ACALL calc_DIV                           
                  ACALL L_1417                             
                  ACALL L_143A                             
                  ACALL calc_ADD                           
                  ACALL L_1307                             
                  JNB   F0,L_1339                          
                  ACALL L_123A                             
                  ACALL L_143A                             
                  ACALL calc_MUL                           
                  AJMP  calc_MUL                           
               ;***
               ;*** SUBROUTINE
               ;***
INT_tos:          ACALL argstack_to_A                      
                  SUBB  A,#081h                            
                  JNC   L_1365                             
                  ACALL L_123A                             
L_1360:           MOV   DPTR,#04e0h                        
                  AJMP  L_141E                             
L_1365:           SUBB  A,#07h                             
                  JNC   ret_10                             
                  CPL   A                                  
                  INC   A                                  
                  MOV   R3,A                               
L_136C:           DEC   R0                                 
L_136D:           DEC   R0                                 
                  MOVX  A,@R0                              
                  ANL   A,#0f0h                            
                  MOVX  @R0,A                              
                  DJNZ  R3,L_1375                          
                  RET                                      
L_1375:           CLR   A                                  
                  MOVX  @R0,A                              
                  DJNZ  R3,L_136D                          
ret_10:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
ABS_tos:          ACALL L_138C                             
                  JNZ   ret_11                             
                  MOVX  @R0,A                              
                  RET                                      
SIGN_tos:         ACALL L_123A                             
                  JZ    L_1360                             
                  DEC   R0                                 
                  MOVX  A,@R0                              
                  MOV   R7,A                               
                  ACALL L_142E                             
                  MOV   A,R7                               
                  JZ    ret_11                             
               ;***
               ;*** SUBROUTINE
               ;***
L_138C:           ACALL argstack_to_A                      
                  DEC   R0                                 
                  JZ    ret_11                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1391:           MOVX  A,@R0                              
                  XRL   A,#01h                             
                  MOVX  @R0,A                              
                  XRL   A,#01h                             
               ;***
               ;*** SUBROUTINE
               ;***
ret_11:           RET                                      
                  ACALL L_120E                             
                  LCALL R3R1_to_DPTR                       
                  CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  AJMP  L_149C                             
                  ACALL L_120E                             
                  LCALL L_09D8                             
                  MOV   A,@R1                              
                  AJMP  L_149C                             
                  ACALL L_120E                             
L_13AB:           MOV   L_00A0,R3                          
                  MOVX  A,@R1                              
                  AJMP  L_149C                             
                  ACALL L_11F3                             
                  ORL   C,F0                               
L_13B4:           JC    L_1360                             
               ;***
               ;*** SUBROUTINE
               ;***
L_13B6:           MOV   DPTR,#013bbh                       
                  AJMP  L_141E                             
                  MOV   X_0000,X_0000                      
                  JNC   L_1413                             
                  XRL   A,L_0031                           
                  MOVX  @R1,A                              
L_13C3:           CPL   C                                  
                  SJMP  L_13B4                             
                  ACALL L_11F3                             
L_13C8:           MOV   C,F0                               
                  SJMP  L_13C3                             
                  ACALL L_11F3                             
                  CPL   F0                                 
                  SJMP  L_13C8                             
                  ACALL L_11F3                             
                  SJMP  L_13B4                             
                  ACALL L_11F3                             
                  ORL   C,F0                               
                  SJMP  L_13C3                             
                  MOV   DPTR,#010ch                        
                  LCALL L_05B4                             
                  MOV   A,R1                               
                  CLR   C                                  
                  RRC   A                                  
                  MOV   R0,A                               
                  MOV   A,#06h                             
                  RRC   A                                  
                  ADD   A,R1                               
                  XCH   A,R0                               
                  ADDC  A,R3                               
                  MOV   R2,A                               
                  DEC   L_0082                             
                  ACALL L_140F                             
                  ACALL L_149F                             
                  ACALL L_13B6                             
               ;***
               ;*** SUBROUTINE
               ;***
calc_DIV:         LCALL L_199B                             
                  AJMP  L_101D                             
                  LCALL L_0F33                             
                  SETB  ONERR_exe                          

; phase error, pc = 13FF label = ‹F‰†hÿ>þ new pc = 1400

                  MOV   DPTR,#0102h                        
L_1400:           AJMP  1002h                              
                  SJMP  L_140F                             
                  LCALL L_0F33                             
                  SETB  ONEX1_exe                          
                  ORL   L_00A8,#084h                       
                  MOV   DPTR,#0120h                        
               ;***
               ;*** SUBROUTINE
               ;***
L_140F:           MOV   A,R2                               
                  MOVX  @DPTR,A                            
                  INC   DPTR                               
                  MOV   A,R0                               
L_1413:           MOVX  @DPTR,A                            
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1415:           ACALL L_1417                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1417:           ACALL argstack_to_A                      
                  SJMP  L_143E                             
               ;***
               ;*** SUBROUTINE
               ;***
Get_e_const:      MOV   DPTR,#017ech                       
               ;***
               ;*** SUBROUTINE
               ;***
L_141E:           ACALL L_11F6                             
                  MOV   L_00A0,R3                          
                  MOV   R3,#06h                            
L_1424:           CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  MOVX  @R1,A                              
                  INC   DPTR                               
                  DEC   R1                                 
                  DJNZ  R3,L_1424                          
                  SETB  arg_stack_value                    
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_142E:           MOV   DPTR,#016e9h                       
                  AJMP  L_141E                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1433:           MOV   R3,#01h                            
                  MOV   R1,#019h                           
                  LJMP  L_0FD6                             
               ;***
               ;*** SUBROUTINE
               ;***
L_143A:           MOV   R0,#019h                           
L_143C:           MOV   R2,#01h                            
L_143E:           LJMP  L_0FE0                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1441:           MOV   R0,#01fh                           
                  SJMP  L_143C                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1445:           ACALL argstack_to_A                      
                  MOV   A,#06h                             
                  MOV   R2,A                               
                  ADD   A,R0                               
                  MOV   R1,A                               
L_144C:           MOVX  A,@R0                              
                  MOV   R3,A                               
                  MOVX  A,@R1                              
                  MOVX  @R0,A                              
                  MOV   A,R3                               
                  MOVX  @R1,A                              
                  DEC   R1                                 
                  DEC   R0                                 
                  DJNZ  R2,L_144C                          
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1457:           ACALL argstack_to_A                      
                  MOV   R3,#01h                            
                  MOV   R1,#01fh                           
L_145D:           MOV   R4,#06h                            
L_145F:           MOV   L_00A0,R2                          
                  MOVX  A,@R0                              
                  MOV   L_00A0,R3                          
                  MOVX  @R1,A                              
                  ACALL L_1576                             
                  DJNZ  R4,L_145F                          
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
PI_tos:           MOV   DPTR,#017f8h                       
                  AJMP  L_141E                             
calc_AND:         ACALL L_148C                             
                  MOV   A,R3                               
                  ANL   A,R7                               
                  MOV   R2,A                               
                  MOV   A,R1                               
                  ANL   A,R6                               
                  SJMP  L_149E                             
                  ACALL L_148C                             
                  MOV   A,R3                               
                  ORL   A,R7                               
                  MOV   R2,A                               
                  MOV   A,R1                               
                  ORL   A,R6                               
                  SJMP  L_149E                             
NOT_tos:          ACALL L_13B6                             
calc_XOR:         ACALL L_148C                             
                  MOV   A,R3                               
                  XRL   A,R7                               
                  MOV   R2,A                               
                  MOV   A,R1                               
                  XRL   A,R6                               
                  SJMP  L_149E                             
               ;***
               ;*** SUBROUTINE
               ;***
L_148C:           ACALL L_120E                             
                  MOV   R7,X_0003                          
                  MOV   R6,X_0001                          
                  AJMP  L_120E                             
                  MOV   DPTR,#0100h                        
                  MOVX  A,@DPTR                            
                  JBC   get_flag,L_149C                    
                  CLR   A                                  
               ;***
               ;*** SUBROUTINE
               ;***
L_149C:           MOV   R2,#00h                            
               ;***
               ;*** SUBROUTINE
               ;***
L_149E:           MOV   R0,A                               
               ;***
               ;*** SUBROUTINE
               ;***
L_149F:           SETB  arg_stack_value                    
                  LJMP  L_19AB                             
[TOS]<-[IE]:      MOV   A,L_00A8                           
                  SJMP  L_149C                             
[TOS]<-[IP]:      MOV   A,L_00B8                           
                  SJMP  L_149C                             
[TOS]<-[TIM0]:    MOV   R2,L_008C                          
                  MOV   R0,L_008A                          
                  SJMP  L_149F                             
[TOS]<-[TIM1]:    MOV   R2,L_008D                          
                  MOV   R0,L_008B                          
                  SJMP  L_149F                             
[TOS]<-[TIM2]:    MOV   R2,L_00CD                          
                  MOV   R0,L_00CC                          
                  SJMP  L_149F                             
[TOS]<-[T2CN]:    MOV   A,L_00C8                           
                  SJMP  L_149C                             
[TOS]<-[TCON]:    MOV   A,L_0088                           
                  SJMP  L_149C                             
[TOS]<-[TMOD]:    MOV   A,L_0089                           
                  SJMP  L_149C                             
[TOS]<-[RCP2]:    MOV   R2,L_00CB                          
                  MOV   R0,L_00CA                          
                  SJMP  L_149F                             
[TOS]<-[PRT1]:    MOV   A,L_0090                           
                  SJMP  L_149C                             
[TOS]<-[PCON]:    MOV   A,L_0087                           
                  SJMP  L_149C                             
L_14D8:           LJMP  L_0568                             
               ;***
               ;*** SUBROUTINE
               ;***
L_14DB:           MOV   A,L_0013                           
                  CJNE  A,#02h,L_14D8                      
                  LCALL L_05A3                             
                  MOV   R4,L_0082                          
                  MOV   R5,L_0083                          
                  MOV   R3,L_000F                          
                  MOV   R1,L_000E                          
                  LCALL L_0586                             
                  JNZ   L_1502                             
                  MOV   A,L_000D                           
                  CJNE  A,#04h,L_14F6                      
                  RET                                      
L_14F6:           ACALL L_1593                             
                  MOV   R2,X_0005                          
                  MOV   R0,X_0004                          
                  ACALL L_1551                             
               ;***
               ;*** SUBROUTINE
               ;***
L_14FE:           MOV   A,#01h                             
                  AJMP  L_1584                             
L_1502:           MOV   R7,A                               
                  LCALL L_184E                             
                  MOV   A,L_000D                           
                  JC    L_1513                             
                  CJNE  A,#04h,L_150E                      
                  CLR   A                                  
L_150E:           SUBB  A,R7                               
                  JZ    L_1547                             
                  JC    L_1532                             
L_1513:           MOV   R7,A                               
                  MOV   A,L_000D                           
                  CJNE  A,#04h,L_151A                      
                  RET                                      
L_151A:           MOV   A,R7                               
                  ACALL L_1593                             
                  LCALL L_1847                             
                  ACALL L_1588                             
                  LCALL L_0DB0                             
                  MOV   R1,X_0004                          
                  MOV   R3,X_0005                          
                  INC   R6                                 
                  CJNE  R6,#00h,L_152E                     
                  INC   R7                                 
L_152E:           ACALL L_156C                             
                  SJMP  L_1547                             
L_1532:           CPL   A                                  
                  INC   A                                  
                  LCALL L_05D8                             
                  ACALL L_1588                             
                  MOV   R1,L_0082                          
                  MOV   R3,L_0083                          
                  MOV   R2,L_000F                          
                  MOV   R0,L_000E                          
                  JZ    L_1545                             
                  ACALL L_1558                             
L_1545:           ACALL L_14FE                             
L_1547:           MOV   R2,L_000F                          
                  MOV   R0,L_000E                          
                  MOV   A,L_000D                           
                  CJNE  A,#04h,L_1551                      
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1551:           CLR   A                                  
                  MOV   R1,#04h                            
                  MOV   R3,A                               
                  MOV   R6,L_000D                          
                  MOV   R7,A                               
               ;***
               ;*** SUBROUTINE
               ;***
L_1558:           ACALL L_1581                             
                  ACALL inc_R2R0                           
                  ACALL L_1632                             
                  JNZ   L_1558                             
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
inc_R2R0:         INC   R0                                 
                  CJNE  R0,#00h,inc_R3R1                   
                  INC   R2                                 
inc_R3R1:         INC   R1                                 
                  CJNE  R1,#00h,ret_12                     
                  INC   R3                                 
ret_12:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_156C:           ACALL L_1581                             
                  ACALL L_1576                             
                  ACALL L_1632                             
                  JNZ   L_156C                             
L_1574:           NOP                                      
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1576:           DEC   R0                                 
                  CJNE  R0,#0ffh,L_157B                    
               ;***
               ;*** SUBROUTINE
               ;***
L_157A:           DEC   R2                                 
L_157B:           DEC   R1                                 
                  CJNE  R1,#0ffh,L_1574                    
                  DEC   R3                                 
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1581:           MOV   L_00A0,R3                          
                  MOVX  A,@R1                              
L_1584:           MOV   L_00A0,R2                          
                  MOVX  @R0,A                              
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1588:           MOV   A,R4                               
                  CLR   C                                  
                  SUBB  A,L_0082                           
                  MOV   R6,A                               
                  MOV   A,R5                               
                  SUBB  A,L_0083                           
                  MOV   R7,A                               
                  ORL   A,R6                               
L_1592:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1593:           ADD   A,R4                               
                  MOV   R1,A                               
                  CLR   A                                  
                  ADDC  A,R5                               
                  MOV   R3,A                               
                  MOV   DPTR,#0104h                        
               ;***
               ;*** SUBROUTINE
               ;***
L_159B:           LCALL L_05C6                             
                  JC    L_1592                             
Show_mem_alloc:   MOV   DPTR,#01810h                       
                  AJMP  L_1030                             
               ;***
               ;*** SUBROUTINE
               ;***
L_15A5:           ACALL L_1763                             
                  LCALL L_0F38                             
                  LCALL L_184E                             
                  MOV   L_00D5,C                           
                  MOV   DPTR,#05h                          
                  ACALL L_140F                             
                  MOV   R0,L_0008                          
                  MOV   R1,#07h                            
L_15B8:           CLR   arg_stack_value                    
                  MOV   DPTR,#0173h                        
L_15BD:           MOV   X_0005,R0                          
                  CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  MOV   R7,A                               
L_15C2:           MOVX  A,@R0                              
                  MOV   R3,A                               
                  CJNE  A,#061h,L_15C7                     
L_15C7:           JC    L_15D0                             
                  CJNE  A,#07bh,L_15CC                     
L_15CC:           JNC   L_15D0                             
                  CLR   ACC.5                              
L_15D0:           MOV   R2,A                               
                  MOVX  @R0,A                              
                  INC   DPTR                               
                  CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  CJNE  A,X_0002,L_15DB                    
                  INC   R0                                 
                  SJMP  L_15C2                             
L_15DB:           JB    ACC.7,L_160D                       
                  JZ    L_160D                             
L_15E0:           INC   DPTR                               
                  CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  JB    ACC.7,L_15E9                       
                  JNZ   L_15E0                             
                  INC   DPTR                               
L_15E9:           MOV   R0,X_0005                          
                  CJNE  A,#0ffh,L_15BD                     
                  CJNE  R2,#020h,L_15F4                    
                  INC   R0                                 
                  SJMP  L_15B8                             
L_15F4:           JNB   exp_present,L_1601                 
                  JB    arg_stack_value,L_1601             
                  SETB  arg_stack_value                    
                  LCALL get_user_lookup                    
                  AJMP  L_15BD                             
L_1601:           ACALL L_161A                             
                  CJNE  A,#022h,L_15B8                     
L_1606:           ACALL L_161A                             
                  CJNE  A,#022h,L_1606                     
                  SJMP  L_15B8                             
L_160D:           MOV   A,R7                               
                  ACALL L_162F                             
                  CJNE  A,#096h,L_15B8                     
                  MOV   A,R3                               
                  ACALL L_161B                             
L_1616:           ACALL L_161A                             
                  SJMP  L_1616                             
               ;***
               ;*** SUBROUTINE
               ;***
L_161A:           MOVX  A,@R0                              
               ;***
               ;*** SUBROUTINE
               ;***
L_161B:           CJNE  A,#0dh,L_162E                      
                  POP   X_0000                             
                  POP   X_0000                             
                  MOVX  @R1,A                              
                  INC   R1                                 
                  MOV   A,#01h                             
                  MOVX  @R1,A                              
                  MOV   A,R1                               
                  SUBB  A,#04h                             
                  MOV   L_000D,A                           
                  MOV   R1,#04h                            
L_162E:           INC   R0                                 
               ;***
               ;*** SUBROUTINE
               ;***
L_162F:           MOVX  @R1,A                              
                  INC   R1                                 
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1632:           DEC   R6                                 
                  CJNE  R6,#0ffh,L_1637                    
                  DEC   R7                                 
L_1637:           MOV   A,R7                               
                  ORL   A,R6                               
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_163A:           MOV   DPTR,#010ah                        
               ;***
               ;*** SUBROUTINE
               ;***
L_163D:           LCALL [DPTR]_to_R2R0                     
                  AJMP  L_149F                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1642:           MOV   DPTR,#017e0h                       
                  ACALL L_141E                             
L_1647:           ACALL L_1415                             
                  ACALL L_1417                             
                  MOV   DPTR,#0703h                        
                  ACALL L_1670                             
                  MOV   DPTR,#0128h                        
                  ACALL L_1705                             
                  MOV   DPTR,#017f2h                       
                  ACALL L_1670                             
                  MOV   DPTR,#012ah                        
                  ACALL L_1705                             
                  MOV   DPTR,#01152h                       
                  ACALL L_120A                             
                  MOV   A,R1                               
                  CPL   A                                  
                  INC   A                                  
                  MOV   L_004A,A                           
                  MOV   R3,#01h                            
                  MOV   R1,#013h                           
                  LJMP  L_0FD6                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1670:           ACALL L_120A                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1672:           MOV   A,R1                               
                  CPL   A                                  
                  ADD   A,#0fh                             
                  MOV   R1,A                               
                  MOV   A,R3                               
                  CPL   A                                  
                  ADDC  A,#00h                             
                  MOV   R3,A                               
                  RET                                      
                  LCALL L_0E7B                             
                  ACALL L_1672                             
L_1682:           CLR   PWM_OUT                            
                  CLR   TR1                                
                  MOV   L_008D,R3                          
                  MOV   L_008B,R1                          
                  CLR   TF1                                
                  SETB  TR1                                
                  ACALL L_1632                             
L_1690:           JNB   TF1,L_1690                         
                  ACALL ret_11                             
                  SETB  PWM_OUT                            
                  LCALL L_0529                             
L_169A:           JNB   TF1,L_169A                         
                  JNZ   L_1682                             
                  RET                                      
                  SJMP  L_16A2                             
L_16A2:           ACALL L_1337                             
                  RRC   A                                  
                  DEC   R1                                 
                  MOV   R7,#00h                            
                  MOV   @R0,#064h                          
                  ADDC  A,@R1                              
                  SUBB  A,#080h                            
                  NOP                                      
                  INC   @R1                                
                  RET                                      
                  MOV   L_0017,#080h                       
                  NOP                                      
                  ANL   L_0035,A                           
                  MOVC  A,@A+DPTR                          
                  ADD   A,R0                               
                  SJMP  L_16BA                             
L_16BA:           ACALL L_1391                             
                  MOV   L_0086,X_00ff                      
                  AJMP  L_1400                             
                  ACALL L_1258                             
                  LJMP  L_2377                             
                  NOP                                      
                  ORL   A,#090h                            
                  INC   L_0016                             
                  MOV   R1,#01h                            
                  INC   R0                                 
                  AJMP  L_1105                             
                  ADD   A,L_007B                           
                  NOP                                      
                  DEC   R1                                 
                  JMP   @A+DPTR                            
                  ANL   A,L_0027                           
                  MOV   R5,#01h                            
                  JNZ   L_16ED                             
                  DIV   AB                                 
                  DEC   R1                                 
                  MOV   R6,#00h                            
                  RLC   A                                  
                  RLC   A                                  
                  RLC   A                                  
                  MOVC  A,@A+PC                            
                  SJMP  L_16E6                             
                  XRL   A,@R1                              
L_16E6:           XRL   A,@R0                              
                  XRL   A,@R0                              
                  DEC   @R0                                
                  AJMP  L_1400                             
                  NOP                                      
                  NOP                                      
L_16ED:           NOP                                      
                  JBC   L_00FF,L_1703                      
                  INC   R7                                 
                  DJNZ  R4,L_1706                          
                  INC   R7                                 
                  ORL   A,@R0                              
                  MOV   A,#0ch                             
                  ACALL L_149C                             
                  ACALL calc_MUL                           
                  ACALL calc_DIV                           
                  ACALL L_120E                             
                  ACALL L_1672                             

; phase error, pc = 1702 label = ‹F‰†hÿ>þ new pc = 1703

                  MOV   DPTR,#0124h                        
L_1703:           AJMP  1024h                              
               ;***
               ;*** SUBROUTINE
               ;***

; phase error, pc = 1705 label = ‹F‰†hÿ>þ new pc = 1706

L_1705:           LJMP  L_05FF                             
L_1706:           INC   X_00ff                             
                  ACALL L_163A                             
                  LCALL L_05A3                             
                  MOV   R0,L_0082                          
                  MOV   R2,L_0083                          
                  ACALL L_149F                             
               ;***
               ;*** SUBROUTINE
               ;***
calc_SUB:         LCALL L_1995                             
                  AJMP  L_101D                             
                  LCALL L_0516                             
                  MOV   R2,L_0007                          
                  MOV   A,R6                               
                  AJMP  L_149E                             
                  MOV   C,EA                               
                  CLR   EA                                 
                  PUSH  L_0047                             
                  MOV   R2,L_0048                          
                  MOV   A,L_0049                           
                  MOV   L_00AF,C                           
                  ACALL L_149E                             
                  POP   L_00E0                             
                  ACALL L_149C                             
                  MOV   A,#0c8h                            
                  ACALL L_149C                             
init_BAStxtptr:   ACALL calc_DIV                           
               ;***
               ;*** SUBROUTINE
               ;***
calc_ADD:         LCALL L_1993                             
                  AJMP  L_101D                             
BAD_SYNTAX_msg:   DFB   "BAD SYNTAX"",8ah                  
DIVIDE_BY_0_msg:  DFB   "DIVIDE BY ZERO"                   
ARRAY_SIZE_msg:   DFB   "ARRAY SIZE"                       
               ;***
               ;*** SUBROUTINE
               ;***
L_1763:           MOV   L_000A,#00h                        
                  MOV   L_0008,#07h                        
                  RET                                      
                  LCALL L_0516                             
                  MOV   R2,#02h                            
                  MOV   R0,#00h                            
                  ACALL L_1558                             
                  LCALL L_065E                             
L_1776:           CLR   enable_cont                        
                  MOV   L_0013,#02h                        
                  MOV   L_0014,#00h                        
goto_CMD_mode:    LCALL init_D23h_D26h                     
check_cmdexp:     CLR   exp_present                        
                  CLR   A                                  
                  MOV   DPTR,#02002h                       
                  MOVC  A,@A+DPTR                          
                  CJNE  A,#05ah,show_READY                 
                  LCALL envoke_cmd_ext                     
show_READY:       MOV   DPTR,#0fbh                         
                  LCALL Show_ROM_msg                       
L_1794:           SETB  command_mode                       
                  MOV   L_003E,L_0081                      
                  ACALL L_1082                             
L_179B:           CLR   get_flag                           
                  MOV   DPTR,#05eh                         
                  MOVX  A,@DPTR                            
                  XRL   A,#034h                            
                  JNZ   L_17A8                             
                  LJMP  L_0808                             
L_17A8:           MOV   R5,#03eh                           
                  LCALL send_[R5]                          
                  LCALL CON_line_input                     
                  ACALL L_15A5                             
                  JB    F0,L_17C4                          
                  ACALL L_14DB                             
                  LCALL L_05E1                             
                  JB    line_edit,L_179B                   
                  SETB  line_edit                          
                  LCALL L_065E                             
                  SJMP  L_179B                             
L_17C4:           ACALL L_1763                             
                  LCALL L_0EE4                             
                  JZ    L_1794                             
                  MOV   DPTR,#010dh                        
                  CJNE  A,#0f0h,L_17D1                     
L_17D1:           JC    L_17DD                             
                  LCALL L_0EDA                             
                  ANL   A,#0fh                             
                  LCALL get_tabel_addr                     
                  SJMP  L_1794                             
L_17DD:           LJMP  L_0819                             
Std_XTAL_freq:    DFB   L=6 88h,00h,00h,92h,05h,11h        
                  DFB   L=1 85h                            
                  DFB   L=1 00h                            
                  DFB   L=1 42h                            
                  DFB   L=1 41h                            
                  DFB   L=1 87h                            
                  DFB   L=1 59h                            
E_2_7182818:      DFB   L=6 81h,00h,18h,28h,18h,27h        
                  DFB   L=1 7ch                            
                  DFB   L=1 00h                            
                  DFB   L=1 00h                            
                  DFB   L=1 00h                            
                  DFB   L=1 75h                            
                  DFB   L=1 83h                            
PI_3_1415926:     DFB   L=6 81h,00h,26h,59h,41h,31h        
                  DFB   L=1 9eh                            
ARITH_UNDFL_msg:  DFB   "ARITH. UNDERFLOW"                 
MEM_ALLOC_msg:    DFB   "MEMORY ALLOCATION                 
                  DFB   """                                
                  DFB   a8h                                
BAD_ARG_msg:      DFB   "BAD ARGUMENT"                     
I_STACK_msg:      DFB   "I-STACK""                         
                  DFB   90h                                
                  DFB   1fh                                
                  DFB   a6h                                
                  DFB   "0"                                
                  DFB   17h                                
                  DFB   "K"                                
L_183E:           MOV   L_0042,L_000A                      
                  MOV   L_0043,L_0008                      
                  LJMP  L_0815                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1847:           MOV   L_000F,L_0083                      
                  MOV   L_000E,L_0082                      
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_184E:           MOV   L_0083,L_000F                      
                  MOV   L_0082,L_000E                      
                  RET                                      
                  JB    command_mode,L_187F                
                  CLR   NOT_DMA_ACK                        
L_185A:           ORL   L_0087,#01h                        
                  JB    ext_int_pending,L_186B             
                  JBC   user_idle_break,L_186B             
                  JNB   ONTIME_executed,L_185A             
                  LCALL L_07E9                             
                  JC    L_185A                             
L_186B:           SETB  NOT_DMA_ACK                        
                  RET                                      
L_186E:           INC   DPTR                               
                  JB    command_mode,L_1895                
                  JNB   ONERR_exe,L_1895                   
                  MOV   DPTR,#0101h                        
                  LCALL L_066D                             
                  INC   DPTR                               
                  LJMP  L_084A                             
L_187F:           MOV   C,command_mode                     
Show_badsyntax:   MOV   DPTR,#0173dh                       
                  SJMP  L_188A                             
Show_I_stack:     MOV   DPTR,#01830h                       
L_1889:           CLR   C                                  
L_188A:           MOV   L_003E,L_0081                      
                  LCALL init_D23h_D26h                     
                  CLR   A                                  
                  MOVC  A,@A+DPTR                          
                  JBC   ACC.7,L_186E                       
L_1895:           ACALL L_184E                             
                  JC    L_189C                             
                  LCALL L_0669                             
L_189C:           LCALL L_069D                             
                  MOV   DPTR,#01ff8h                       
                  LCALL Get_DPTR_char                      
                  ACALL L_1847                             
L_18A7:           LCALL Get_DPTR_char                      
                  JNB   command_mode,L_18B2                
L_18AD:           CLR   STOP_CTRLC_found                   
                  LJMP  goto_CMD_mode                      
L_18B2:           MOV   DPTR,#0101h                        
                  LCALL Get_DPTR_char                      
                  LCALL L_0E9E                             
                  CLR   A                                  
L_18BC:           ACALL L_184E                             
                  LCALL L_05D8                             
                  ACALL L_18F5                             
                  JC    L_18CB                             
                  JZ    L_18CB                             
                  MOVX  A,@DPTR                            
                  CJNE  A,#01h,L_18BC                      
L_18CB:           ACALL L_1847                             
                  ACALL L_18F5                             
                  MOV   A,R1                               
                  ADD   A,#0ah                             
                  MOV   L_0045,A                           
                  INC   DPTR                               
                  LCALL L_163D                             
                  ACALL L_19A1                             
                  JB    STOP_CTRLC_found,L_18AD            
                  LCALL L_069D                             
                  ACALL L_1847                             
                  LCALL L_1088                             
                  LCALL L_1079                             
L_18E8:           MOV   R5,#02dh                           
                  ACALL L_1990                             
                  DJNZ  L_0045,L_18E8                      
                  MOV   R5,#058h                           
                  ACALL L_1990                             
                  AJMP  L_18AD                             
               ;***
               ;*** SUBROUTINE
               ;***
L_18F5:           MOV   R3,L_000A                          
                  MOV   R1,L_0008                          
                  LJMP  L_0A05                             
L_18FC:           MOV   L_004A,L_008C                      
                  XCH   A,L_0047                           
                  INC   A                                  
                  CJNE  A,#0c8h,L_190D                     
                  CLR   A                                  
                  INC   L_0049                             
                  CJNE  A,L_0049,L_190D                    
                  INC   L_0048                             
L_190D:           XCH   A,L_0047                           
                  POP   L_00D0                             
                  RETI                                     
                  ACALL L_192F                             
                  CLR   ET0                                
                  CLR   CLOCK1_exe                         
                  JNC   ret_13                             
                  ANL   L_0089,#0F0h                       
                  SETB  CLOCK1_exe                         
                  ORL   L_00A8,#082h                       
                  SETB  TR0                                
ret_13:           RET                                      
                  ACALL L_192F                             
                  MOV   L_001E,C                           
                  RET                                      
                  ACALL L_192F                             
                  MOV   L_001C,C                           
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_192F:           LCALL L_0ED8                             
                  SUBB  A,#031h                            
                  CPL   C                                  
L_1935:           RET                                      
test_RB0:         JB    RS1,L_1935                         
                  JB    RS0,L_1935                         

; phase error, pc = 193C label = ‹F‰†hÿ>þ new pc = 193E

                  JBC   ACC.7,L_1945                       
L_193E:           INC   @R0                                
                  MOV   DPTR,#047h                         

; phase error, pc = 1942 label = ‹F‰†hÿ>þ new pc = 1943

                  LJMP  get_tabel_addr                     
L_1943:           INC   R1                                 
                  ANL   A,R7                               
L_1945:           JB    ACC.0,L_199F                       
                  JZ    L_1990                             

; phase error, pc = 194A label = ‹F‰†hÿ>þ new pc = 194C

                  MOV   DPTR,#01991h                       
L_194C:           ACALL 1C73h                              
               ;***
               ;*** SUBROUTINE
               ;***
L_194E:           ACALL L_199D                             
                  JNC   L_199F                             
                  ACALL L_19A5                             
                  JNZ   L_198C                             
                  PUSH  L_0083                             
                  PUSH  L_0082                             
                  ACALL L_19AB                             
                  POP   L_0082                             
                  POP   L_0083                             
                  CLR   A                                  
                  RET                                      
                  XCHD  A,@R1                              
                  SETB  C/!T2                              
                  DA    A                                  
                  ANL   A,#0c5h                            
                  XCH   A,R6                               
                  JB    L_00C2,L_1945                      
                  JB    TR2,L_193E                         
                  XCH   A,R0                               
                  XCH   A,R6                               
                  ORL   C,/L_004B                          
                  AJMP  L_1ED4                             
                  AJMP  L_1ED5                             
                  ANL   L_00CB,#0D9h                       
                  ADD   A,R4                               
                  JB    L_0049,L_194C                      
                  DA    A                                  
                  XCH   A,L_00CC                           
                  ORL   C,/L_00C3                          
                  XCH   A,R7                               
                  SETB  P                                  
                  ADD   A,R6                               
                  JB    enable_fake_DMA,L_1943             
                  ADDC  A,R0                               

; phase error, pc = 198B label = ‹F‰†hÿ>þ new pc = 198C

                  ADDC  A,L_0022                           
L_198C:           RET                                      
                  NOP                                      
                  NOP                                      
                  NOP                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1990:           LJMP  send_[R5]                          
               ;***
               ;*** SUBROUTINE
               ;***
L_1993:           AJMP  L_19B7                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1995:           AJMP  L_19AD                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1997:           AJMP  L_1A6A                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1999:           AJMP  L_1A9A                             
               ;***
               ;*** SUBROUTINE
               ;***
L_199B:           AJMP  L_1ACF                             
               ;***
               ;*** SUBROUTINE
               ;***
L_199D:           AJMP  L_1C96                             
L_199F:           AJMP  L_1CCF                             
               ;***
               ;*** SUBROUTINE
               ;***
L_19A1:           AJMP  L_1D87                             
               ;***
               ;*** SUBROUTINE
               ;***
L_19A3:           AJMP  L_1F04                             
               ;***
               ;*** SUBROUTINE
               ;***
L_19A5:           AJMP  L_1EAB                             
               ;***
               ;*** SUBROUTINE
               ;***
L_19A7:           AJMP  L_1EE0                             
               ;***
               ;*** SUBROUTINE
               ;***
L_19A9:           AJMP  L_1F4C                             
               ;***
               ;*** SUBROUTINE
               ;***
L_19AB:           AJMP  L_1CC3                             
L_19AD:           MOV   L_00A0,#01h                        
                  MOV   R0,L_0009                          
                  DEC   R0                                 
                  MOVX  A,@R0                              
                  CPL   ACC.0                              
                  MOVX  @R0,A                              
L_19B7:           ACALL L_1C77                             
                  MOV   A,R7                               
                  JZ    L_19C9                             
                  CJNE  R6,#00h,L_19D1                     
                  ACALL L_1C6B                             
                  MOV   R7,#06h                            
L_19C3:           MOVX  A,@R0                              
                  MOVX  @R1,A                              
                  DEC   R0                                 
                  DEC   R1                                 
                  DJNZ  R7,L_19C3                          
               ;***
               ;*** SUBROUTINE
               ;***
L_19C9:           MOV   A,L_0009                           
                  ADD   A,#06h                             
                  MOV   L_0009,A                           
                  CLR   A                                  
                  RET                                      
L_19D1:           SUBB  A,R6                               
                  MOV   L_0030,R7                          
                  MOV   L_002F,R4                          
                  JNC   L_19E1                             
                  MOV   L_0030,R6                          
                  MOV   L_002F,R3                          
                  CPL   A                                  
                  INC   A                                  
                  XCH   A,R0                               
                  XCH   A,R1                               
                  XCH   A,R0                               
L_19E1:           MOV   R7,A                               
                  CLR   reserved                           
                  CJNE  R5,#00h,L_19E9                     
                  SETB  reserved                           
L_19E9:           ACALL L_1C88                             
                  CJNE  R7,#0bh,L_19EE                     
L_19EE:           JC    L_19F2                             
                  MOV   R7,#0ah                            
L_19F2:           MOV   L_002A,#00h                        
                  ACALL L_1BC8                             
                  MOV   R7,#04h                            
                  MOV   R1,#02eh                           
                  MOV   A,#09eh                            
                  CLR   C                                  
                  SUBB  A,R4                               
                  DA    A                                  
                  XCH   A,R4                               
                  JNZ   L_1A04                             
                  MOV   R4,A                               
L_1A04:           CJNE  A,#050h,L_1A07                     
L_1A07:           JNB   reserved,L_1A22                    
                  CPL   C                                  
                  ACALL L_1A19                             
                  JNC   L_1A17                             
                  INC   L_002A                             
                  MOV   R7,#01h                            
                  ACALL L_1BC8                             
                  ACALL L_1B7F                             
L_1A17:           AJMP  L_1B70                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1A19:           MOVX  A,@R0                              
                  ADDC  A,@R1                              
                  DA    A                                  
                  MOV   @R1,A                              
                  DEC   R0                                 
                  DEC   R1                                 
                  DJNZ  R7,L_1A19                          
                  RET                                      
L_1A22:           MOVX  A,@R0                              
                  MOV   R6,A                               
                  CLR   A                                  
                  ADDC  A,#099h                            
                  SUBB  A,@R1                              
                  ADD   A,R6                               
                  DA    A                                  
                  MOV   @R1,A                              
                  DEC   R0                                 
                  DEC   R1                                 
                  DJNZ  R7,L_1A22                          
                  JC    L_1A42                             
                  CPL   L_0078                             
                  MOV   R1,#02eh                           
                  MOV   R7,#04h                            
L_1A37:           MOV   A,#09ah                            
                  SUBB  A,@R1                              
                  ADD   A,#00h                             
                  DA    A                                  
                  MOV   @R1,A                              
                  DEC   R1                                 
                  CPL   C                                  
                  DJNZ  R7,L_1A37                          
L_1A42:           MOV   R0,#02bh                           
                  MOV   R7,#00h                            
L_1A46:           MOV   A,@R0                              
                  JNZ   L_1A51                             
                  INC   R7                                 
                  INC   R7                                 
                  INC   R0                                 
                  CJNE  R0,#02fh,L_1A46                    
                  AJMP  L_1BB8                             
L_1A51:           CJNE  A,#010h,L_1A54                     
L_1A54:           JNC   L_1A57                             
                  INC   R7                                 
L_1A57:           MOV   A,L_0030                           
                  CLR   C                                  
                  SUBB  A,R7                               
                  JZ    L_1A68                             
                  JC    L_1A68                             
                  MOV   L_0030,A                           
                  ACALL L_1C02                             
                  MOV   L_002A,#00h                        
                  AJMP  L_1B70                             
L_1A68:           AJMP  L_1BB2                             
L_1A6A:           ACALL L_1C77                             
                  MOV   A,L_0009                           
                  ADD   A,#0ch                             
                  MOV   L_0009,A                           
                  MOV   A,R6                               
                  CLR   F0                                 
                  SUBB  A,R7                               
                  JZ    L_1A82                             
                  JC    L_1A7D                             
L_1A7A:           MOV   A,R3                               
                  SJMP  L_1A7E                             
L_1A7D:           MOV   A,R4                               
L_1A7E:           JZ    ret_14                             
                  CPL   C                                  
ret_14:           RET                                      
L_1A82:           CJNE  R5,#00h,L_1A7A                     
                  MOV   R7,#04h                            
                  DEC   R0                                 
                  DEC   R0                                 
                  DEC   R0                                 
                  DEC   R1                                 
                  DEC   R1                                 
                  DEC   R1                                 
L_1A8D:           MOVX  A,@R0                              
                  MOV   R6,A                               
                  MOVX  A,@R1                              
                  SUBB  A,R6                               
                  JNZ   L_1A7D                             
                  INC   R0                                 
                  INC   R1                                 
                  DJNZ  R7,L_1A8D                          
                  SETB  F0                                 
                  RET                                      
L_1A9A:           ACALL L_1C75                             
                  CJNE  R6,#00h,L_1AA1                     
L_1A9F:           AJMP  L_1BB8                             
L_1AA1:           MOV   L_002F,R5                          
                  MOV   A,R7                               
                  JZ    L_1A9F                             
                  ADD   A,R6                               
                  JB    ACC.7,L_1AAF                       
                  JBC   CY,L_1AB3                          
                  AJMP  L_1BB2                             
L_1AAF:           JNC   L_1AB3                             
L_1AB1:           AJMP  L_1BA1                             
L_1AB3:           SUBB  A,#081h                            
                  MOV   R6,A                               
                  ACALL L_1B8B                             
                  MOV   R3,#04h                            
                  MOV   R4,X_0001                          
L_1ABC:           MOV   X_0001,R4                          
                  MOVX  A,@R1                              
                  MOV   R2,A                               
                  ACALL L_1C38                             
                  MOV   A,R2                               
                  SWAP  A                                  
                  ACALL L_1C38                             
                  DEC   R4                                 
                  DJNZ  R3,L_1ABC                          
                  MOV   L_0030,R6                          
                  MOV   L_002F,R5                          
                  AJMP  L_1B30                             
L_1ACF:           ACALL L_1C77                             
                  MOV   L_002F,R5                          
                  CJNE  R7,#00h,L_1ADC                     
                  ACALL L_1BA1                             
                  CLR   A                                  
                  SETB  ACC.3                              
                  RET                                      
L_1ADC:           MOV   A,R6                               
                  JZ    L_1A9F                             
                  SUBB  A,R7                               
                  JB    ACC.7,L_1AE7                       
                  JNC   L_1AE9                             
                  AJMP  L_1BB2                             
L_1AE7:           JNC   L_1AB1                             
L_1AE9:           ADD   A,#081h                            
                  MOV   L_0030,A                           
                  ACALL L_1C88                             
                  MOV   R2,#034h                           
                  MOV   R3,X_0000                          
                  MOV   L_002A,#00h                        
L_1AF6:           MOV   R5,#0ffh                           
                  SETB  C                                  
L_1AF9:           MOV   X_0000,R3                          
                  MOV   R1,#02eh                           
                  MOV   R7,#04h                            
                  JNC   L_1B18                             
L_1B01:           MOVX  A,@R0                              
                  MOV   R6,A                               
                  CLR   A                                  
                  ADDC  A,#099h                            
                  SUBB  A,R6                               
                  ADD   A,@R1                              
                  DA    A                                  
                  MOV   @R1,A                              
                  DEC   R0                                 
                  DEC   R1                                 
                  DJNZ  R7,L_1B01                          
                  INC   R5                                 
                  JC    L_1AF9                             
                  MOV   A,@R1                              
                  SUBB  A,#01h                             
                  MOV   @R1,A                              
                  CPL   C                                  
                  SJMP  L_1AF9                             
L_1B18:           ACALL L_1A19                             
                  MOV   @R1,#00h                           
                  MOV   X_0000,R2                          
                  MOV   @R0,X_0005                         
                  INC   R2                                 
                  MOV   R7,#01h                            
                  ACALL L_1C00                             
                  CJNE  R2,#03eh,L_1AF6                    
                  DJNZ  L_0030,L_1B2D                      
                  AJMP  L_1BB2                             
L_1B2D:           MOV   L_002A,#00h                        
L_1B30:           MOV   R0,#034h                           
                  MOV   A,@R0                              
                  MOV   R6,A                               
                  JZ    L_1B39                             
                  ACALL L_1B7F                             
                  DEC   R0                                 
L_1B39:           INC   R0                                 
                  MOV   A,#08h                             
                  MOV   R1,A                               
                  ADD   A,R0                               
                  MOV   R0,A                               
                  CJNE  @R0,#05h,L_1B42                    
L_1B42:           JC    L_1B57                             
L_1B44:           SETB  C                                  
                  CLR   A                                  
                  DEC   R0                                 
                  ADDC  A,@R0                              
                  DA    A                                  
                  XCHD  A,@R0                              
                  JNB   ACC.4,L_1B56                       
                  DJNZ  R1,L_1B44                          
                  DEC   R0                                 
                  MOV   @R0,#01h                           
                  ACALL L_1B7F                             
                  SJMP  L_1B5C                             
L_1B56:           DEC   R1                                 
L_1B57:           MOV   A,R1                               
                  CLR   C                                  
                  XCH   A,R0                               
                  SUBB  A,R0                               
                  MOV   R0,A                               
L_1B5C:           MOV   R1,#02bh                           
L_1B5E:           MOV   A,@R0                              
                  SWAP  A                                  
                  INC   R0                                 
                  XCHD  A,@R0                              
                  ORL   X_0006,A                           
                  MOV   @R1,A                              
                  INC   R0                                 
                  INC   R1                                 
                  CJNE  R1,#02fh,L_1B5E                    
                  MOV   A,R6                               
                  JNZ   L_1B70                             
                  MOV   L_0030,#00h                        
               ;***
               ;*** SUBROUTINE
               ;***
L_1B70:           ACALL L_1C6B                             
                  MOV   L_0009,R1                          
                  MOV   R0,#030h                           
L_1B76:           MOV   A,@R0                              
                  MOVX  @R1,A                              
                  DEC   R0                                 
                  DEC   R1                                 
                  CJNE  R0,#02ah,L_1B76                    
                  CLR   A                                  
L_1B7E:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1B7F:           INC   L_0030                             
                  MOV   A,L_0030                           
                  JNZ   L_1B7E                             
                  POP   L_00E0                             
                  POP   L_00E0                             
                  AJMP  L_1BA1                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1B8B:           PUSH  X_0001                             
                  MOV   R1,#032h                           
L_1B8F:           MOVX  A,@R0                              
                  ANL   A,#0fh                             
                  MOV   @R1,A                              
                  MOVX  A,@R0                              
                  SWAP  A                                  
                  ANL   A,#0fh                             
                  DEC   R1                                 
                  MOV   @R1,A                              
                  DEC   R0                                 
                  DEC   R1                                 
                  CJNE  R1,#02ah,L_1B8F                    
                  POP   X_0001                             
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1BA1:           MOV   R0,#02eh                           
                  MOV   A,#099h                            
L_1BA5:           MOV   @R0,A                              
                  DEC   R0                                 
                  CJNE  R0,#02ah,L_1BA5                    
                  MOV   L_0030,#0FFh                       
                  ACALL L_1B70                             
                  SETB  ACC.1                              
ret_15:           RET                                      
L_1BB2:           ACALL L_1BB8                             
                  CLR   A                                  
                  SETB  ACC.0                              
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1BB8:           ACALL L_1BBF                             
                  ACALL L_1B70                             
                  SETB  ACC.2                              
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1BBF:           CLR   A                                  
                  MOV   R0,#03dh                           
L_1BC2:           MOV   @R0,A                              
                  DEC   R0                                 
                  CJNE  R0,#029h,L_1BC2                    
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1BC8:           MOV   R4,#00h                            
                  CLR   C                                  
L_1BCB:           MOV   A,R7                               
                  JZ    ret_16                             
                  SUBB  A,#02h                             
                  JNC   L_1BF1                             
                  PUSH  X_0000                             
                  PUSH  X_0001                             
                  MOV   R1,#02eh                           
                  MOV   R0,#02dh                           
                  MOV   A,R4                               
                  XCHD  A,@R1                              
                  SWAP  A                                  
                  MOV   R4,A                               
L_1BDE:           MOV   A,@R1                              
                  XCHD  A,@R0                              
                  SWAP  A                                  
                  MOV   @R1,A                              
                  DEC   R0                                 
                  DEC   R1                                 
                  CJNE  R1,#02ah,L_1BDE                    
                  MOV   A,@R1                              
                  SWAP  A                                  
                  ANL   A,#0fh                             
                  MOV   @R1,A                              
                  POP   X_0001                             
                  POP   X_0000                             
ret_16:           RET                                      
L_1BF1:           MOV   R7,A                               
                  CLR   A                                  
                  XCH   A,L_002A                           
                  XCH   A,L_002B                           
                  XCH   A,L_002C                           
                  XCH   A,L_002D                           
                  XCH   A,L_002E                           
                  MOV   R4,A                               
                  SJMP  L_1BCB                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1C00:           MOV   R4,#00h                            
               ;***
               ;*** SUBROUTINE
               ;***
L_1C02:           CLR   C                                  
L_1C03:           MOV   A,R7                               
                  JZ    ret_17                             
                  SUBB  A,#02h                             
                  JNC   L_1C29                             
                  PUSH  X_0000                             
                  PUSH  X_0001                             
                  MOV   R0,#02ah                           
                  MOV   R1,#02bh                           
                  MOV   A,@R0                              
                  SWAP  A                                  
                  MOV   @R0,A                              
L_1C15:           MOV   A,@R1                              
                  SWAP  A                                  
                  XCHD  A,@R0                              
                  MOV   @R1,A                              
                  INC   R0                                 
                  INC   R1                                 
                  CJNE  R0,#02eh,L_1C15                    
                  MOV   A,R4                               
                  SWAP  A                                  
                  XCHD  A,@R0                              
                  ANL   A,#0f0h                            
                  MOV   R4,A                               
                  POP   X_0001                             
                  POP   X_0000                             
ret_17:           RET                                      
L_1C29:           MOV   R7,A                               
                  CLR   A                                  
                  XCH   A,R4                               
                  XCH   A,L_002E                           
                  XCH   A,L_002D                           
                  XCH   A,L_002C                           
                  XCH   A,L_002B                           
                  XCH   A,L_002A                           
                  SJMP  L_1C03                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1C38:           ANL   A,#0fh                             
                  MOV   R7,A                               
                  MOV   R0,#03ch                           
                  MOV   R1,#032h                           
                  CLR   A                                  
                  MOV   L_0033,A                           
L_1C42:           DEC   R0                                 
                  ADD   A,@R0                              
                  DA    A                                  
                  JNB   ACC.4,L_1C4B                       
                  DEC   R0                                 
                  INC   @R0                                
                  INC   R0                                 
L_1C4B:           XCHD  A,@R0                              
                  MOV   L_00F0,R7                          
                  MOV   A,@R1                              
                  MUL   AB                                 
                  MOV   L_00F0,#0Ah                        
                  DIV   AB                                 
                  XCH   A,L_00F0                           
                  ADD   A,@R0                              
                  DA    A                                  
                  JNB   ACC.4,L_1C5D                       
                  INC   L_00F0                             
L_1C5D:           INC   R0                                 
                  XCHD  A,@R0                              
                  DEC   R0                                 
                  MOV   A,L_00F0                           
                  DEC   R1                                 
                  CJNE  R1,#02ah,L_1C42                    
                  ADD   A,L_0033                           
                  DA    A                                  
                  MOV   @R0,A                              
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1C6B:           MOV   L_00A0,#01h                        
                  MOV   R0,L_0009                          
                  MOV   A,#06h                             
                  ADD   A,R0                               
                  MOV   R1,A                               
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1C75:           ACALL L_1BBF                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1C77:           ACALL L_1C6B                             
                  MOVX  A,@R0                              
                  MOV   R7,A                               
                  MOVX  A,@R1                              
                  MOV   R6,A                               
                  DEC   R0                                 
                  DEC   R1                                 
                  MOVX  A,@R0                              
                  MOV   R4,A                               
                  MOVX  A,@R1                              
                  MOV   R3,A                               
                  XRL   A,R4                               
                  MOV   R5,A                               
                  DEC   R0                                 
                  DEC   R1                                 
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1C88:           PUSH  X_0000                             
                  MOV   R0,#02eh                           
L_1C8C:           MOVX  A,@R1                              
                  MOV   @R0,A                              
                  DEC   R1                                 
                  DEC   R0                                 
                  CJNE  R0,#02ah,L_1C8C                    
                  POP   X_0000                             
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1C96:           ACALL L_1D6C                             
                  PUSH  L_0083                             
                  PUSH  L_0082                             
L_1C9C:           MOVX  A,@DPTR                            
                  ACALL L_1FED                             
                  JC    L_1CB3                             
                  ACALL L_1CB6                             
                  JC    L_1CB3                             
                  CLR   ACC.5                              
                  CJNE  A,#048h,L_1CAD                     
                  SETB  C                                  
                  SJMP  L_1CAE                             
L_1CAD:           CLR   C                                  
L_1CAE:           POP   L_0082                             
                  POP   L_0083                             
                  RET                                      
L_1CB3:           INC   DPTR                               
                  SJMP  L_1C9C                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1CB6:           CLR   ACC.5                              
                  CJNE  A,#047h,L_1CBB                     
L_1CBB:           JC    L_1CBE                             
                  RET                                      
L_1CBE:           CJNE  A,#041h,L_1CC1                     
L_1CC1:           CPL   C                                  
ret_18:           RET                                      
L_1CC3:           MOV   R3,#00h                            
                  MOV   R1,#058h                           
                  ACALL L_1F04                             
                  MOV   A,#0dh                             
                  MOVX  @R1,A                              
                  MOV   DPTR,#058h                         
L_1CCF:           ACALL L_1BBF                             
                  ACALL L_1D6C                             
                  ACALL L_1D72                             
                  MOV   L_0078,C                           
                  MOV   R0,#034h                           
                  MOV   R6,#07fh                           
                  SETB  F0                                 
L_1CDD:           ACALL L_1FEB                             
                  JNC   L_1CE8                             
                  ANL   A,#0fh                             
                  ACALL L_1D45                             
L_1CE5:           INC   DPTR                               
                  SJMP  L_1CDD                             
L_1CE8:           CJNE  A,#02eh,L_1CF7                     
                  JB    L_0051,L_1D51                      
                  SETB  L_0051                             
                  CJNE  R0,#034h,L_1CE5                    
                  SETB  L_0052                             
                  SJMP  L_1CE5                             
L_1CF7:           JB    F0,L_1D51                          
                  CJNE  A,#065h,L_1CFF                     
                  SJMP  L_1D02                             
L_1CFF:           CJNE  A,#045h,L_1D35                     
L_1D02:           ACALL L_1D6B                             
                  ACALL L_1D72                             
                  MOV   L_0050,C                           
                  ACALL L_1FEB                             
                  JNC   L_1D51                             
                  ANL   A,#0fh                             
                  MOV   R5,A                               
L_1D0F:           INC   DPTR                               
                  ACALL L_1FEB                             
                  JNC   L_1D21                             
                  ANL   A,#0fh                             
                  XCH   A,R5                               
                  MOV   L_00F0,#0Ah                        
                  MUL   AB                                 
                  ADD   A,R5                               
                  MOV   R5,A                               
                  JNC   L_1D0F                             
                  MOV   R5,#0ffh                           
L_1D21:           MOV   A,R5                               
                  JNB   L_0050,L_1D2E                      
                  CLR   C                                  
                  SUBB  A,R6                               
                  CPL   A                                  
                  INC   A                                  
                  JC    L_1D34                             
                  MOV   A,#01h                             
                  RET                                      
L_1D2E:           ADD   A,R6                               
                  JNC   L_1D34                             
                  MOV   A,#02h                             
                  RET                                      
L_1D34:           XCH   A,R6                               
L_1D35:           MOV   L_0030,R6                          
                  CJNE  R0,#034h,L_1D3C                    
                  ACALL L_1BBF                             
L_1D3C:           MOV   A,L_0009                           
                  CLR   C                                  
                  SUBB  A,#0ch                             
                  MOV   L_0009,A                           
                  AJMP  L_1B30                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1D45:           CLR   F0                                 
                  JNZ   L_1D54                             
                  CJNE  R0,#034h,L_1D54                    
                  JNB   L_0052,ret_19                      
L_1D4F:           DJNZ  R6,ret_19                          
L_1D51:           MOV   A,#0ffh                            
ret_19:           RET                                      
L_1D54:           JB    L_0053,L_1D59                      
                  CLR   L_0052                             
L_1D59:           JB    L_0052,L_1D4F                      
                  JB    L_0051,L_1D60                      
                  INC   R6                                 
L_1D60:           JB    L_0053,ret_19                      
                  CJNE  R0,#03dh,L_1D68                    
                  SETB  L_0053                             
L_1D68:           MOV   @R0,A                              
                  INC   R0                                 
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1D6B:           INC   DPTR                               
               ;***
               ;*** SUBROUTINE
               ;***
L_1D6C:           MOVX  A,@DPTR                            
                  CJNE  A,#020h,ret_20                     
                  SJMP  L_1D6B                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1D72:           CJNE  A,#0e3h,L_1D77                     
                  SJMP  L_1D85                             
L_1D77:           CJNE  A,#02bh,L_1D7C                     
                  SJMP  L_1D85                             
L_1D7C:           CJNE  A,#0e5h,L_1D81                     
                  SJMP  L_1D84                             
L_1D81:           CJNE  A,#02dh,ret_20                     
L_1D84:           SETB  C                                  
L_1D85:           INC   DPTR                               
ret_20:           RET                                      
L_1D87:           ACALL L_1C77                             
                  ACALL L_19C9                             
                  MOV   A,R7                               
                  MOV   R6,A                               
                  ACALL L_1B8B                             
                  MOV   R0,#02bh                           
                  MOV   A,L_0017                           
                  MOV   R3,A                               
                  JZ    L_1DDF                             
                  CJNE  A,#0f0h,L_1D99                     
L_1D99:           JNC   L_1E0E                             
                  MOV   A,R6                               
                  JNZ   L_1DA0                             
                  MOV   R6,#080h                           
L_1DA0:           MOV   A,R3                               
                  SWAP  A                                  
                  ANL   A,#0fh                             
                  MOV   R2,A                               
                  ACALL L_1E74                             
                  XCH   A,R2                               
                  CLR   C                                  
                  SUBB  A,R2                               
                  MOV   R7,A                               
                  JNC   L_1DB3                             
                  MOV   R5,#03fh                           
                  ACALL L_1EA9                             
                  AJMP  L_1DDF                             
L_1DB3:           CJNE  R2,#00h,L_1DBD                     
                  DEC   R7                                 
                  ACALL L_1E96                             
                  ACALL L_1EA3                             
                  SJMP  L_1DC3                             
L_1DBD:           ACALL L_1E96                             
                  MOV   A,R2                               
                  MOV   R7,A                               
                  ACALL L_1E58                             
L_1DC3:           MOV   A,R3                               
                  ANL   A,#0fh                             
                  MOV   R2,A                               
                  JZ    ret_20                             
                  ACALL L_1E9F                             
                  ACALL L_1E7D                             
                  CJNE  A,X_0002,L_1DD3                    
L_1DD0:           MOV   A,R2                               
                  AJMP  L_1E8D                             
L_1DD3:           JNC   L_1DD0                             
                  XCH   A,R2                               
                  CLR   C                                  
                  SUBB  A,R2                               
                  XCH   A,R2                               
                  ACALL L_1E8D                             
                  MOV   A,R2                               
                  MOV   R7,A                               
                  AJMP  L_1E58                             
L_1DDF:           MOV   A,R6                               
                  JNZ   L_1DE6                             
                  ACALL L_1EA7                             
                  AJMP  L_1EA3                             
L_1DE6:           MOV   R3,#0f0h                           
                  MOV   A,#077h                            
                  ADD   A,R6                               
                  JC    L_1E0E                             
                  SUBB  A,#0f7h                            
                  JC    L_1E0E                             
                  ACALL L_1E98                             
                  ACALL L_1E74                             
                  CJNE  A,#08h,L_1DFA                      
                  AJMP  L_1E58                             
L_1DFA:           ACALL L_1E58                             
                  ACALL L_1E6A                             
                  JZ    ret_21                             
                  ACALL L_1E9F                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1E02:           MOV   R7,#01h                            
                  ACALL L_1E58                             
                  JNZ   ret_21                             
                  ACALL L_1E6A                             
                  JZ    ret_21                             
                  SJMP  L_1E02                             
L_1E0E:           ACALL L_1E98                             
                  MOV   R7,#01h                            
                  ACALL L_1E58                             
                  ACALL L_1E9F                             
                  MOV   A,R3                               
                  ANL   A,#0fh                             
                  JZ    L_1E21                             
                  MOV   R7,A                               
                  DEC   R7                                 
                  ACALL L_1E58                             
                  SJMP  L_1E23                             
L_1E21:           ACALL L_1E02                             
L_1E23:           ACALL L_1EA7                             
                  MOV   R5,#045h                           
                  ACALL L_1EA9                             
                  MOV   A,R6                               
                  JZ    L_1E30                             
                  DEC   A                                  
                  CJNE  A,#080h,L_1E35                     
L_1E30:           ACALL L_1EA7                             
                  CLR   A                                  
                  SJMP  L_1E41                             
L_1E35:           JC    L_1E3D                             
                  MOV   R5,#02bh                           
                  ACALL L_1EA9                             
                  SJMP  L_1E41                             
L_1E3D:           ACALL L_1E9B                             
                  CPL   A                                  
                  INC   A                                  
L_1E41:           CLR   ACC.7                              
                  MOV   R0,A                               
                  MOV   R2,#00h                            
                  MOV   R1,#058h                           
                  MOV   R3,#00h                            
                  ACALL L_1F04                             
                  MOV   R0,#058h                           
L_1E4E:           MOVX  A,@R0                              
                  MOV   R5,A                               
                  ACALL L_1EA9                             
                  INC   R0                                 
                  MOV   A,R0                               
                  CJNE  A,X_0001,L_1E4E                    
ret_21:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1E58:           MOV   A,R7                               
                  JZ    ret_22                             
                  MOV   A,@R0                              
                  ORL   A,#030h                            
                  INC   R0                                 
                  DEC   R7                                 
                  MOV   R5,A                               
                  ACALL L_1EA9                             
                  CLR   A                                  
                  CJNE  R0,#033h,L_1E58                    
                  MOV   A,#055h                            
ret_22:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1E6A:           MOV   R1,X_0000                          
L_1E6C:           MOV   A,@R1                              
                  JNZ   ret_23                             
                  INC   R1                                 
                  CJNE  R1,#033h,L_1E6C                    
ret_23:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1E74:           MOV   A,R6                               
                  CLR   C                                  
                  SUBB  A,#080h                            
                  JNC   L_1E7B                             
                  CLR   A                                  
L_1E7B:           MOV   R7,A                               
                  RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1E7D:           CLR   C                                  
                  MOV   A,#080h                            
                  SUBB  A,R6                               
                  JNC   ret_24                             
                  CLR   A                                  
ret_24:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1E85:           MOV   A,R7                               
                  JZ    ret_24                             
                  ACALL L_1EA7                             
                  DEC   R7                                 
                  SJMP  L_1E85                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1E8D:           MOV   R7,A                               
L_1E8E:           MOV   A,R7                               
                  JZ    ret_24                             
                  ACALL L_1EA3                             
                  DEC   R7                                 
                  SJMP  L_1E8E                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1E96:           ACALL L_1E85                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1E98:           MOV   A,R4                               
                  JZ    L_1EA7                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1E9B:           MOV   R5,#02dh                           
                  SJMP  L_1EA9                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1E9F:           MOV   R5,#02eh                           
                  SJMP  L_1EA9                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1EA3:           MOV   R5,#030h                           
                  SJMP  L_1EA9                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1EA7:           MOV   R5,#020h                           
               ;***
               ;*** SUBROUTINE
               ;***
L_1EA9:           AJMP  L_1990                             
L_1EAB:           ACALL L_1C96                             
                  MOV   L_0023,C                           
                  ACALL L_1FEB                             
                  CPL   C                                  
                  JC    L_1EDC                             
                  MOV   R3,#00h                            
                  MOV   R1,#00h                            
                  SJMP  L_1ECF                             
L_1EBA:           INC   DPTR                               
                  MOV   X_0000,R1                          
                  MOV   X_0002,R3                          
                  ACALL L_1FEB                             
                  JC    L_1ECF                             
                  JNB   reserved,L_1EDC                    
                  ACALL L_1CB6                             
                  JC    L_1ECD                             
                  INC   DPTR                               
                  SJMP  L_1EDC                             
L_1ECD:           ADD   A,#09h                             
L_1ECF:           MOV   L_00F0,#0Ah                        

; phase error, pc = 1ED2 label = ‹F‰†hÿ>þ new pc = 1ED4

                  JNB   reserved,L_1ED8                    
L_1ED4:           RR    A                                  
L_1ED5:           MOV   L_00F0,#010h                       
L_1ED8:           ACALL L_1EE3                             
                  JNC   L_1EBA                             
L_1EDC:           CLR   A                                  
                  MOV   L_00E1,C                           
                  RET                                      
L_1EE0:           MOV   L_00F0,#0Ah                        
               ;***
               ;*** SUBROUTINE
               ;***
L_1EE3:           PUSH  L_00E0                             
                  PUSH  L_00F0                             
                  MOV   A,R1                               
                  MUL   AB                                 
                  MOV   R1,A                               
                  MOV   A,R3                               
                  MOV   R3,L_00F0                          
                  POP   L_00F0                             
                  MUL   AB                                 
                  MOV   C,OV                               
                  MOV   L_00D5,C                           
                  ADD   A,R3                               
                  MOV   R3,A                               
                  POP   L_00E0                             
                  ORL   C,F0                               
                  JC    ret_25                             
                  ANL   A,#0fh                             
                  ADD   A,R1                               
                  MOV   R1,A                               
                  CLR   A                                  
                  ADDC  A,R3                               
                  MOV   R3,A                               
ret_25:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1F04:           CLR   A                                  
                  MOV   DPTR,#02710h                       
                  ACALL L_1F21                             
                  MOV   DPTR,#03e8h                        
                  ACALL L_1F21                             
                  MOV   DPTR,#064h                         
                  ACALL L_1F21                             
                  MOV   DPTR,#0ah                          
                  ACALL L_1F21                             
                  MOV   DPTR,#01h                          
                  ACALL L_1F21                             
                  JZ    L_1F40                             
L_1F20:           RET                                      
               ;***
               ;*** SUBROUTINE
               ;***
L_1F21:           MOV   R6,#0ffh                           
L_1F23:           INC   R6                                 
                  XCH   A,R2                               
                  CJNE  A,L_0083,L_1F28                    
L_1F28:           XCH   A,R2                               
                  JC    L_1F3D                             
                  XCH   A,R0                               
                  SUBB  A,L_0082                           
                  XCH   A,R0                               
                  XCH   A,R2                               
                  SUBB  A,L_0083                           
                  XCH   A,R2                               
                  JNC   L_1F23                             
                  XCH   A,R0                               
                  ADD   A,L_0082                           
                  XCH   A,R0                               
                  XCH   A,R2                               
                  ADDC  A,L_0083                           
                  XCH   A,R2                               
L_1F3D:           ORL   A,R6                               
                  JZ    L_1F20                             
L_1F40:           MOV   A,#030h                            
                  ADD   A,R6                               
                  MOV   L_00A0,R3                          
                  MOVX  @R1,A                              
                  INC   R1                                 
                  CJNE  R1,#00h,ret_26                     
                  INC   R3                                 
ret_26:           RET                                      
L_1F4C:           ACALL L_1EA7                             
                  MOV   C,hex_no_zero                      
                  MOV   L_0023,C                           
                  MOV   A,R3                               
                  ACALL L_1F6F                             
                  MOV   A,R3                               
                  ACALL L_1F70                             
                  CLR   reserved                           
                  MOV   A,R1                               
                  ACALL L_1F6F                             
                  MOV   A,R1                               
                  ACALL L_1F70                             
                  MOV   R5,#048h                           
L_1F62:           AJMP  L_1EA9                             
L_1F64:           CLR   reserved                           
                  ADD   A,#090h                            
                  DA    A                                  
                  ADDC  A,#040h                            
                  DA    A                                  
                  MOV   R5,A                               
                  SJMP  L_1F62                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1F6F:           SWAP  A                                  
               ;***
               ;*** SUBROUTINE
               ;***
L_1F70:           ANL   A,#0fh                             
                  JNZ   L_1F64                             
                  JNB   reserved,L_1F64                    
                  RET                                      
L_1F78:           JB    trap_timer1,L_1F7E                 
                  LJMP  XTRN_tim1_int                      
L_1F7E:           LJMP  L_2088                             
NO_DATA_msg:      DFB   "NO DATA""                         
                  DFB   94h                                
ARITH_OVFL_msg:   DFB   "ARITH. OVERFLOW                   
                  DFB   ""                                 
PROGRAMMING_msg:  DFB   "PROGRAMMING"CAN'T CONTINUE        
                  DFB   ""                                 
INVAL_LNR_msg:    DFB   "INVALID LINE NUMBER"              
PROM_MODE_msg:    DFB   "PROM MODE"                        
SIGN_ON_msg:      DFB   "*MCS-51(tm) BASIC V1.1            
                  DFB   "*                                 
                  DFB   """                                
               ;***
               ;*** SUBROUTINE
               ;***
L_1FEB:           ACALL L_1D6C                             
               ;***
               ;*** SUBROUTINE
               ;***
L_1FED:           CJNE  A,#03ah,L_1FF0                     
L_1FF0:           JC    L_1FF3                             
                  RET                                      
L_1FF3:           CJNE  A,#030h,L_1FF6                     
L_1FF6:           CPL   C                                  
                  RET                                      
                  ORL   A,L_0052                           
                  ANL   L_004F,A                           
                  ANL   L_003A,A                           
                  JB    input_exe,reset_opt_activ          
 0000                           END

