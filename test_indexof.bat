Setlocal ENABLEDELAYEDEXPANSION

set str=abcdefghijklmnopqrstuvxyz

call :indexOf result "%str%" "e"
echo %result%

REM @echo off
REM echo EM set "string=<ax2697:tenantDomain>org_12345678"
REM set "string=%string:<=#%"
REM set "string=%string:>=#%"
REM 
REM set "find_index_of=org_12345678"
REM 
REM echo %string%
REM call :indexOf index "%string%" "%find_index_of%"
REM echo %index%

