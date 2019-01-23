#!/bin/bash
# 範例腳本


##shStyle ###


_binsh=$(realpath "$(dirname "$(realpath "$0")")/../bin")
[ -z "`grep ":$_binsh:" <<< ":$PATH:"`" ] && PATH="$_binsh:$PATH"


##shStyle ###


source shbase.redirection.sh
source shbase "#abase"
source shbase "#stdin"
source shbase "#onCtrlC"


##shStyle ###


shScript_route() {
    case "$1" in
    subCmdA ) _shCmdLevel=1 ;
        case "$2" in
        subCmdB ) _shCmdLevel=2 ;;
        esac ;;
    pressCtrlC ) _shCmdLevel=1 ;;
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
  subCmdA      [[BRIEFLY:subCmdA]]
  pressCtrlC   [[BRIEFLY:pressCtrlC]]
[[OPT]]
  -f, --showFileInfo   顯示文件路徑資訊。
  -i, --showStdin      顯示標準輸入。
  -h, --help           幫助。
"
fnOpt_main() {
    case "$1" in
        -f | --fileInfo )
            opt_showFileInfo=1
            opt_carryOpt+="$1 "
            return 1
            ;;
        -i | --showStdin )
            opt_showStdin=1
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
    opt_showStdin=0
    opt_carryOpt=""
    parseOption "$_fileName"

    if [ $opt_showFileInfo -ne 0 ]; then
        echo "文件路徑資訊："
        printf "  %s: %s\n" \
            "__filename" "$__filename" \
            "_dirsh" "$_dirsh" \
            "_fileName" "$_fileName"
        echo
    fi

    if [ $opt_showStdin -ne 0 ]; then
        echo "標準輸入的內容："
        [ -n "$_stdin" ] \
            && echo "---$_br$_stdin$_br---" \
            || echo "  (空)"
        echo
    fi

    printf "執行主命令：\n  攜帶選項： %s\n  攜帶參數： %s\n" \
        "$opt_carryOpt" "(${#_args[@]}) ${_args[*]}"
}

showHelpRecord "main_subCmdA" "\
A 子命令。
[[USAGE]]
[[SUBCMD]]
  subCmdB   [[BRIEFLY:subCmdB]]
[[OPT]]
  -h, --help   幫助。
"
fnOpt_main_subCmdA() {
    case "$1" in
        -h | --help ) showHelp "$_fileName" ;;
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
        -h | --help ) showHelp "$_fileName" ;;
        * ) return 3 ;;
    esac
}
fnSh_main_subCmdA_subCmdB() {
    parseOption "$_fileName"
    echo "執行 B 子命令"
}

showHelpRecord "main_pressCtrlC" "\
<Ctrl>+C 退出測試。
[[USAGE]]
[[OPT]]
  -h, --help   幫助。
"
fnOpt_main_pressCtrlC() {
    case "$1" in
        -h | --help ) showHelp "$_fileName" ;;
        * )
            [ -z "$2" ] \
                && return 1 \
                || return 2
            ;;
    esac
}
fnSh_main_pressCtrlC() {
    parseOption "$_fileName"

    shScript_onCtrlC \
        "echo \"$_fRedB觸發 <Ctrl>+C 退出事件$_fN\" >&2" \
        "echo \"$_fRedB請檢查命令。 ($_fileName ${_origArgs[*]})$_fN\" >&2"

    echo "執行 pressCtrlC 子命令"
    printf "（請按下 <Ctrl>+C 繼續）"
    sleep 86400
}


##shStyle 共享變數



##shStyle 函式庫



##shStyle ###


shScript "main" "$@"

