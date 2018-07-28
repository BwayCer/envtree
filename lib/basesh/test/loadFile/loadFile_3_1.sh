#!/bin/bash


echo "[loadFile_3_1.sh]: \"$_shBase_loadfile\" 文件被執行。"

case "$1" in
    # 模組名不可變
    2 )
        echo "[loadFile_3_1.sh]: 刻意修改 \"\$_shBase_loadfile\" 變量值。"
        _shBase_loadfile="---"
        ;;
    # 循環載入
    4 )
        source shbase.sh "./loadFile_2.sh" "$@"
        ;;
esac


