#!/bin/bash
# ysBashBuild/install-make.cygwin.sh


##shStyle ###


# loxog

# _br
# __filename
# _dirsh
# _fileName

# ysPath
# envCode


##shStyle 共享變數


userdirPath=`realpath "$_dirsh/../userdir"`


##shStyle ###


fnLink_toHome() {
    local lnPath="$1"
    ln -sf "$lnPath" "$HOME"
}
fnLinkUserdir() {
    local line

    find "$userdirPath" -maxdepth 1 | sed "1d" | while read line
    do
        fnLink_toHome "$line"
    done
}


##shStyle ###


fnLinkUserdir

