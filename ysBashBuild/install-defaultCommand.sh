#!/bin/bash
# 安裝預設應用程式


##shStyle ###


# loxog

# _br
# __filename
# _dirsh
# _fileName

# ysPath
# envCode


##shStyle 共享變數


ysUserdirPath=`realpath "$ysPath/userdir"`
userdirPath=`realpath "$_dirsh/../userdir"`


##shStyle ###


fnLink_toHome() {
    local lnPath="$1"
    ln -sf "$lnPath" "$HOME"
}
fnLinkUserdir() {
    local dirPath=$1

    local line

    find "$dirPath" -maxdepth 1 | sed "1d" | while read line
    do
        fnLink_toHome "$line"
    done
}

fnCheckCmd() {
    local ysExit=$1; shift

    local cmd msg
    local notFoundCmdList=()

    for cmd in "$@"
    do
        if ! which "$cmd" &> /dev/null ; then
            notFoundCmdList[${#notFoundCmdList[@]}]=$cmd
        fi
    done

    if [ ${#notFoundCmdList[@]} -ne 0 ]; then
        msg=`{ \
            echo -n "未安裝 ${notFoundCmdList[0]}"
            [ ${#notFoundCmdList[@]} -gt 1 ] && printf ", %s" "${notFoundCmdList[@]:1}"
            echo " 依賴命令。"
        }`

        if [ $ysExit -eq 1 ]; then
            echo "$msg" | loxog -f "$_fileName" --stderr err
            exit 1
        else
            echo "$msg" | loxog -f "$_fileName" war
        fi
    fi
}


##shStyle ###


defaultCmdAddList=()
warnCmdAddList=()
defaultCmdList=(
    vim
    git
)
warnCmdList=(
    curl
    wget
)

case "$envCode" in
    1 )
        warnCmdAddList=(
            docker
        )
        ;;
    2 )
        ;;
esac

fnCheckCmd 1 "${defaultCmdList[@]}" "${defaultCmdAddList[@]}"
fnCheckCmd 0 "${warnCmdList[@]}" "${warnCmdAddList[@]}"

case "$envCode" in
    # 1: Linux
    1 )
        ;;

    # 2: Cygwin
    2 )
        ;;
esac

fnLink_toHome "$ysPath/capp"
fnLink_toHome "$ysPath/gitman"
fnLinkUserdir "$userdirPath"

[ -d "$ysUserdirPath" ] || mkdir "$ysUserdirPath"
fnLinkUserdir "$ysUserdirPath"

