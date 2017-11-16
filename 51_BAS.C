/**********************************************************************
*                                                                     *
*        FILE:  51_BAS.C                                              *
*                                                                     *
*     PURPOSE:  BASIC functions                                       *
*                                                                     *
* DESCRIPTION:  THIS FILE CONTAINS FUNCTIONS FOR THE 51-SHELL         *
*               FOR THE 8052AH BASIC ENVIROMENT                       *
*                                                                     *
*     HISTORY:  911211 V0.1                                           *
*                                                                     *
**********************************************************************/

/*---------------------------------------------------------------------------
                        HEADER FILES
---------------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include <window.h>
#include <time.h>
#include <dos.h>
#include <front9.h>
#include <hva_util.h>
#include "51shell.h"
#include "51_bas.h"

/*---------------------------------------------------------------------------
                        LOCAL VARIABLES
---------------------------------------------------------------------------*/
static char *progmode_str[] =
{
  "Normal",
  "INTELligent",
};

#define BIT_0 0x01
#define BIT_1 0x02
#define BIT_2 0x04
#define BIT_3 0x08
#define BIT_4 0x10
#define BIT_5 0x20
#define BIT_6 0x40
#define BIT_7 0x80

/*---------------------------------------------------------------------------
                        PROTOTYPES
---------------------------------------------------------------------------*/
static void change_progmode(void);
static void do_prog_eprom(void);
static void do_reset_opt(void);

/*===========================================================================
                        START OF FUNCTIONS
===========================================================================*/

/*#+func--------------------------------------------------------------
    FUNCTION: change_progmode()
     PURPOSE: Select EPROM program mode
 DESCRIPTION: The 2 available modes are NORMAL and INTELligent
     RETURNS: nothing
     HISTORY: 911218 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void change_progmode()
{
  #define NO_ITEMS 2

  MENU menu[NO_ITEMS];
  int choise = ESC;

  setup_menu(menu,0,"Normal     ", 0, NULL, "", NULL, NULL, EXIT);
  setup_menu(menu,1,"INTELligent", 0, NULL, "", NULL, NULL, EXIT);

  choise = popup(NO_ITEMS,menu,5,40);

  switch(choise)
  {
    case 'N':
      eprom_progmode = PROG_NORMAL;
      break;

    case 'I':
      eprom_progmode = PROG_INTELLIGENT;
      break;

    default:
      break;
  }

  #undef NO_ITEMS
}

/*#+func--------------------------------------------------------------
    FUNCTION: do_prog_eprom()
     PURPOSE: Program EPROM with current program
 DESCRIPTION: -
     RETURNS: nothing
     HISTORY: 911218 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void do_prog_eprom()
{
  switch (eprom_progmode)
  {
    case PROG_NORMAL:
      send_command("PROG",NO_WAIT,DISP);
      break;

    case PROG_INTELLIGENT:
      send_command("FPROG",NO_WAIT,DISP);
      break;

    default:
      wn_error("Unknown program algoritme %d",eprom_progmode);
      break;
  }
}

/*#+func--------------------------------------------------------------
    FUNCTION: do_reset_opt()
     PURPOSE: Program EPROM with choosen reset option
 DESCRIPTION: Popup a menu with reset options and program EPROM
     RETURNS: nothing
     HISTORY: 911218 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void do_reset_opt()
{
  #define NO_ITEMS 6

  MENU menu[NO_ITEMS];
  char command[40];
  int choise;

  setup_menu(menu,0," PROG1 ", 5, NULL, ":PROGx", NULL, NULL, EXIT);
  setup_menu(menu,1," PROG2 ", 5, NULL, ":PROGx", NULL, NULL, EXIT);
  setup_menu(menu,2," PROG3 ", 5, NULL, ":PROGx", NULL, NULL, EXIT);
  setup_menu(menu,3," PROG4 ", 5, NULL, ":PROGx", NULL, NULL, EXIT);
  setup_menu(menu,4," PROG5 ", 5, NULL, ":PROGx", NULL, NULL, EXIT);
  setup_menu(menu,5," PROG6 ", 5, NULL, ":PROGx", NULL, NULL, EXIT);

  choise = popup(6,menu,5,40);

  command[0] = '\0';

  switch(choise)
  {
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
      switch(eprom_progmode)
      {
        case PROG_NORMAL:
          sprintf(command,"PROG%c",choise);
          break;
        case PROG_INTELLIGENT:
          sprintf(command,"FPROG%c",choise);
          break;
        default:
          wn_error("Unknown RESET OPTION");
          return;
      }
      send_command(command,NO_WAIT,DISP);
      break;

    case ESC:
      break;

    default:
      wn_error("Unknown RESET OPTION");
      break;
  }
  #undef NO_ITEMS
}

/*#+func--------------------------------------------------------------
    FUNCTION: prog_eprom()
     PURPOSE: Program EPROM on 8052AH processor card
 DESCRIPTION: popup a new menu to decide which program option is required
     RETURNS: nothing
     HISTORY: 911218 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void prog_eprom()
{
  #define NO_ITEMS 3

  MENU menu[NO_ITEMS];
  int choise = ESC;

  setup_menu(menu,0,"Mode          ", 0, change_progmode,  "",       NULL, NULL, NO_FLAGS);
  setup_menu(menu,1,"(F)PROG       ", 3, do_prog_eprom,    "",       NULL, NULL, EXIT );
  setup_menu(menu,2,"RESET options ", 0, do_reset_opt,     ":PROGx", NULL, NULL, EXIT );

  do
  {
    /*--------------------------------
      Set pointer to new progmode_str
    ----------------------------------*/
    menu[0].data = progmode_str[eprom_progmode];
    menu[0].format = "%s";

    /*-----------------
      Popup the menu
    -----------------*/
    choise = popup(NO_ITEMS,menu,5,40);
  }
  while (choise != ESC);

  #undef NO_ITEMS
}

