#!/bin/bash
# 顯示幫助說明樣本


##shStyle ###


_binsh=$(realpath "$(dirname "$(realpath "$0")")/../../bin")
[ -z "`grep ":$_binsh:" <<< ":$PATH:"`" ] && PATH="$_binsh:$PATH"


##shStyle ###


source shbase "#showHelp"


##shStyle 共享變數


# 文件路徑資訊
_fileName=`basename "$0"`


##shStyle ###


showHelpRecord "fnMain" "\
主命令。
[[USAGE]]
[[SUBCMD]]
  subCmdA    [[BRIEFLY:subCmdA]]
  subCmdB    [[BRIEFLY:subCmdB]]
[[OPT]]
  -h, --help   幫助。
"

showHelpRecord "fnMain_subCmdA" "\
A 子命令。
[[USAGE]]
[[OPT]]
  -h, --help   幫助。
"

showHelpRecord "fnMain_subCmdB" "\
B 子命令。
[[USAGE]]
[[OPT]]
  -h, --help   幫助。
"


case "$1" in
    subCmdA )
        showHelp "$_fileName" "fnMain_subCmdA"
        ;;
    subCmdB )
        showHelp "$_fileName" "fnMain_subCmdB"
        ;;
    * )
        showHelp "$_fileName" "fnMain"
        ;;
esac

