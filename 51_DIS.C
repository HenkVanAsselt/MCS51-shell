/*******************************************************************************
*                                                                              *
*        FILE: DIS51.C                                                         *
*                                                                              *
*     PURPOSE: MCS51 disassembler                                              *
*                                                                              *
* DESCRIPTION: Disassembles INTEL HEX-16 and BIN code.                         *
*                                                                              *
*     HISTORY: 911230 V0.1                                                     *
*                                                                              *
*******************************************************************************/

/*------------------------------------------------------------------------------
                        HEADER FILES
------------------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <conio.h>
#include <time.h>
#include <stdarg.h>

#define MAIN_51_DIS_MODULE
char dis_filename[80];          /* !!!! Watch out */

#include <window.h>
#include <hva_util.h>
#include "51shell.h"
#include "51_dis.h"


/*---------------------------------------------------------------------------
                        GLOBAL VARIABLES
---------------------------------------------------------------------------*/
int  verbose = FALSE;
int  debug   = 0;
FILE *outfile;

/*---------------------------------------------------------------------------
                        LOCAL VARIABLES
---------------------------------------------------------------------------*/
BYTE *obj_code = NULL;      /* Pointer to object code in memory  */

LABEL *first_label = NULL;   /* Start label entry of double linked list */
LABEL *last_label  = NULL;   /* Last label entry of double linked list  */

int  filetype = 0;
int  datatype = CODEADDR;
char info_str[80];
char hex_str[STRLEN];
char instr_str[STRLEN];
char comment_str[80];
int  pass = 0;
char basename[80];

ADDRESS     start_address = 0;     /* Start address of disassmbly       */
ADDRESS     end_address = 0;       /* Endaddress of objectcode          */
char        *linelabel = NULL;
int         save_mode = FALSE;
int         asm_output = FALSE;

ARG arg_tabel[] =
{
  { 'f', STRING,  &dis_filename, "File to disassemble"                },
  { 'a', BOOLEAN, &asm_output,   "ASM output (default = LST)"         },
  { 't', STRING,  &target_str,   "Target processor (8048/8051/8052)"  },
  { 'v', BOOLEAN, &verbose,      "Verbose output"                     },
  { 'd', BOOLEAN, &debug,        "Debug output"                       },
  { 's', BOOLEAN, &save_mode,    "Save output mode"                   },
};

/*---------------------------------------------------------------------------
                        PROTOTYPES
---------------------------------------------------------------------------*/
void print_labels(int type);
void print_equations(int type);
void disassemble(void);
void print_header(char *filename, int asm_output);
int pass1(ADDRESS start_address, ADDRESS end_address);
int pass2(ADDRESS start_address, ADDRESS end_address);
void check_intr_addr(ADDRESS pc);
void check_if_called(ADDRESS pc);

/*==============================================================================
                        START OF FUNCTIONS
==============================================================================*/

/*#+func---------------------------------------------------------------------
|    FUNCTION: list_dis()
|     PURPOSE: list disassembled file
| DESCRIPTION: -
|     RETURNS: nothing
|     HISTORY: 920102 V0.1
--#-func-------------------------------------------------------------------*/
void list_dis()
{
  char s[80];

  strcpy(s,dis_filename);
  base_name(s);
  strcat(s,".dis");
  list_file(s);
}

/*#+func--------------------------------------------------------------
|    FUNCTION: edit_label
|     PURPOSE: edit disassembler label file
| DESCRIPTION: calls edit_source() with label file name
|     RETURNS: nothing
|     HISTORY: 911124 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void edit_label()
{
  char filename[STRLEN];

  strcpy(filename,dis_filename);
  base_filename(filename);
  strcat(filename,".lbl");
  edit_source(filename);
}

/*#+func--------------------------------------------------------------
|    FUNCTION: disassemble
|     PURPOSE: Call external disassemble program
| DESCRIPTION:
|     RETURNS: nothing
|     HISTORY: 920407 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void disassemble()
{
  char command[256];
  WINDOW *w;

  /*--------------------------
    Open the compile window
  --------------------------*/
  w = wn_open(_NO_BORDER,MINROW,MINCOL,MAXXSIZE,MAXYSIZE,
              16*BLACK+WHITE,16*BLACK+WHITE);

  /*----------------------
    Setup command string
  -----------------------*/
  sprintf(command,"51_dis -f%s -t%s",
        dis_filename,target_str);
  wn_printf(w,"CALLING DISASSEMBLER:\n%s\n",command);

  call(command);

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


