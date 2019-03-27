#!/bin/bash
# 數組陣列 - 連接


##shStyle 函式庫


# fnArrayJoin <分隔符> <項目 ...>
fnArrayJoin() {
    local separator="$1"; shift
    local list=("$@")

    local idx
    local lastIdx=$((${#list[@]} - 1))
    local txt=""

    for idx in `seq 0 $lastIdx`
    do
        txt+=${list[idx]}
        [ $idx -eq $lastIdx ] || txt+="$separator"
    done

    echo -n "$txt"
}


##shStyle ###


[ -n "$_shBase_loadfile" ] || fnArrayJoin "$@"

