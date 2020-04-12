#!/bin/bash
# 安裝基礎設定


##shStyle ###


# loxog

# _br
# __filename
# _dirsh
# _fileName

# ysPath
# plantHome
# envCode

# fnLinkUserdir
# fnLinkList


##shStyle 共享變數


libPath=`realpath "$_dirsh/../lib"`


##shStyle ###


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