/*#+func--------------------------------------------------------------
|    FUNCTION: change_dis_wkf()
|     PURPOSE: change disassemble workfile
| DESCRIPTION: Change the filename of the current file to disassemble
|     RETURNS: nothing
|     HISTORY: 911230 V0.1 - Initial version
--#-func-------------------------------------------------------------*/
void change_dis_wkf()
{
  #define NO_ITEMS 3

  char filename[STRLEN];
  char mask[STRLEN];
  int choise = ESC;
  static MENU menu[NO_ITEMS];

  setup_menu(menu,0, " HEX ", 1, NULL, "", NULL, NULL, EXIT );
  setup_menu(menu,1, " BIN ", 1, NULL, "", NULL, NULL, EXIT );
  setup_menu(menu,2, " OBJ ", 1, NULL, "", NULL, NULL, EXIT );

  choise = popup(NO_ITEMS,menu,5,40);

  switch(choise)
  {
    case 'H': strcpy(mask,"*.hex"); break;
    case 'B': strcpy(mask,"*.bin"); break;
    case 'O': strcpy(mask,"*.obj"); break;
  }

  strcpy(filename,dis_filename);

  if (get_dir(mask,filename) != NULL)
  {
    strupr(filename);
    strcpy(dis_filename,filename);
  }
  strcpy(workfile,dis_filename);

  #undef NO_ITEMS
}

/*#+func-------------------------------------------------------------------
   FUNCTION: output()
    PURPOSE: Log output to a log file
     SYNTAX: void log(char *format, ...);
DESCRIPTION: -
    RETURNS: nothing
    HISTORY: 920325 V0.1 - Initial version
--#-func-------------------------------------------------------------------*/
void output(char *format, ...)
{
  va_list arguments;
  static FILE *fp = NULL;
  static int first_time = TRUE;

  if (save_mode) {

    if (first_time) {
      fp = fopen("work.dis","w");
      fclose(fp);
      fp = NULL;
      first_time = FALSE;
    }

    fp = fopen("work.dis","r+");
    if (!fp) {
      fprintf(stderr,"\nCannot open %s\n\a",basename);
      return;
    }
    else {
      va_start(arguments,format);
      if (verbose) vprintf(format,arguments);
        fseek(fp,0L,SEEK_END);
      vfprintf(fp,format,arguments);
      va_end(arguments);
        fclose(fp);
    }
  }

  else {
    va_start(arguments,format);
    if (verbose) vprintf(format,arguments);
    vfprintf(outfile,format,arguments);
    va_end(arguments);
  }

}

/*-------------------------------------------------------------------
|   FUNCTION: add_label()
|    PURPOSE: Add label label tabel
| DESRIPTION: Checks if the address is not already in the table. If
|             so, the labeltype will be adjusted with the new given
|             type. If the address is not in the table, a label will
|             be generated (L_xxxx) and put in the table.
|             If the codelabel is of the string type, the length of
|             the string will also be added. Otherwise it will be 0.
|    RETURNS: 0 if all OK,
|             -1 if not
|             -2 if label and type already found.
|    VERSION: 901216 V0.1
|             920316 V0.2 - Added .length field for DATASTRING labels
---------------------------------------------------------------------*/
int add_label(ADDRESS address, char *label, int type, int length, char *comment)
{
  LABEL *entry;
  LABEL *ptr;
  char  tmp_label[40];

  /*
  if (debug) output("add_label(%04X,%-s,%02x,%d,%s)\n",
    address,label,type,length,comment);
  */

  /*---------------------------------------------------------
    Check if address with given type is already in the table
  ----------------------------------------------------------*/
  ptr = find_label(address,type);
  if (ptr) {
    ptr->type |= type;
    return(1);
  }

  /*-----------------------------------------------
    Address and type are not already in the list.
    Allocate memory for the label entry
  ------------------------------------------------*/
  entry = calloc(1,sizeof(LABEL));
  if (!entry) {
    fprintf(stderr,"not enough memory\n");
    return(-1);
  }

  /*------------------------------
    Fill the fields of the entry
  -------------------------------*/
  entry->addr   = address;
  entry->type   = type;
  if (length < 1)
    length = 1;
  entry->length = length;

  if (!label || label[0]=='\0') {
    /*---------------------------------------------------
      No label given, generate an address for the label
    ----------------------------------------------------*/
    sprintf(tmp_label,"L_%04X",address);
    entry->label  = strdup(tmp_label);
    entry->type |= AUTODEF;           /* Mark as internal generated label */
  }
  else {
    /*-----------------------------
      Label given, use this label
    ------------------------------*/
    entry->label = strdup(label);
  }

  /*-----------------------------
    Add comment to label table
  -----------------------------*/
  if (comment)
    entry->comment = strdup(comment);
  else
    entry->comment = NULL;

  /*-----------------------------------------------------
    Place the label (sorted) in the table of data labels
  -------------------------------------------------------*/
  first_label = DLSortStore(entry,first_label,&last_label);
  return(0);

}

/*--------------------------------------------------------------------------
|   FUNCTION: datalength()
|    PURPOSE: Find the DATASTRING length of the address in the code_label tabel
| DESRIPTION: -
|    RETURNS: Length of the DATASTRING started on this address.
|             0 if address not found.
|    VERSION: 901216 V0.1
|             920316 V0.2
--------------------------------------------------------------------------*/
int datalength(ADDRESS address)
{
  LABEL *ptr;

  ptr = search_label(first_label,address);
  if (ptr)
    return(ptr->length);
  else
    return(1);
}

