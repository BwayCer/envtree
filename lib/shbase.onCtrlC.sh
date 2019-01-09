#!/bin/bash
# 腳本基礎 - <Ctrl>+c 退出事件


##shStyle 腳本環境


# <Ctrl>+c 退出事件
# # 範例：
# #   * `shScript_onCtrlC "echo \"觸發 <Ctrl>+C 退出事件\" >&2"`
# [[USAGE]] <命令 ... (`sh -c` 可有效執行的命令文字)>

shScript_onCtrlC() {
    local val
    for val in "$@"
    do
        _shScript_onCtrlC_cmd+=$val$_br
    done
}
_shScript_onCtrlC_cmd=""


##shStyle ###


[ -n "$_br" ] || _br="
"
trap 'sh -c "echo; $_shScript_onCtrlC_cmd echo"; exit' 2

