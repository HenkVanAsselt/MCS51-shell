######################################################
# Makefile for 51SHELL with MSC                      #
######################################################

#CC   = cl /DMSC /AL /c /Zi /Zd /W3 /Fs
CC   = cl
#LIB = tlib
ASM  = masm /ML /W2 /Zi /Zd /L $*.asm,,,;

### Set inference rules
#########################

.c.obj:
    $(CC) $*.c

.asm.obj:
    $(ASM) $*

### Set dependencies
######################

51basic.obj:  51basic.c

51_filio.obj: 51_filio.c

51_serio.obj: 51_serio.c

51_menu.obj:  51_menu.c

51_util.obj:  51_util.c

51_bas.obj:   51_bas.c

51shell.ndx: 51shell.hlp
  genindex 51shell.hlp

51basic.exe: 51basic.obj 51_menu.obj 51_filio.obj 51_serio.obj 51_util.obj\
 51_bas.obj\
 \lib\window.lib \lib\serial9.lib \lib\hva_util.lib
 link @51basic.lnk

51shell.ndx: 51shell.hlp
  genindex 51shell.hlp