/*-------------------------------------------------------------------
    FUNCTION: find_label()
     PURPOSE: Find the label entry of an address with a specific
              datatype in the label table.
      SYNTAX: LABEL *find_label(ADDRESS address, int type);
 DESCRIPTION: If an address is found in the table, but the types don't
              match, then we will continue the search.
     RETURNS: Pointer to the label entry in the table,
              NULL if address not found.
     VERSION: 901216 V0.1
---------------------------------------------------------------------*/
LABEL *find_label(ADDRESS address, int type)
{
  LABEL *ptr;

  ptr = first_label;

  do {
    ptr = search_label(ptr,address);
    if (!ptr) {               /* Address not found at all */
      return(NULL);
    }
    if (ptr->type & type)     /* If types match, return pointer to label */
      return(ptr);
    else
      ptr = ptr->next;        /* Else continue searching */
  }
  while (TRUE);
}

/*-------------------------------------------------------------------
|   FUNCTION: add_da_comment()
|    PURPOSE: Add data address comment to comment string
| DESRIPTION: -
|    RETURNS: nothing
|    VERSION: 920113 V0.1
---------------------------------------------------------------------*/
void add_da_comment(ADDRESS address)
{
  char *dc = NULL;

  if (target == 8052)
  {
    switch((int) address)
    {
      case 0x00 : dc = "Not used, reserved                          "; break;
      case 0x01 : dc = "Not used, reserved                          "; break;
      case 0x02 : dc = "Not used, reserved                          "; break;
      case 0x03 : dc = "Not used, reserved                          "; break;
      case 0x04 : dc = "Length of the current edited line           "; break;
      case 0x05 : dc = "'LN NUM' in bin. of current edited line (H) "; break;
      case 0x06 : dc = "'LN NUM' in bin. of current edited line (L) "; break;
      case 0x5e : dc = "Used for 'RUN' trap mode (=34h)             "; break;
      case 0x5f : dc = "Used for 'POWER-UP' trap (=0A5h)            "; break;
      case 0xff : dc = "Control stack overflow                      "; break;
      case 0x100: dc = "Location to save 'GET' character            "; break;
      case 0x101: dc = "Location to save error character code       "; break;
      case 0x102: dc = "Location to go to on user 'ONERR' (H)       "; break;
      case 0x103: dc = "Location to go to on user 'ONERR' (L)       "; break;
      case 0x104: dc = "Top of variable storage (H)                 "; break;
      case 0x105: dc = "Top of variable storage (L)                 "; break;
      case 0x106: dc = "FP storage allocation (H)                   "; break;
      case 0x107: dc = "FP storage allocation (L)                   "; break;
      case 0x108: dc = "Memory allocated for matrices (H)           "; break;
      case 0x109: dc = "Memory allocated for matrices (L)           "; break;
      case 0x10a: dc = "Top of memory assigned to basic (H)         "; break;
      case 0x10b: dc = "Top of memory assigned to basic (L)         "; break;
      case 0x10c: dc = "Random number seed (H)                      "; break;
      case 0x10d: dc = "Random number seed (L)                      "; break;
      case 0x120: dc = "Location to go to on 'ONEX1' interrupt (H)  "; break;
      case 0x121: dc = "Location to go to on 'ONEX1' interrupt (L)  "; break;
      case 0x122: dc = "Number of bytes allocated for strings (H)   "; break;
      case 0x123: dc = "Number of bytes allocated for strings (L)   "; break;
      case 0x124: dc = "Software serial port baudrate (H)           "; break;
      case 0x125: dc = "Software serial port baudrate (L)           "; break;
      case 0x126: dc = "Line number for 'ONTIME' interrupt (H)      "; break;
      case 0x127: dc = "Line number for 'ONTIME' interrupt (L)      "; break;
      case 0x128: dc = "'NORMAL' PROM programmer timeout (H)        "; break;
      case 0x129: dc = "'NORMAL' PROM programmer timeout (L)        "; break;
      case 0x12A: dc = "'INTELLIGENT' PROM programmer time out (H)  "; break;
      case 0x12b: dc = "'INTELLIGENT' PROM programmer time out (L)  "; break;
      case 0x12C: dc = "Reserved                                    "; break;
      default:    dc = NULL; break;
    }

    if (dc)
      strcat(comment_str,dc);

  }
}

/*-------------------------------------------------------------------
|   FUNCTION: get_codetype(ADDRESS address)
|    PURPOSE: -
| DESRIPTION: -
|    RETURNS: address type
|    VERSION: -
---------------------------------------------------------------------*/
int get_codetype(ADDRESS address)
{
  static int old_type = CODEADDR;
  LABEL *ptr;

  ptr = find_label(address,CODE);
  if (ptr)
    old_type = ptr->type;
  return(old_type);

}

