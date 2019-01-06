#!/bin/bash
# 腳本基礎 - <Ctrl>+c 退出事件


##shStyle 腳本環境


# shScript_onCtrlC <... 命令>
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

