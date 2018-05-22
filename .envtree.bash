#!/bin/bash
# 啟用專屬命令行介面


if [ -f "$HOME/.bashrc.ysBash" ]; then
    source "$HOME/.bashrc.ysBash"
else
    "$HOME/ys/capp/lib/envtree/ysBash" init
fi

