#!/bin/bash
# 腳本基礎 - 輸出日誌

# # 參數說明：
# #   * 方法
# #     * `com`   一般文字。
# #     * `war`   黃色粗體字。
# #     * `err`   紅色粗體字。
# #
# # 範例：
# #   * 一般訊息： `loxog com 'txt1' 'txt2'`
# #   * 錯誤訊息： `loxog --stderr err 'txt1' 'txt2'`
# #   * 由管道傳遞輸出訊息： `printf 'txt1\ntxt2\n' | loxog com`
# [[USAGE]] <方法 (com|war|err)> [輸出訊息]
# [[OPT]]
#   -f, --fileName <文件名>   顯示文件名訊息。
#       --stderr              輸出至標準錯誤。


##shStyle ###


source shbase "#fColor"
source shbase "#parseOption"


##shStyle 腳本環境


[ -n "$_shBase_loadfile" ] \
    && loxog_fileName=`basename "$_shBase_loadfile"` \
    || loxog_fileName="loxog"

loxog_opt_fileName=""
loxog_opt_stderr=0
loxog_opt() {
    case "$1" in
        -f | --fileName )
            [ -z "$2" ] && parseOption_shift=4

            loxog_opt_fileName="$2"
            parseOption_shift=2
            ;;
        --stderr )
            loxog_opt_stderr=1
            parseOption_shift=1
            ;;
        * ) parseOption_shift=3 ;;
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
    local color formatArgu
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

    formatArgu="$color$prefixSource%s$_fN$_br"

    [ -n "${args[*]}" ] \
        && outTxt+="`printf "$formatArgu" "${args[@]}"`$_br"

    if [ -n "$_stdin" ]; then
        outTxt+="`{ \
            IFS='';
            while read line
            do
                printf "$formatArgu" "$line"
            done <<< "$_stdin"
            unset IFS
        }`$_br"
    fi

    if [ $loxog_opt_stderr -ne 1 ]; then
        echo -n "$outTxt"
    else
        echo -n "$outTxt" >&2
    fi
}


##shStyle ###

[ -n "$_br" ] || _br="
"

