#!/bin/sh
# 船塢工人 - 單次執行 的 虛擬運行腳本


# /bin/sh 不存在 `id --user`


##shStyle 函式庫


# 船塢工人 - 單次執行 的 虛擬運行腳本
# [[USAGE]] [命令參數 ...]
# [[OPT]]
#       --cd <path>   移動到指定路徑。

fnOnceRun() {
    local opt_cdpwd=""

    while [ -n "y" ]
    do
        case "$1" in
            --cd )
                [ -z "$2" ] && shift && continue

                [ -d "$2" ] && opt_cdpwd=$2
                shift 2
                ;;
            * ) break ;;
        esac
    done

    if [ -n "$opt_cdpwd" ]; then
        cd "$opt_cdpwd"
    elif [ `id -u` -eq 1000 ]; then
        cd "/home/bwaycer"
    else
        cd "/home/onceTmp"
    fi

    # 不登入環境 (sh, bash) 所執行的命令與載入 ysBash.bashrc 環境
    local bashrcPath="$HOME/capp/ysBash.bashrc"
    ([ "$1" == "sh" ] || [ "$1" == "bash" ]) ||
        [ -z "$*" ] || [ ! -f "$bashrcPath" ] ||
        ! sh $bashrcPath 1> /dev/null ||
        source $bashrcPath &> /dev/null

    "$@"
}


##shStyle ###


fnOnceRun "$@"

