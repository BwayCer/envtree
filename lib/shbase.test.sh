#!/bin/bash
# 腳本基礎 - 測試


##shStyle ###


source shbase "#fColor"


##shStyle 函式庫


fnTest() {
    local opt_fields=""

    while [ -n "y" ]
    do
        case "$1" in
            --fields )
                opt_fields=$2
                shift 2
                ;;
            * ) break ;;
        esac
    done

    local title
    local recordCmdMsg rtnCode rtnCode_second
    local ynShowPrintArea=0

    ((fnTest_count++))

    [ -n "$fnTest_title" ] && title=$fnTest_title || title="---"
    printf "${_fYelB}## (%03d) %s$_fN\n" "$fnTest_count" "$title"

    if ! fnTest_shCheck ; then
        printf "執行結果： ${_fGreB}%s$_fN\n" "未設定測試執行程序"
        echo
        return
    fi

    # 是否顯示該次打印訊息
    if [ "$opt_fields" == "all" ] \
        || [ -n "`grep -F ",$fnTest_count," <<< ",$opt_fields,"`" ]
    then
        ynShowPrintArea=1
    fi

    fnTest_shRun &> /dev/null
    rtnCode=$?
    [ $rtnCode -ne 0 ] && ynShowPrintArea=1

    if [ $ynShowPrintArea -eq 0 ]; then
        fnTest_shRun &> /dev/null
        rtnCode_second=$?
    else
        echo
        fnTest_shRun
        rtnCode_second=$?
        echo
    fi

    # 測試程式碼反覆執行結果不可變
    if [ "$rtnCode" != "$rtnCode_second" ]; then
        printf "${_fRedB}[shbase.test.sh]: %s$_fN\n" \
            "測試程式碼兩次執行結果不一致。 ($rtnCode != $rtnCode_second)"
        echo
        exit 1
    fi

    fnTest_shClear

    printf "執行結果： "
    [ $rtnCode -eq 0 ] \
        && printf "${_fGreB}成功" \
        || printf "${_fRedB}失敗"
    printf "$_fN\n"
    echo
}
fnTest_count=0
fnTest_shCheck() {
     type fnTest_it &> /dev/null && type fnTest_ok &> /dev/null \
        && return 0 \
        || return 1
}
fnTest_shClear() {
    unset fnTest_title
    unset -f fnTest_before
    unset -f fnTest_after
    unset -f fnTest_it
    unset -f fnTest_ok
}
fnTest_shRun() {
    local rtnCode

    if type fnTest_before &> /dev/null ; then
        echo "--- 執行前處理區 ---"
        echo
        fnTest_before
        echo
    fi

    echo "--- 執行區 ---"
    echo
    fnTest_it
    rtnCode=$?
    echo
    printf "${_fYelB}(exitCode: %s)$_fN\n" "$rtnCode"
    echo

    if type fnTest_after &> /dev/null ; then
        echo "--- 執行後處理區 ---"
        echo
        fnTest_after
        echo
    fi

    echo "--- 執行結束 ---"

    fnTest_ok $rtnCode &> /dev/null
    rtnCode=$?

    return $rtnCode
}
# fnTest_title=""   # 執行項目名稱
# fnTest_before()   # 執行前動作
# fnTest_after()    # 執行後動作
# fnTest_it()       # 執行動作
# fnTest_ok()       # 判斷執行結果

