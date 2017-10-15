#!/bin/bash
# 安裝 vim-plug


mkdirname="`dirname $0`/.vim/autoload/"

rm $0
mkdir -p $mkdirname
cd $mkdirname
curl -O https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

