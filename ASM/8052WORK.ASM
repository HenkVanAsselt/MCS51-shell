PASS 1  start=0  end=0

;MCS51 Disassembler, 911230 V0.1 (C) HvA
  CPU "8051.tbl"
  HOF "INT16"

;****************************************
;  BIT ADDRESSES
;****************************************
ONTIME_executed  EQU  00010H
;1 = 'ONTIME' statement is executed
BASIC_int_in_prog  EQU  00011H
;1 = basic interrupt in progress
ONEX1_exe        EQU  00012H
;1 = 'ONEX1' statement is executed
ONERR_exe        EQU  00013H
;1 = 'ONERR' statement is executed
ONTIME_exe       EQU  00014H
;1 = 'ONTIME' interrupt in progress
line_edit        EQU  00015H
;1 = line is edited
ext_int_pending  EQU  00016H
;1 = external interrupt pending
enable_cont      EQU  00017H
;1 = 'CONT' command will work
get_flag         EQU  00018H
;1 = flag for 'GET' operator
print_list_exe   EQU  00019H
;1 = 'PRINT@' or 'LIST@' evoked
trap_timer1      EQU  0001AH
;Trap 'TIMER1' interrrupt
LP_CON_out_ctrl  EQU  0001BH
;1 = LP CON output control
user_CON_out_ctrl  EQU  0001CH
;1 = user def CON output control
array_init       EQU  0001DH
;Basic array initialization bit
user_CON_in_ctrl  EQU  0001EH
;1 = user def CON input control
trap_serial_port  EQU  0001FH
;Trap serial port interrupt
STOP_CTRLC_found  EQU  00020H
;STOP or CTRL encountered
user_idle_break  EQU  00021H
;User idle break bit
input_exe        EQU  00022H
;1 = input instruction in progress
reserved         EQU  00023H
;Reserved
arg_stack_value  EQU  00024H
;1 = argument stack has a value
RETI_exe         EQU  00025H
;RETI instruction executed
trap_ext0        EQU  00026H
;Trap external interrupt 0
valid_@_driver   EQU  00027H
;1 = valid '...@' driver by user
soft_trap_test   EQU  00028H
;Software trap test
find_eop         EQU  00029H
;1 = Find the end of program
DIM_statement    EQU  0002AH
;1 = DIM statement
int_stat_save    EQU  0002BH
;Interrupt status save bit
input_trap       EQU  0002CH
;Input trap
exp_present      EQU  0002DH
;1 = expansion present
CLOCK1_exe       EQU  0002EH
;1 = 'CLOCK1' executed, else cleared　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　  000B0H

P3.1             EQU  000B1H

P3.2             EQU  000B2H

P3.3             EQU  000B3H

P3.4             EQU  000B4H

P3.5             EQU  000B5H

P3.6             EQU  000B6H

P3.7             EQU  000B7H

PT2              EQU  000BDH

PS               EQU  000BCH

PT1              EQU  000BBH

PX1              EQU  000BAH

PT0              EQU  000B9H

PX0              EQU  000B8H

TF2              EQU  000CFH

EXF2             EQU  000CEH

RCLK             EQU  000CDH

TCLK             EQU  000CCH

EXEN2            EQU  000CBH

TR2              EQU  000CAH

C/!T2            EQU  000C9H

CP/!R            EQU  000C8H

CY               EQU  000D7H

AC               EQU  000D6H

F0               EQU  000D5H

RS1              EQU  000D4H

RS0              EQU  000D3H

OV               EQU  000D2H

P                EQU  000D0H

ACC.0            EQU  000E0H

ACC.1            EQU  000E1H

ACC.2            EQU  000E2H

ACC.3            EQU  000E3H

ACC.4            EQU  000E4H

ACC.5            EQU  000E5H

ACC.6            EQU  000E6H

ACC.7            EQU  000E7H

B.0              EQU  000F0H

B.1              EQU  000F1H

B.2              EQU  000F2H

B.3              EQU  000F3H

B.4              EQU  000F4H

B.5              EQU  000F5H

B.6              EQU  000F6H

B.7              EQU  000F7H

;****************************************
;  EXTERNAL DATA DEFINITIONS
;****************************************
;****************************************
;  INTERNAL DATA DEFINITIONS
;****************************************
;Source: 8052WORK.HEX.HEX
;Output: 8052WORK.HEX.DIS - Created on 92-02-31 23:10:30


               ;***
               ;*** RESET address
               ;***
                  NOP                                      ;
 0000                           END