/*-------------------------------------------------------------------
|   FUNCTION: print_equations(int type)
|    PURPOSE: print user defined data labels as equations in outputfile
| DESRIPTION: -
|    RETURNS: nothing
|    VERSION: 901216 V0.1
---------------------------------------------------------------------*/
void print_equations(int type)
{
  LABEL *ptr;

  output(";****************************************\n;  ");
  if (type == EXTERNAL)
    output("EXTERNAL DATA DEFINITIONS\n");
  else if (type == BITADDR)
    output("BIT ADDRESSES\n");
  else if (type == INTERNAL)
    output("INTERNAL DATA DEFINITIONS\n");
  output(";****************************************\n");

  /*------------------------------------------------------
  | Print labels as equations (on start of assembler file)
  --------------------------------------------------------*/
  ptr = first_label;
  while (ptr) {
    if ((ptr->type & type) && !(ptr->type & AUTODEF)) {
      output("%-18s  EQU  0%04XH  ",
        ptr->label,ptr->addr & 0xFFFF);
      if (ptr->comment)
        output(";%s",ptr->comment);
      output("\n");
    }
    ptr = ptr->next;
  }
}

/*-------------------------------------------------------------------
|   FUNCTION: print_labels(int type)
|    PURPOSE: print labels on screen and in disassembly file
| DESRIPTION: -
|    RETURNS: nothing
|    VERSION: 901216 V0.1
---------------------------------------------------------------------*/
void print_labels(int type)
{
  int  i = 0;
  LABEL *ptr;
  int   len;

  /*-------------------
  | Print header line
  --------------------*/
  output(";****************************************\n;  ");
  if (type == CODE)
    output("CODE LABLE TABLE:\n");
  if (type == CALLED)
    output("SUBROUTINES:\n");
  output(";****************************************\n");

  /*-------------------
  | Print code labels
  -------------------*/
  ptr = first_label;
  i = 0;
  while (ptr)
  {
    /*------------------------------
      Print a label entry (if any)
    -------------------------------*/
    if (ptr) {
      /* Check if correct type and not internally defined */
      if ((ptr->type & type) && !(ptr->type & AUTODEF)) {
        len = strlen(ptr->label);
        output("%s:",ptr->label);
        output("%*.*s",20-len,20-len,"                                 ");
        output("%04XH ",ptr->addr);
        if (ptr->comment)
          output(";%s",ptr->comment);
        output("\n");
        i++;
      }
      ptr = ptr->next;
    }
  }
  output("\n");
}

