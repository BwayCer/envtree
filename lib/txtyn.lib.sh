#!/bin/bash
# 文字有沒有

#--
# 文字版的 ~indexOf 判斷
#
# 注意！ 不允許使用多行文字
#--


##shStyle 函式庫


# fnTxtyn
#    [--loose (寬鬆比對)]
#    <方法 (concat|hasOwn|rm|val)> <原始文字> <新增文字>
fnTxtyn() {
    local opt_loose=0

    while [ -n "y" ]
    do
        case "$1" in
            --loose )
                opt_loose=1
                shift
                ;;
            * ) break ;;
        esac
    done

    local method="$1"
    local txt="$2"
    local newTxt="$3"

    local _filename="txtyn.lib.sh"

    if [ `wc -l <<< "$txt"` -ne 1 ] || [ `wc -l <<< "$newTxt"` -ne 1 ]; then
        echo "[$_filename]: 不允許使用多行文字。" >&2
        return 1
    fi

    local lenNewTxt=${#newTxt}
    local key=$lenNewTxt$newTxt
    local grepLooseOpt grepIdx

    [ $opt_loose -eq 1 ] && grepLooseOpt="-i"
    # 使用文字搜尋而不是正規
    # grepIdx 引索的第一個字是空白
    grepIdx=`grep -Fbo $grepLooseOpt " $key " <<< " $txt " | sed -n "1p" \
                | cut -d ':' -f 1`

    case "$method" in
        "hasOwn" )
            [ -n "$grepIdx" ] && echo 1 || echo 0
            ;;
        "concat" )
            [ -n "$grepIdx" ] \
                && echo $txt \
                || echo $txt $key
            ;;
        "rm" )
            if [ -n "$grepIdx" ]; then
                # ${str:引索起點:長度}
                txt="${txt:0:$grepIdx}${txt:(($grepIdx + ${#key} + 1))}"
            fi

            echo $txt
            ;;
        "val" )
            [ -n "$grepIdx" ] \
                && echo "${txt:(($grepIdx + ${#lenNewTxt})):$lenNewTxt}" \
                || echo
            ;;
    esac
}


##shStyle ###


[ -n "$_shBase_loadfile" ] || fnTxtyn "$@"