/*#+func---------------------------------------------------------------------
     FUNCTION: show_IE()
      PURPOSE: show contents of 8052AH IE register in a window
       SYNTAX: void show_IE(WINDOW *w, int ie)
  DESCRIPTION: -
      RETURNS: nothing
      HISTORY: 920706 V0.1
--#-func-------------------------------------------------------------------*/
void show_IE(WINDOW *w, int ie)
{
  char *enabled = "enabled";
  char *disabled = "disabled";
  int key;

  wn_printf(w,"IE.7  EA   All interrupts %s\n",
    (ie & BIT_7) ? disabled : enabled);
  wn_printf(w,"IE.6  --   Reserved\n");
  wn_printf(w,"IE.5  ET2  Timer 2 overflow or capture interrupt %s\n",
    (ie & BIT_5) ? disabled : enabled);
  wn_printf(w,"IE.4  ES   Serial Port interrupt %s\n",
    (ie & BIT_4) ? disabled : enabled);
  wn_printf(w,"IE.3  ET1  Timer 1 Overflow interrupt %s\n",
    (ie & BIT_3) ? disabled : enabled);
  wn_printf(w,"IE.2  EX1  External interrupt 1 %s\n",
    (ie & BIT_2) ? disabled : enabled);
  wn_printf(w,"IE.1  ET1  Timer 0 Overflow interrupt %s\n",
    (ie & BIT_1) ? disabled : enabled);
  wn_printf(w,"IE.0  EX0  External interrupt 0 %s\n",
    (ie & BIT_0) ? disabled : enabled);
  wn_printf(w,"\nF1 = help    others = exit");

  while(TRUE) {
    key = waitkey();
    if (key == F1) {
      help("IE");
      continue;
    }
    else
      break;
  }

}

/*#+func---------------------------------------------------------------------
     FUNCTION: show_IP()
      PURPOSE: show contents of 8052AH IP register in a window
       SYNTAX: void show_IE(WINDOW *w, int ie)
  DESCRIPTION: -
      RETURNS: nothing
      HISTORY: 920706 V0.1
--#-func-------------------------------------------------------------------*/
void show_IP(WINDOW *w, int ip)
{
  char *normal = "normal";
  char *upgraded = "upgraded";
  int  key;

  wn_printf(w,"IP.7  ---  Reserved\n");
  wn_printf(w,"IP.6  ---  Reserved\n");
  wn_printf(w,"IP.5  PT2  Timer 2 interrupt priority level     %s\n",
    (ip & BIT_5) ? upgraded : normal);
  wn_printf(w,"IP.4  PS   Serial Port interrupt priority level %s\n",
    (ip & BIT_4) ? upgraded : normal);
  wn_printf(w,"IP.3  PT1  Timer 1 interrupt 1 priority level   %s\n",
    (ip & BIT_3) ? upgraded : normal);
  wn_printf(w,"IP.2  PX1  External interrupt 1 priority level  %s\n",
    (ip & BIT_2) ? upgraded : normal);
  wn_printf(w,"IP.1  PT0  Timer 0 interrupt priority level     %s\n",
    (ip & BIT_1) ? upgraded : normal);
  wn_printf(w,"IP.0  PX0  External interrupt 0 priority level  %s\n",
    (ip & BIT_0) ? upgraded : normal);
  wn_printf(w,"\nF1 = help    others = exit");

  while(TRUE) {
    key = waitkey();
    if (key == F1) {
      help("IP");
      continue;
    }
    else
      break;
  }

}

/*#+func---------------------------------------------------------------------
     FUNCTION: show_PSW()
      PURPOSE: show contents of 8052AH PSW register in a window
       SYNTAX: void show_PSW(WINDOW *w, int psw)
  DESCRIPTION: -
      RETURNS: nothing
      HISTORY: 920706 V0.1
--#-func-------------------------------------------------------------------*/
void show_PSW(WINDOW *w, int psw)
{
  char *set = "set";
  char *clear = "clear";
  int key;

  wn_printf(w,"PSW.7  CY    Carry flag                            %s\n",
    (psw & BIT_7) ? set : clear);
  wn_printf(w,"PSW.6  AC    Auxiliary Carry flag                  %s\n",
    (psw & BIT_6) ? set : clear);
  wn_printf(w,"PSW.5  F0    Flag 0                                %s\n",
    (psw & BIT_5) ? set : clear);
  wn_printf(w,"PSW.4  RS1   Register Bank Select control bits 1   %s\n",
    (psw & BIT_4) ? set : clear);
  wn_printf(w,"PSW.3  RS0   Register Bank Select control bits 0   %s\n",
    (psw & BIT_3) ? set : clear);
  wn_printf(w,"PSW.2  OV    Overflow flag                         %s\n",
    (psw & BIT_2) ? set : clear);
  wn_printf(w,"PSW.1  -     User definable flag                   %s\n",
    (psw & BIT_1) ? set : clear);
  wn_printf(w,"PSW.0  P     Parity flag                           %s\n",
    (psw & BIT_0) ? set : clear);
  wn_printf(w,"\nF1 = help    others = exit");

  while(TRUE) {
    key = waitkey();
    if (key == F1) {
      help("PSW");
      continue;
    }
    else
      break;
  }

}

/*#+func---------------------------------------------------------------------
     FUNCTION: show_TMOD()
      PURPOSE: show contents of 8052AH TMOD register in a window
       SYNTAX: void show_TMOD(WINDOW *w, int tmod)
  DESCRIPTION: -
      RETURNS: nothing
      HISTORY: 920706 V0.1
--#-func-------------------------------------------------------------------*/
void show_TMOD(WINDOW *w, int psw)
{
  int key;

  wn_printf(w,"\n\nNot yet implemented\n");
  wn_printf(w,"\nF1 = help    others = exit");

  psw++;

  while(TRUE) {
    key = waitkey();
    if (key == F1) {
      help("TMOD");
      continue;
    }
    else
      break;
  }

}

