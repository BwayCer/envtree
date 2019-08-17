#!/bin/bash
# 簡化 腳本基礎 - 載入


if [ -z "$_shBase" ]; then
    _shBase_throw() {
        local code=$1
        local msg="$2"

        local loadfile
        [ -n "$_shBase_loadfile" ] \
            && loadfile="$_shBase_loadfile" \
            || loadfile="origin:`basename "$0"`"

        printf "[shbase.sh]: %s (on %s)\n" "$msg" "$loadfile" >&2
        exit $code
    }

    which "shbase" &> /dev/null \
        && _shBase=$(dirname "$(realpath "$(which "shbase")")") \
        || _shBase_throw 1 "找不到 \"shbase.sh (shbase*)\" 文件。"

    _shBase=`realpath "$_shBase/../../shbase/lib"`

    # 當前加載的模組名 可用於判別是否是
    _shBase_loadfile=""

    # shBase#abase 僅可被載入一次
    _shBase_abase=0
    # 紀錄已載入清單 避免重複載入
    _shBase_loaded=""

    _shBase_load() {
        local name="$1"

        # 若已加載過就略過
        [ "`_shBase_load_txtyn "hasOwn" "$_shBase_loaded" "$name"`" -eq 1 ] && return

        local tmp
        local prevFilename filename
        local tmpName=$name

        # 腳本基礎相關文件
        if [[ "$tmpName" =~ ^#[A-Za-z]+$ ]]; then
            if [ "$tmpName" == "#abase" ]; then
                [ $_shBase_abase -ne 0 ] && _shBase_throw 1 "重複載入 \"#abase\" 文件。"
                _shBase_abase=1
            fi
            tmpName="$_shBase/shbase.${tmpName:1}.sh"
        # 判斷文件路徑
        elif [[ ! "$tmpName" =~ "/" ]]; then
            tmp=`which "$tmpName" 2> /dev/null`
            if [ $? -eq 0 ]; then
                tmpName=$tmp
            fi
        fi

        [ -f "$tmpName" ] && [ -x "$tmpName" ] \
            || _shBase_throw 1 "找不到 \"$name\" 文件。"

        filename=`realpath "$tmpName"`

        prevFilename=$_shBase_loadfile
        _shBase_loadfile=$filename
        _shBase_load_source
        _shBase_loaded=`_shBase_load_txtyn "concat" "$_shBase_loaded" "$name"`
        _shBase_loaded=`_shBase_load_txtyn "concat" "$_shBase_loaded" "$filename"`
        _shBase_loadfile=$prevFilename
    }
    _shBase_load_source() {
        source "$_shBase_loadfile"
    }
    _shBase_load_txtyn() {
        local method="$1"
        local txt="$2"
        local newTxt="$3"

        local lenNewTxt=${#newTxt}
        local key=$lenNewTxt$newTxt
        local grepIdx

        case "$method" in
            "hasOwn" )
                [[ " $txt " =~ " $key " ]] && echo 1 || echo 0
                ;;
            "concat" )
                [[ " $txt " =~ " $key " ]] \
                    && echo $txt \
                    || echo $txt $key
                ;;
        esac
    }
fi

_shBase_load "$@"

