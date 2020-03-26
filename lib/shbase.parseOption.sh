#!/bin/bash
# 腳本基礎 - 解析選項


##shStyle ###


source shbase "#fColor"


##shStyle 函式庫


# fnParseOption <文件名> <處理選項函數名> [參數 ...]
rtnParseOption=()
fnParseOption() {
    local filename="$1"
    local fnHandleOpt="$2"   # fnOpt, fnLib_opt
    shift 2
    local args=("$@")

    fnParseOption_throw_filename=$filename

    if ! type $fnHandleOpt &> /dev/null ; then
        echo "找不到 \`$fnHandleOpt\` 解析選項函式。" | fnParseOption_throw
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
            # TODO 即將棄用 過渡期替代
            if [ $tmp -eq 0 ]; then
                tmp="$parseOption_shift"
                parseOption_shift=0
            fi
        fi
        case $tmp in
            # 視為設定不完全
            0 )
                echo "\"$fnHandleOpt\" 的回傳值不如預期。" \
                    | fnParseOption_throw
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
        echo "$errMsg" | sed "1d" | fnParseOption_throw
        exit 1
    fi
}
fnParseOption_throw_filename=""
fnParseOption_throw() {
    local formatArgus="$_fRedB[$fnParseOption_throw_filename]: %s$_fN$_br"

    while read pipeData;
    do
        printf "$formatArgus" "$pipeData" >&2
    done <&0;
}


##shStyle 腳本環境


# 解析選項
# # 參數說明：
# #   * 文件名： 用於辨識是否為主文件。
# #   * 介面函式項目名稱： "<處理選項函數名>" = "<介面函式項目名稱>_opt"。
# #   * 參數： 函數接受到的參數 `$@`。
# [[USAGE]] <文件名> <介面函式項目名稱> [參數 ...]

parseOption() {
    local fileName="$1"
    local fnHandleOptLinkName="$2"
    shift 2

    local fnHandleOpt="${fnHandleOptLinkName}_opt"
    fnParseOption "$fileName" "$fnHandleOpt" "$@"
}

# 避免使用 `fu() { return 1 }` 退出碼以利使用 `set -e` 的功能
parseOption_shift=0


##shStyle ###


[ -n "$_br" ] || _br="
"