/*#+func---------------------------------------------------------------------
     FUNCTION: show_TCON()
      PURPOSE: show contents of 8052AH TCON register in a window
       SYNTAX: void show_TCON(WINDOW *w, int tcon)
  DESCRIPTION: -
      RETURNS: nothing
      HISTORY: 920706 V0.1
--#-func-------------------------------------------------------------------*/
void show_TCON(WINDOW *w, int tcon)
{
  char *set = "set";
  char *clear = "clear";
  int key;

  wn_printf(w,"TCON.7  TF1   Timer 1 overflow flag         %s\n",
    (tcon & BIT_7) ? set : clear);
  wn_printf(w,"TCON.6  TR1   Timer 1 Run control bit       %s\n",
    (tcon & BIT_6) ? set : clear);
  wn_printf(w,"TCON.5  TF0   Timer 0 overflow flag         %s\n",
    (tcon & BIT_5) ? set : clear);
  wn_printf(w,"TCON.4  TR0   Timer 0 Run control bit       %s\n",
    (tcon & BIT_4) ? set : clear);
  wn_printf(w,"TCON.3  IE1   Interrupt 1 Edge flag         %s\n",
    (tcon & BIT_3) ? set : clear);
  wn_printf(w,"TCON.2  IT1   Interrupt 1 Type control bit  %s\n",
    (tcon & BIT_2) ? set : clear);
  wn_printf(w,"TCON.1  IE0   Interrupt 0 Edge flag         %s\n",
    (tcon & BIT_1) ? set : clear);
  wn_printf(w,"TCON.0  IT0   Interrupt 0 Type control bit  %s\n",
    (tcon & BIT_0) ? set : clear);
  wn_printf(w,"\nF1 = help    others = exit");

  while(TRUE) {
    key = waitkey();
    if (key == F1) {
      help("TCON");
      continue;
    }
    else
      break;
  }

}

/*#+func---------------------------------------------------------------------
     FUNCTION: show_T2CON()
      PURPOSE: show contents of 8052AH T2CON register in a window
       SYNTAX: void show_T2CON(WINDOW *w, int t2con)
  DESCRIPTION: -
      RETURNS: nothing
      HISTORY: 920706 V0.1
--#-func-------------------------------------------------------------------*/
void show_T2CON(WINDOW *w, int t2con)
{
  char *set = "set";
  char *clear = "clear";
  int key;

  wn_printf(w,"T2CON.7   TF2     Timer 2 overflow flag         %s\n",
    (t2con & BIT_7) ? set : clear);
  wn_printf(w,"T2CON.6   EXF2    Timer 2 external flag         %s\n",
    (t2con & BIT_6) ? set : clear);
  wn_printf(w,"T2CON.5   RCLK    Receive Clock flag            %s\n",
    (t2con & BIT_5) ? set : clear);
  wn_printf(w,"T2CON.4   TCLK    Transmit Clock flag           %s\n",
    (t2con & BIT_4) ? set : clear);
  wn_printf(w,"T2CON.3   EXEN2   Timer 2 external enable flag  %s\n",
    (t2con & BIT_3) ? set : clear);
  wn_printf(w,"T2CON.2   TR2     Start/Stop control for Timer2 %s\n",
    (t2con & BIT_2) ? set : clear);
  wn_printf(w,"T2CON.1   C/!T2   Timer or counter select       %s\n",
    (t2con & BIT_1) ? "External event counter" : "internal timer");
  wn_printf(w,"T2CON.0   CP/!RL2 Capture/Reload flag           %s\n",
    (t2con & BIT_0) ? set : clear);
  wn_printf(w,"\nF1 = help    others = exit");

  while(TRUE) {
    key = waitkey();
    if (key == F1) {
      help("T2CON");
      continue;
    }
    else
      break;
  }


}

