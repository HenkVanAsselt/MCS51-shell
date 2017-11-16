/**********************************************************************
*                                                                     *
*        FILE:  51_PAS.C                                              *
*                                                                     *
*     PURPOSE:  PASCAL functions                                      *
*                                                                     *
* DESCRIPTION:  THIS FILE CONTAINS FUNCTIONS FOR THE 51-SHELL         *
*               FOR THE PASCAL ENVIROMENT                             *
*                                                                     *
*     HISTORY:  911211 V0.1                                           *
*                                                                     *
**********************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include <window.h>
#include <time.h>
#include <dos.h>
#include <hva_util.h>
#include <front9.h>
#include "51shell.h"

MENU M_PASCAL[] =
{
  { "Work file", 0, change_pas_wkf, "change_wkf",     pas_filename, "%s" },
  { "Edit    ",  0, edit_pas,       "edit_source",    NULL, NULL, },
  { "Compile ",  0, pascal51,       "pas_compilers",  NULL, NULL, },
  { "List    ",  1, list_asm,       "list_it",        NULL, NULL, },
  { "Assemble",  0, assemble,       "asm51",          NULL, NULL, },
  { "Link    ",  0, link51,         "link51",         NULL, NULL, },
  { "Map     ",  0, list_map,       "list_it",        NULL, NULL, },
  { "Options ",  0, pas_options,    "pas_options",    NULL, NULL, },
  { NULL }
};

/*#+func--------------------------------------------------------------
|    FUNCTION: change_pas_wkf()
|     PURPOSE: change pascal workfile
| DESCRIPTION: Change the filename of the current pascal workfile
|     RETURNS: nothing
|     HISTORY: 911211 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void change_pas_wkf()
{
  char filename[80];
  char *path;

  strcpy(filename,pas_filename);
  path = get_dir("*.pas",filename);
  if (path != NULL) {
    strcpy(pas_filename,path);
    strcpy(workfile,pas_filename);
  }
}

/*-------------------------------------------------------------------
|    FUNCTION: edit_pas
|     PURPOSE: edit PASCAL source file
| DESCRIPTION: calls edit_source() with source file name
|     RETURNS: nothing
|     HISTORY: 911124 V0.1 - Initial version
---------------------------------------------------------------------*/
void edit_pas()
{
  edit_source(pas_filename);
}

/*-------------------------------------------------------------------
|    FUNCTION: do_compile
|     PURPOSE: invoke pascal compiler
| DESCRIPTION: Open a window, call compiler and close window.
|     RETURNS: nothing
|     HISTORY: 911216 V0.1 - Initial version
---------------------------------------------------------------------*/
void pascal51()
{
  FILE *f;
  extern int force_exit;
  char file[50];
  char command[80];
  int ret;

  strcpy(file,pas_filename);
  base_filename(file);

  sprintf(command,"%s %s /T %s",pas_compiler,file,target_str);
  ret = editstr(10,10,40,"Command line: ",command,1);
  if (ret == ESC)
    return;

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
  fprintf(f,"%s\n",command);
  fprintf(f,"pause\n");
  fprintf(f,"shell");
  fclose(f);

  /*---------------------------------------------
    Exit the program to execute batchfile
  ----------------------------------------------*/
  force_exit = CALL_EXECUTE;
  exit(CALL_EXECUTE);
}

/*-------------------------------------------------------------------
|    FUNCTION: do_link
|     PURPOSE: invoke pascal linker
| DESCRIPTION: Open a window, call linker and close window.
|     RETURNS: nothing
|     HISTORY: 911216 V0.1 - Initial version
---------------------------------------------------------------------*/
/*///////////////////////////////////////////////////////////////////////////

Invocation: (V3.10)

LINK51[ -M-]{ -switch} first_file{{ -switch}  other_files}[ -H]

where possible switches are Xxxxx Oxxxx Dxx,
first_file is a file with extension .OBJ and makes a .A51 and possibly .HEX
other_files are object or library files.
-M- will force no map file. xxxx are hex numbers. -H will generate .HEX file

////////////////////////////////////////////////////////////////////////////*/

