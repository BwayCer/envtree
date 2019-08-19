#!/bin/bash
# bashrcSource/make.cygwin.sh


##shStyle ###


# __ysBashPath
# __envCode


##shStyle ###


tmpPath="`cat "$__ysBashPath/capp/lib/make.cygwin/lib/_cappPath.config"`/.bin"
[[ ":$PATH:" =~ ":$tmpPath:" ]] || PATH="$PATH:$tmpPath"
unset tmpPath


# https://superuser.com/questions/18830
# https://blog.twtnn.com/2013/11/windowstasklisttaskkillprocess.html
alias taskkill.f.PID="taskkill.exe /f /PID"