/*#+func---------------------------------------------------------------------
    FUNCTION: show_8052AH_regs()
     PURPOSE: Show special 8052AH registers
 DESCRIPTION: -
     RETURNS: nothing
     HISTORY: 911230 V0.1
--#-func-------------------------------------------------------------------*/
void show_8052AH_regs()
{
  #define NO_ITEMS 10

  int port1  = 0 ,
      ip     = 0 ,
      ie     = 0 ,
      tmod   = 0 ,
      tcon   = 0 ,
      t2con  = 0 ,
      timer0 = 0 ,
      timer1 = 0 ,
      timer2 = 0 ,
      rcap2  = 0 ;

typedef struct
  { char *cmd;
    int  val;
  }
REGISTER;

static REGISTER reg[] = {
               { "ph1.port1",  0 },
               { "ph1.ip",     0 },
               { "ph1.ie",     0 },
               { "ph1.tmod",   0 },
               { "ph1.tcon",   0 },
               { "ph1.t2con",  0 },
               { "ph1.timer0", 0 },
               { "ph1.timer1", 0 },
               { "ph1.timer2", 0 },
               { "ph1.rcap2",  0 }
               };

  char *token;
  int  i;
  int  choise;
  MENU menu[NO_ITEMS];
  WINDOW *w;

  /*------------------------------
    Send command and get reply's
  -------------------------------*/
  wn_clear(io_window);
  set_terminator(io_channel,'>');
  for (i=0 ; i<NO_ITEMS ; i++)
  {
    send_command(reg[i].cmd,NO_WAIT,NO_DISP);
    reply_ptr = get_reply(reply,NO_DISP);
    token = strtok(reply_ptr,"\n");
    token = strtok(NULL,"\n");
    if (token)
      sscanf(token,"%x",&reg[i].val);
  }

  setup_menu(menu, 0, "  PORT1    ", -1, NULL, "PORT1"  , &reg[0].val, "%04Xh", NO_FLAGS);
  setup_menu(menu, 1, "     IP -->", -1, NULL, "IP"     , &reg[1].val, "%04Xh", NO_FLAGS);
  setup_menu(menu, 2, "     IE -->", -1, NULL, "IE"     , &reg[2].val, "%04Xh", NO_FLAGS);
  setup_menu(menu, 3, "   TMOD -->", -1, NULL, "TMOD"   , &reg[3].val, "%04Xh", NO_FLAGS);
  setup_menu(menu, 4, "   TCON -->", -1, NULL, "TCON"   , &reg[4].val, "%04Xh", NO_FLAGS);
  setup_menu(menu, 5, "  T2CON -->", -1, NULL, "T2CON"  , &reg[5].val, "%04Xh", NO_FLAGS);
  setup_menu(menu, 6, " TIMER0    ", -1, NULL, "TIMER0" , &reg[6].val, "%04Xh", NO_FLAGS);
  setup_menu(menu, 7, " TIMER1    ", -1, NULL, "TIMER1" , &reg[7].val, "%04Xh", NO_FLAGS);
  setup_menu(menu, 8, " TIMER2    ", -1, NULL, "TIMER2" , &reg[8].val, "%04Xh", NO_FLAGS);
  setup_menu(menu, 9, "  RCAP2    ", -1, NULL, "RCAP2"  , &reg[9].val, "%04Xh", NO_FLAGS);

  do {

    choise = popup(NO_ITEMS,menu,5,40);

    switch(choise) {

      case 0:  help(menu[0].help);
               break;

      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        w = wn_open(_SINGLE_LINE,3,5,70,17,16*WHITE+BLACK,16*WHITE+BLACK);
        switch(choise) {
          case 1:  show_IE(w,reg[1].val);    break;
          case 2:  show_IP(w,reg[2].val);    break;
          case 3:  show_TMOD(w,reg[3].val);  break;
          case 4:  show_TCON(w,reg[4].val);  break;
          case 5:  show_T2CON(w,reg[5].val); break;

          default: break;
        }
        w = wn_close(w);
        break;

      case 6:  help(menu[6].help); break;
      case 7:  help(menu[7].help); break;
      case 8:  help(menu[8].help); break;
      case 9:  help(menu[9].help); break;
      default: break;
    }
  }
  while (choise != ESC);

  #undef NO_ITEMS
}

/*#+func---------------------------------------------------------------------
    FUNCTION: show_8052AH_alloc()
     PURPOSE: Show special 8052ah storage allocation
 DESCRIPTION: -
     RETURNS: -
     HISTORY: 911230 V0.1
--#-func-------------------------------------------------------------------*/
void show_8052AH_alloc()
{
  unsigned int mtop   = 0,
               vartop = 0,
               dimuse = 0,
               varuse = 0;
  char s[5][40];
  char *token;
  int  i;

  #define NO_ITEMS 1
  MENU menu[NO_ITEMS];

  static char *cmd[] =
  {
    "ph1.xby(10ah)*256+xby(10bh)",
    "ph1.xby(104h)*256+xby(105h)",
    "ph1.xby(106h)*256+xby(107h)",
    "ph1.xby(108h)*256+xby(109h)"
  };

  setup_menu(menu, 0, "OK", 0, NULL,  NULL, NULL, NULL , EXIT);

  /*------------------------------
    Send command and get reply's
  -------------------------------*/
  wn_clear(io_window);
  set_terminator(io_channel,'>');
  for (i=0 ; i<4 ; i++)
  {
    send_command(cmd[i],NO_WAIT,NO_DISP);
    reply_ptr = get_reply(reply,NO_DISP);
    token = strtok(reply_ptr,"\n");
    token = strtok(NULL,"\n");
    if (token)
    {
      switch(i)
      {
        case 0: sscanf(token,"%x",&mtop); break;
        case 1: sscanf(token,"%x",&vartop); break;
        case 2: sscanf(token,"%x",&varuse); break;
        case 3: sscanf(token,"%x",&dimuse); break;
      }
    }
  }

  /*----------------------------
    Fill entries of dialog menu
  ------------------------------*/
  sprintf(s[0],"  MTOP = %04Xh",mtop);
  sprintf(s[1],"VARTOP = %04Xh",vartop);
  sprintf(s[2],"VARUSE = %04dd",varuse);
  sprintf(s[3],"DIMUSE = %04dd",dimuse);

  /*-------------------
    Show dialog menu
  -------------------*/
  wn_dialog(13,40,NO_ITEMS,menu,6,
              "8052AH memory allocation",
              "                        ",
              s[0],s[1],s[2],s[3]);

  #undef NO_ITEMS
}

