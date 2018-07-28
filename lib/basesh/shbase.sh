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


if [ -z "$_shBase" ]; then
    _shBase=1

    # 當前加載的模組名 可用於判別是否是
    _shBase_loadfile=""

    # 紀錄已載入清單 避免重複載入
    _shBase_loaded=""
    # 紀錄載入中清單 避免循環載入
    _shBase_loading=""

    _shBase_load() {
        local name="$1"; shift

        local loaded
        local prevFilename filename
        local tmpName=$name

        # 腳本基礎相關文件名稱轉換
        [ -n "`grep "^#[A-Za-z]\+$" <<< "$tmpName"`" ] \
            && tmpName="shbase.${tmpName:1}.sh"

        # 判斷文件路徑
        which "$tmpName" &> /dev/null \
            && tmpName=`which "$tmpName"`

        if [ -f "$tmpName" ] && [ -x "$tmpName" ]; then
            filename=`realpath "$tmpName"`
        else
            _shBase_load_throw 1 "找不到 \"$name\" 文件。"
        fi

        # 若已加載過就略過
        [ `_shBase_load_txtyn "hasOwn" "$_shBase_loaded" "$filename"` -eq 1 ] && return

        # 若載入中則代表循環載入 拋出錯誤
        [ `_shBase_load_txtyn "hasOwn" "$_shBase_loading" "$filename"` -eq 1 ] \
            && _shBase_load_throw 1 "循環載入 \"$filename\" 文件。"

        _shBase_loading=`_shBase_load_txtyn "concat" "$_shBase_loading" "$filename"`
        prevFilename=$_shBase_loadfile
        _shBase_loadfile=$filename
        _shBase_load_source "$@"
        _shBase_loading=`_shBase_load_txtyn "rm" "$_shBase_loading" "$filename"`
        _shBase_loaded=`_shBase_load_txtyn "concat" "$_shBase_loaded" "$filename"`
        _shBase_loadfile=$prevFilename
    }
    _shBase_load_source() {
        source "$_shBase_loadfile" "$@"
    }
    # txtfind.lib.sh 文字有沒有
    _shBase_load_txtyn() {
        local method="$1"
        local txt=`echo $2`      # 把多行文字轉為單行
        local newTxt=`echo $3`

        local key

        case "$method" in
            "hasOwn" )
                [ -n "`grep " ${#newTxt}$newTxt " <<< " $txt "`" ] \
                    && echo 1 \
                    || echo 0
                ;;
            "concat" )
                key=${#newTxt}$newTxt

                [ -n "`grep " $key " <<< " $txt "`" ] \
                    && echo $txt \
                    || echo $txt $key
                ;;
            "rm" )
                key=${#newTxt}$newTxt

                if [ -n "`grep " $key " <<< " $txt "`" ]; then
                    key=`sed 's/\//\\\\\//g' <<< "$key"`
                    txt=`sed "s/ $key / /" <<< " $txt "`
                fi

                echo $txt
                ;;
        esac
    }
    _shBase_load_throw() {
        local code=$1
        local msg="$2"

        printf "[shbase.sh]: %s\n" "$msg" >&2
        exit $code
    }
fi

[ "$_shBase" == "1" ] && _shBase_load "$@"

