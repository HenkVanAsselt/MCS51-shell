#
#   makefile for DBVGALvv.zip   VGA/VESA library        by David Boynton
#                                                       25 Jan 92
#
#change the following line(s) for a different c compiler/librarian/assembler

CC = tcc -A
#TurboC++ v1.01 /ANSI keywords only

LIB = tlib
ASM = tasm /ml

vidlib.zip : readme vidlib.doc vesa.doc videof.lib videof.map\
             vidlib.h vesa.h src_c.zip src_asm.zip demos.zip makefile
  del vidlib.zip
  pkzip -a vidlib.zip readme vidlib.doc vesa.doc videof.lib vidlib.h vesa.h\
                      videof.map src_c.zip src_asm.zip demos.zip makefile

# vidlib.zip sub-zips

src_c.zip: vidlib.c vidlib4.c vidlib8.c vtext.c vesa.c vesa8.c
  del src_c.zip
  pkzip -a src_c.zip vidlib.c vidlib4.c vidlib8.c vtext.c vesa.c vesa8.c

src_asm.zip: wdacs.asm memcpyb.asm ldacs.asm palette.asm vgc.asm vsq.asm \
             vputs.asm vmo.asm vac.asm vcrtc.asm ega12set.asm l33set.asm \
	     l40set.asm normal.asm retrace.asm rdacs.asm sdacs.asm
  del src_asm.zip
  pkzip -a src_asm.zip wdacs.asm memcpyb.asm ldacs.asm palette.asm vgc.asm \
		       retrace.asm rdacs.asm sdacs.asm
  pkzip -a src_asm.zip vsq.asm vputs.asm vmo.asm vac.asm vcrtc.asm \
                       ega12set.asm l33set.asm l40set.asm normal.asm

demos.zip: testvl.exe vesainfo.exe vgaregs.exe test.exe l33.exe l40.com l28.com
  del demos.zip
  pkzip -a demos.zip testvl.exe testvl.c vesainfo.exe vesainfo.c vgaregs.c \
                      vgaregs.exe test.c test.exe 
  pkzip -a demos.zip l28.asm l28.com l33.asm l33.exe l40.asm l40.com

# demo/test programs

testvl.exe:   vidlib.h testvl.c videof.lib 
    $(CC) -ml testvl.c videof.lib

test.exe:     vidlib.h test.c videof.lib
    $(CC) -ml test.c videof.lib

vesainfo.exe: vidlib.h vesa.h vesainfo.c videof.lib 
    $(CC) -ml vesainfo.c videof.lib

vgaregs.exe:  vidlib.h vgaregs.c videof.lib
    $(CC) -ml vgaregs.c videof.lib

l33.exe: l33.asm
    $(ASM) l33
    tlink l33 videof.lib

l40.com: l40.asm
   $(ASM) l40
   tlink l40 
   exe2bin l40,l40.com
   del l40.exe

l28.com: l28.asm
   $(ASM) l28
   tlink l28 
   exe2bin l28,l28.com
   del l28.exe

# library

videof.lib: vputs.obj wdacs.obj memcpyb.obj ldacs.obj palette.obj vgc.obj \
  vsq.obj rdacs.obj sdacs.obj normal.obj vidlib.obj vidlib4.obj vidlib8.obj \
  vesa.obj vesa8.obj vtext.obj vcrtc.obj ega12set.obj l33set.obj l40set.obj \
  vac.obj vmo.obj retrace.obj videof.map

# library compiles

.c.obj:
    $(CC) -c -ml   $*
    $(LIB) videof.lib/c +-$*

.asm.obj:
    $(ASM) $*
    $(LIB) videof.lib/c +-$*

# low level components of videof.lib
rdacs.obj: rdacs.asm
sdacs.obj: sdacs.asm
normal.obj: normal.asm
vputs.obj: vputs.asm
wdacs.obj: wdacs.asm
memcpyb.obj: memcpyb.asm
ldacs.obj: ldacs.asm
palette.obj: palette.asm
vgc.obj:  vgc.asm
vsq.obj:  vsq.asm
vmo.obj: vmo.asm
vac.obj: vac.asm
vcrtc.obj: vcrtc.asm
retrace.obj: retrace.asm
ega12set.obj: ega12set.asm
l33set.obj: l33set.asm
l40set.obj: l40set.asm

videof.map:     
        $(LIB) videof.lib/c ,videof.map

# Higher level components of videof.lib

vidlib.obj: vidlib.h vidlib.c
vidlib4.obj: vidlib.h vidlib4.c 
vidlib8.obj: vidlib.h vidlib8.c 
vesa.obj:    vidlib.h vesa.h vesa.c 
vesa8.obj:   vidlib.h vesa.h vesa8.c 
vtext.obj:   vidlib.h vtext.c 

