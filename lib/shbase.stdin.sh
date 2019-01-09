#!/bin/bash
# 腳本基礎 - 標準輸入


##shStyle 腳本環境


# 標準輸入變量
_stdin=`[ ! -t 0 ] && while read pipeData; do echo $pipeData; done <&0`

