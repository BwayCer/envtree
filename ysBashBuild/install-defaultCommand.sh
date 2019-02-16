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

fnBuild_vim() {
    local plugRepositoryPath="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    local vimDirPath="$userdirPath/.vim"
    local plugFilePath="$vimDirPath/autoload/plug.vim"

    # vim-plug
    if [ ! -f "$plugFilePath" ]; then
        mkdir -p "$vimDirPath/autoload"
        curl "$plugRepositoryPath" > "$plugFilePath"
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
    go
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
        fnBuild_vim
        ;;

    # 2: Cygwin
    2 )
        fnBuild_vim
        ;;
esac

fnLink_toHome "$ysPath/capp"
fnLink_toHome "$ysPath/gitman"
fnLinkUserdir

