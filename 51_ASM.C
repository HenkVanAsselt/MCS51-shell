/**********************************************************************
*                                                                     *
*        FILE:  51_ASM.C                                              *
*                                                                     *
*     PURPOSE:  ASSEMBLER FUNCTIONS                                   *
*                                                                     *
* DESCRIPTION:  THIS FILE CONTAINS FUNCTIONS FOR THE 51-SHELL         *
*               FOR THE ASSEMBLER ENVIROMENT                          *
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

static void list_asmlst(void);

MENU M_ASM[] =
{
  { "Work file", 0, change_asm_wkf, "change_wkf",  asm_filename, "%s", NO_FLAGS},
  { "Edit    ",  0, edit_asm,       "edit_source", NULL, NULL, NO_FLAGS},
  { "Assemble",  0, assemble,       "assemblers",  NULL, NULL, NO_FLAGS},
  { "Listing" ,  0, list_asmlst,    "list_it",     NULL, NULL, NO_FLAGS},
  { "Options ",  0, asm_options,    "asm_options", NULL, NULL, NO_FLAGS},
  { NULL }
};

/*#+func--------------------------------------------------------------
|    FUNCTION: change_asm_wkf()
|     PURPOSE: change assembler workfile
| DESCRIPTION: Change the filename of the current assembler workfile
|     RETURNS: nothing
|     HISTORY: 911211 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void change_asm_wkf()
{
  char filename[80];
  char *path;

  strcpy(filename,asm_filename);
  path = get_dir("*.asm",filename);
  if (path != NULL) {
    strcpy(asm_filename,path);
    strcpy(workfile,asm_filename);
  }
}

/*#+func--------------------------------------------------------------
|    FUNCTION: list_asmlst()
|     PURPOSE: List assembler list file
| DESCRIPTION: -
|     RETURNS: nothing
|     HISTORY: 911127 V0.1
--#-func-------------------------------------------------------------*/
static void list_asmlst()
{
  char s[80];

  strcpy(s,asm_filename);
  base_filename(s);
  strcat(s,".lst");
  list_file(s);
}

/*-------------------------------------------------------------------
|    FUNCTION: edit_asm
|     PURPOSE: edit ASSEMBLER source file
| DESCRIPTION: calls edit_source() with source file name
|     RETURNS: nothing
|     HISTORY: 911124 V0.1 - Initial version
---------------------------------------------------------------------*/
void edit_asm()
{
  edit_source(asm_filename);
}

/*#+func---------------------------------------------------------------------
|    FUNCTION: assemble()
|     PURPOSE: Call 48/51 assembler
|      SYNTAX: void asm51(void);
| DESCRIPTION: -
|     RETURNS: nothing
|     HISTORY: 920326 V0.1
--#-func-------------------------------------------------------------------*/
void assemble()
{
  FILE *f;
  extern int force_exit;
  char command[256];
  char filename[81];

  char drive[_MAX_DRIVE],         /* Variables for _splitpath */
       dir[_MAX_DIR],
       asm[_MAX_FNAME],
       ext[_MAX_EXT];

  strcpy(filename,asm_filename);
  base_filename(filename);
  strcpy(asm,assembler_path);
  _splitpath(assembler_path,drive,dir,asm,ext);
  strupr(asm);

  printf("Assembler: <%s>\n",asm);
  getch();

  /*----------------------
    Setup command string
  -----------------------*/
  if (!strcmp(asm,"C16"))
      sprintf(command,"%s %s.asm -H %s.hex -L %s.lst",
        assembler_path,filename,filename,filename);

  else if (!strcmp(asm,"ASM51"))
      sprintf(command,"%s %s /T %s",
        assembler_path,filename,target_str);

  else if (!strcmp(asm,"A51"))
      sprintf(command,"%s %s",assembler_path,filename);

  else if (!strcmp(asm,"A48"))
      sprintf(command,"%s %s.ASM",assembler_path,filename);

  else
    command[0] = '\0';

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

/*#+func--------------------------------------------------------------
|    FUNCTION: change_assembler()
|     PURPOSE: Choose an assembler and set path and options
| DESCRIPTION: -
|     RETURNS: nothing
|     HISTORY: 911211 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void change_assembler()
{
  #define NO_MENU_ITEMS 5

  int choise;
  MENU menu[NO_MENU_ITEMS];
  char filename[80];
  char *path;

  switch(assembler_type) {
    case C16:   strcpy(assembler_str,"C16");     break;
    case ASM51: strcpy(assembler_str,"ASM51");   break;
    case A48:   strcpy(assembler_str,"A48");     break;
    case A51:   strcpy(assembler_str,"A51");     break;
    default:    strcpy(assembler_str,"Unknown"); break;
  }

  setup_menu(menu, 0, "Current assembler:",   -1,
    NULL, NULL,    assembler_str, "%s", COMMENT);
  setup_menu(menu, 1, "1  Cross-asm 'C16'",   0,
    NULL, "C16",   NULL, NULL, NULL);
  setup_menu(menu, 2, "2  System51  'ASM51'", 0,
    NULL, "ASM51", NULL, NULL, NULL);
  setup_menu(menu, 3, "3  PseudoSam 'A48'",   0,
    NULL, "A48",   NULL, NULL, NULL);
  setup_menu(menu, 4, "4  PseudoSam 'A51'",   0,
    NULL, "A51",   NULL, NULL, NULL);

  choise = popup(NO_MENU_ITEMS,menu,5,40);
  if (choise == ESC)
    return;

  switch (choise)
  {
    case '1':
      assembler_type = C16;
      strcpy(assembler_str,"C16");
      break;

    case '2':
      assembler_type = ASM51;
      strcpy(assembler_str,"ASM51");
      break;

    case '3':
      assembler_type = A48;
      strcpy(assembler_str,"A48");
      break;

    case '4':
      assembler_type = A51;
      strcpy(assembler_str,"A51");
      break;

    default:
      break;
  }

  strcpy(filename,assembler_path);
  path = get_dir("*.*",filename);
  if (path != NULL) {
    strcpy(assembler_path,path);
  }

  #undef NO_MENU_ITEMS
}

/*#+func--------------------------------------------------------------
|    FUNCTION: asm_options()
|     PURPOSE: Set assembler options
| DESCRIPTION: -
|     RETURNS: nothing
|     HISTORY: 911211 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void asm_options()
{
  #define NO_ITEMS 3
  int choise;
  MENU menu[NO_ITEMS];

  setup_menu(menu,0,"Current settings:", -1, NULL, NULL, NULL, NULL, COMMENT);
  setup_menu(menu,1,"Assembler",0,change_assembler,"assemblers",assembler_path, "%s",NO_FLAGS);
  setup_menu(menu,2,"Target   ",0,change_target,   "assemblers",target_str,    "%s",NO_FLAGS);

  while (TRUE)
  {
    choise = popup(NO_ITEMS,menu,5,40);
    if (choise == ESC)
      return;
  }

  #undef NO_ITEMS
}
