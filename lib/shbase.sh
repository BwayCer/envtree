#!/bin/bash
# 腳本基礎 - 載入


##shStyle 介面函式
# 對外接口 請驗證輸入值
# 禁止介面函式間相互調用 避免全域變數混雜

##shStyle 共享變數

##shStyle 函式庫
# 若有來源者請註記
# 所有功能請在函式範圍內完成 fnLib, fnLib_xxx, rtnLib_xxx
# 僅允許使用 腳本環境、共享變數 的全域物件

##shStyle 腳本環境

##shStyle ###
# 不共享環境、專屬環境或其他分類


#--
# 載入邏輯
#   1. 腳本基礎相關文件只限與本文件相同目錄且特定名稱的文件。
#   2. 只有 "shbase.abase.sh" 文件可有效攜帶參數。
#   3. 必須為可執行文件。
#   4. 不允許跨行的路徑名。
#   5. 相同文件僅會被載入一次。
#--


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

    # 當前加載的模組名 可用於判別是否是
    _shBase_loadfile=""

    # shBase#abase 僅可被載入一次
    _shBase_abase=0
    # 紀錄已載入清單 避免重複載入
    _shBase_loaded=""
    # 紀錄載入中清單 避免循環載入
    _shBase_loading=""

    _shBase_load() {
        local name="$1"; shift

        local prevFilename filename
        local tmpName=$name

        # 腳本基礎相關文件
        if [ -n "`grep "^#[A-Za-z]\+$" <<< "$tmpName"`" ]; then
            if [ "$tmpName" == "#abase" ]; then
                [ $_shBase_abase -ne 0 ] && _shBase_throw 1 "重複載入 \"#abase\" 文件。"
                _shBase_abase=1
            fi
            tmpName="$_shBase/shbase.${tmpName:1}.sh"
        # 判斷文件路徑
        elif [ -z "`grep -F "/" <<< "$tmpName"`" ] && which "$tmpName" &> /dev/null
        then
            tmpName=`which "$tmpName"`
        fi

        [ -f "$tmpName" ] && [ -x "$tmpName" ] \
            || _shBase_throw 1 "找不到 \"$name\" 文件。"

        filename=`realpath "$tmpName"`

        # 若已加載過就略過
        [ "`_shBase_load_txtyn "hasOwn" "$_shBase_loaded" "$filename"`" -eq 1 ] && return

        # 若載入中則代表循環載入 拋出錯誤
        [ "`_shBase_load_txtyn "hasOwn" "$_shBase_loading" "$filename"`" -eq 1 ] \
            && _shBase_throw 1 "循環載入 \"$filename\" 文件。"

        _shBase_loading=`_shBase_load_txtyn "concat" "$_shBase_loading" "$filename"`
        prevFilename=$_shBase_loadfile
        _shBase_loadfile=$filename
        # 一般文件只提供載入服務
        [ "$name" != "#abase" ] \
            && _shBase_load_source \
            || _shBase_load_source "$@"
        _shBase_loading=`_shBase_load_txtyn "rm" "$_shBase_loading" "$filename"`
        _shBase_loaded=`_shBase_load_txtyn "concat" "$_shBase_loaded" "$filename"`
        _shBase_loadfile=$prevFilename
    }
    _shBase_load_source() {
        source "$_shBase_loadfile" "$@"
    }
    _shBase_load_txtyn() {
        local method="$1"
        local txt="$2"
        local newTxt="$3"

        if [ `wc -l <<< "$txt"` -ne 1 ] || [ `wc -l <<< "$newTxt"` -ne 1 ]; then
            _shBase_throw 1 "不允許跨行的路徑名。"
        fi

        local tmp

        $_shBase/txtyn.lib.sh "$@"
        tmp=$?; [ $tmp -eq 0 ] || exit $tmp
    }
fi

_shBase_load "$@"