void link51()
{
  int i;
  char filename[80];
  extern int force_exit;
  char command[256];
  FILE *batchfile;

  /*------------------
    Command setup
  ------------------*/
  strcpy(filename,workfile);
  base_filename(filename);
  sprintf(command,"%s %s ",pas_linker,filename);

  /*---------------------------
    Add the libraries to link
  ----------------------------*/
  for (i=0 ; i<5 ; i++) {
    if (paslib[i] && (paslib[i][0] != '\0')) {
      strcat(command,paslib[i]);
      strcat(command," ");
    }
  }

  /*-----------------------------------------------------
    Open the batchfile 'execute.bat'
  ------------------------------------------------------*/
  batchfile = fopen("execute.bat","w");
  if (!batchfile) {
    wn_printf(io_window,"Error in opening execute.bat\n");
    wn_printf(io_window,"\nPress any key to continue ...\n");
    getch();
    return;
  }

  /*---------------------------------------
    Write commands to the batch file
  ---------------------------------------*/
  fprintf(batchfile,"@echo on\n");
  fprintf(batchfile,"%s\n",command);
  fprintf(batchfile,"pause\n");
  fprintf(batchfile,"shell");

  /*---------------------------------------
    Close the batchfile
  ---------------------------------------*/
  fclose(batchfile);

  /*---------------------------------------------
    Exit the program to execute batchfile
  ----------------------------------------------*/
  force_exit = CALL_EXECUTE;
  exit(CALL_EXECUTE);
}

/*#+func-----------------------------------------------------------------------
    FUNCTION: set_paslibs()
     PURPOSE: Set the pascal libraries to call with pascal linker
      SYNTAX: void set_paslibs(void);
 DESCRIPTION: -
     RETURNS: nothing
     HISTORY: 01-Jan-1993 21:39:46 V0.1 - Initial version
--#-func----------------------------------------------------------------------*/
void set_paslibs(void)
{
  #define NO_MENU_ITEMS 5

  int choise;
  MENU menu[NO_MENU_ITEMS];

  setup_menu(menu, 0, "1 ", 0, NULL,"pas_compilers", paslib[0], "%s", EDIT_STR);
  setup_menu(menu, 1, "2 ", 0, NULL,"pas_compilers", paslib[1], "%s", EDIT_STR);
  setup_menu(menu, 2, "3 ", 0, NULL,"pas_compilers", paslib[2], "%s", EDIT_STR);
  setup_menu(menu, 3, "4 ", 0, NULL,"pas_compilers", paslib[3], "%s", EDIT_STR);
  setup_menu(menu, 4, "5 ", 0, NULL,"pas_compilers", paslib[4], "%s", EDIT_STR);

  while (TRUE)
  {
    choise = popup(NO_MENU_ITEMS,menu,13,27);
    if (choise == ESC || choise == 'E')
      return;
  }

  #undef NO_MENU_ITEMS
}

/*#+func--------------------------------------------------------------
|    FUNCTION: pas_options()
|     PURPOSE: Set pascal options
| DESCRIPTION: -
|     RETURNS: nothing
|     HISTORY: 911203 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void pas_options()
{
  #define NO_MENU_ITEMS 4
  int choise;
  MENU menu[NO_MENU_ITEMS];

  char filename[80];
  char *path;

  setup_menu(menu, 0, "Compiler  ", 0, NULL,
    "pas_compilers", pas_compiler, "%s", NO_FLAGS);
  setup_menu(menu, 1, "Linker    ", 0, NULL,
    "pas_compilers", pas_linker, "%s", NO_FLAGS);
  setup_menu(menu, 2, "Libraries ", 2, set_paslibs,
    "pas_compilers", set_paslibs, NULL, NO_FLAGS);
  setup_menu(menu, 3, "Target    ", 0, change_target,
    "target", target_str, "%s", NO_FLAGS);

  while (TRUE)
  {
    choise = popup(NO_MENU_ITEMS,menu,10,18);
    switch(choise) {
      case ESC: return;
                break;
      case 'C': strcpy(filename,pas_compiler);
                path = get_dir("*.*",filename);
                if (path != NULL)
                  strcpy(pas_compiler,path);
                break;
      case 'L': strcpy(filename,pas_linker);
                path = get_dir("*.*",filename);
                if (path != NULL)
                  strcpy(pas_linker,path);
                break;
      default:  break;
    }
  }

  #undef NO_MENU_ITEMS
}
