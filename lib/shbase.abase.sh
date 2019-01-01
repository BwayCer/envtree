#!/bin/bash
# 腳本基礎 - 基礎


##shStyle ###


source shbase "#fColor"
source shbase "#loxog"
source shbase "#parseOption"
source shbase "#showHelp"


##shStyle 腳本環境


_PWD=$PWD
_br="
"

# 文件路徑資訊
__filename=`realpath "$0"`
_dirsh=`dirname "$__filename"`
# _binsh=""
_libsh=`realpath "$_dirsh/.."`
_fileName=`basename "$0"`


### 基礎框架

_origArgs="" # 保留原始參數
_args=""

_shCmd=""
_shCmdLevel=0
# shScript_route() # 抽象需創建

# 對 _args 參數陣列挪移
argsShift() {
    local amount=$1

    if [ -z "$amount" ] || [ $amount -lt 1 ]; then amount=1; fi
    _args=("${_args[@]:$amount}")
}

# parseOption <文件名> [處理選項函數名] [選項 ...] [參數 ...]
parseOption() {
    local fileName="$1"
    local fnHandleOptLinkName="$2"

    if [ "$fileName" == "$_fileName" ]; then
        fnParseOption "$fileName" \
            "fnOpt${_shCmd}" \
            "${_args[@]}"
        _args=("${rtnParseOption[@]}")
    else
        shift 2
        fnParseOption "$fileName" \
            "${fnHandleOptLinkName}_opt" \
            "$@"
    fi
}

# showHelp <文件名> [介面函式命令項目名稱]
showHelp() {
    local fileName="$1"
    local cmdNameArgu="$2"

    local cmdName

    if [ "$fileName" == "$_fileName" ]; then
        cmdName=$_shCmd
    else
        cmdName="_$cmdNameArgu"
    fi

    fnShowHelp "$cmdName"
}

# 運行腳本
# shScript <?命令前綴名> [... 傳入參數]
shScript() {
    local cmdPrefix="$1"; shift

    # 設定參數
    _origArgs=("$@")
    _args=("$@")

    # 由路由判斷執行命令
    [ -n "$cmdPrefix" ] \
        && _shCmd="_$cmdPrefix" \
        || _shCmd=""
    _shCmdLevel=0
    shScript_route "$@"
    if [ $_shCmdLevel -ge 0 ]; then
        for tmp in `seq 0 $(( $_shCmdLevel - 1 ))`
        do _shCmd+="_${_args[ $tmp ]}"; done
        [ $_shCmdLevel -ne 0 ] && argsShift $_shCmdLevel
    fi

    # 執行命令
    fnSh${_shCmd} "${_args[@]}"

    # 清空
    _origArgs=""
    _args=""
    _shCmd=""
    _shCmdLevel=0
}

