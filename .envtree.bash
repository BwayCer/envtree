#!/bin/bash
# 啟用專屬命令行介面


if [ -f "$HOME/ys/capp/lib/envtree/.proFile.ysBash" ]; then
    source "$HOME/ys/capp/lib/envtree/.proFile.ysBash"
else
    "$HOME/ys/capp/lib/envtree/ysBash" init
fi

