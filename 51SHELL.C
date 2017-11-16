/**********************************************************************
*                                                                     *
*        FILE: 51SHELL.C                                              *
*                                                                     *
*     PURPOSE: WINDOWED ENVIROMENT FOR HvA MSC-51 COMPUTERS           *
*                                                                     *
* DESCRIPTION: -                                                      *
*                                                                     *
*     HISTORY: 911124 V0.1 - INITIAL VERSION                          *
*                                                                     *
**********************************************************************/

#define  MAIN_MODULE

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
#include <hva_util.h>
#include "51shell.h"
#include "51_dis.h"

void call_basic(void);

MENU M_shell[] =
{
  { "Directory ", 0, show_dir,      "show_dir",   NULL, NULL, },
  { "Change dir", 0, change_dir,    "change_dir", NULL, NULL, },
  /* { "Terminal  ", 0, call_terminal, "terminal",   NULL, NULL  }, */
  { "OS shell  ", 0, OS_shell,      "OS_shell",   NULL, NULL, },
  { "Memory    ", 0, show_mem,      "",           NULL, NULL, },
  { "Exit      ", 0, exit_prog,     "exit",       NULL, NULL, },
  { NULL }
};

extern MENU M_PASCAL[];
extern MENU M_ASM[];

MENU M_BASIC[] =
{
  { "BASIC    ", 0, call_basic,  NULL, NULL, NULL, NO_FLAGS },
  { NULL }
};

MENU M_make[] =
{
  { "File name", 0, change_make_wkf, "change_wkf",   make_filename, "%s", NO_FLAGS },
  { "Edit     ", 0, edit_make,       "edit_source",  NULL, NULL },
  { "Make it  ", 0, do_make,         "do_makeit",    NULL, NULL },
  { NULL }
};

MENU M_options[] =
{
  { "Target        ", 1, change_target, "assemblers", target_str, "%s", NO_FLAGS},
  { "Editor path   ", 0, NULL, "editor_path", editor_path,        "%s", EDIT_STR },
  { "Serial params ", 0, change_serial, "change_serial", serial_str, "%s", NO_FLAGS},
  { NULL }
};

MENU M_help[] =
{
  { "MCS 51 family",   -1, NULL, "MCS_51_family", NULL, NULL, HELP_ONLY },
  { "XTAL/Baudrate",   -1, NULL, "xtal_baudrate", NULL, NULL, HELP_ONLY },
  { "Eproms       ",   -1, NULL, "Eproms",        NULL, NULL, HELP_ONLY },
  { "HEX formats  ",   -1, NULL, "HEX_formats",   NULL, NULL, HELP_ONLY },
  { NULL }
};

MENU M_utils[] =
{
  { "Zapload     F2", 0, call_zapload, "Zapload", NULL, NULL, },
  { "Conversions F3", 0, call_convert, "Hexconv", NULL, NULL, },
  { NULL }
};

/*
MENU M_DISASM[] =
{
  { "Work file  ", 0, change_dis_wkf, ":change_dis_wkf", dis_filename, "%s", },
  { "Target     ", 0, change_target,  ":assemblers",     target_str,   "%s", },
  { "Edit labels", 0, edit_label,     ":dis_assemble",   NULL, NULL, },
  { "Disassemble", 0, disassemble,    ":dis_assemble",   NULL, NULL, },
  { "List       ", 0, list_dis,       ":list_it",        NULL, NULL, },
  { NULL }
};
*/

MENU_HEAD heads[] =
{
  { "System",  0, 6, M_shell   },
/*
  { "DISasm",  0, 4, M_DISASM  },
*/
  { "BASIC",   0, 1, M_BASIC   },
  { "PASCAL",  0, 5, M_PASCAL  },
  { "ASM",     0, 5, M_ASM     },
/*
  { "Make",    0, 3, M_make    },
*/
  { "Help",    0, 4, M_help    },
  { "Options", 0, 3, M_options },
  { "Utils  ", 0, 2, M_utils   },
  { NULL }
};

  /*#+func-----------------------------------------------------------------------
    FUNCTION: call_basic()
     PURPOSE: execute '51basic' program
      SYNTAX: void call_basic(void);
 DESCRIPTION: Makes a batchfile in which '51basic.exe' will be called
     RETURNS: Nothing
     HISTORY: 05-Jan-1993 21:58:46 V0.1 - Initial version
--#-func----------------------------------------------------------------------*/
void call_basic()
{
  FILE *f;
  extern int force_exit;

  /*-----------------------------------------------------
    Open the batchfile 'execute.bat'
  ------------------------------------------------------*/
  f = fopen("execute.bat","w");
  if (!f) {
    wn_printf(io_window,"Error in opening execute.bat\n");
    wn_printf(io_window,"\nPress any key to continue ...\n");
    getch();
    return;
  }

  /*---------------------------------------
    Write commands to the batch file
  ---------------------------------------*/
  fprintf(f,"51basic\n");
  fprintf(f,"shell\n");
  fclose(f);

  /*---------------------------------------------
    Exit the program to execute batchfile
  ----------------------------------------------*/
  force_exit = CALL_EXECUTE;
  exit(CALL_EXECUTE);
}

/*-------------------------------------------------------------------
|    FUNCTION: main()
|     PURPOSE: main programm
| DESCRIPTION: -
|     RETURNS: nothing
|     HISTORY: 911124 V0.1 - Initial version
---------------------------------------------------------------------*/
int main(void);
main()
{
  int c;

  initialize();
  pulldown_bar(heads);

  while (TRUE)
  {
    if (ESC_pressed())
    {
      getch();               /* Remove 'ESC' from keyboard buffer */
      exit_prog();
    }
    else if (ALT_pressed())
    {
      if (key_pressed())
      {
        c = waitkey();
        pulldown(heads,c,":general_info");
      }
    }
  }

  /*--------------------
    Exit this programm
  ---------------------*/
  exit(0);
  return(0);

}
