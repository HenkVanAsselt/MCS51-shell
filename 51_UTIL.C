/****************************************************************************
*                                                                           *
*        FILE: 51_UTIL.C                                                    *
*                                                                           *
*     PURPOSE: FILE WITH UTILITIES FOR 51SHELL                              *
*                                                                           *
* DESCRIPTION: -                                                            *
*                                                                           *
*     HISTORY: 911105 V0.1                                                  *
*                                                                           *
****************************************************************************/

/*---------------------------------------------------------------------------
                        HEADER FILES
---------------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <conio.h>
#include <direct.h>
#include <time.h>
#include <string.h>
#include <window.h>
#include <front9.h>
#include <hva_util.h>
#include "51shell.h"

/*---------------------------------------------------------------------------
                        PROTOTYPES
---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
                        CONSTANTS
---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
                        LOCAL VARIABLES
---------------------------------------------------------------------------*/
static time_t tnow;

/*---------------------------------------------------------------------------
                        GLOBAL VARIABLES
---------------------------------------------------------------------------*/
int force_exit = 0;

/*===========================================================================
                        START OF FUNCTIONS
===========================================================================*/

/*#+func-------------------------------------------------------------------
   FUNCTION: log51()
    PURPOSE: Log 51shell actions to a log file
     SYNTAX: void wn_log(char *format, ...);
DESCRIPTION: If 'LOG51' is defined, a file called '51shell.log' will be
             opened. The arguments given will be printed in the logfile.
             The format of the arguments is the same as for 'printf()'.
    RETURNS: nothing
    HISTORY: 920203 V0.1 - Initial version
--#-func-------------------------------------------------------------------*/
void log51(char *format, ...)
{
  va_list arguments;
  static char *ep = NULL;     /* Points to environment var that names file */
  FILE *fp = NULL;

  if (ep == NULL                /* First time through, just create blank file */
  && (ep = getenv("LOG51"))
  && (fp = fopen(ep,"w")) ) {
    fclose(fp);
    fp = NULL;
  }

  if (ep)  {                     /* If we have a filename, proceed */
    fp = fopen(ep,"r+");
    if (!fp) {
      fprintf(stderr,"\nCannot open %s\n\a",ep);
      return;
    }
    else {
      va_start(arguments,format);
      fseek(fp,0L,SEEK_END);
      vfprintf(fp,format,arguments);
      va_end(arguments);
      fclose(fp);
    }
  }
}

/*#+func--------------------------------------------------------------
    FUNCTION: delay()
     PURPOSE: Wait for about t milliseconds
 DESCRIPTION: -
     RETURNS: nothing
     HISTORY: 911217 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void delay(long t)
{
  long return_time;

  return_time = clock() + t;

  while (return_time > clock())
    ;
}

/*#+func--------------------------------------------------------------
    FUNCTION: disp_input()
     PURPOSE: Display input of serial channel in input window
 DESCRIPTION: -
     RETURNS: nothing
     HISTORY: 911217 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void disp_input(char *s)
{
  int len;

  /*-----------------------------------------------------
    Check if last character of the string is a linefeed.
    If not, add one to the string
  ------------------------------------------------------*/
  len = strlen(s);
  if (len > 0 && len < 256 && s[len-1] != LF)
  {
    s[len] = LF;
    s[len+1] = '\0';
  }
  wn_printf(io_window,"%s",s);

}

/*#+func--------------------------------------------------------------
    FUNCTION: disp_output()
     PURPOSE: Display output of serial channel in output window
 DESCRIPTION: -
     RETURNS: nothing
     HISTORY: 911217 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void disp_output(char *s)
{
  int len;

  /*-----------------------------------------------------
    Check if last character of the string is a linefeed.
    If not, add one to the string
  ------------------------------------------------------*/
  len = strlen(s);
  if (len < 256 && s[len-1] != LF)
  {
    s[len] = LF;
    s[len+1] = '\0';
  }
  wn_printf(io_window,"%s",s);
}

/*#+func--------------------------------------------------------------
    FUNCTION: hex_to_dec()
     PURPOSE: Convert character HEX value to decimal value
 DESCRIPTION: -
     RETURNS: converted value
     HISTORY: 911202 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
int hex_to_dec(char c)
{
  switch (c)
  {
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9': return(c-'0'); break;
    case 'a':
    case 'b':
    case 'c':
    case 'd':
    case 'e':
    case 'f': return(c-'a'+10); break;
    case 'A':
    case 'B':
    case 'C':
    case 'D':
    case 'E':
    case 'F': return(c-'A'+10); break;
  }
  return(-1);
}

/*#+func-------------------------------------------------------------
    FUNCTION: exit_prog()
     PURPOSE: exit from program
 DESCRIPTION: Perform this function only once:
              update system files,
              call exit()
              If force_exit is set, then exit with specified exit code:
              10 = perform 'execute.bat' and start program again.
     RETURNS: nothing
     HISTORY: 911124 V0.3
--#-func-------------------------------------------------------------*/
void exit_prog()
{
  #define NO_ITEMS 2

  static int done = FALSE;
  int choise = ESC;
  MENU menu[NO_ITEMS];

  setup_menu(menu, 0, "Yes", 0, NULL,  NULL, NULL, NULL , EXIT);
  setup_menu(menu, 1, "No",  0, NULL,  NULL, NULL, NULL , EXIT);

  if (!done && !force_exit)               /* Do this only once */
  {
    /*-------------------------------------
      Ask if programm has to be terminated
    ---------------------------------------*/
    choise = wn_dialog(13,40,NO_ITEMS,menu,1,"Exit from program ?");
    if (choise == 'N' || choise == ESC)
      return;
  }

  if (!done)
  {
    /*---------------------------------
      Save information in '.INI' file
    -----------------------------------*/
    save_ini();

    /*----------------
      Close io window
    ------------------*/
    io_window = wn_close(io_window);
    /* wn_exit();  */        /* Exit from HvA window enviroment          */

    done = TRUE;        /* Set flag (this routine has been executed */
    exit(force_exit);
  }
}

