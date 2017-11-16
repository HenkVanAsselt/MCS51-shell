/FUNCTION:/              {
                           if ($1 == "|") {
                             printf("\n\n:%s\n",$3);
                             printf("^%s\n\n",$3);
                           }
                           else {
                             printf("\n\n:%s\n\n",$2);
                             printf("^%s\n\n",$2);
                           }
                         }
/FUNCTION:/,/RETURNS:/   {
                           if ($1=="|") {
                               for(i=2 ; i<=NF ; i++) printf("%s ",$i);
                               printf("\n");
                           }
                           else
                             print $0
                          }
