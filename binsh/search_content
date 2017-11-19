#!/bin/bash
# 搜尋文件內容


viewFile="${PWD}/.search_content.tem.txt"

# $1: 關鍵字
# $2: 相對路徑
grep -rni $1 ${PWD}/$2 | sed '1,$s/\(\w\+\):\(\w\+\):\(.\+\)/\1:\2\n\t\3\n/' > $viewFile

vim $viewFile
rm $viewFile

# if [ $? == 0 ] ; then
#     rm $viewFile
# fi

exit 0

