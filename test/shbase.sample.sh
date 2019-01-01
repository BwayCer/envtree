#!/bin/bash
# 範例腳本


##shStyle ###


_binsh=$(realpath "$(dirname "$(realpath "$0")")/../bin")
[ -z "`grep ":$_binsh:" <<< ":$PATH:"`" ] && PATH="$_binsh:$PATH"


##shStyle ###


source shbase.redirection.sh
source shbase "#abase"


##shStyle ###


shScript_route() {
    case "$1" in
    subCmdA ) _shCmdLevel=1 ;
        case "$2" in
        subCmdB ) _shCmdLevel=2 ;;
        esac ;;
    esac
}


##shStyle 介面函式


showHelpRecord "main" "\
主命令簡述
# 主命令說明 1
# 主命令說明 2
# 主命令說明 3 ...
[[USAGE]] [多個參數]
[[SUBCMD]]
  subCmdA       [[BRIEFLY:subCmdA]]
[[OPT]]
  -f, --showFileInfo   顯示文件路徑資訊。
  -h, --help           幫助。
"
fnOpt_main() {
    case "$1" in
        -f | --fileInfo )
            opt_showFileInfo=1
            opt_carryOpt+="$1 "
            return 1
            ;;
        -h | --help ) showHelp "$_fileName" ;;
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
fnSh_main() {
    [ $# -eq 0 ] && showHelp "$_fileName"

    opt_showFileInfo=0
    opt_carryOpt=""
    parseOption "$_fileName"

    if [ $opt_showFileInfo -ne 0 ]; then
        echo "文件路徑資訊："
        printf "  %s: %s\n" \
            "__filename" "$__filename" \
            "_dirsh" "$_dirsh" \
            "_libsh" "$_libsh" \
            "_fileName" "$_fileName"
        echo
    fi

    printf "執行主命令：\n  攜帶選項： %s\n  攜帶參數： %s\n" \
        "$opt_carryOpt" "(${#_args[@]}) ${_args[*]}"
}

showHelpRecord "main_subCmdA" "\
A 子命令。
[[USAGE]]
[[SUBCMD]]
  subCmdB    [[BRIEFLY:subCmdB]]
[[OPT]]
  -h, --help   幫助。
"
fnOpt_main_subCmdA() {
    case "$1" in
        -h | --help ) showHelp "$_fileName";;
        * ) return 3 ;;
    esac
}
fnSh_main_subCmdA() {
    parseOption "$_fileName"
    echo "執行 A 子命令"
}

showHelpRecord "main_subCmdA_subCmdB" "\
B 子命令。
[[USAGE]]
[[OPT]]
  -h, --help   幫助。
"
fnOpt_main_subCmdA_subCmdB() {
    case "$1" in
        -h | --help ) showHelp "$_fileName";;
        * ) return 3 ;;
    esac
}
fnSh_main_subCmdA_subCmdB() {
    parseOption "$_fileName"
    echo "執行 B 子命令"
}


##shStyle 共享變數



##shStyle 函式庫



##shStyle ###


shScript "main" "$@"

