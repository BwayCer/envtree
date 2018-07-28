#!/bin/bash
# 文件載入測試


##shStyle 腳本環境


_br="
"

# 文件路徑資訊
__filename=`realpath "$0"`
_dirsh=`dirname "$__filename"`


_fN=`tput sgr0`
_fRedB=`tput setaf 1``tput bold`
_fGreB=`tput setaf 2``tput bold`
_fYelB=`tput setaf 3``tput bold`


##shStyle 共享變數


baseshDirname=`realpath "$_dirsh/../.."`
testBinDirname=`realpath "$_dirsh/bin"`

envPath_basesh='
[ -z "`grep ":'$baseshDirname':" <<< ":$PATH:"`" ] && PATH="'$baseshDirname':$PATH"
'
envPath_testBin='
[ -z "`grep ":'$testBinDirname':" <<< ":$PATH:"`" ] && PATH="'$testBinDirname':$PATH"
'


##shStyle 函式庫


fnRunSh() {
    fnRunSh_count=$((fnRunSh_count + 1))

    local recordCmdMsg rtnCode
    local autoShowCommandArea=0

    echo
    printf "$_fYelB## (%03d) %s$_fN\n" "$fnRunSh_count" "$fnRunSh_title"
    echo

    if [ $fnRunSh_opt_enableCommandArea -eq 0 ]; then
        sh -c "$fnRunSh_txtsh" &> /dev/null
        rtnCode=$?
        fnRunSh_callback $rtnCode &> /dev/null
        rtnCode=$?
        [ $rtnCode -ne 0 ] && autoShowCommandArea=1
    fi

    if [ $autoShowCommandArea -eq 1 ] || [ $fnRunSh_opt_enableCommandArea -eq 1 ]; then
        echo "--- 執行區 ---"

        sh -c "$fnRunSh_txtsh"
        rtnCode=$?

        echo "--- 執行結束 ---"
        echo

        fnRunSh_callback $rtnCode &> /dev/null
        rtnCode=$?
    fi

    printf "執行結果： "
    [ $rtnCode -eq 0 ] \
        && printf "$_fGreB成功" \
        || printf "$_fRedB失敗"
    printf "$_fN\n"

    echo
}
fnRunSh_count=0
fnRunSh_opt_enableCommandArea=0
# fnRunSh_title=""
# fnRunSh_txtsh=""
# fnRunSh_callback()


##shStyle ###


if [ "$1" == "--fullmsg" ]; then
    fnRunSh_opt_enableCommandArea=1
fi


#
# test 載入 非執行文件、資料夾
#

fnRunSh_title="載入非執行文件錯誤測試"
fnRunSh_txtsh=$envPath_basesh'
loadFile="./loadFile_1_1.txt"
echo "$ source shbase.sh \"$loadFile\""
source shbase.sh "$loadFile"
'
fnRunSh_callback() {
    local exitCode=$1

    [ $exitCode -eq 1 ] \
        && return 0 \
        || return 1
}
fnRunSh

fnRunSh_title="載入資料夾錯誤測試"
fnRunSh_txtsh=$envPath_basesh'
loadFile="./loadFile_1_2.folder"
echo "$ source shbase.sh \"$loadFile\""
source shbase.sh "$loadFile"
'
fnRunSh_callback() {
    local exitCode=$1

    [ $exitCode -eq 1 ] \
        && return 0 \
        || return 1
}
fnRunSh


#
# test 載入文件並傳遞參數
#

fnRunSh_title="載入文件並傳遞參數測試"
fnRunSh_txtsh=$envPath_basesh'
loadFile="./loadFile_2.sh"
echo "$ source shbase.sh \"$loadFile\" 1 2 3"
source shbase.sh "$loadFile" 1 2 3
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnRunSh_callback() {
    local exitCode=$1

    return $exitCode
}
fnRunSh

fnRunSh_title="載入可執行文件並傳遞參數測試"
fnRunSh_txtsh=$envPath_basesh$envPath_testBin'
loadFile="loadFile_bin_1.sh"
echo "$ source shbase.sh \"$loadFile\" 1 2 3"
source shbase.sh "$loadFile" 1 2 3
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnRunSh_callback() {
    local exitCode=$1

    return $exitCode
}
fnRunSh

fnRunSh_title="載入鏈結文件並傳遞參數測試"
fnRunSh_txtsh=$envPath_basesh$envPath_testBin'
loadFile="loadFile_bin_2_link"
echo "$ source shbase.sh \"$loadFile\" 1 2 3"
source shbase.sh "$loadFile" 1 2 3
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnRunSh_callback() {
    local exitCode=$1

    return $exitCode
}
fnRunSh

fnRunSh_title="載入腳本基礎文件並傳遞參數測試"
fnRunSh_txtsh=$envPath_basesh$envPath_testBin'
loadFile="#testLoadFile"
echo "$ source shbase.sh \"$loadFile\" 1 2 3"
source shbase.sh "$loadFile" 1 2 3
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnRunSh_callback() {
    local exitCode=$1

    return $exitCode
}
fnRunSh


#
# test 載入多個文件
#

fnRunSh_title="載入多個文件且模組名不可變"
fnRunSh_txtsh=$envPath_basesh'
for loadFile in "./loadFile_3_2.sh" "./loadFile_2.sh"
do
    echo "$ source shbase.sh \"$loadFile\" 2"
    source shbase.sh "$loadFile" 2
    tmp=$?; [ $tmp -eq 0 ] || exit $tmp
done
'
fnRunSh_callback() {
    local exitCode=$1

    return $exitCode
}
fnRunSh


fnRunSh_title="載入多個文件且重複加載測試"
fnRunSh_txtsh=$envPath_basesh'
for loadFile in "./loadFile_2.sh" "./loadFile_3_2.sh" "./loadFile_2.sh"
do
    echo "$ source shbase.sh \"$loadFile\" 3"
    source shbase.sh "$loadFile" 3
    tmp=$?; [ $tmp -eq 0 ] || exit $tmp
done
'
fnRunSh_callback() {
    local exitCode=$1

    [ $exitCode -eq 0 ] \
        && return 0 \
        || return 1
}
fnRunSh


fnRunSh_title="循環載入錯誤測試"
fnRunSh_txtsh=$envPath_basesh'
loadFile="./loadFile_2.sh"
echo "$ source shbase.sh \"$loadFile\" 4"
source shbase.sh "$loadFile" 4
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnRunSh_callback() {
    local exitCode=$1

    [ $exitCode -eq 1 ] \
        && return 0 \
        || return 1
}
fnRunSh



