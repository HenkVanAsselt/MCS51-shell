/**********************************************************************
*                                                                     *
*        FILE:  FILIO.C                                               *
*                                                                     *
*     PURPOSE:  FILE I/O                                              *
*                                                                     *
* DESCRIPTION:  THIS FILE CONTAINS MSC-51 SHELL FILE I/O ROUTINES     *
*                                                                     *
*     HISTORY:  911124 V0.1                                           *
*               930104 V0.2 - Use a structure with header,format and  *
*                             data to make file io simpler            *
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
#include <front9.h>
#include <hva_util.h>
#include "51shell.h"

extern char *dis_filename;      /* !!! Watch out */

/*----------------------------
  Menu structure definition
-----------------------------*/
typedef struct
{
  char   *header;
  char   *format;
  void   *data;
}
IO_DATA;

static IO_DATA io_data[] = {
  { "WORK_FILENAME",  "%s", workfile         },
  { "BAS_FILENAME",   "%s", bas_filename     },
  { "ASM_FILENAME",   "%s", asm_filename     },
  { "ASSEMBLER_PATH", "%s", assembler_path   },
  { "DIS_FILENAME",   "%s", &dis_filename     },
  { "PAS_FILENAME",   "%s", pas_filename     },
  { "PAS_COMPILER",   "%s", pas_compiler     },
  { "PAS_LINKER",     "%s", pas_linker       },
  { "ASSEMBLER_TYPE", "%d", &assembler_type   },
  { "ASSEMBLER_STR",  "%s", assembler_str    },
  { "MAKE_FILENAME",  "%s", make_filename    },
  { "EDITOR_PATH",    "%s", editor_path      },
  { "TARGET",         "%s", target_str       },
  { "PASLIB1",        "%s", paslib[0]        },
  { "PASLIB2",        "%s", paslib[1]        },
  { "PASLIB3",        "%s", paslib[2]        },
  { "PASLIB4",        "%s", paslib[3]        },
  { "PASLIB5",        "%s", paslib[4]        },
  { NULL, NULL, NULL }
};

/*#+func---------------------------------------------------------------------
|    FUNCTION: save_ini()
|     PURPOSE: Save '.INI' file
|      SYNTAX: int save_ini(void);
| DESCRIPTION: -
|     RETURNS: TRUE if successfull, FALSE if not
|     HISTORY: 920316 V0.1
--#-func-------------------------------------------------------------------*/
int save_ini()
{
  FILE  *fp;
  int   i = 0;
  char  data[80];

  /*---------------
  | Open datafile
  ----------------*/
  fp = fopen("51SHELL.INI","w");
  if (!fp)
  {
    wn_error("ERROR: couldn't open 51SHELL.INI");
    return(FALSE);
  }

  /*--------------------------
    Save items of system file
  ---------------------------*/
  i = 0;
  while(io_data[i].header) {
    fprintf(fp,"%-20s",io_data[i].header);
    void_sprintf(data,io_data[i].format,io_data[i].data);
    trimstr(data);
    fprintf(fp,"%s\n",data);
    i++;
  }

  /*----------------------------
    Close datafile and return
  ----------------------------*/
  fclose(fp);
  return(TRUE);
}

/*#+func---------------------------------------------------------------------
|    FUNCTION: read_ini()
|     PURPOSE: Read '.INI' file
|      SYNTAX: int read_ini(void);
| DESCRIPTION: -
|     RETURNS: TRUE if successfull, FALSE if not
|     HISTORY: 920316 V0.1
--#-func-------------------------------------------------------------------*/
int read_ini()
{
  #define MAXCHAR 132

  FILE	*infile;
  char  s[MAXCHAR+1];
  int   i=0;
  char  format[80];
  char  dummy[80];
  char  param[80];

  /*---------------
  | Open datafile
  ----------------*/
  infile = fopen("51SHELL.INI","r");
  if (!infile)
  {
    wn_error("ERROR: couldn't open 51SHELL.INI");
    return(FALSE);
  }

  /*--------------------------
    Read system parameters
  ---------------------------*/
  while (fgets(s,MAXCHAR,infile) != NULL)
  {
    sprintf(format,"%%s %s",io_data[i].format);
    sscanf(s,format,param,dummy);
    i = 0;
    while (io_data[i].header) {
      if (!strcmp(io_data[i].header,param)) {
        trimstr(s+20);
        void_sscanf(s+20,io_data[i].format,io_data[i].data);
        break;
      }
      else
        i++;
    }
  }

  fclose(infile);
  return(TRUE);

#undef MAXCHAR

}

/*#+func--------------------------------------------------------------
|    FUNCTION: list_map()
|     PURPOSE: List a map file
| DESCRIPTION:
|     RETURNS:
|     HISTORY:
--#-func-------------------------------------------------------------*/
void list_map()
{
  char s[80];

  strcpy(s,workfile);
  base_filename(s);
  strcat(s,".map");
  list_file(s);
}

/*#+func--------------------------------------------------------------
|    FUNCTION: list_lst()
|     PURPOSE: List .lst file
| DESCRIPTION: -
|     RETURNS: nothing
|     HISTORY: 911127 V0.1
--#-func-------------------------------------------------------------*/
void list_lst()
{
  char s[80];

  strcpy(s,workfile);
  base_filename(s);
  strcat(s,".lst");
  list_file(s);
}

/*#+func--------------------------------------------------------------
|    FUNCTION: list_asm()
|     PURPOSE: List .asm file
| DESCRIPTION: -
|     RETURNS: nothing
|     HISTORY: 911127 V0.1
--#-func-------------------------------------------------------------*/
void list_asm()
{
  char s[80];

  strcpy(s,workfile);
  base_filename(s);
  strcat(s,".asm");
  list_file(s);
}

/*#+func----------------------------------------------------------------
|    FUNCTION: list_file()
|     PURPOSE: List a file
| DESCRIPTION: File can be listed by 2 methods:
|              (1) By 4DOS 'list' command (using system() instead of spawn()
|              (2) By calling editor.
|              4DOS will be automatically detected.
|     RETURNS: nothing
|     HISTORY: 911212 V0.1 - Initial version
|              911217 V0.2 - Automatic detection of 4DOS added. If no
|                            4DOS present, function will call the editor
--#-func----------------------------------------------------------------*/
void list_file(char *filename)
{
  char command_str[80];
  WINDOW *w;

  /*----------------------------
    Open standard DOS window
  -----------------------------*/
  w = wn_open(_NO_BORDER,MINROW,MINCOL,MAXXSIZE,MAXYSIZE,
              16*BLACK+WHITE,16*BLACK+WHITE);

  if (detect_4DOS())
  {
    sprintf(command_str,"list %s",filename);
    system(command_str);
  }
  else
  {
    edit_source(filename);
  }

  w = wn_close(w);
}
