#!/bin/bash
# 腳本基礎 - 輸出日誌


##shStyle ###


source shbase "#fColor"


##shStyle 腳本環境


# loxog <方法 (com|war|err)> [輸出訊息]
#   例如：
#     * 一般訊息： loxog com 'txt1' 'txt2'
#     * 錯誤訊息： loxog err 'txt1' 'txt2' >&2
#     * 由管道傳遞輸出訊息： echo -e 'txt1\ntxt2' | loxog com
loxog() {
    # 若非由終端輸入則由管道讀取值
    local _stdin=`[ ! -t 0 ] && { \
        IFS='';
        while read pipeData; do echo "$pipeData"; done <&0;
        unset IFS
    }`
    local method="$1"; shift

    local idx val len
    local color formatArgus

    case $method in
        com ) color=$_fN    ;; # common
        war ) color=$_fYelB ;; # warn
        err ) color=$_fRedB ;; # error
    esac

    formatArgus="$color%s$_fN\n"

    [ -n "$*" ] && printf "$formatArgus" "$@"

    if [ -n "$_stdin" ]; then
        len=`echo "$_stdin" | wc -l`
        for idx in `seq 1 $len`
        do
            val=`echo "$_stdin" | sed -n "${idx}p"`
            printf "$formatArgus" "$val"
        done
    fi
}


##shStyle ###

[ -n "$_br" ] || _br="
"