/*#+func-------------------------------------------------------------
    FUNCTION: initialize()
     PURPOSE: Initialize 8052 shell enviroment
 DESCRIPTION: initialize variables,
              prints introduction screen,
     RETURNS:
     HISTORY: 911124 V0.3
--#-func-------------------------------------------------------------*/
void initialize()
{
  extern char *default_subject;
  int error;

  /*-------------------------
    Initiate time variables
  --------------------------*/
  time(&tnow);
  tmnow = localtime(&tnow);

  /*----------------------------
    Initilize (graphic) screen
  ----------------------------*/
  wn_init();

  /*-------------------------------------------------
    Show introduction screen with copyright message
  ---------------------------------------------------*/
  /*
  intro_screen();
  */

  /*-------------------------------
    Initialize help file functions
  ---------------------------------*/
  default_subject = ":general_info";
  init_help("51shell");

  /*-------------------
    Load '.INI' file
  -------------------*/
  read_ini();

  /*-----------------------
    Initialize serial port
  -------------------------*/
  sio_init();
  error = set_serial_io(io_channel, 'B', io_handshake,
          io_baudrate, io_no_databits, io_no_stopbits,
          io_parity, io_terminator, STRLEN);
  set_terminator(io_channel,'>');
  channel_info[io_channel-1] = channel_info[io_channel-1] | TERMINAL_MODE;

  /*----------------------------------------------
    Set vector to exit_prog() if exit() is called
  ------------------------------------------------*/
  atexit(exit_prog);
}

/*#+func--------------------------------------------------------------
    FUNCTION: call_zapload()
     PURPOSE: Call the zapload utilitie.
 DESCRIPTION: -
     RETURNS: nothing
     HISTORY: 911211 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void call_zapload()
{
  WINDOW *w;
  int i;

  /*----------------------------
    Open standard DOS window
  -----------------------------*/
  w = wn_open(_NO_BORDER,MINROW,MINCOL,MAXXSIZE,MAXYSIZE,
              16*BLACK+WHITE,16*BLACK+WHITE);

  puts("calling zapload\n");
  i = call("zapload");
  printf("\n returned %d\n",i);
  puts("\n\nPress any key to continue ...");
  getch();

  w = wn_close(w);
}

/*#+func--------------------------------------------------------------
    FUNCTION: call_convert()
     PURPOSE: Call the external converter program.
 DESCRIPTION: -
     RETURNS: nothing
     HISTORY: 911211 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void call_convert()
{
  WINDOW *w;

  /*----------------------------
    Open standard DOS window
  -----------------------------*/
  w = wn_open(_NO_BORDER,MINROW,MINCOL,MAXXSIZE,MAXYSIZE,
              16*BLACK+WHITE,16*BLACK+WHITE);

  call("convert");
  puts("\n\nPress any key to continue ...");
  getch();

  w = wn_close(w);
}

/*#+func---------------------------------------------------------------------
    FUNCTION: show_mem()
     PURPOSE: Show memory
      SYNTAX: void show_mem(void);
 DESCRIPTION: Calls dos 'MEM.EXE' by spawn
     RETURNS: nothing
     HISTORY: 920318 V0.1
--#-func-------------------------------------------------------------------*/
void show_mem()
{
  WINDOW *w;

  /*--------------------------
    Open the compile window
  --------------------------*/
  w = wn_open(_NO_BORDER,MINROW,MINCOL,MAXXSIZE,MAXYSIZE,
              16*BLACK+WHITE,16*BLACK+WHITE);

  /*-----------------------------
    Call the standalone program
  ------------------------------*/
  /*
  call("c:\\dos\\mem /c | more");
  */
  call("c:\\qemm\\mft");

  /*---------------------------------------------------------
    Wait for a keypress, so you can read the error message(s)
  ----------------------------------------------------------*/
  puts("\nPress any key to continue ...");
  getch();

  /*----------------------------
    Close the compile window
  ----------------------------*/
  w = wn_close(w);
}

/*#+func-------------------------------------------------------------
    FUNCTION: edit_source
     PURPOSE: edit source file
 DESCRIPTION: calls editor with source file name
     RETURNS: nothing
     HISTORY: 911124 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void edit_source(char *filename)
{
  char command_str[80];
  WINDOW *w;
  int  ret = ESC;

  /*---------------------------------------------------------------
    Confirm name of file to edit. If <ESC> was pressed, quit from
    this function
  -----------------------------------------------------------------*/
  ret = editstr(10,10,20,"Edit source",filename,_DRAW);
  if (ret == ESC)
    return;

  /*-----------------------------------------------------------
    If there is a wildcard character in the filename, display
    all matching file names and pick one. If <ESC> was pressed,
    quit from this function.
  ------------------------------------------------------------*/
  if ( strchr(filename,'*') || strchr(filename,'?') )
    if (get_dir(filename,filename) == NULL)
       return;

  /*---------------------------------
    Open edit window (screen-size)
  ---------------------------------*/
  w = wn_open(_NO_BORDER,MINROW,MINCOL,MAXXSIZE,MAXYSIZE,
              16*BLACK+WHITE,16*BLACK+WHITE);
  wn_sync(w,TRUE);
  wn_clear(w);

  /*------------------
    Call the editor
  ------------------*/
  strcpy(command_str,editor_path);
  strcat(command_str," ");
  strcat(command_str,filename);
  call(command_str);

  /*-------------------------
    Close the edit window
  -------------------------*/
  w = wn_close(w);
}