/*-------------------------------------------------------------------
    FUNCTION: process_instruction();
     PURPOSE: -
  DESRIPTION: Will only be called during pass 2 if pc is a CODEADDRESS
     RETURNS: next address;
     VERSION: 901216 V0.1
---------------------------------------------------------------------*/
ADDRESS process_instruction(ADDRESS opcode_address)
{
  ADDRESS pc;            /* Address of opcode          */
  char    *s;            /* Pointer to mnemonic string */
  int     len;           /* Instruction length         */
  BYTE    b1;            /* Instruction byte 1         */
  BYTE    b2;            /* Instruction byte 2         */
  BYTE    b3;            /* Instruction byte 3         */
  ADDRESS ba;            /* Bit Address                */
  ADDRESS da;            /* Data Address               */
  ADDRESS ca;            /* Code Address               */
  int     id;            /* Immediate data             */

  char    tmp[STRLEN];
  char    s1[STRLEN];
  char    *token;
  char    *ptr;
  char    c;
  char    *label;
  int     var1;
  ADDRESS newpc;
  LABEL   *labelptr;

  /*----------------------
  | Get instruction data
  -----------------------*/
  pc = opcode_address;
  if (target == 8051 || target == 8052)
    s = decode_51(obj_code,pc,&len,&b1,&b2,&b3,&ba,&da,&ca,&id);
  else if (target == 8048)
    s = decode_48(obj_code,pc,&len,&b1,&b2,&b3,&ba,&da,&ca,&id);
  trimstr(s);

  if (debug)
    output("pc=%0x l=%d %02x%02x%02x ba=%0x ca=%0x da=%0x id=%0x\n%s\n",
      pc,len,b1,b2,b3,ba,ca,da,id,s);

  check_intr_addr(pc);
  check_if_called(pc);

  /*--------------------
    Build HEX string
  --------------------*/
  if (!asm_output)     /* !asm_output == LST output */
  {
    switch(len)
    {
       case 1:  sprintf(hex_str,"%02x",        b1);        break;
       case 2:  sprintf(hex_str,"%02x%02x"    ,b1,b2);     break;
       case 3:  sprintf(hex_str,"%02x%02x%02x",b1,b2,b3);  break;
       default: hex_str[0] = '\0';
    }
  }

  /*-------------
    Build code
  -------------*/
  strcpy(s1,s);      /* Copy mnemonic string */
  ptr = s1;
  instr_str[0] = '\0';

  /*--------------------------------------
    Check for first value in the string
  ---------------------------------------*/
  var1 = FALSE;
  token = strpbrk(s1,"bcdi");    /* BITADDR, CODEADDR, DATAADDR, IMMEDIATE */
  if (token)
  {
    var1 = TRUE;
    c = *token;
    ptr = token+1;
    *token = '\0';
    strcat(instr_str,s1);

    switch(c)
    {
      case 'b':   /* BITADDR */
        labelptr = find_label(ba,BITADDR);
        if (labelptr)
          sprintf(tmp,"%s",labelptr->label);
        else
          sprintf(tmp,"%02Xh",ba);
        strcat(instr_str,tmp);
        break;
      case 'c':  /* CODEADDR */
        labelptr = find_label(ca,CODEADDR);
        if (labelptr)
          sprintf(tmp,"%s",labelptr->label);
        else
          sprintf(tmp,"%04Xh",ca);
        strcat(instr_str,tmp);
        break;
      case 'd':  /* EXTERNAL */
        /*
        add_da_comment(da);
        */
        labelptr = find_label(da,EXTERNAL);
        if (labelptr)
          sprintf(tmp,"%s",labelptr->label);
        else
          sprintf(tmp,"%04Xh",da);
        strcat(instr_str,tmp);
        break;
      case 'i':  /* IMMEDIATE */
        sprintf(tmp,"0%-xh",id);
        strcat(instr_str,tmp);
        break;
      default:
        break;
    }

    *token = '\0';       /* Replace character by a '\0' */
  }
  else
  {
    /*------------------------------------------------------
      No token found. This means there is no operand with a
      special value found
    --------------------------------------------------------*/
    strcat(instr_str,s);
  }

  if (var1)
  {
    /*--------------------------------------
      Check for second value in the string
    ---------------------------------------*/
    token = strpbrk(ptr,"bcdi");    /* BITADDR, CODEADDR, DATAADDR, IMMEDIATE */
    if (token)
    {
      c = *token;
      /*-----------------------------------------
        Print characters between the two tokens
      -------------------------------------------*/
      *token = '\0';
      strcat(instr_str,ptr);
      ptr = token+1;

      switch(c)
      {
        case 'b':   /* BITADDR */
          labelptr = find_label(ba,BITADDR);
          if (labelptr)
            strcat(instr_str,labelptr->label);
          break;
        case 'c':  /* CODEADDR */
          labelptr = find_label(ca,CODEADDR);
          if (labelptr)
            sprintf(tmp,"%s",labelptr->label);
          else
            sprintf(tmp,"%04Xh",ca);
          strcat(instr_str,tmp);
          break;
        case 'd':  /* DATAADDR */
          /*-------------------------------------------------
            Handle exception: 0x85= mov data addr, data addr
          --------------------------------------------------*/
          if (b1 == 0x85)
            da = ca;
          /*
          add_da_comment(da);
          */
          labelptr = find_label(da,EXTERNAL);
          if (labelptr)
            sprintf(tmp,"%s",labelptr->label);
          else
            sprintf(tmp,"D_%04Xh",da);
          strcat(instr_str,tmp);
          break;
        case 'i':  /* IMMEDIATE */
          sprintf(tmp,"0%-Xh",id);
          strcat(instr_str,tmp);
          break;
        default:
          break;
      }

      if (*ptr)
        strcat(instr_str,ptr);

    }
    else
    {
      /*-----------------------------------------------------------
        No token found. This means there is no 2nd operand with a
        special value found
      -----------------------------------------------------------*/
      strcat(instr_str,ptr);
    }
  }

  /*-----------------------------------------------
    Place extra return after RET and RETR for 8048
  ------------------------------------------------*/
  if (target == 8048 && (b1 == 0x83 || b1 == 0x93))
    strcat(comment_str,"\n");

  /*-----------------------------------------------
    Place extra return after RET and RETI for 8051
  ------------------------------------------------*/
  if ((target == 8051 || target == 8052)
      && (b1 == 0x22 || b1 == 0x32))
    strcat(comment_str,"\n");

  /*----------------------------------------
    Check on mixing data and address labels
  ------------------------------------------*/
  newpc = (ADDRESS) 0;
  switch(len)
  {
    case 2:
      labelptr = find_label(pc+1,CODEADDR);
      if (labelptr)
        newpc = (ADDRESS)pc+1;
      break;
    case 3:
      labelptr = find_label(pc+1,CODEADDR);
      if (labelptr)
        newpc = pc+1;
      else
      {
        labelptr = find_label(pc+2,CODEADDR);
        if (labelptr)
          newpc = (ADDRESS)pc+2;
      }
      break;
    default:
      newpc = (ADDRESS) 0;
      break;
  }
  if (newpc)
    strcat(info_str,"?");

  strcat(instr_str,"\n");

  if (newpc)
  {
    if (pass == 2)
      output("\n; phase error, pc = %04X label = %s new pc = %04X\n\n",
        pc,label,newpc);
    return(newpc);
  }
  else
  {
    return(opcode_address+len);
  }

}

