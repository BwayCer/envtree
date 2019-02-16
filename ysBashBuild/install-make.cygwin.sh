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

# Git for Window 的 bash 無法讀取 ln 鏈結文件
fnBuild_bashGwEnv_gitconfig() {
    local gitconfigPath="$HOME/.gitconfig"
    local gitconfigLnkPath="${gitconfigPath}.lnk"

    if [ -e "$gitconfigPath" ]; then
        mv "$gitconfigPath" "$gitconfigLnkPath"
        cat "$gitconfigLnkPath" > "$gitconfigPath"
    fi
}


##shStyle ###


fnLinkUserdir

fnBuild_bashGwEnv_gitconfig

