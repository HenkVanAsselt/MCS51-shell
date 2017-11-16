/*******************************************************************************
*                                                                              *
*        FILE: DISUTIL.C                                                       *
*                                                                              *
*     PURPOSE: Utilities for the MCS51 disassembler                            *
*                                                                              *
* DESCRIPTION:                                                                 *
*                                                                              *
*     HISTORY: 920317 V0.1                                                     *
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
#include <hva_util.h>
#include "51_dis.h"

extern int target;              /* !!! Watch out */

/*---------------------------------------------------------------------------
                        PROTOTYPES
---------------------------------------------------------------------------*/
BYTE *make_objcode(void);

/*#+func-------------------------------------------------------------
    FUNCTION: read_labelfile()
     PURPOSE: store pre-defined labels in label table and read labelfile
 DESCRIPTION: A record of the label file consists of 3 fields:
              field 1: Label
              field 2: address
              field 3: Label type : 'C' = CODE
                                    'D' = DATA
                                    'S' = DATASTRING
              field 4: Length of the data (if given)
              filed 5: preceded by a ';' and gives the comment on the
                       label
     RETURNS: 0        = success
              -1 = file open error
     VERSION: 901216 V0.1
              920107 V0.2 - Added predefined labels for 8052/8048
--#-func-------------------------------------------------------------*/
int read_labelfile(char *labelfile)
{
  FILE *infile;
  char s[STRLEN];
  char *label;
  ADDRESS address;
  char *typestr;
  char *comment;
  int  type;
  char *m;
  int  i = 0;
  char *token;
  char *dummy;
  int  length =1;
  int  linenr = 0;

  /*-----------------
  | Open label file
  ------------------*/
  printf("Reading labelfile %s\n",labelfile);
  infile = fopen(labelfile,"r");
  if (!infile)
  {
    printf("ERROR coudn't open labelfile %s\n",labelfile);
    return(-1);          /* No label file. Pitty... but no big deal */
  }

  /*----------------------
  | Process label file
  -----------------------*/
  while (!feof(infile))
  {
    if (ESC_pressed())
      exit(0);

    if (!fgets(s,STRLEN,infile))      /* Read entry */
      continue;
    linenr++;

    trimstr(s);

    /*------------------------------
      Check if line is a comment
    -------------------------------*/
    if (*s == ';' || *s == '#')
      continue;

    /*------------------------------
      Check if line is empty
    -------------------------------*/
    if (*s == '\n' || *s == '\0')
       continue;

    /*-------------
      Get label
    -------------*/
    label = strtok(s," \t\n");
    if (label)
      trimstr(label);

    /*------------
      Get address
    --------------*/
    token = strtok(NULL," \t\n");
    if (token)
    {
      m = strpbrk(token,"xXhH");
      if (m)
        address = (ADDRESS) strtoul(token,&dummy,16);
      else
        address = (ADDRESS) strtoul(token,&dummy,10);
    }
    else
     address = -1;

    /*-------------------
      Get address type
    --------------------*/
    typestr = strtok(NULL," ;\t\n");
    if (typestr)
    {
      strupr(typestr);
      trimstr(typestr);
      switch(*typestr)
      {
        case 'B':  type = BITADDR;    break;
        case 'C':  type = CODEADDR;   break;
        case 'D':  type = CODEDATA;   break;
        case 'S':  type = CODESTRING; break;
        case 'I':  type = INTERNAL;   break;
        case 'E':  type = EXTERNAL;   break;
        default:
          printf("Unknown label type in line %d\n",linenr);
          break;
      }
    }

    /*-------------
      Get comment
    ---------------*/
    token = strtok(NULL,";");
    if (token) {
      comment = strtok(NULL,"\n");    /* Comment till end of line */
      if (comment)
        trimstr(comment);
     }
     else
       comment = NULL;

    /*--------------------------
      Add entry to label table
    --------------------------*/
    switch(type) {
      case BITADDR:
      case CODEADDR:
        add_label(address,label,type,1,comment);
        break;
      case CODEDATA:
      case CODESTRING:
      case INTERNAL:
      case EXTERNAL:
        length = 1;
        if (typestr && *(typestr+1))
          length = (int) strtoul(typestr+1,&dummy,10);
        add_label(address,label,type,length,comment);
        break;
      default:
        break;
    }
  }

  return(0);
}

