#!/bin/bash
# 文字有沒有

# # 參數說明：
# #   * 方法
# #     * `concat`   在 "原始文字" 中新增 "新增文字"。
# #     * `hasOwn`   檢查 "原始文字" 中是否包含 "新增文字"。
# #     * `rm`       在 "原始文字" 中移除 "新增文字"。
# #     * `val`      顯示 "原始文字" 中 "新增文字" 的原始文字。
# [[USAGE]] <方法 (concat|hasOwn|rm|val)> <原始文字> <新增文字>
# [[OPT]]
#       --loose   寬鬆比對。

#--
# 文字版的 ~indexOf 判斷
#
# 注意！ 不允許使用多行文字
#--


##shStyle 介面函式


fnTxtyn() {
    local filename=$fnTxtyn_fileName

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

    if [ `wc -l <<< "$txt"` -ne 1 ] || [ `wc -l <<< "$newTxt"` -ne 1 ]; then
        echo "[$filename]: 不允許使用多行文字。" >&2
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


if [ -n "$_shBase_loadfile" ]; then
    fnTxtyn_fileName="$_shBase_loadfile"
else
    fnTxtyn_fileName=`basename "$0"`
    fnTxtyn "$@"
fi

