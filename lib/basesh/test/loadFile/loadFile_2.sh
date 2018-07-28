#!/bin/bash


echo "[loadFile_2.sh]: \"$_shBase_loadfile\" 文件被執行。"

case "$1" in
    # 接收參數測試
    1 )
        if [ $2 -ne 2 ] || [ $3 -ne 3 ]; then
            echo "[loadFile_2.sh]: 接收到的參數不符合預期。" >&2
            exit 1
        else
            echo "[loadFile_2.sh]: 接收到參數： $*"
        fi
        ;;
    # 模組名不可變
    2 )
        source shbase.sh "./loadFile_3_1.sh" "$@"
        if [ "loadFile_2.sh" != "`basename "$_shBase_loadfile"`" ]; then
            echo "[loadFile_2.sh]: 模組名不符合預期。" >&2
            exit 1
        fi
        ;;
    # 重複載入
    # 循環載入
    [34] )
        if [ "$loadFile_2" == "1" ]; then
            echo "[loadFile_2.sh]: 載入次數不符合預期。（重複載入）" >&2
            exit 2
        fi
        loadFile_2=1
        source shbase.sh "./loadFile_3_1.sh" "$@"
        ;;
esac