/*#+func---------------------------------------------------------------------
    FUNCTION: dump_8052AH_RAM()
     PURPOSE: Dump RAM contents
 DESCRIPTION: -
     RETURNS: -
     HISTORY: 911230 V0.1
--#-func-------------------------------------------------------------------*/
void dump_8052AH_RAM()
{
  static unsigned int start = 0x0000;
  static unsigned int end   = 0x00FF;
  unsigned int address;
  char command[STRLEN];
  int choise = ESC;
  char *token;
  unsigned char b[80];
  int i;

  #define NO_ITEMS 3
  MENU menu[NO_ITEMS];

  setup_menu(menu, 0, "Start:",  0, NULL,  NULL, &start, "%04x", EXIT);
  setup_menu(menu, 1, "End:",    0, NULL,  NULL, &end,   "%04x", EXIT);
  setup_menu(menu, 2, "Dump it", 0, NULL,  NULL, NULL,   NULL,   EXIT);

  while (TRUE)
  {
    choise = popup(NO_ITEMS,menu,3,50);

    if (choise == 'D')	 /* Dump memory */
    {
      /*----------------------------
        Show dump header
      -----------------------------*/
      wn_clear(io_window);
      wn_printf(io_window,"DUMP | 0123456789ABCDEF  ");
      wn_printf(io_window,"00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F\n");
      wn_printf(io_window,"-----|-------------------");
      wn_printf(io_window,"-----------------------------------------------");

      set_terminator(io_channel,'>');

      /*-----------------------------------------
        Show the contents of the address range
      ------------------------------------------*/
      for (address = start ; address < end ; address += 16)
      {
        /*------------------------------
          ESC will break from the loop
        -------------------------------*/
        if (ESC_pressed()) {
          getch();
          break;
        }

        /*----------------------------------------
          Let the processor show the RAM contents
        ------------------------------------------*/
        sprintf(command,"FOR I=%04Xh TO %04Xh: PH0.XBY(I), : NEXT I",
                address, address+15);
        send_command(command,NO_WAIT,NO_DISP);

        /*---------------------------------
          Get the reply string
        ----------------------------------*/
        reply_ptr = get_reply(reply,NO_DISP);
        token = strtok(reply_ptr,"\n");
        token = strtok(NULL,"\n");
        if (!token) break;

        /*---------------------------------
          Break the reply string down
        ----------------------------------*/
        sscanf(token,"%xH %xH %xH %xH %xH %xH %xH %xH %xH %xH %xH %xH %xH %xH %xH %xH",
          &b[0],&b[1],&b[2],&b[3],&b[4],&b[5],&b[6],&b[7],
          &b[8],&b[9],&b[10],&b[11],&b[12],&b[13],&b[14],&b[15]);

        /*-----------------------------------------------------
          Show the address, contents as characters and as HEX
        -------------------------------------------------------*/
        wn_printf(io_window,"\n%04x | ",address);
        for (i=0 ; i<16 ; i++)
          wn_printf(io_window,"%c",  b[i]<32 ? ' ' : b[i]);
        wn_printf(io_window,"  ");
        for (i=0 ; i<16 ; i++)
          wn_printf(io_window,"%02X ",b[i]);

      }
      wn_printf(io_window,"\n");
    }

    if (choise == ESC)
      break;
  }

  #undef NO_ITEMS
}

/*-------------------------------------------------------------------
   FUNCTION: get_reply()
    PURPOSE: Get reply of 8052AH MCS-52 BASIC
 DESRIPTION: disp  = 0 : no display of input
             disp <> 0 : display input
    RETURNS: ptr to string if all OK
             NULL on error
    VERSION: 911230 V0.1 - Initial version
             20-Nov-1992 16:43:09 V0.2 - Removal of ESC from kbd buffer
---------------------------------------------------------------------*/
char *get_reply(char *reply, int disp)
{
  int  i = 0;
  int  c;
  long starttime;
  long realtime;

  starttime = clock();

  while (TRUE)
  {
    if (ESC_pressed()) {
      getch();
      return(NULL);
    }

    /*--------------------
      Check for timeout
    --------------------*/
    realtime = clock();
    if ((realtime - starttime) > 1000L) {
      sleep(500L);
      return(NULL);
    }

    /*-------------------------------------------
      Get serial data and print it in the window.
      Return from routine if prompt received.
    -------------------------------------------*/
    while (( c = sio_getc(io_channel)) != EOF) {
      if (disp)
        wn_printf(io_window,"%c",c);
      reply[i++] = (char)c;
      reply[i] = '\0';
      if (c == terminator[io_channel-1])
        return(reply);
    }

  }
  return(NULL);
}

/*-------------------------------------------------------------------
   FUNCTION: wait_for_prompt
    PURPOSE: Wait on basic prompt
 DESRIPTION: -
    RETURNS:  0 if prompt received,
             -1 if timeout occured,
             -2 if ESC pressed
    VERSION: 911218 V0.1 - Initial version
---------------------------------------------------------------------*/
int wait_for_prompt()
{
  int error = 0;
  long starttime;
  long realtime;
  int  c;

  starttime = clock();

  while (TRUE)
  {
    if (ESC_pressed())
      return(-2);

    /*--------------------
      Check for timeout
    --------------------*/
    realtime = clock();
    if ((realtime - starttime) > 1000L)
      return(-1);

    /*-------------------------------------------
      Get serial data and print it in the window.
      Return from routine if prompt received.
    -------------------------------------------*/
    while (( c = sio_getc(io_channel)) != EOF) {
      wn_printf(io_window,"%c",c);
      if (c == '>')
        return(0);
    }

  }
  return(0);

}

/*#+func--------------------------------------------------------------
    FUNCTION: init_8052AH()
     PURPOSE: Initialize 8052AH processor
 DESCRIPTION: Send a space and wait for a replay.
     RETURNS: nothing
     HISTORY: 911217 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void init_8052AH()
{
  int i;
  char s[STRLEN];

  disp_status("Initializing 8052AH by sending a space");

  wn_clear(io_window);
  wn_printf(io_window,"Waiting for reply: 10");
  set_terminator(io_channel,'>');

  for (i=10 ; i>0 ; i--)
  {
    wn_printf(io_window,"\b\b%2d",i);

    /*---------------------------------------------
      Check if ESC pressed. If so, break from loop
    ----------------------------------------------*/
    if (ESC_pressed())
    {
      getch();
      break;
    }

    /*---------------------------------------
      Send a space to the 8052AH
    ---------------------------------------*/
    sio_putc(' ',io_channel);
    sleep(1000L);

    /*---------------------------------------
      Try to get data from serial channel
      and print copyright message
    ---------------------------------------*/
    if (sio_gets(s,STRLEN,io_channel)) {
      wn_printf(io_window,"%s",s);
      break;
    }

  }
}