/*#+func-------------------------------------------------------------------
    FUNCTION: DLSortStore()
     PURPOSE: Add label to to double linked list
      SYNTAX: LABEL *DLSortStore(info,start,last);
 DESCRIPTION: Uses DLSortStore() routine form MODULA-2 book pp 95
     RETURNS: pointer to first label in the list
     HISTORY: 920321 V0.1 - Initial version
--#-func-------------------------------------------------------------------*/
LABEL *DLSortStore(LABEL *info,
                   LABEL *start,
                   LABEL **last)
{
  LABEL *old, *top, *ptr;

  ptr = start;
  top = start;
  old = NULL;

  /*--------------------------------------
    Add label entry to double linked list
  ---------------------------------------*/
  if (ptr == NULL) {
    /*--- This is the first label in the list ---*/
    info->next  = NULL;
    *last       = info;
    info->prior = NULL;
    return(info);
  }
  else
  {
    while (ptr != NULL)
    {
      if (ptr->addr != info->addr) {
        old   = ptr;
        ptr = ptr->next;
      }
      else {
        /* Label goes in the middle of the list */
        if (old != NULL) {
          old->next   = info;
          info->next  = ptr;
          info->prior = old;
          return(top);   /* Keep same starting point */
        }
        else {
          info->next  = ptr;   /* New first element */
          info->prior = NULL;
          return(info);
        }
      }
    } /* while() */

    /*--- Label goes to the end of the list */

    (*last)->next = info;
    info->next  = NULL;
    info->prior = *last;
    *last       = info;
    return(top);
  }
}

/*#+func-------------------------------------------------------------------
    FUNCTION: del_label()
     PURPOSE: delete label entry from double linked label list
      SYNTAX: static LABEL *del_label(start,addr)
 DESCRIPTION: -
     RETURNS: pointer to start of list
     HISTORY: 910730 V0.1 - Initial version
--#-func-------------------------------------------------------------------*/
LABEL *del_label(LABEL *start, ADDRESS addr)
{
  LABEL *temp,*temp2;
  int  done;

  temp = start;
  if (start->addr == addr) {
    /*--- First entry in the list ---*/
    if (temp->next != NULL) {
      temp = start->next;
      temp->prior = NULL;
    }
    if (start->label)
      free(start->label);
    free(start);
    return(temp);
  }
  else {
    done = FALSE;
    temp = start->next;
    temp2 = start;
    while (temp != NULL) {
      if (temp->addr == addr) {
        temp2->next = temp->next;
        if (temp->next != NULL) {
          temp->next->prior = temp2;
        }
        done = TRUE;
        if (temp->label)
          free(temp->label);
        free(temp);
      }
      else {
        temp2 = temp;
        temp = temp->next;
      }
    }
    if (!done)
    {
      fprintf(stderr,"Address not found\n");
    }
    return(start);
  }
}

/*#+func-------------------------------------------------------------------
    FUNCTION: search_label()
     PURPOSE: Search for the address of a label in the linked list
      SYNTAX: static LABEL *del_label(start,addr)
 DESCRIPTION: -
     RETURNS: pointer to the address is found, NULL if none found
     HISTORY: 910730 V0.1 - Initial version
--#-func-------------------------------------------------------------------*/
LABEL *search_label(LABEL *start, ADDRESS addr)
{
  LABEL *ptr;

  ptr = start;
  while (ptr) {
    if (ptr->addr == addr)
      return(ptr);
    else
      ptr = ptr->next;
  }
  return(NULL);  /* Not in the list */
}

/*#+func---------------------------------------------------------------------
|    FUNCTION: make_objcode()
|     PURPOSE: Allocate memory to var obj_code
|      SYNTAX: BYTE *make_objcode(void);
| DESCRIPTION: -
|     RETURNS: Pointer to block allocated
|     HISTORY: 920324 V0.1
--#-func-------------------------------------------------------------------*/
BYTE *make_objcode(void)
{
  BYTE *ptr;

  ptr = calloc(OBJ_SIZE,sizeof(BYTE));
  if (!ptr)
  {
    printf("ERROR: not enough memory obj_code\n");
    exit(-2);
  }
  else
    return(ptr);
}

/*#+func-------------------------------------------------------------
|   FUNCTION: load_objfile()
|    PURPOSE: Read object file (.BIN or .OBJ) from disk
| DESRIPTION: -
|    RETURNS:  0 = success
|             -1 = file open error
|    VERSION: 901216 V0.1
--#-func-------------------------------------------------------------*/
int load_objfile(char *filename)
{
  FILE  *infile;
  long  file_length;

  if (!obj_code)
    obj_code = make_objcode();

  printf("Loading object file %s\n",filename);
  infile = fopen(filename,"rb");
  if (!infile)
  {
    printf("ERROR: couldn't open file '%s'\n",filename);
    return(-1); /* OPEN_ERROR */
  }

  fseek(infile,0L,SEEK_END);      /* Pointer to end of file   */
  file_length = ftell(infile);    /* Read file pointer        */
  fseek(infile,0L,SEEK_SET);      /* Pointer to start of file */
  fread(obj_code,1,(size_t)file_length,infile);

  fclose(infile);
  return(0);
}

/*#+func-------------------------------------------------------------
|   FUNCTION: decode_byte(char *s)
|    PURPOSE: decode a byte from character stream s
| DESRIPTION: Takes the first two digits and convert them to a BYTE
|    RETURNS: The value decoded
|    VERSION: 901213 V0.1
--#-func-------------------------------------------------------------*/
BYTE decode_byte(char *s)
{
  char t[3];
  BYTE i;

  t[0] = s[0];
  t[1] = s[1];
  t[2] = '\0';
  sscanf(t,"%2x",&i);
  return((BYTE)i);
}

