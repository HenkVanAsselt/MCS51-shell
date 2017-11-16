######################################################
# Makefile for 51SHELL with MSC                      #
######################################################

CC =  cl /AL /L /W3 /c /Zi
LIB = lib window.lib -+$*.obj ,window.pub
ASM = masm /DMSC /ML /W2 /Zi /Zd /L $*.asm,,,;
ARJ = arj u mcs51.arj

### Set inference rules
#########################

.c.obj:
    $(CC) $*.c
    $(ARJ) $*.c

.asm.obj:
    $(ASM) $*
    $(ARJ) $*

### Set dependencies
######################

51shell.obj:  51shell.c 51shell.h

51_filio.obj: $*.c

51_serio.obj: $*.c

51_menu.obj: $*.c

51_util.obj: $*.c

51_bas.obj: $*.c

51_pas.obj: $*.c

51_asm.obj: $*.c

51_dis.obj: $*.c

disutil.obj: $*.c

decode48.obj: $*.c

decode51.obj: $*.c

51_dis.obj: $*.c 51_dis.h

disutil.obj: $*.c 51_dis.h

decode48.obj: $*.c

decode51.obj: $*.c

############################
# MCS51 Disassembler linkage
############################
#51_dis.exe: 51_dis.obj decode48.obj decode51.obj disutil.obj
#  link @51_dis.lnk

##############################
# MCS51 shell help generation
##############################
51shell.ndx: 51shell.hlp
  genindex 51shell.hlp
  $(ARJ) $*.hlp
  $(ARJ) $*.ndx

############################
# MCS51 shell linkage
############################
51shell.exe: 51shell.obj 51_menu.obj 51_filio.obj 51_serio.obj 51_util.obj\
 51_bas.obj\
 51_pas.obj\
 51_asm.obj\
 51_dis.obj\
 \lib\window.lib \lib\serial9.lib \lib\hva_util.lib
 link @51shell.lnk
