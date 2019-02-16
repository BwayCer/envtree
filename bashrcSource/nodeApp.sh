#!/bin/bash
# bashrcSource/nodeApp.sh


##shStyle ###


# __ysBashPath
# __envCode


##shStyle ###


tmpPath="$__ysBashPath/capp/lib/nodeApp/node_bin"
[[ ":$PATH:" =~ ":$tmpPath:" ]] || PATH="$PATH:$tmpPath"
unset tmpPath

