#!/bin/bash
# 函式庫範例腳本


##shStyle ###


_binsh=$(realpath "$(dirname "$(realpath "$0")")/../bin")
[ -z "`grep ":$_binsh:" <<< ":$PATH:"`" ] && PATH="$_binsh:$PATH"


##shStyle ###


source shbase "#parseOption"
source shbase "#showHelp"


##shStyle 函式庫


showHelpRecord "fnSampleLib" "\
函式庫簡述
# 函式庫說明 1
# 函式庫說明 2
# 函式庫說明 3 ...
[[USAGE]] [多個參數]
[[OPT]]
  -h, --help   幫助。
"
fnSampleLib_opt() {
    case "$1" in
        -h | --help ) showHelp "$fnSampleLib_fileName" "fnSampleLib" ;;
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
fnSampleLib() {
    [ $# -eq 0 ] && showHelp "$fnSampleLib_fileName" "fnSampleLib"

    opt_carryOpt=""
    parseOption "$fnSampleLib_fileName" "fnSampleLib" "$@"

    printf "執行函式庫：\n  攜帶選項： %s\n  攜帶參數： %s\n" \
        "$opt_carryOpt" "(${#rtnParseOption[@]}) ${rtnParseOption[*]}"
}


##shStyle ###


if [ -n "$_shBase_loadfile" ]; then
    fnSampleLib_fileName="$_shBase_loadfile"
else
    fnSampleLib_fileName=`basename "$0"`
    fnSampleLib "$@"
fi

