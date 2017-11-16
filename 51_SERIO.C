/**********************************************************************
*                                                                     *
*        FILE: 51_SERIO.C                                             *
*                                                                     *
*     PURPOSE: Serial io routines for MSC-51 shell                    *
*                                                                     *
* DESCRIPTION: -                                                      *
*                                                                     *
*     HISTORY: 911128 V0.1 - Initial version                          *
*                                                                     *
**********************************************************************/

/*--------------
  Header files
---------------*/
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <time.h>
#include <string.h>
#include <window.h>
#include <front9.h>
#include "51shell.h"

/*-------------------------------------------------------------------
    FUNCTION: popup_handshakes()
     PURPOSE: Popup available handshakes
 DESCRIPTION: -
     RETURNS: (char) handshake selected
     HISTORY: 910909 V0.1 - Initial version
---------------------------------------------------------------------*/
char popup_handshakes(void);    /* prototype */
char popup_handshakes()
{

  #define  NO_HANDSHAKES 3

  int choise;
  MENU menu[NO_HANDSHAKES];

  init_menu(menu,NO_HANDSHAKES);

  menu[0].header =  "   None      ";
  menu[1].header =  "   Xon/Xoff  ";
  menu[2].header =  "   DSR/CTS   ";

  choise = popup(NO_HANDSHAKES,menu,5,40);
  if (choise == ESC)
    return(0);

  switch (choise)
  {
    case 0: return('N');
    case 1: return('X');
    case 2: return('D');
    default: return('N');
  }
  return('N');
}

/*-------------------------------------------------------------------
    FUNCTION: popup_baudrates()
     PURPOSE: Popup available baudrates
 DESCRIPTION: -
     RETURNS: Baudrate selected
     HISTORY: 910909 V0.1 - Initial version
---------------------------------------------------------------------*/
int popup_baudrates(void);    /* prototype */
int popup_baudrates()
{

  #define  NO_BAUDRATES 7

  int choise;
  MENU menu[NO_BAUDRATES];

  init_menu(menu,NO_BAUDRATES);

  menu[0].header =  "    300  ";
  menu[1].header =  "    600  ";
  menu[2].header =  "   1200  ";
  menu[3].header =  "   2400  ";
  menu[4].header =  "   4800  ";
  menu[5].header =  "   9600  ";
  menu[6].header =  "  19200  ";

  choise = popup(NO_BAUDRATES,menu,5,40);
  if (choise == ESC)
    return(0);

  switch (choise)
  {
    case 0: return(300);
    case 1: return(600);
    case 2: return(1200);
    case 3: return(2400);
    case 4: return(4800);
    case 5: return(9600);
    case 6: return(19200);
    default: return(0);
  }
  return(0);
}

/*#+func--------------------------------------------------------------
    FUNCTION: change_serial()
     PURPOSE: change serial parameters
 DESCRIPTION: -
     RETURNS: nothing
     HISTORY: 911127 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void change_serial()
{
  #define NO_PARAMS    7

  #define CHANNEL      0
  #define BAUDRATE     1
  #define DATABITS     2
  #define PARITY       3
  #define STOPBITS     4
  #define HANDSHAKE    5
  #define ECHO         6

  int i;
  int choise = ESC;
  MENU menu[NO_PARAMS];
  char s[NO_PARAMS][40];
  int error;

  do
  {
    init_menu(menu,NO_PARAMS);
    choise = ESC;
    i = 0;

    i = CHANNEL;
    menu[i].header = "Channel   ";
    menu[i].format = "%1d";
    menu[i].data   = &io_channel;
    menu[i].hotkey = -1;

    i = BAUDRATE;
    sprintf(s[i],"Baudrate    %d",io_baudrate);
    menu[i].header = s[i];
    menu[i].hotkey = -1;

    i = DATABITS;
    menu[i].header = "Databits  ";
    menu[i].format = "%d";
    menu[i].data   = &io_no_databits;
    menu[i].hotkey = -1;

    i = PARITY;
    menu[i].header = "Parity    ";
    menu[i].format = "%c";
    menu[i].data   = &io_parity;
    menu[i].hotkey = -1;

    i = STOPBITS;
    menu[i].header = "Stopbits  ";
    menu[i].format = "%d";
    menu[i].data   = &io_no_stopbits;
    menu[i].hotkey = -1;

    i = HANDSHAKE;
    strcpy(s[i],"Handshake   ");
    switch(io_handshake)
    {
      case 'N': strcat(s[i],"None "); break;
      case 'D': strcat(s[i],"DSR/CTS "); break;
      case 'X': strcat(s[i],"Xon/Xoff "); break;
      default : strcat(s[i],"- "); break;
    }
    menu[i].header = s[i] ;
    menu[i].hotkey = -1;

    i = ECHO;
    menu[i].header = "Echo      ";
    menu[i].format = "%B";
    menu[i].data   = &io_echo;
    menu[i].hotkey = -1;


    choise = popup(NO_PARAMS,menu,5,43);

    if (choise == BAUDRATE)
    {
       io_baudrate = popup_baudrates();
    }
    else if (choise == HANDSHAKE)
    {
       io_handshake = popup_handshakes();
    }

    /*-------------------------------------------------
      Set serial i/o if one of the channel parameters
      have been changed
    --------------------------------------------------*/
    switch (choise)
    {
      case CHANNEL:
      case BAUDRATE:
      case DATABITS:
      case PARITY:
      case STOPBITS:
      case HANDSHAKE:
           error = set_serial_io(io_channel, 'B', io_handshake,
                   io_baudrate, io_no_databits, io_no_stopbits,
                   io_parity, io_terminator, STRLEN);
           break;
      default:
             break;
    }

  }
  while (choise != ESC);

  #undef NO_PARAMS
}
