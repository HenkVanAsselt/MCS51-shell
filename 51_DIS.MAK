######################################################
# Makefile for 51_DIS  with MSC                      #
######################################################

### Set inference rules
#########################

.c.obj:
  cl $*.c

.asm.obj:
  masm /ML /W2 /Zi /Zd /L $*.asm,,,;

### Set dependencies
######################

51_dis.obj: $*.c 51_dis.h

disutil.obj: $*.c 51_dis.h

decode48.obj: $*.c

decode51.obj: $*.c

51_dis.exe: 51_dis.obj decode48.obj decode51.obj disutil.obj
  link @51_dis.lnk

51shell.ndx: 51shell.hlp
  genindex 51shell.hlp