/*-------------------------------------------------------------------
|   FUNCTION: process_data();
|    PURPOSE: -
| DESRIPTION: Will only be called in pass 2
|    RETURNS: next address;
|    VERSION: 901216 V0.1
---------------------------------------------------------------------*/
ADDRESS process_data(ADDRESS pc)
{
  int     type;
  char    tmp[80];
  int     i;
  int     len;

  /*-----------------------
    Initialize variables
  ------------------------*/
  type = get_codetype(pc);
  strcpy(instr_str,"DFB   ");
  hex_str[0] = '\0';

  /*--------------------------
     Build STRING expression
  ---------------------------*/
  if (type & CODESTRING) {
    strcpy(instr_str,"DFB   ");
    len = datalength(pc);
    i = 0;
    while (i < len) {
      if (isprint(obj_code[pc]))
        strcat(instr_str,"\"");
      while (i<len && isprint(obj_code[pc+i])) {
        sprintf(tmp,"%c",obj_code[pc+i]);
        strcat(instr_str,tmp);
        sprintf(tmp,"%02x",obj_code[pc+i]);       /* Build hex string */
        strcat(hex_str,tmp);
        i++;
        if (!isprint(obj_code[pc+i]))
          strcat(instr_str,"\",");
      }
      while (i<len && !isprint(obj_code[pc+i])) {
        sprintf(tmp,"%02xh,",obj_code[pc+i]);
        strcat(instr_str,tmp);
        sprintf(tmp,"%02x",obj_code[pc+i]);       /* Build hex string */
        strcat(hex_str,tmp);
        i++;
      }
    }
    return(pc+len);
  }

  else if (type & CODEDATA) {
    strcpy(instr_str,"DFB   ");
    len = datalength(pc);
    sprintf(tmp,"L=%d ",len);
    strcat(instr_str,tmp);
    i = 0;
    if (len == 2) {      /* 2 bytes fixed address in code data */
      sprintf(tmp,"%02x%02xh ",obj_code[pc],obj_code[pc+1]);
      strcat(instr_str,tmp);
    }
    else {
      while (i < len) {
        sprintf(tmp,"%02xh,",obj_code[pc+i]);
        strcat(instr_str,tmp);
        i++;
        type = get_codetype(pc+i);
        if (pc+i > end_address)
          return(pc+i);
      }
    }
    return(pc+len);
  }

}

/*-------------------------------------------------------------------
|   FUNCTION: pass1()
|    PURPOSE: pass 1 of disassembly object code in memory
| DESRIPTION: Main purpose it to get the target_addresses of
|             JUMP and CALL instructions.
|    RETURNS: 0=successfull, <0=failure
|    VERSION: 901212 V0.1
---------------------------------------------------------------------*/
int pass1(ADDRESS start_address, ADDRESS end_address)
{
  ADDRESS pc;            /* Address of opcode          */
  int     l;             /* Instruction length         */
  BYTE    b1;            /* Instruction byte 1         */
  BYTE    b2;            /* Instruction byte 2         */
  BYTE    b3;            /* Instruction byte 3         */
  ADDRESS ba;            /* Bit Address                */
  ADDRESS da;            /* Data Address               */
  ADDRESS ca;            /* Code Address               */
  int     id;            /* Immediate data             */
  char    *s;

  pass = 1;

  datatype = CODEADDR;             /* Reset datatype */

  pc = start_address;
  printf("PASS 1: pc = %04X",pc);
  while (pc < end_address)
  {
    if (CTRLC_pressed())
      exit(0);

    /*------------------------
      Show that we are busy
    ------------------------*/
    if (pc%8 == 0)
      printf("\b\b\b\b%04X",pc);

    /*---------------------
    | Process instruction
    ----------------------*/
    datatype = get_codetype(pc);
    if (datatype & CODESTRING)
    {
      l = datalength(pc);
      pc += l;
    }
    else if (datatype & CODEADDR)
    {
      if (target == 8051 || target == 8052) {
        s = decode_51(obj_code,pc,&l,&b1,&b2,&b3,&ba,&da,&ca,&id);
      }
      else if (target == 8048) {
        s = decode_48(obj_code,pc,&l,&b1,&b2,&b3,&ba,&da,&ca,&id);
      }
      trimstr(s);

      if (debug)
        output("%02x%02x%02x l=%d pc=%0x mnemonic=%-15s ba=%0x ca=%0x da=%0x ca=%0x id=%0x\n",
          b1,b2,b3,l,pc,s,ba,ca,da,id);

      /*-------------------------------
        Add bit-address to label list
      -------------------------------*/
      if (ba != 0xFFFF)
        add_label(ba,"",BITADDR,1,NULL);

      /*-------------------------------
        Add data-address to label list
      --------------------------------*/
      if (da != 0xFFFF)
        add_label(da,"",EXTERNAL,1,NULL);

      /*-------------------------------
        Add code-address to label list
      --------------------------------*/
      if (ca != 0xFFFF)
      {
        /*--------------------------------
          If this is a CALL instruction,
          add info to the labeltabel
        --------------------------------*/
        if (target == 8048)
        {
          switch (b1)
          {
            case 0x14:
            case 0x34:
            case 0x54:
            case 0x74:
            case 0x94:
            case 0xB4:
            case 0xD4:
            case 0xF4: add_label(ca,"",CODEADDR|CALLED,1,NULL); break;
            default:   add_label(ca,"",CODEADDR,1,NULL); break;
          }
        }
        if (target == 8051 || target == 8052)
        {
          switch (b1)
          {
            case 0x11:
            case 0x12:
            case 0x31:
            case 0x51:
            case 0x71:
            case 0x91:
            case 0xB1:
            case 0xD1:
            case 0xF1: add_label(ca,"",CODEADDR|CALLED,1,NULL); break;
            default:   add_label(ca,"",CODEADDR,1,NULL); break;
          }
        }
      }

      pc += l;     /* Adjust PC with instruction length */
    }
    else
      pc++;

  }
  printf("\n");
  return(0);
}

