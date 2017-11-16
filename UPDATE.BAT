REM ****************************
REM *  Delete temporary files  *
REM ****************************
CALL cleanup
@del tmp*.*
@del *.tmp
@del *.bak

REM **********************
REM *  Update diskette   *
REM **********************
@copy /u *.c b:\
@copy /u 51_dis.h 51shell.h b:\
@copy /u *.bat *.lnk *.mak b:\
@copy /u *.ndx *.hlp b:\
@copy /u *.doc b:\
@copy /u bas\*.bas b:\bas
@copy /u asm\*.asm b:\asm
@copy /u pas\*.pas b:\pas
@copy /u 8052.lbl 8052rom.lbl b:\
@copy /u 51shell.ini b:\
@copy /u \lib\hva_util.lib b:\
@copy /u \include\hva_util.h b:\
@copy /u \lib\serial9.lib b:\
@copy /u \include\front9.h b:\

REM **********************
REM *  Update Harddisk   *
REM **********************
@copy /uv b:\*.c .
@copy /uv b:\51shell.h .
@copy /uv b:\51_dis.h .
@copy /uv b:\*.bat .
@copy /uv b:\*.lnk .
@copy /uv b:\*.mak .
@copy /uv b:\*.ndx .
@copy /uv b:\*.hlp .
@copy /uv b:\*.doc .
@copy /uv b:\bas\*.bas bas
@copy /uv b:\asm\*.asm asm
@copy /uv b:\pas\*.pas pas
@copy /uv b:\8052rom.lbl .
@copy /uv b:\8052.lbl .
