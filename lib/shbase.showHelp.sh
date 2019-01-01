#!/bin/bash
# 腳本基礎 - 顯示幫助說明


#--
# declare ~== typeset
# bash 版本 v4 以上支援
#--


##shStyle 函式庫


# @var {Object} showHelp_info
# @property {string} {cmdName}_briefly
# 該命令說明的簡短描述。
# @property {string} {cmdName}
# 該命令說明的完整描述。
declare -gA showHelp_info;

# fnShowHelp <介面函式命令項目名稱>
fnShowHelp() {
    local _br="$fnShowHelp_br"

    local cmdName="$1"   # 登記於 showHelp_info 上的命令項目

    local txtHelp=${showHelp_info[${cmdName}]}
    [ -z "$txtHelp" ] && exit

    local usage
    local subCmdName subCmdBriefly
    local bisUsage=` echo "$txtHelp" | grep "\[\[USAGE\]\]"`
    local bisSubCmd=`echo "$txtHelp" | grep "\[\[SUBCMD\]\]"`
    local bisOpt=`   echo "$txtHelp" | grep "\[\[OPT\]\]"`
    local regexBriefly="\[\[BRIEFLY:\([^]]\+\)\]\]"

    if [ -n "$bisUsage" ]; then
        usage="用法："
        [ -n "$bisSubCmd" ] && usage+=" [命令]"
        [ -n "$bisOpt" ] && usage+=" [選項]"

        txtHelp=`echo "$txtHelp" | sed "s/\[\[USAGE\]\]/\n$usage/"`
    fi

    [ -n "$bisSubCmd" ] && \
        txtHelp=`echo "$txtHelp" | sed "s/\[\[SUBCMD\]\]/\\n\\n命令：\\n/"`

    [ -n "$bisOpt" ] && \
        txtHelp=`echo "$txtHelp" | sed "s/\[\[OPT\]\]/\\n\\n選項：\\n/"`

    while [ -n "`echo "$txtHelp" | grep "$regexBriefly"`" ]
    do
        subCmdName=`echo "$txtHelp" \
            | grep -m 1 "$regexBriefly" \
            | sed "s/.*$regexBriefly.*/\1/"`
        subCmdBriefly=${showHelp_info[${cmdName}_${subCmdName}_briefly]}
        txtHelp=`echo "$txtHelp" \
            | sed "s/\[\[BRIEFLY:$subCmdName\]\]/$subCmdBriefly/"`
    done

    [ -n "${showHelp_info[${cmdName}_briefly]}" ] && \
        txtHelp=`echo "$txtHelp$_br" | sed "2i ===\n"`

    echo "$txtHelp$_br"
    exit
}
fnShowHelp_br="
"


##shStyle 腳本環境


# showHelp <介面函式命令項目名稱>
showHelp() {
    # local fileName="$1"
    local cmdNameArgu="$2"

    local cmdName="_$cmdNameArgu" # 配合 _shCmd 寫法
    fnShowHelp "$cmdName"
}
# showHelpRecord <介面函式命令項目名稱> <描述 (第一句為簡述)>
#   有效參數：
#     * `[[USAGE]]`： 用法，顯示如： "用法： [命令] [選項]"。
#     * `[[SUBCMD]]`： 子命令，顯示如： "命令："。
#     * `[[OPT]]`： 選項，顯示如： "選項："。
#     * `[[BRIEFLY:subCmdName]]`： 關於子命令的描述。
#   例如：
#     showHelpRecord "main_subCmdA" "\
#     A 子命令。
#     [[USAGE]]
#     [[SUBCMD]]
#       subCmdB    [[BRIEFLY:subCmdB]]
#     [[OPT]]
#       -h, --help   幫助。
#     "
showHelpRecord() {
    local cmdName="_$1" # 配合 _shCmd 寫法
    local describe="$2"

    local briefly=`echo "$describe" | sed -n "1p"`

    showHelp_info["${cmdName}_briefly"]=$briefly
    showHelp_info["$cmdName"]=$describe
}

