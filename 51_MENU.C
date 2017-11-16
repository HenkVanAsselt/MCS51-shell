/****************************************************************************
*                                                                           *
*        FILE: 51_MENU.C                                                    *
*                                                                           *
*     PURPOSE: WINDOWED ENVIROMENT FOR HvA MSC-51 COMPUTERS                 *
*              THIS FILE CONTAINS ALL MENU ROUTINES FOR 51SHELL             *
*                                                                           *
* DESCRIPTION: -                                                            *
*                                                                           *
*     HISTORY: 911202 V0.1 - INITIAL VERSION                                *
*                                                                           *
****************************************************************************/

/*---------------------------------------------------------------------------
                        HEADER FILES
---------------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <time.h>
#include <string.h>
#include <window.h>
#include <front9.h>
#include "51shell.h"

/*---------------------------------------------------------------------------
                        PROTOTYPES
---------------------------------------------------------------------------*/

/*===========================================================================
                        START OF FUNCTIONS
===========================================================================*/

/*#+func--------------------------------------------------------------
|    FUNCTION: change_target()
|     PURPOSE: change target (8048/8051 etc)
| DESCRIPTION:
|     RETURNS: nothing
|     HISTORY: 920102 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void change_target()
{
  #define NO_ITEMS 17

  int choise = ESC ;

  MENU menu[NO_ITEMS];

  setup_menu(menu,0, " Current target ", -1, NULL, ":target", target_str, "%s", COMMENT );
  setup_menu(menu,1, "(A)  8x48  ", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,2, "(B)  8x51  ", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,3, "(C)  8031  ", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,4, "(D)  8x52  ", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,5, "(E)  8032  ", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,6, "(F)  80515 ", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,7, "(G)  80535 ", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,8, "(H)  80512 ", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,9, "(I)  80532 ", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,10, "(J)  8x44  ", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,11,"(K)  8xC552", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,12,"(L)  DS5000", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,13,"(M)  80152 ", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,14,"(N)  87C751", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,15,"(O)  80C521", 1, NULL, ":target", NULL, NULL, EXIT );
  setup_menu(menu,16,"(P)  80C321", 1, NULL, ":target", NULL, NULL, EXIT );

  choise = popup(NO_ITEMS,menu,5,40);
  switch (choise)
  {
    case 'A': strcpy(target_str,"8x48");   break;
    case 'B': strcpy(target_str,"8x51");   break;
    case 'C': strcpy(target_str,"8031");   break;
    case 'D': strcpy(target_str,"8x52");   break;
    case 'E': strcpy(target_str,"8032");   break;
    case 'F': strcpy(target_str,"80515");  break;
    case 'G': strcpy(target_str,"80535");  break;
    case 'H': strcpy(target_str,"80512");  break;
    case 'I': strcpy(target_str,"80532");  break;
    case 'J': strcpy(target_str,"8x44");   break;
    case 'K': strcpy(target_str,"8xC552"); break;
    case 'L': strcpy(target_str,"DS5000"); break;
    case 'M': strcpy(target_str,"80152");  break;
    case 'N': strcpy(target_str,"87C751"); break;
    case 'O': strcpy(target_str,"80C521"); break;
    case 'P': strcpy(target_str,"80C321"); break;
    case ESC: return; break;
    default:  break;
  }

  #undef NO_ITEMS
}

/*#+func--------------------------------------------------------------
|    FUNCTION: change_make_wkf()
|     PURPOSE: change make workfile
| DESCRIPTION: Change the filename of the current make workfile
|     RETURNS: nothing
|     HISTORY: 911216 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void change_make_wkf()
{
  char filename[15];

  strcpy(filename,make_filename);

  if (get_dir("*.mak",filename) != NULL)
    strcpy(make_filename,filename);
}

/*-------------------------------------------------------------------
|    FUNCTION: edit_makefile
|     PURPOSE: edit make source file
| DESCRIPTION: calls edit_source() with make file name
|     RETURNS: nothing
|     HISTORY: 911124 V0.1 - Initial version
---------------------------------------------------------------------*/
void edit_make()
{
  edit_source(make_filename);
}

/*-------------------------------------------------------------------
|    FUNCTION: do_make
|     PURPOSE: invoke make utilitie
| DESCRIPTION: Open a window, call 'make' and close window.
|     RETURNS: nothing
|     HISTORY: 911216 V0.1 - Initial version
---------------------------------------------------------------------*/
void do_make()
{
  char command_str[80];
  WINDOW *w;

  w = wn_open(_NO_BORDER,MINROW,MINCOL,MAXXSIZE,MAXYSIZE,
              16*BLACK+WHITE,16*BLACK+WHITE);

  disp_status("Make %s",make_filename);
  sprintf(command_str,"make %s",make_filename);
  call(command_str);

  /*---------------------------------------------------------
    Wait for a keypress, so you can read the error messages
  ----------------------------------------------------------*/
  puts("\nPress any key to continue ...");
  getch();

  w = wn_close(w);
}

/*-------------------------------------------------------------------
|    FUNCTION: Intro_screen()
|     PURPOSE: Intro screen with copyright message
| DESCRIPTION: -
|     RETURNS: nothing
|     HISTORY: 911124 V0.1 - Initial version
---------------------------------------------------------------------*/
void intro_screen()
{
  MENU menu[1];

  setup_menu(menu, 0, "OK", 0, NULL, "", NULL, NULL, EXIT );

  wn_dialog(13,40,1,menu,6,
    "       MCS-51             ",
    "  Development enviroment  ",
    "                          ",
    "  (c) H.B.J. van Asselt   ",
    "      16 JAN 1992 V1.1    ",
    "");
}
