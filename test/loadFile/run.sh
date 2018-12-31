#!/bin/bash
# 文件載入測試


##shStyle 共享變數


# 文件路徑資訊
_dirsh=$(dirname "$(realpath "$0")")
_binsh=`realpath "$_dirsh/../../bin"`
_libsh=`realpath "$_dirsh/../../lib"`


# 執行 `sh -c` 隔離使用的程式碼
testCode=""

binTestDir=`realpath "$_dirsh/binTest"`
libTestDir=`realpath "$_dirsh/libTest"`

envPath_binTest='
[ -z "`grep ":'"$binTestDir"':" <<< ":$PATH:"`" ] && PATH="'"$binTestDir"':$PATH"
'


fnFileContent_catchArgs() {
    local fileName="$1"

    echo '#!/bin/bash'
    echo
    echo 'echo "['$fileName']: \"$_shBase_loadfile\" 文件被執行。"'
    echo ''
    echo 'if [ -n "$*" ]; then'
    echo '    echo "['$fileName']: 接收到參數： $*" >&2'
    echo '    echo "['$fileName']: 接收到的參數不符合預期。" >&2'
    echo '    exit 1'
    echo 'fi'
}
txt_loadFile_2=`fnFileContent_catchArgs "loadFile_2.sh"`
txt_loadFile_bin_1=`fnFileContent_catchArgs "loadFile_bin_1.sh"`
txt_shbase_testLoadFile=`fnFileContent_catchArgs "shbase.testLoadFile.sh"`
txt_shbase_abase='#!/bin/bash

echo "[shbase.abase.sh]: \"$_shBase_loadfile\" 文件被執行。"

if [ "$1" != "1" ] || [ "$2" != "2" ] || [ "$3" != "3" ]; then
    echo "[shbase.abase.sh]: 接收到參數： $*" >&2
    echo "[shbase.abase.sh]: 接收到的參數不符合預期。" >&2
    exit 1
fi
'
txt_testNoChangeName_1='#!/bin/bash

echo "[testNoChangeName_1.sh]: \"$_shBase_loadfile\" 文件被執行。"

source shbase "./testNoChangeName_2.sh" "$@"

echo "[testNoChangeName_1.sh]: 當前模組名訊息為： \"`basename "$_shBase_loadfile"`\"。"
if [ "testNoChangeName_1.sh" != "`basename "$_shBase_loadfile"`" ]; then
    echo "[testNoChangeName_1.sh]: 模組名不符合預期。" >&2
    exit 1
fi
'
txt_testNoChangeName_2='#!/bin/bash

echo "[testNoChangeName_2.sh]: \"$_shBase_loadfile\" 文件被執行。"

_shBase_loadfile="---"
echo "[testNoChangeName_2.sh]: 刻意修改變量值 \`_shBase_loadfile=\"$_shBase_loadfile\"\`。"
'
txt_testMultipleLoad_1='#!/bin/bash

echo "[testMultipleLoad_1.sh]: \"$_shBase_loadfile\" 文件被執行。"

if [ "$testMultipleLoad_1" == "1" ]; then
    echo "[testMultipleLoad_1.sh]: 載入次數不符合預期。（重複載入）" >&2
    exit 2
fi

testMultipleLoad_1=1
'
txt_testLoopLoad_1='#!/bin/bash

echo "[testLoopLoad_1.sh]: \"$_shBase_loadfile\" 文件被執行。"

if [ "$testLoopLoad_1" == "1" ]; then
    echo "[testLoopLoad_1.sh]: 載入次數不符合預期。（重複載入）" >&2
    exit 2
fi

testLoopLoad_1=1

source shbase "./testLoopLoad_2.sh"
'
txt_testLoopLoad_2='#!/bin/bash

echo "[testLoopLoad_2.sh]: \"$_shBase_loadfile\" 文件被執行。"

source shbase "./testLoopLoad_1.sh"
'


fnRm() {
    for filename in "$@"
    do
        if [ -d "$filename" ]; then
            echo "$ rm -rf \"$filename\""
            rm -rf "$filename"
        elif [ -e "$filename" ]; then
            echo "$ rm \"$filename\""
            rm "$filename"
        else
            echo "# 找不到 \"$filename\""
        fi
    done
}


##shStyle ###


[ -z "`grep ":$_binsh:" <<< ":$PATH:"`" ] && PATH="$_binsh:$PATH"
source shbase "#test"


