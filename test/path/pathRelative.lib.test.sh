#!/bin/bash
# 路徑 - 相對路徑 測試


##shStyle 建立測試環境


source shbase "#test"
source shbase "#loxog"


# 文件路徑資訊
_dirsh=$(dirname "$(realpath "$0")")


cd "$_dirsh"

if ! which pathRelative.lib.sh &> /dev/null ; then
    loxog -f "$_fileName" --stderr err \
        "找不到 \`pathRelative.lib.sh\` 命令。"
    exit 1
fi


##shStyle 共享變數



##shStyle 執行測試


#
# test # 絕對路徑測試
#

fnTest_title="無交集路徑測試"
fnTest_it() {
    local tmp
    local resultPath
    local originDirPath="$HOME"
    local    targetPath="/dev/null"

    resultPath=`pathRelative.lib.sh "$originDirPath" "$targetPath" 2> /dev/null`
    tmp=$?

    printf "  %10s : %s\n" \
        "參考目錄" "$originDirPath" \
        "目標" "$targetPath" \
        "實際" "$resultPath" \
        "預期" "/dev/null"

    [ $tmp -eq 0 ] || return $tmp
    [ "$resultPath" == "/dev/null" ]
}
fnTest_ok() {
    local exitCode=$1
    [ $exitCode -eq 0 ]
}
fnTest "$@"


#
# test # 上層相對路徑測試
#

fnTest_title="同層路徑測試"
fnTest_it() {
    local tmp
    local resultPath
    local originDirPath="../../"
    local    targetPath="../../lib"

    resultPath=`pathRelative.lib.sh "$originDirPath" "$targetPath" 2> /dev/null`
    tmp=$?

    printf "  %10s : %s\n" \
        "參考目錄" "$originDirPath" \
        "目標" "$targetPath" \
        "實際" "$resultPath" \
        "預期" "./lib"

    [ $tmp -eq 0 ] || return $tmp
    [ "$resultPath" == "./lib" ]
}
fnTest_ok() {
    local exitCode=$1
    [ $exitCode -eq 0 ]
}
fnTest "$@"

fnTest_title="下層路徑測試"
fnTest_it() {
    local tmp
    local resultPath
    local originDirPath="../../"
    local    targetPath="../../lib/pathRelative.lib.sh"

    resultPath=`pathRelative.lib.sh "$originDirPath" "$targetPath" 2>&1`
    tmp=$?

    printf "  %10s : %s\n" \
        "參考目錄" "$originDirPath" \
        "目標" "$targetPath" \
        "實際" "$resultPath" \
        "預期" "./lib/pathRelative.lib.sh"

    [ $tmp -eq 0 ] || return $tmp
    [ "$resultPath" == "./lib/pathRelative.lib.sh" ]
}
fnTest_ok() {
    local exitCode=$1
    [ $exitCode -eq 0 ]
}
fnTest "$@"

fnTest_title="上層路徑測試"
fnTest_it() {
    local tmp
    local resultPath
    local originDirPath="."
    local    targetPath="../../"

    resultPath=`pathRelative.lib.sh "$originDirPath" "$targetPath" 2> /dev/null`
    tmp=$?

    printf "  %10s : %s\n" \
        "參考目錄" "$originDirPath" \
        "目標" "$targetPath" \
        "實際" "$resultPath" \
        "預期" "../../"

    [ $tmp -eq 0 ] || return $tmp
    [ "$resultPath" == "../../" ]
}
fnTest_ok() {
    local exitCode=$1
    [ $exitCode -eq 0 ]
}
fnTest "$@"


##shStyle 復原環境


fnTest_exit