/*-------------------------------------------------------------------
    FUNCTION: send_command()
     PURPOSE: Sends command to 8052 system
      SYNTAX: send_command(char *command, int wait, int disp);
              char *command - pointer to command string to send
              int  wait     - 0 = no wait
                              1 = wait for prompt (and discard input)
              int  disp     - 0 = no display of command
                              1 = command will be displayed
 DESCRIPTION: -
     RETURNS: nothing
     VERSION: 911125 V0.1 - Initial version
---------------------------------------------------------------------*/
void send_command(char *command, int wait, int disp)
{
  char s[STRLEN];

  /*------------------------------------
    Show the command on the screen
  ----------------------------------*/
  disp_status("Command: %s",command);
  sprintf(s,"%s%c",command,CR);    /* Add CR */
  sleep(25L);
  if (disp == DISP)
    disp_output(s);

  /*-------------------------------
    Send the command to the 8052AH
  ---------------------------------*/
  sio_printf(io_channel,"%s",s);

  /*---------------------------------------
    Wait for prompt if wanted
  ---------------------------------------*/
  if (wait == WAIT)
    wait_for_prompt();

}

/*#+func--------------------------------------------------------------
    FUNCTION: get_bas_line()
     PURPOSE: Get line from 8052AH processor
 DESCRIPTION: Wait for a line from the processor
      SYNTAX: get_bas_line(char *s, int n, int disp);
              char *s      - Pointer to string to save characters in
              int n        - Maximum number of characters to receive
              int disp     -    0 = Don't display data
                             <> 0 = Display incoming data
     RETURNS: pointer to the start of the line in the received string
              NULL if no line received within timeout time.
     HISTORY: 911202 V0.1
--#-func-------------------------------------------------------------*/
char *get_bas_line(char *s, int n, int disp)
{
  long starttime;
  long realtime;

  starttime = clock();              /* Set start time           */

  /*-------------------------
    Start of 'endless' loop
  --------------------------*/
  while (TRUE)
  {
    /*----------------------------------
      Break from loop if 'ESC' pressed
    -----------------------------------*/
    if (ESC_pressed())
    {
      getch();
      return(NULL);
    }

    /*------------------------------------------------
      Check for timeout. If timeout, break from loop
    ------------------------------------------------*/
    realtime = clock();
    if ((realtime - starttime) > 1000L)
      return(NULL);

    /*-----------------
      Get serial data
    ------------------*/
    if (sio_gets(s,n,io_channel)) {
      if (disp)
        wn_printf(io_window,"%s",s);
      return(s);
    }

  }
  return(NULL);

}

/*-------------------------------------------------------------------
   FUNCTION: load_basic()
    PURPOSE: Load 8052-BASIC source from disk into 8052 system
 DESRIPTION: Load basic the source line for line from disk and transfers
             it to the 8052 system
    RETURNS: Nothing
    VERSION: 911124 V0.1 - Initial version
             911125 V0.2 - Line for line reading and transfer
---------------------------------------------------------------------*/
void load_basic(void)
{
  FILE *f;
  int  len;
  char s[STRLEN+1];
  int  linenr;

  /*-----------------------------------------------------------------
    Try to open the basic source file. If the file could not
    be opened, show an error message and return from this function.
    Else show that we will loading a basic source file.
  ------------------------------------------------------------------*/
  f = fopen(bas_filename,"r");
  if (!f)
  {
    wn_error("ERROR: could't open file %s",bas_filename);
    return;
  }
  else
    disp_status("Loading source from file '%s'",bas_filename);

  /*--------------------------------------
    Send 'NEW' command to clear 8052 RAM
  ---------------------------------------*/
  set_terminator(io_channel,'>');
  send_command("NEW",WAIT,DISP);

  /*---------------------------
    Start an 'endless' loop
  ----------------------------*/
  while (!feof(f))
  {
    /*---------------------------------------
      If 'ESC' pressed, break from the loop
    -----------------------------------------*/
    if (ESC_pressed() || CTRLC_pressed())
    {
      getch();
      break;
    }

    /*-----------------------------------------
      Get a line from the sourcefile,
      Send line to 8052 and wait for a prompt
    -------------------------------------------*/
    fgets(s,STRLEN,f);
    if (feof(f))
      break;

    len = strlen(s);
    if (len <= 0)
      continue;

    linenr = atoi(s);
    disp_status("Sending line %d",linenr);

    if (s[len-2] == LF || s[len-2] == CR)
      s[len-2] = '\0';
    if (s[len-1] == LF || s[len-1] == CR)
      s[len-1] = '\0';
    /* disp_output(s); */
    sio_printf(io_channel,"%s%c",s,CR);
    wait_for_prompt();
  }

  /*-------------
    Close file
  --------------*/
  fclose(f);

  return;
}

/*-------------------------------------------------------------------
   FUNCTION: list_basic()
    PURPOSE: List 8052-BASIC source on screen
 DESRIPTION:
    RETURNS: Nothing
    VERSION: 920623 V0.1 - Initial version
---------------------------------------------------------------------*/
void list_basic(void)
{
  send_command("LIST",NO_WAIT,DISP);
}

