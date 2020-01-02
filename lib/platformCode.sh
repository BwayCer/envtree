#!/bin/bash
# 平台代碼


##shStyle 介面函式


[ -n "$_shBase_loadfile" ] \
    && fnMain_fileName=`basename "$_shBase_loadfile"` \
    || fnMain_fileName=`basename "$0"`

fnMain_help="\
平台代碼
===

# 便於程式辨別所處平台。

# 方法說明：
#   * 取得平台代碼： \`$fnMain_fileName\`
#   * 解析平台代碼： \`$fnMain_fileName <平台代碼> <允許平台代碼>\`
#                    (該 <平台代碼> 是否為允許的平台，
#                     若是則回傳 \"1\"，反之則回傳 \"0\"。)
#   * 取得允許所有： \`$fnMain_fileName allowAll\`
#     平台的代碼

# 平台代碼:
#   * 1: Linux
#   * 2: Cygwin

用法： [<平台代碼> <允許平台代碼>]
"
fnMain() {
    local platformCode=$1
    local allowCode=$2

    if [ $# -eq 0 ]; then
        case `uname` in
            *CYGWIN* ) echo 2 ;; # Cygwin
            * )        echo 1 ;; # Linux
        esac
    elif [ $# -eq 2 ] && [ $platformCode -ge 0 ] && [ "$allowCode" -ge 0 ]; then
        [ $[platformCode & allowCode] -ne 0 ] && echo 1 || echo 0
    elif [ $# -eq 1 ] && [ "$platformCode" == "allowAll" ]; then
        echo 3
    else
        printf "$fnMain_help"
    fi
}


##shStyle ###


fnMain "$@"

