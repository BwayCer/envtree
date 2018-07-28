#!/bin/bash


echo "[loadFile_bin_1.sh]: \"$_shBase_loadfile\" 文件被執行。"

if [ $1 -ne 1 ] || [ $2 -ne 2 ] || [ $3 -ne 3 ]; then
    echo "[loadFile_bin_1.sh]: 接收到的參數不符合預期。" >&2
    exit 1
else
    echo "[loadFile_bin_1.sh]: 接收到參數： $*"
fi