cd "$_dirsh"
[ -d "$binTestDir" ] && rm -rf "$binTestDir"
[ -d "$libTestDir" ] && rm -rf "$libTestDir"
mkdir "$binTestDir" "$libTestDir"
cp "$_libsh/shbase.sh" "$libTestDir"
cp "$_libsh/txtyn.lib.sh" "$libTestDir"
ln -s "$libTestDir/shbase.sh" "$binTestDir/shbase"


#
# test 載入 非執行文件、資料夾
#

fnTest_title="載入非執行文件錯誤測試"
fnTest_before() {
    local filename="./loadFile_1_1.txt"
    echo "create \"$filename\""
    touch "$filename"
    chmod 644 "$filename"
}
fnTest_after() {
    fnRm "./loadFile_1_1.txt"
}
testCode=$envPath_binTest'
loadFile="./loadFile_1_1.txt"
echo "$ source shbase \"$loadFile\""
source shbase "$loadFile"
'
fnTest_it() {
    sh -c "$testCode"
}
fnTest_ok() {
    local exitCode=$1

    [ $exitCode -eq 1 ] \
        && return 0 \
        || return 1
}
fnTest "$@"

fnTest_title="載入資料夾錯誤測試"
fnTest_before() {
    echo '$ mkdir "./loadFile_1_2.folder"'
    mkdir "./loadFile_1_2.folder"
}
fnTest_after() {
    fnRm "./loadFile_1_2.folder"
}
testCode=$envPath_binTest'
loadFile="./loadFile_1_2.folder"
echo "$ source shbase \"$loadFile\""
source shbase "$loadFile"
'
fnTest_it() {
    sh -c "$testCode"
}
fnTest_ok() {
    local exitCode=$1

    [ $exitCode -eq 1 ] \
        && return 0 \
        || return 1
}
fnTest "$@"


#
# test 載入文件
#

fnTest_title="載入文件測試"
fnTest_before() {
    local filename
    filename="./loadFile_2.sh"
    echo "create \"$filename\""
    echo "$txt_loadFile_2" > "$filename"
    chmod 755 "$filename"
}
fnTest_after() {
    fnRm "./loadFile_2.sh"
}
testCode=$envPath_binTest'
loadFile="./loadFile_2.sh"
echo "$ source shbase \"$loadFile\" 1 2 3"
source shbase "$loadFile" 1 2 3
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnTest_it() {
    sh -c "$testCode"
}
fnTest_ok() {
    local exitCode=$1

    return $exitCode
}
fnTest "$@"

fnTest_title="載入可執行文件測試"
fnTest_before() {
    local filename="$binTestDir/loadFile_bin_1.sh"
    echo "#\$ create \"$filename\""
    echo "$txt_loadFile_bin_1" > "$filename"
    chmod 755 "$filename"
}
fnTest_after() {
    fnRm "$binTestDir/loadFile_bin_1.sh"
}
testCode=$envPath_binTest'
loadFile="loadFile_bin_1.sh"
echo "$ source shbase \"$loadFile\" 1 2 3"
source shbase "$loadFile" 1 2 3
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnTest_it() {
    sh -c "$testCode"
}
fnTest_ok() {
    local exitCode=$1

    return $exitCode
}
fnTest "$@"

fnTest_title="載入鏈結文件測試"
fnTest_before() {
    local filename="$binTestDir/loadFile_bin_1.sh"
    echo "#\$ create \"$filename\""
    echo "$txt_loadFile_bin_1" > "$filename"
    chmod 755 "$filename"
    echo "\$ ln -s \"./loadFile_bin_1.sh\" \"$binTestDir/loadFile_bin_2_link\""
    ln -s "./loadFile_bin_1.sh" "$binTestDir/loadFile_bin_2_link"
}
fnTest_after() {
    fnRm \
        "$binTestDir/loadFile_bin_1.sh" \
        "$binTestDir/loadFile_bin_2_link"
}
testCode=$envPath_binTest'
loadFile="loadFile_bin_2_link"
echo "$ source shbase \"$loadFile\" 1 2 3"
source shbase "$loadFile" 1 2 3
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnTest_it() {
    sh -c "$testCode"
}
fnTest_ok() {
    local exitCode=$1

    return $exitCode
}
fnTest "$@"

