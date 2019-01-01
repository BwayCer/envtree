#!/bin/bash
# 腳本基礎 - 解析選項


##shStyle ###


source shbase "#loxog"


##shStyle 函式庫


# fnParseOption <文件名> <處理選項函數名> [選項 ...] [參數 ...]
rtnParseOption=()
fnParseOption() {
    local _br="$fnParseOption_br"

    local filename="$1"
    local fnHandleOpt="$2"   # fnOpt, fnLib_opt
    shift 2
    local args=("$@")

    if ! type $fnHandleOpt &> /dev/null ; then
        echo "[$fileName]: 找不到 \`$fnHandleOpt\` 解析選項函式。" \
            | loxog err >&2
        exit 1
    fi

    local tmp opt val cutLen
    local errMsg=""

    rtnParseOption=()

    while [ 1 ]
    do
        opt=${args[0]}
        val=${args[1]}
        cutLen=2

        if [ "$opt" == "--" ] || [ -z "`echo "_$opt" | grep "^_-"`" ]; then break; fi

        if [ -n "`echo "_$opt" | grep "^_-[^-]"`" ] && [ ${#opt} -ne 2 ]; then
            tmp="-"${opt:2}
            opt=${opt:0:2}
            val=""
            cutLen=1
            args=("$opt" "$tmp" "${args[@]:1}")
        elif [ -n "`echo "_$val" | grep "^_-"`" ]; then
            val=""
            cutLen=1
        fi

        if [ "$opt" == "--color" ]; then
            _fColor_force 1
            tmp=1
        else
            $fnHandleOpt "$opt" "$val"
            tmp=$?
        fi
        case $tmp in
            # 視為設定不完全
            0 )
                echo "[$filename]: \"$fnHandleOpt\" 的回傳值不如預期。" >&2
                exit 1
                ;;
            # 使用 1 個參數
            1 )
                [ $cutLen -eq 2 ] && ((cutLen--))
                ;;
            # 使用 2 個參數
            2 ) ;;
            3 )
                errMsg+=$_br'找不到 "'$opt'" 選項。'
                ;;
            4 )
                [ "$val" == "" ] && val="null" || val='"'$val'"'
                errMsg+=$_br$val' 不符合 "'$opt'" 選項的預期值。'
                ;;
        esac

        args=("${args[@]:$cutLen}")
    done

    if [ "${args[0]}" == "--" ]; then
        args=("${args[@]:1}")
    else
        for val in "${args[@]}"
        do
            [ -z "`echo "_$val" | grep "^_-"`" ] && continue

            errMsg+=$_br'不符合 "[命令] [選項] [參數]" 的命令用法。'
            break
        done
    fi

    if [ -z "$errMsg" ]; then
        rtnParseOption=("${args[@]}")
    else
        echo "$errMsg" | sed "1d" \
            | sed "s/^\(.\)/[$fileName]: \1/" \
            | loxog err >&2
        exit 1
    fi
}
fnParseOption_br="
"


##shStyle 腳本環境


# parseOption <文件名> <處理選項函數名> [選項 ...] [參數 ...]
parseOption() {
    local fileName="$1"
    local fnHandleOptLinkName="$2"
    shift 2

    local fnHandleOpt="${fnHandleOptLinkName}_opt"
    fnParseOption "$fileName" "$fnHandleOpt" "$@"
}

