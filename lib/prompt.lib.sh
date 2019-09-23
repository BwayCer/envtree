#!/bin/bash
# 選項提問


##shStyle ###


source shbase "#fColor"
source shbase "#loxog"
source shbase "#parseOption"
source shbase "#showHelp"


##shStyle 函式庫


[ -n "$_shBase_loadfile" ] \
    && fnSampleLib_fileName=`basename "$_shBase_loadfile"` \
    || fnSampleLib_fileName=`basename "$0"`

showHelpRecord "fnPrompt" "\
選項提問
# 範例：
# $ ./$fnSampleLib_fileName \"請選擇\" \"Yes|yes|Y|y:*:確定\" \"No|no|N|n:取消\"
# 請選擇 ( Yes: 確定 ; No: 取消 ) :
[[USAGE]] <問題題目> <選項 [ ...] ([A-Za-z0-9_|-]*:\*\?:.*)>
[[OPT]]
  -h, --help   幫助。
"
fnPrompt_opt_carryOpt=""
fnPrompt_opt() {
    case "$1" in
        -h | --help ) showHelp "$fnSampleLib_fileName" "fnPrompt" ;;
        * ) return 3 ;;
    esac
}
rtnPrompt=""
fnPrompt() {
    parseOption "$fnSampleLib_fileName" "fnPrompt" "$@"

    local txtQuestion=${rtnParseOption[0]}
    local args=("${rtnParseOption[@]:1}")

    local val describe
    local option optionName optionDefault optionDescribe
    local txtList=""
    local defaultOption=""
    local txtDescribe=""

    for val in "${args[@]}"
    do
        [[ "$val" =~ $fnPrompt_regexCommandPure ]] || continue

        option=`        cut -d ":" -f 1 <<< "$val"`
        optionName=`    cut -d "|" -f 1 <<< "$option"`
        optionDefault=` sed "s/$fnPrompt_regexCommand/\2/" <<< "$val"`
        optionDescribe=`sed "s/$fnPrompt_regexCommand/\4/" <<< "$val"`

        describe=$optionName
        if [ -n "$optionDescribe" ]; then
            describe+=": $optionDescribe"
        fi

        txtList+="$_br|$option|"

        if [ "$optionDefault" == "*" ]; then
            defaultOption="$optionName"
            txtDescribe+=" `_fColor 21`${describe} ;$_fN"
        else
            txtDescribe+=" $describe ;"
        fi
    done

    if [ -z "$txtList" ]; then
        printf "%s%s\n" \
            "不符合預期的參數。" \
            ' ($ ./prompt <問題> <選項 "[A-Za-z0-9_|-]*:\*\?:.*" ...>' \
            | loxog -f "$fnSampleLib_fileName" --stderr err
        exit 1
    fi

    fnPrompt_ask "$txtQuestion ($txtDescribe )" "$txtList" "$defaultOption" "1"
}
fnPrompt_regexCommandPure='^[A-Za-z0-9_-][A-Za-z0-9_|-]*(:(\*)?)?(:(.*))?$'
fnPrompt_regexCommand='^[A-Za-z0-9_-][A-Za-z0-9_|-]*\(:\(\*\)\?\)\?\(:\(.*\)\)\?$'
fnPrompt_ask() {
    local txtQuestion="$1"
    local txtList="$2"
    local defaultOption="$3"
    local loopTimes=$4

    local tmpCho

    printf "%s : " "$txtQuestion"
    read tmpCho

    if [ -n "$defaultOption" ] && [ -z "$tmpCho" ]; then
        rtnPrompt="$defaultOption"
    elif [ -n "$defaultOption" ] && [ $loopTimes -ge 3 ]; then
        rtnPrompt="$defaultOption"
    elif [[ ! "$tmpCho" =~ "|" ]] && [[ "$txtList" =~ "|$tmpCho|" ]]; then
        rtnPrompt=`grep "|$tmpCho|" <<< "$txtList" | cut -d "|" -f 2`
    else
        fnPrompt_ask "$txtQuestion" "$txtList" "$defaultOption" "$((loopTimes + 1))"
    fi
}


##shStyle ###


if [ ! -n "$_shBase_loadfile" ]; then
    fnPrompt "$@"
    echo -e "選取結果：\n---\n$rtnPrompt\n---"
fi

