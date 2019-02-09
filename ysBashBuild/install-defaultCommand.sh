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
    ln -sf "$lnPath"   "$HOME"
}
fnLinkUserdir() {
    local line

    find "$userdirPath" -maxdepth 1 | sed "1d" | while read line
    do
        fnLink_toHome "$line"
    done
}

fnCheckDefaultCmd() {
    local cmd
    local notFoundCmdList=()

    for cmd in "$@"
    do
        if ! which "$cmd" &> /dev/null ; then
            notFoundCmdList[${#notFoundCmdList[@]}]=$cmd
        fi
    done

    if [ ${#notFoundCmdList[@]} -ne 0 ]; then
        echo `{ \
            echo -n "未安裝 ${notFoundCmdList[0]}"
            [ ${#notFoundCmdList[@]} -gt 1 ] && printf ", %s" "${notFoundCmdList[@]:1}"
            echo " 依賴命令。"
        }` | loxog -f "$_fileName" --stderr err
        exit 1
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


# defaultCmdAddList=()
defaultCmdList=(
    vim
    git
    go
)

case "$envCode" in
    1 )
        defaultCmdAddList=(
            docker
        )
        ;;
    2 )
        defaultCmdAddList=()
        ;;
esac

fnCheckDefaultCmd "${defaultCmdList[@]}" "${defaultCmdAddList[@]}"

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