/*#+func-------------------------------------------------------------
|   FUNCTION: load_hexfile()
|    PURPOSE: Load hexfile and convert to object code
| DESRIPTION: INTEL-16 HEX (?) file consists of a number of lines:
|             ':NNAAAATTDDDD...DDCC' in which:
|             ':'        = start of line
|             'NN'       = number of databytes
|             'AAAAAA'   = loadaddress of data
|             'TT'       = record type
|             'DDDD..DD' = data
|             'CC'       = 1 byte checksum
|    RETURNS: 0=succes
|             -1 = file open error
|             -2 = allocation error
|    VERSION: 901216 V0.1
--#-func-------------------------------------------------------------*/
int load_hexfile(char    *filename,
                 ADDRESS *start_address,
                 ADDRESS *end_address)
{
  FILE *infile;
  char c;
  char s[STRLEN];
  int  length = 0;
  int  rectype;
  char datastr[STRLEN];
  char hexfile[STRLEN];
  ADDRESS address;
  int  i;
  int linenr = 0;

  if (!obj_code)
    obj_code = make_objcode();

  /*---------------------------
  | Open hex file for reading
  ----------------------------*/
  strcpy(hexfile,filename);
  base_filename(hexfile);
  strcat(hexfile,".HEX");
  printf("Loading HEX file %s\n",hexfile);
  infile = fopen(hexfile,"r");
  if (!infile)
  {
    printf("ERROR: couldn't open file '%s'\n",hexfile);
    return(-1);
  }

  *start_address = -1;
  while (!feof(infile))
  {
    if (!fgets(s,STRLEN,infile))     /* Get input line      */
      continue;
    linenr++;

    if (s[0] != ':') break;          /* End of file reached */

    sscanf(s,"%c%2x%4x%2x%s",&c,&length,&address,&rectype,datastr);

    /*--------------------------
      Initialize start address
    ---------------------------*/
    if (*start_address == -1)
      *start_address = address;

    /*----------------------------------
      Determine start- and end addresses
    ------------------------------------*/
    *start_address = min(*start_address,address);
    *end_address   = max(*end_address,address+length);

    if (rectype == 0x01  || length == 0x00)
    {
       /*-------------
         END RECORD
       -------------*/
       ;    /* Handle  end record */
    }
    else
    {
      /*-------------------------------
        DATA RECORD
        Convert hexdata to object data
      --------------------------------*/
      i = 0;
      do
      {
        obj_code[(unsigned int)address++] = decode_byte(datastr+i);
        i += 2;
        length--;
      }
      while (length);
    }
  }

  fclose(infile);
  return(0);   /* success */
}

/*#+func---------------------------------------------------------------------
|    FUNCTION: check_intr_addr()
|     PURPOSE: Check if pc concerns an interrupt address.
|      SYNTAX: void check_intr_addr(ADDRESS pc);
| DESCRIPTION: If pc concerns an interrrupt address, print information
|              about it to the output file
|     RETURNS: nothing
|     HISTORY: 920326 V0.1
--#-func-------------------------------------------------------------------*/
void check_intr_addr(ADDRESS pc)
{
  char *ptr;

  if (target == 8051 || target == 8052)
  {
    switch(pc)
    {
      case 0x0000: ptr="RESET address";                          break;
      case 0x0003: ptr="External interrupt 0 interrupt address"; break;
      case 0x000B: ptr="Timer 0 overflow interrupt address";     break;
      case 0x0013: ptr="External interrupt 1 interrupt address"; break;
      case 0x001B: ptr="Timer 1 overflow interrupt address";     break;
      case 0x0023: ptr="Timer 2 overflow interrupt address";     break;
      default: ptr = NULL;
    }
    if (ptr)
    {
      output("\n                  ;***\n");
      output("                  ;*** %s\n",ptr);
      output("                  ;***\n");
    }
  }
  if (target == 8048)
  {
    switch (pc)
    {
      case 0x0000: ptr="RESET address";                           break;
      case 0x0003: ptr="External interrupt 0 interrupt address";  break;
      case 0x0007: ptr="Timer/Event counter overflow interrupt";  break;
      default: ptr = NULL;
    }
    if (ptr)
    {
      output("\n                  ;***\n");
      output("                  ;*** %s\n",ptr);
      output("                  ;***\n");
    }
  }
}

/*#+func---------------------------------------------------------------------
     FUNCTION: check_if_called(ADDRESS *pc)
      PURPOSE: Check if address 'pc' is a subroutine
  DESCRIPTION: If address is a subroutine, print information about it
               in the output file
      RETURNS: nothing
      HISTORY: 920326 V0.1
--#-func-------------------------------------------------------------------*/
void check_if_called(ADDRESS pc)
{
  LABEL *labelptr;

  labelptr = find_label(pc,CALLED);
  if (labelptr)
  {
    output("               ;***\n");
    output("               ;*** SUBROUTINE\n");
    output("               ;***\n");
  }
}
