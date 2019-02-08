#!/bin/bash
# bashrcSource/nodeApp.sh


tmpPath="$__ysBashPath/capp/lib/nodeApp/node_bin"
[[ ":$PATH:" =~ ":$tmpPath:" ]] || PATH="$PATH:$tmpPath"
unset tmpPath

