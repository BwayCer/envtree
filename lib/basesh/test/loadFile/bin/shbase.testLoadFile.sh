#!/bin/bash


echo "[shbase.testLoadFile.sh]: \"$_shBase_loadfile\" 文件被執行。"

if [ $1 -ne 1 ] || [ $2 -ne 2 ] || [ $3 -ne 3 ]; then
    echo "[shbase.testLoadFile.sh]: 接收到的參數不符合預期。" >&2
    exit 1
else
    echo "[shbase.testLoadFile.sh]: 接收到參數： $*"
fi

