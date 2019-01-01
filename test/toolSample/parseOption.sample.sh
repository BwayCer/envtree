#!/bin/bash
# 解析選項樣本


##shStyle ###


_binsh=$(realpath "$(dirname "$(realpath "$0")")/../../bin")
[ -z "`grep ":$_binsh:" <<< ":$PATH:"`" ] && PATH="$_binsh:$PATH"


##shStyle ###


source shbase "#parseOption"


##shStyle 共享變數


# 文件路徑資訊
_fileName=`basename "$0"`


##shStyle ###


fnParseOptionSample_opt() {
    case "$1" in
        * )
            if [ -z "$2" ]; then
                opt_carryOpt+="$1 "
                return 1
            else
                opt_carryOpt+="$1=\"$2\" "
                return 2
            fi
            ;;
    esac
}
fnParseOptionSample() {
    local opt_carryOpt remainedArgs

    parseOption \
        "$_fileName" \
        "fnParseOptionSample" \
        "$@"
    remainedArgs=("${rtnParseOption[@]}")
    printf "執行主命令：\n  攜帶選項： %s\n  攜帶參數： %s\n" \
        "$opt_carryOpt" "(${#remainedArgs[@]}) ${remainedArgs[*]}"
}

fnParseOptionSample "$@"

