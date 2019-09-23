#!/bin/bash
# 安裝基礎設定


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
libPath=`realpath "$_dirsh/../lib"`
userdirPath=`realpath "$_dirsh/../userdir"`

tmuxConfLevelNo="$libPath/.tmux_levelNo.conf"
tmuxConfLevel01="$libPath/.tmux_level01.conf"


##shStyle ###


fnLink_toHome() {
    local lnPath="$1"
    ln -sf "$lnPath" "$HOME"
}
fnLink_toFileList() {
    local infoTxt="$1"

    local originPath linkPath

    while read line
    do
        originPath=`cut -d " " -f 2- <<< "$line"`
        linkPath=`  cut -d " " -f 1  <<< "$line"`
        ln -sf "$originPath" "$linkPath"
    done <<< "`grep "." <<< "$infoTxt" | sed "s/ ----*= / /g"`"
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

tmuxConfPath=$tmuxConfLevelNo

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
        tmuxConfPath=$tmuxConfLevel01
        ;;
esac

[ -d "$ysUserdirPath" ] \
    && fnLinkUserdir "$ysUserdirPath" \
    || mkdir "$ysUserdirPath"

fnLinkUserdir "$userdirPath"
fnLink_toFileList "
$HOME --------------= $ysPath/capp
$HOME --------------= $ysPath/gitman
$HOME/.tmux.conf ---= $tmuxConfPath
"

