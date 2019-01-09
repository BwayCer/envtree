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

# 解析選項
# # 參數說明：
# #   * 文件名： 用於辨識是否為主文件。
# #   * 介面函式項目名稱：
# #       主文件會自動輸入（"<處理選項函數名>" = "fnOpt_<介面函式項目名稱>"）；
# #       函式庫文件請參考 "<處理選項函數名>" = "<介面函式項目名稱>_opt" 填寫。
# #   * 參數： 主文件會自動輸入；
# #            函式庫文件請參考接受到的參數 `$@` 填寫。
# [[USAGE]] <文件名> [介面函式項目名稱] [參數 ...]
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

# 顯示幫助說明
# # 參數說明：
# #   * 文件名： 用於辨識是否為主文件。
# #   * 介面函式項目名稱： 主文件會自動輸入；
# #                        函式庫文件請自行輸入。
# [[USAGE]] <文件名> [介面函式項目名稱]
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