fnTest_title="載入腳本基礎文件測試"
fnTest_before() {
    local filename="$libTestDir/shbase.testLoadFile.sh"
    echo "#\$ create \"$filename\""
    echo "$txt_shbase_testLoadFile" > "$filename"
    chmod 755 "$filename"
}
fnTest_after() {
    fnRm "$libTestDir/shbase.testLoadFile.sh"
}
testCode=$envPath_binTest'
loadFile="#testLoadFile"
echo "$ source shbase \"$loadFile\" 1 2 3"
source shbase "$loadFile" 1 2 3
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnTest_it() {
    sh -c "$testCode"
}
fnTest_ok() {
    local exitCode=$1

    return $exitCode
}
fnTest "$@"

fnTest_title="載入腳本基礎 #abash 文件並傳遞參數測試"
fnTest_before() {
    local filename="$libTestDir/shbase.abase.sh"
    echo "#\$ create \"$filename\""
    echo "$txt_shbase_abase" > "$filename"
    chmod 755 "$filename"
}
fnTest_after() {
    fnRm "$libTestDir/shbase.abase.sh"
}
testCode=$envPath_binTest'
loadFile="#abase"
echo "$ source shbase \"$loadFile\" 1 2 3"
source shbase "$loadFile" 1 2 3
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnTest_it() {
    sh -c "$testCode"
}
fnTest_ok() {
    local exitCode=$1

    return $exitCode
}
fnTest "$@"


#
# test 載入多個文件
#

fnTest_title="載入多個文件且模組名不可變"
fnTest_before() {
    local filename
    filename="./testNoChangeName_1.sh"
    echo "#\$ create \"$filename\""
    echo "$txt_testNoChangeName_1" > "$filename"
    chmod 755 "$filename"
    filename="./testNoChangeName_2.sh"
    echo "#\$ create \"$filename\""
    echo "$txt_testNoChangeName_2" > "$filename"
    chmod 755 "$filename"
}
fnTest_after() {
    fnRm "./testNoChangeName_1.sh" "./testNoChangeName_2.sh"
}
testCode=$envPath_binTest'
loadFile="./testNoChangeName_1.sh"
echo "$ source shbase \"$loadFile\""
source shbase "$loadFile"
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnTest_it() {
    sh -c "$testCode"
}
fnTest_ok() {
    local exitCode=$1

    return $exitCode
}
fnTest "$@"


fnTest_title="載入多個文件且重複加載測試"
fnTest_before() {
    local filename
    filename="./loadFile_2.sh"
    echo "#\$ create \"$filename\""
    echo "$txt_loadFile_2" > "$filename"
    chmod 755 "$filename"
    filename="./testMultipleLoad_1.sh"
    echo "#\$ create \"$filename\""
    echo "$txt_testMultipleLoad_1" > "$filename"
    chmod 755 "$filename"
}
fnTest_after() {
    fnRm "./loadFile_2.sh" "./testMultipleLoad_1.sh"
}
testCode=$envPath_binTest'
for loadFile in "./testMultipleLoad_1.sh" "./loadFile_2.sh" "./testMultipleLoad_1.sh"
do
    echo "$ source shbase \"$loadFile\""
    source shbase "$loadFile"
    tmp=$?; [ $tmp -eq 0 ] || exit $tmp
done
'
fnTest_it() {
    sh -c "$testCode"
}
fnTest_ok() {
    local exitCode=$1

    [ $exitCode -eq 0 ] \
        && return 0 \
        || return 1
}
fnTest "$@"


fnTest_title="循環載入錯誤測試"
fnTest_before() {
    local filename
    filename="./testLoopLoad_1.sh"
    echo "#\$ create \"$filename\""
    echo "$txt_testLoopLoad_1" > "$filename"
    chmod 755 "$filename"
    filename="./testLoopLoad_2.sh"
    echo "#\$ create \"$filename\""
    echo "$txt_testLoopLoad_2" > "$filename"
    chmod 755 "$filename"
}
fnTest_after() {
    fnRm "./testLoopLoad_1.sh" "./testLoopLoad_2.sh"
}
testCode=$envPath_binTest'
loadFile="./testLoopLoad_1.sh"
echo "$ source shbase \"$loadFile\""
source shbase "$loadFile"
tmp=$?; [ $tmp -eq 0 ] || exit $tmp
'
fnTest_it() {
    sh -c "$testCode"
}
fnTest_ok() {
    local exitCode=$1

    k=$exitCode
    [ $exitCode -eq 1 ] \
        && return 0 \
        || return 1
}
fnTest "$@"


rm -rf "$binTestDir" "$libTestDir"
exit