/*-------------------------------------------------------------------
    FUNCTION: print_header()
     PURPOSE: print header to outputfile
      SYNTAX: void print_header(FILE *fp, char *filename, int asm_output);
 DESCRIPTION: -
     RETURNS: nothing
     VERSION: 920324 V0.1
---------------------------------------------------------------------*/
void print_header(char *filename, int asm_output)
{
  struct tm  *tmnow;
  time_t tnow;

  if (asm_output)
  {
    output("\n;MCS51 Disassembler, 911230 V0.1 (C) HvA\n");
    output("  CPU \"8051.tbl\"\n");
    output("  HOF \"INT16\"\n\n");
  }
  else
  {
     output("\n;MCS51 Disassembler, 911230 V0.1 (C) HvA\n");
  }

  time(&tnow);
  tmnow = localtime(&tnow);

  trimstr(filename);
  output(";Source: %s.HEX\n",filename);

  output(";Output: %s.DIS - Created on %02d-%02d-%02d %02d:%02d:%02d\n\n",
    filename,
    tmnow->tm_year, tmnow->tm_mon, tmnow->tm_mday,
    tmnow->tm_hour,tmnow->tm_min,tmnow->tm_sec);

  if (asm_output) {
    print_equations(BITADDR);
    print_equations(EXTERNAL);
    print_equations(INTERNAL);
  }
}

/*-------------------------------------------------------------------
    FUNCTION: pass2()
     PURPOSE: pass 2 of disassembling object code in memory
      SYNTAX: int pass2(ADDRESS start_address, ADDRESS end_address);
 DESCRIPTION: Main function is the output of the disassembled code
     RETURNS: 0=successfull, <0=failure
     VERSION: 901217 V0.2
---------------------------------------------------------------------*/
int pass2(ADDRESS start_address, ADDRESS end_address)
{
  ADDRESS pc = 0;
  ADDRESS old_pc;
  int     i = 0,
          len = 0;
  LABEL  *labelptr;

  pass = 2;

  datatype = CODEADDR;             /* Reset datatype */

  /*-----------------------------
  | Write ouput header to file
  ------------------------------*/
  print_header(dis_filename,asm_output);

  pc = start_address;
  printf("PASS 2: pc = %04X",pc);
  while (pc <= end_address)
  {
    if (CTRLC_pressed())
      exit(0);

    /*------------------------
      Show that we are busy
    ------------------------*/
    if (pc%8 == 0)
      printf("\b\b\b\b%04X",pc);

    old_pc = pc;

    /*----------------------------------------
      Initialize the info and comment strings
    -----------------------------------------*/
    info_str[0] = '\0';
    strcpy(comment_str,"; ");

    datatype = get_codetype(pc);

    if (datatype & CODEADDR)
    {
      strcat(info_str,"C");
      pc = process_instruction(pc);
    }
    else if (datatype & CODESTRING)
    {
      strcat(info_str,"S");
      pc = process_data(pc);
    }
    else if (datatype & CODEDATA)
    {
      strcat(info_str,"D");
      pc = process_data(pc);
    }
    else
    {
      if (debug)
        output("invalid datatype %02x\n",datatype);
      pc++;
      break;
    }

    /*---------------------------------------
      Print the address, info and HEX string
    ----------------------------------------*/
    if (!asm_output)
    {
      output(" %04X ",old_pc);
      output("%-4.4s",info_str);
      output("%-20.20s ",hex_str);
    }

    /*---------------------------
      Print the label (if any)
    ---------------------------*/
    labelptr = find_label(old_pc,CODEADDR|CODEDATA|CODESTRING);
    if (labelptr)
    {
      if (labelptr->label) {
        len = strlen(labelptr->label);
        output("%s:",labelptr->label);
        output("%*.*s",17-len,17-len,"                                 ");
      }
    }
    else {
      output("%-16s  ","");
    }

    /*-------------------------
      Print the instruction
    -------------------------*/
    if (instr_str[0])
    {
      trimstr(instr_str);
      len = strlen(instr_str);
      if (instr_str[len-1] == ',')
        instr_str[len-1] = '\0';     /* Remove last ',' from the string */
      output("%-40.40s ",instr_str);
    }
    else {
      output("%-40.40s ","");
    }

    /*--------------------
      Print the comment
    --------------------*/
    if (comment_str[0])
    {
      if (strlen(comment_str) > 4) {    /* Avoid output of onlye "; " */
        trimstr(comment_str);
        output("%s",comment_str);
      }
    }

    /*--------------------------
      Terminate the output line
    ----------------------------*/
    output("\n");

  }

  /*------------------------------
    Add 'END' statement to output
  --------------------------------*/
  output(" 0000                           END\n\n");

  if (!asm_output) {
    print_labels(CODE);         /* Print all code labels          */
    print_labels(CALLED);       /* Print all subroutine addresses */
  }

  printf("\n");
  return(0);
}

