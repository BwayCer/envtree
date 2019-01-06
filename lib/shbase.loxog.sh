#!/bin/bash
# 腳本基礎 - 輸出日誌


##shStyle ###


source shbase "#fColor"
source shbase "#parseOption"


##shStyle 腳本環境


# loxog
#    [-f, --fileName <文件名>]
#    [--stderr]
#    <方法 (com|war|err)> [輸出訊息]
#
# 使用說明：
#   * 一般訊息： loxog com 'txt1' 'txt2'
#   * 錯誤訊息： loxog --stderr err 'txt1' 'txt2'
#   * 由管道傳遞輸出訊息： echo -e 'txt1\ntxt2' | loxog com

[ -n "$_shBase_loadfile" ] \
    && loxog_fileName=`basename "$_shBase_loadfile"` \
    || loxog_fileName="loxog"

loxog_opt_fileName=""
loxog_opt_stderr=0
loxog_opt() {
    case "$1" in
        -f | --fileName )
            [ -z "$2" ] && return 4

            loxog_opt_fileName="$2"
            return 2
            ;;
        --stderr )
            loxog_opt_stderr=1
            return 1
            ;;
        * ) return 3 ;;
    esac
}
loxog() {
    # 若非由終端輸入則由管道讀取值
    local _stdin=`[ ! -t 0 ] && { \
        IFS='';
        while read pipeData; do echo "$pipeData"; done <&0;
        unset IFS
    }`

    parseOption "$loxog_fileName" "loxog" "$@"
    local args=("${rtnParseOption[@]}")

    local method="${args[0]}"; args=("${args[@]:1}")

    local line
    local color formatArgus
    local prefixSource=""
    local outTxt=""

    case $method in
        com ) color=$_fN    ;; # common
        war ) color=$_fYelB ;; # warn
        err ) color=$_fRedB ;; # error
    esac

    if [ -n "$loxog_opt_fileName" ]; then
        prefixSource="[$loxog_opt_fileName]: "
    fi

    formatArgus="$color$prefixSource%s$_fN$_br"

    [ -n "${args[*]}" ] \
        && outTxt+="`printf "$formatArgus" "${args[@]}"`$_br"

    if [ -n "$_stdin" ]; then
        outTxt+="`{ \
            IFS='';
            while read line
            do
                printf "$formatArgus" "$line"
            done <<< "$_stdin"
            unset IFS
        }`$_br"
    fi

    if [ $loxog_opt_stderr -ne 1 ]; then
        printf "$outTxt"
    else
        printf "$outTxt" >&2
    fi
}


##shStyle ###

[ -n "$_br" ] || _br="
"

