######################################################
# Makefile for 51SHELL with MSC                      #
######################################################

### Set inference rules
#########################

.c.obj:
### TURBO C
#    tcc -DTURBOC -K -M -f -r -C -I\tc\include -L\tc\lib -c -k -ml -u -w $*.c
### MSC 5.1
    cl $*.c

.asm.obj:
    masm /ML /W2 /Zi /Zd /L $*.asm,,,;

### Set dependencies
######################

51shell.obj: $*.c $*.h

51_filio.obj: $*.c

51_serio.obj: $*.c

51_menu.obj: $*.c

51_util.obj: $*.c

51_bas.obj: $*.c

51_pas.obj: $*.c

51_asm.obj: $*.c

51shell.exe: 51shell.obj 51_menu.obj 51_filio.obj 51_serio.obj 51_util.obj\
 51_bas.obj 51_pas.obj 51_asm.obj\
 \lib\window.lib \lib\serial9.lib
 link @51shell.lnk

51shell.ndx: 51shell.hlp
  genindex 51shell.hlp
