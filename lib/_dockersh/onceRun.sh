#!/bin/sh
# 船塢工人 - 單次執行 的 虛擬運行腳本

# [[USAGE]] [命令參數 ...]
# [[OPT]]
#       --cd <path>   移動到指定路徑。


# /bin/sh 不存在 `id --user`


##shStyle 函式庫


fnOnceRun() {
    local opt_ysPath=""
    local opt_cd=""

    while [ -n "y" ]
    do
        case "$1" in
            --ysPath )
                [ -z "$2" ] && shift && continue

                [ -d "$2" ] && opt_ysPath=$2
                shift 2
                ;;
            --cd )
                [ -z "$2" ] && shift && continue

                [ -d "$2" ] && opt_cd=$2
                shift 2
                ;;
            * ) break ;;
        esac
    done

    [ -L "$HOME/.ys" ] || [ -z "$opt_ysPath" ] || ln -sf "$opt_ysPath" "$HOME/.ys"

    [ -z "$opt_cd" ] || cd "$opt_cd"

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

