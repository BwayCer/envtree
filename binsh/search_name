#!/bin/bash
# 搜尋文件名稱


viewFile="${PWD}/.search_name.tem.txt"

# $1: 文件名稱
# $2: 相對路徑
# $3、$4: find 的有效選項
find $2 $3 $4 | grep --color=auto $1 > $viewFile

vim $viewFile
rm $viewFile

exit 0