/*------------------------------------------------------------------
    FUNCTION: disassemble_file()
     PURPOSE: main body of the MCS51 disassembler
      SYNTAX: void disassemble(char *filename)
 DESCRIPTION: -
     RETURNS: nothing
     VERSION: 901239 V0.1
---------------------------------------------------------------------*/
void disassemble_file(char *dis_filename)
{
  char  filename[STRLEN];

  pass = 0;

  /*----------------------
  | Open file for output
  -----------------------*/
  strcpy(filename,dis_filename);
  base_filename(filename);
  strcpy(basename,filename);
  if (asm_output)
    strcat(filename,".asm");
  else
    strcat(filename,".dis");
  outfile = fopen(filename,"w");
  if (!outfile)
  {
    printf("ERROR: couldn't open output '%s'\n",filename);
    exit(0);
  }

  /*------------------------------
    Read default 8052 label file
  -------------------------------*/
  read_labelfile("8052.lbl");

  /*----------------------------------------
    Read labelfile of file to disassemble
  ----------------------------------------*/
  strcpy(filename,dis_filename);
  trimstr(filename);
  strupr(filename);
  base_filename(filename);
  strcat(filename,".LBL");
  read_labelfile(filename);

  /*--------------------
  | Get type of file
  ---------------------*/
  strupr(dis_filename);
  trimstr(dis_filename);
  if (strstr(dis_filename,".HEX"))
    load_hexfile(dis_filename, &start_address, &end_address);
  else if (strstr(dis_filename,".OBJ"))
    load_objfile(dis_filename);
  else if (strstr(dis_filename,".BIN"))
     load_objfile(dis_filename);
  else
  {
    printf("ERROR: wrong file extension: %s\n",dis_filename);
    return;
  }

  /*----------------------------
  | Perform 2-pass disassembly
  -----------------------------*/
  printf("Disassembling %04X - %04X\n",start_address,end_address);
  pass1(start_address,end_address);
  pass2(start_address,end_address);

  /*------------------------
    Close output file
    Free allocated memory
  -------------------------*/
  fclose(outfile);

  if (obj_code)
  {
    free(obj_code);
    obj_code = NULL;
  }

}

/*#+func---------------------------------------------------------------------
|    FUNCTION: main()
|     PURPOSE: Main function for 51_dis.c
| DESCRIPTION: none
|     RETURNS: noting
|     HISTORY: 911230 V0.1
--#-func-------------------------------------------------------------------*/
int main(int argc, char **argv)
{
  /*-------------------------
    Setup global variables
  --------------------------*/
  target = 8052;
  strcpy(target_str,  "8052           ");
  strcpy(dis_filename,"work           ");

  /*--------------------------------
    Process command line arguments
  ---------------------------------*/
  if (argc == 1) {
    pr_usage(arg_tabel,TABSIZE);
    exit(-1);
  }
  argc = getargs(argc,argv,arg_tabel,TABSIZE,NULL);

  /*-----------------------------------------------
    Determine what the target of disassembling is
  -------------------------------------------------*/
  trimstr(target_str);
  if      (!strcmp(target_str,"8052")) target = 8052;
  else if (!strcmp(target_str,"8x52")) target = 8052;
  else if (!strcmp(target_str,"8x32")) target = 8032;
  else if (!strcmp(target_str,"8x48")) target = 8048;
  else {
    printf("ERROR: Cannot disassemble %s\n",target_str);
    exit(-1);
  }

  /*----------------------
    Perform disassembling
  ------------------------*/
  trimstr(dis_filename);
  disassemble_file(dis_filename);

  return(0);
}