/*-------------------------------------------------------------------
    FUNCTION: save_basic()
     PURPOSE: Save 8052-BASIC source on disk
 DESCRIPTION:
     RETURNS: Nothing
     VERSION: 901124 V0.1 - Initial version
---------------------------------------------------------------------*/
void save_basic(void)
{
  char s[STRLEN];      /* string from 8052 to save */
  char *ptr;
  FILE *f;
  char header[80];
  int  choise = ESC;

  #define NO_ITEMS 3
  MENU menu[NO_ITEMS];

  setup_menu(menu,0,"Overwrite", 0, NULL, "", NULL, NULL, EXIT);
  setup_menu(menu,1,"New",       0, NULL, "", NULL, NULL, EXIT);
  setup_menu(menu,2,"Exit",      0, NULL, "", NULL, NULL, EXIT);

  while (TRUE)
  {
    /*----------------------------------
      Check if filename already exists
    -----------------------------------*/
    if (file_exists(bas_filename))
    {
      /*-----------------------------------------
        File exists already. Ask what to do next
      ------------------------------------------*/
      sprintf(header,"WARNING: '%s' already exists",bas_filename);
      choise = wn_dialog(13,40,NO_ITEMS,menu,1,header);

      switch(choise) {

        case 'O' :              /* Overwrite */
          break;

        case 'N' :              /* New name  */
          editstr(10,10,20,"SAVE BASIC IN FILE",bas_filename,_DRAW);
          base_filename(bas_filename);
          strcat(bas_filename,".BAS");
          break;

        case 'X' :              /* Exit */
          return;

        case ESC :              /* Escape */
          return;

        default:
          break;
      } /* end switch(choise) */

      /*---------------------------------------
        Break from loop when overwrite file
      ---------------------------------------*/
      if (choise == 'O')
        break;
    }
    else
      /*---------------------------------
        Filename does not already exist
      ----------------------------------*/
      break;
  }

  /*------------------------------
    Open file to save source in
  ------------------------------*/
  f = fopen(bas_filename,"w");
  if (!f)
  {
    wn_error("ERROR: couldn't open file '%s'",bas_filename);
    return;
  }
  disp_status("Saving source in file '%s'",bas_filename);

  /*-------------------------------------------------
    Send 'LIST' command to 8052 to start listing
    Make LF as terminator. Wait for a LF because the
    command will be echoed by the processor.
  -------------------------------------------------*/
  set_terminator(io_channel,LF);
  send_command("LIST",NO_WAIT,DISP);

  while (TRUE)
  {
    /*-----------------------
      Check if ESC pressed
    -----------------------*/
    if (ESC_pressed())
    {
      getch();
      stop_basic();
      break;
    }

    /*-----------------------------
      Get a line from the 8052AH
    -----------------------------*/
    ptr = get_reply(s,DISP);

    /*------------------------------------------
      If 'LIST' is received, continue with loop
    --------------------------------------------*/
    if (ptr)
    {
      if (ptr[0] == 'L' &&
          ptr[1] == 'I' &&
          ptr[2] == 'S' &&
          ptr[3] == 'T' )
        continue;

      /*------------------------------------------
        If 'READY' received, stop with receiving
      -------------------------------------------*/
      else if (ptr[0] == 'R' &&
               ptr[1] == 'E' &&
               ptr[2] == 'A' &&
               ptr[3] == 'D' &&
               ptr[4] == 'Y')
        break;

      /*----------------------------------------------
        Save every other line in the file just opened
      ------------------------------------------------*/
      else
      {
        wn_printf(io_window,"%s",ptr);
        fprintf(f,"%s",ptr);
      }
    }
  } /* end while(TRUE) */

  /*------------
    Close file
  -------------*/
  fclose(f);

  #undef NO_ITEMS

}

/*#+func--------------------------------------------------------------
    FUNCTION: transfer_hex()
     PURPOSE: Transfer HEX file to 8052AH
 DESCRIPTION: Opens HEX file of which the filename is given
              Reads the HEX file line by line and processes it
              each byte will be sent by a XBY() command of the 8052AH
     RETURNS: 0  if successfull,
              -1 if unknown hex format
              -2 if hexformat not implemented
              -3 if file coudn't be opened
              -4 if transfer interrupted by 'ESC' key
     HISTORY: 911202 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
int transfer_hex(char *filename)
{
  #define INTEL_16      0
  #define INTEL_MCS86   1
  #define MOTOROLA_S1   2
  #define MOTOROLA_S2   3
  #define TEKTRONICS    4

  static char *hexformat_str[] =
  {
    "INTEL 16",
    "INTEL MCS86",
    "MOTOROLA S1",
    "MOTOROLA S2",
    "TEKTRONICS",
  };

  FILE *f;
  int linenr = 0;
  char s[STRLEN];
  char command_str[STRLEN];
  int no_databytes;
  int base_address;
  int record_type;
  int hex_format = -1;
  int i,j;

  f = fopen(filename,"r");
  if (f == NULL)
  {
    sprintf(error_msg,"ERROR: open HEX file %s",filename);
    wn_error(error_msg);
    return(-3);
  }
  disp_status("Uploading HEX file '%s'",filename);

  set_terminator(io_channel,'>');

  while (!feof(f))
  {
    /*--------------------
      Get line from file
    ---------------------*/
    fgets(s,STRLEN,f);
    linenr++;
    if (feof(f))
      break;
    /*-----------------------------------------
      Determine file format only on first line
    ------------------------------------------*/
    if (linenr == 1)
    {
      switch(s[0])
      {
        case ':':
          hex_format = INTEL_16;
          break;
        case 'S':
          if (s[1] == '1')
            hex_format = MOTOROLA_S1;
          else if (s[1] == '2')
            hex_format = MOTOROLA_S2;
          break;
        case '/':
          hex_format = TEKTRONICS;
          break;
        default:
          wn_error("Unknown HEX format");
          return(-1);
          break;
      }

      if (hex_format != INTEL_16)
      {
        wn_error("HEX format not implemented");
        return(-2);
      }
    }

