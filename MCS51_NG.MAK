############################################################
#
#  Make Utility File for NG guide for HvA MCS51 shell
#
#  Creates: MCS51.NG
#
#  Date: 920627 V0.1
#
############################################################

#################
# inference rules
#################

.c.ng1:
    awk make_ng.awk $*.c > $*.ng1

######################
# create '.ng1' files
######################

51shell.ng1:    51shell.c

51_asm.ng1:     51_asm.c

51_bas.ng1:     51_bas.c

51_dis.ng1:     51_dis.c

51_filio.ng1:   51_filio.c

51_menu.ng1:    51_menu.c

51_pas.ng1:     51_pas.c

51_serio.ng1:   51_serio.c

51_util.ng1:    51_util.c

decode48.ng1:   decode48.c

decode51.ng1:   decode51.c

disutil.ng1:    disutil.c

zapload.ng1:    zapload.c

#######################################
# Create 'ng2' file out of 'ng1' files
#######################################


mcs51.ng2:    51shell.ng1 51_asm.ng1 51_bas.ng1 51_dis.ng1 51_filio.ng1 \
              51_menu.ng1 51_pas.ng1 51_serio.ng1 51_util.ng1 decode48.ng1 \
              decode51.ng1 disutil.ng1 zapload.ng1
              type *.ng1 > mcs51.ng2
              del *.ng1

###############################
# Invoke Norton Guides compiler
###############################

ascii.ngo:     \ng\ascii.ngt
  NGC $*.ngt

color.ngo:     \ng\color.ngt
  NGC $*.ngt

kbdcodes.ngo:  \ng\kbcodes.ngt
  NGC $*.ngt

linebox.ngo:   \ng\linebox.ngt
  NGC $*.ngt

specchar.ngo:  \ng\specchar.ngt
  NGC $*.ngt

mcs51.NGO:     mcs51.ngt
  NGC $*.ng2

#############################
# Invoke Norton Guides linker
#############################

mcs51_ng.NG:  mcs51_ng.LNK mcs51.NGO
              NGML mcs51_ng.LNK
