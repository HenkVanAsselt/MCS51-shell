#
# Make an NG entry
#

/FUNCTION:/              {
                           if ($1 == "|") {
                             printf("\n!short: %s\n",$3);
                           }
                           else {
                             printf("\n!short: %s\n",$2);
                           }
                         }
#
# This will be the text
#

/FUNCTION:/,/RETURNS:/   {
                           if ($1=="|") {
                               for(i=2 ; i<=NF ; i++) printf("%s ",$i);
                               printf("\n");
                           }
                           else
                             print $0;
                         }
#
# Show the source file name of the function
#

/RETURNS:/ {
             printf("\n\nfile: %s",FILENAME)
           }
