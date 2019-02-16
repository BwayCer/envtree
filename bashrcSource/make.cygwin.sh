#!/bin/bash
# bashrcSource/make.cygwin.sh


##shStyle ###


# __ysBashPath
# __envCode


##shStyle ###


tmpPath="`cat "$__ysBashPath/capp/lib/make.cygwin/lib/_cappPath.config"`/.bin"
[[ ":$PATH:" =~ ":$tmpPath:" ]] || PATH="$PATH:$tmpPath"
unset tmpPath

