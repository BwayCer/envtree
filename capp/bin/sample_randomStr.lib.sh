#!/bin/bash
# 64 位亂數文字


fnRandomStr() {
    local len=6
    [ -n "$1" ] && [ $1 -gt 0 ] && len=$1

    local loop rem random
    local strAns=""
    for loop in `seq 1 $len`
    do
        random=$RANDOM
        rem=$[ $random & 63 ]
        random=$[ $random >> 6 ]
        strAns+=${fnRandomStr_count64:$rem:1}
    done
    echo $strAns
}
fnRandomStr_count64="0123456789ABCDEFGHIJKLMNOPQRSTUVXWYZabcdefghijklmnopqrstuvxwyz_-"


fnRandomStr "$@"

