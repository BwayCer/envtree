#!/bin/bash
# 路徑 - 相對路徑


##shStyle 函式庫


# fnPathRelative <參考目錄路徑> <查詢路徑>
fnPathRelative() {
    local referencePathArgu="$1"
    local queryPathArgu="$2"

    local tmp
    local idx
    local referencePath queryPath
    local baseFieldNameLength relativeLength
    local fieldIdx fieldNameA fieldNameB
    local relativePath=""

    referencePath="`realpath "$referencePathArgu"`/"
    tmp=$?; [ $tmp -eq 0 ] || return $tmp
    queryPath=`realpath "$queryPathArgu"`
    tmp=$?; [ $tmp -eq 0 ] || return $tmp

    # 若為跨行的路徑則不認為其有交集
    if [ `wc -l <<< "$exePath"` -ne 1 ]; then
        echo "$queryPath"
        return
    fi

    baseFieldNameLength=`grep -Fo "/" <<< "$referencePath" | wc -l`

    fieldIdx=1
    for idx in `seq 2 "$baseFieldNameLength"`
    do
        fieldNameA=`cut -d "/" -f "$idx" <<< "$referencePath"`
        [ -z "$fieldNameA" ] && break
        fieldNameB=`cut -d "/" -f "$idx" <<< "$queryPath"`
        [ -z "$fieldNameB" ] && break

        [ "$fieldNameA" != "$fieldNameB" ] && break
        fieldIdx=$idx
    done

    ((relativeLength= $baseFieldNameLength - $fieldIdx))

    if [ $relativeLength -eq 0 ]; then
        relativePath+="./"
    else
        for idx in `seq 1 "$relativeLength"`
        do
            relativePath+="../"
        done
    fi

    relativePath+=`cut -d "/" -f "$((fieldIdx + 1))-" <<< "$queryPath"`
    echo "$relativePath"
}


##shStyle ###


[ -n "$_shBase_loadfile" ] || fnPathRelative "$@"