/*        1         2         3         4         5
012345678901234567890123456789012345678901234567890

:1002800075F06484F521740AC5F084C425F0F52264
:0E0290002275F01084A475F00A84C445F02293
:00000001FF
*/

    if (hex_format == INTEL_16)
    {
      no_databytes =   16*hex_to_dec(s[1]) +
                          hex_to_dec(s[2]);
      base_address = 4096*hex_to_dec(s[3]) +
                      256*hex_to_dec(s[4]) +
                       16*hex_to_dec(s[5]) +
                          hex_to_dec(s[6]);
      record_type =    16*hex_to_dec(s[7]) +
                          hex_to_dec(s[8]);

      if (record_type == 0)    /* Data */
      {
        j = 9;
        for (i=0 ; i<no_databytes ; i++)
        {
          sprintf(command_str,"XBY(%04xH)=%c%cH",
            base_address+i, s[j], s[j+1]);
          j += 2;
          send_command(command_str,NO_WAIT,DISP);
          if (kbhit())
          {
            if (getch() == ESC)
            {
              fclose(f);
              return(-4);
            }
          }
        }
      }

      if (record_type == 1)
        break;
    }

  }

  fclose(f);      /* Close HEX file */
  return(0);      /* All OK         */

}

/*#+func--------------------------------------------------------------
    FUNCTION: bas_loadhex()
     PURPOSE: Load assembler (HEX) file in 8052AH basic processor
 DESCRIPTION: Show a menu and take actions. If transfer wanted,
              call transfer_hex()
     RETURNS: nothing
     HISTORY: 911128 V0.1 - Initial version
              911202 V0.2 - Load address etc. interpreted form HEX
                            file.
--#-func-------------------------------------------------------------*/
void bas_loadhex()
{
  #define NO_MENU_ITEMS 5

  char *path;
  MENU menu[NO_MENU_ITEMS];

  static char *hex_filename = "work.hex       ";
  static int start_address  = 0x4000;
  static int end_address    = 0x4000;
  static int length         = 0x0000;

  init_menu(menu,NO_MENU_ITEMS);

  /*------------------
    Set menu headers
  --------------------*/
  menu[0].header =  "File         ";
  menu[1].header =  "Start address";
  menu[2].header =  "End address  ";
  menu[3].header =  "Length       ";
  menu[4].header =  "Transfer     ";

  /*----------------
    Set menu data
  ----------------*/
  menu[0].data = hex_filename;   menu[0].format = "%s";
  menu[1].data = &start_address; menu[1].format = "%d";
  menu[2].data = &end_address;   menu[2].format = "%d";
  menu[3].data = &length;        menu[3].format = "%d";
  menu[4].data = NULL;           menu[4].format = NULL;

  /*-----------
    Set flags
  ------------*/
  menu[0].flags = NO_FLAGS;

  path = get_dir("*.hex",hex_filename);
  if (path)
    transfer_hex(path);

  #undef NO_ITEMS
}

/*#+func--------------------------------------------------------------
    FUNCTION: change_bas_wkf()
     PURPOSE: change basic workfile
 DESCRIPTION: Change the filename of the current basic workfile
     RETURNS: nothing
     HISTORY: 911211 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void change_bas_wkf()
{
  char filename[NAMELEN];
  char *path;

  strcpy(filename,bas_filename);

  path = get_dir("*.bas",filename);
  if (path != NULL) {
    strcpy(bas_filename,path);
    strcpy(workfile,bas_filename);
  }
}

/*#+func--------------------------------------------------------------
    FUNCTION: edit_bas
     PURPOSE: edit BASIC source file
 DESCRIPTION: calls edit_source() with source file name
     RETURNS: nothing
     HISTORY: 911124 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void edit_bas()
{
  edit_source(bas_filename);
}

/*-------------------------------------------------------------------
    FUNCTION: run_basic
     PURPOSE: Run basic in 8052 system
 DESCRIPTION: Sends 'RUN' command to 8052 system
     RETURNS: nothing
     HISTORY: 911124 V0.1 - Initial version
---------------------------------------------------------------------*/
void run_basic()
{
  send_command("RUN",NO_WAIT,DISP);
}

/*-------------------------------------------------------------------
    FUNCTION: stop_basic
     PURPOSE: Stop running basic program in 8052 system
 DESCRIPTION: Sends 'CTRL-C' command to 8052 system
     RETURNS: nothing
     HISTORY: 911124 V0.1 - Initial version
---------------------------------------------------------------------*/
void stop_basic()
{
  sio_putc(0x03,io_channel);
}

/*#+func--------------------------------------------------------------
    FUNCTION: help_basic()
     PURPOSE: Popup a menu with help items for MSC52 BASIC
 DESCRIPTION: -
     RETURNS: nothing
     HISTORY: 911128 V0.1
--#-func-------------------------------------------------------------*/
void help_basic()
{
  int choise;

  #define NO_ITEMS 7

  MENU menu[NO_ITEMS];

  setup_menu(menu,0," Commands        ", -1, NULL, ":commands",      NULL, NULL, HELP_ONLY );
  setup_menu(menu,1," Statements      ", -1, NULL, ":statements",    NULL, NULL, HELP_ONLY );
  setup_menu(menu,2," Operators       ", -1, NULL, ":operators",     NULL, NULL, HELP_ONLY );
  setup_menu(menu,3," PROGx           ", -1, NULL, ":PROGx",         NULL, NULL, HELP_ONLY );
  setup_menu(menu,4," Registers       ", -1, NULL, ":registers",     NULL, NULL, HELP_ONLY );
  setup_menu(menu,5," Internal memory ", -1, NULL, ":internal_mem",  NULL, NULL, HELP_ONLY );
  setup_menu(menu,6," External memory ", -1, NULL, ":external_mem",  NULL, NULL, HELP_ONLY );

  while (TRUE)
  {
    choise = popup(NO_ITEMS,menu,5,40);
    if (choise == ESC)
      return;
  }

  #undef NO_ITEMS
}
