#!/bin/bash
# 私人聘用的船塢工人


##shStyle ###


_originPlace="bin"

_shScript() {
    case "$1" in
    rmall ) _shCmdLevel=1 ;;
    run   ) _shCmdLevel=1 ;;
    exec  ) _shCmdLevel=1 ;;
    esac
}


##shStyle 介面函式


fnHelp_main() { echo "# 私人聘用的船塢工人
[[USAGE]]
[[SUBCMD]]
  rmall    $fnHelp_rmall_briefly
  run      $fnHelp_run_briefly
  exec     $fnHelp_exec_briefly
[[OPT]]
  -h, --help   幫助。
"; }
fnOpt_main() {
    case "$1" in
        -h | --help ) fnShowHelp ;;
        * ) return 3 ;;
    esac
}
fnMain() {
    fnShowHelp
}

fnHelp_rmall_briefly="刪除容器。"
fnHelp_rmall() { echo "# $fnHelp_rmall_briefly
# $_fRedB注意！ 若沒有指定容器預設為全部容器。$_fN
[[USAGE]] [指定容器 ...]
[[OPT]]
  -h, --help   幫助。
"; }
fnOpt_rmall() {
    case "$1" in
        -h | --help ) fnShowHelp ;;
        * ) return 3 ;;
    esac
}
fnMain_rmall() {
    fnParseOption

    local item
    local rmList=`[ -n "$*" ] && echo "$@" || docker ps -aq`

    for item in $rmList
    do
        if [ -n "`docker ps    --format "{{.ID}} {{.Names}}" | grep "$item"`" ]; then
            docker stop "$item" > /dev/null
        fi
        if [ -n "`docker ps -a --format "{{.ID}} {{.Names}}" | grep "$item"`" ]; then
            docker rm "$item"
        fi
    done
}


fnHelp_run_briefly="運行容器。"
fnHelp_run() { echo "# $fnHelp_run_briefly
[[USAGE]] [\`docker run\` 選項（\`-h\` 除外）] <映像文件>
[[OPT]]
  -M, --imageMode <imageName>   映像文件模式，使用映像文件的既定選項。
                                預設與參數的 <映像文件> 相同。
      --noEnvbase               不執行 \`/dockerc/run envbase\` 的環境設定。
  -h, --help                    幫助。
"; }
fnOpt_run() {
    case "$1" in
        -M | --imageMode )
            opt_imageMode="$2"
            return 2
            ;;
        --noEnvbase )
            opt_noEnvbase=1
            return 1
            ;;
        -d | --detach | --disable-content-trust | --init | -i | --interactive | \
        --no-healthcheck | --oom-kill-disable | --privileged | -P | --publish-all | \
        --read-only | --rm | --sig-proxy | -t | --tty )
            opt_dockerOpt[ ${#opt_dockerOpt[@]} ]="$1"
            return 1
            ;;
        --add-host | -a | --attach | --blkio-weight | --blkio-weight-device | \
        --cap-add | --cap-drop | --cgroup-parent | --cidfile | --cpu-period | \
        --cpu-quota | --cpu-rt-period | --cpu-rt-runtime | -c | --cpu-shares | --cpus | \
        --cpuset-cpus | --cpuset-mems | --detach-keys | --device | \
        --device-cgroup-rule | --device-read-bps | --device-read-iops | \
        --device-write-bps | --device-write-iops | --dns | --dns-option | \
        --dns-search | --entrypoint | -e | --env | --env-file | --expose | \
        --group-add | --health-cmd | --health-interval | --health-retries | \
        --health-start-period | --health-timeout | --hostname | --ip | --ip6 | --ipc | \
        --isolation | --kernel-memory | -l | --label | --label-file | --link | \
        --link-local-ip | --log-driver | --log-opt | --mac-address | -m | --memory | \
        --memory-reservation | --memory-swap | --memory-swappiness | --mount | --name | \
        --network | --network-alias | --oom-score-adj | --pid | --pids-limit | -p | \
        --publish | --restart | --runtime | --security-opt | --shm-size | --stop-signal | \
        --stop-timeout | --storage-opt | --sysctl | --tmpfs | --ulimit | -u | --user | \
        --userns | --uts | -v | --volume | --volume-driver | --volumes-from | -w | --workdir )
            opt_dockerOpt[ ${#opt_dockerOpt[@]} ]="$1"
            opt_dockerOpt[ ${#opt_dockerOpt[@]} ]="$2"
            return 2
            ;;
        -h | --help ) fnShowHelp ;;
        * ) return 3 ;;
    esac }
fnMain_run() {
    opt_imageMode=""
    opt_noEnvbase=0
    opt_dockerOpt=()
    fnParseOption

    local tmp
    local imageName="${_args[0]}"

    local image runMode digest
    local imageList=`docker images --format "{{.Repository}}"`

    image=""
    if [ -n "$imageName" ]; then
        if [ -n "`echo "$imageList" | grep "^$imageName$"`" ]; then
            image="$imageName"
        elif [ -n "`echo "$imageList" | grep "^bwaycer/$imageName$"`" ]; then
            image="bwaycer/$imageName"
        else
            Loxog err "找不到 \"$imageName\" 映像文件。"
            exit 1
        fi
    else
        Loxog err "請指定映像文件。"
        exit 1
    fi

    runMode=""
    if [ -n "$opt_imageMode" ]; then
        runMode="$opt_imageMode"
    elif [ -n "$imageName" ]; then
        runMode="$imageName"
    fi
    if [ -n "$runMode" ] && [ -n "`echo "$allow_imageMode" | grep " $runMode "`" ]; then
        runMode=`fnImageMode_${runMode}_optVolume`
    else
        Loxog err "找不到 \"$runMode\" 映像文件模式。"
        exit 1
    fi

    # 運行容器
    digest=`docker run $runMode -td "${opt_dockerOpt[@]}" $image bash`
    tmp=$?
    [ $tmp -ne 0 ] && exit $tmp
    echo $digest

    # 環境建置
    if [ $opt_noEnvbase -eq 0 ]; then
        docker exec -it $digest /dockerc/run envbase
    fi
}


fnHelp_exec_briefly="以 \"bwaycer\" 身分執行容器。"
fnHelp_exec() { echo "# $fnHelp_exec_briefly
[[USAGE]] <容器名稱>
[[OPT]]
  -h, --help                    幫助。
"; }
fnOpt_exec() {
    case "$1" in
        -h | --help ) fnShowHelp ;;
        * ) return 3 ;;
    esac
}
fnMain_exec() {
    fnParseOption

    local tmp

    docker exec -it "${_args[0]}" bash -c 'cd /home/bwaycer; su bwaycer'
    tmp=$?
    [ $tmp -ne 0 ] && exit $tmp
}


##shStyle 共享變數


allow_imageMode=" mizarch "

# mizarch: https://github.com/BwayCer/image.docker/tree/master/mizarch
fnImageMode_mizarch_optVolume() {
    echo "\
        --volume /home//bwaycer/dockerc/:/dockerc/ \
        --volume /home/bwaycer/ys/:/home/ys/ \
        --volume /srv/:/srv/ \
        --volume /etc/letsencrypt/:/etc/letsencrypt/ \
    " | sed "s/   */   /g"
}


##shStyle 函式庫



##shStyle 腳本環境


__filename=`realpath "$0"`
_dirsh=`dirname "$__filename"`
[ "$_originPlace" == "bin" ] && _binsh=$_dirsh || _binsh=`realpath "$_dirsh/../../bin"`
[ "$_originPlace" == "bin" ] && _libsh=`realpath "$_dirsh/../lib"` || _libsh=`realpath "$_dirsh/.."`
_fileName=`basename "$0"`

_PWD=$PWD
_br="
"

# 0 黑 black
# 1 紅 red
# 2 綠 green
# 3 黃 yellow
# 4 藍 blue
# 5 粉 magenta
# 6 青 cyan
# 7 白 white
_fColor() {
    local color=$1
    local bold=$2
    local bgcolor=$3
    local underline=$4

    [ $_fColor_usable -eq 0 ] && [ $_fColor_force -eq 0 ] && return

    if [ "$color" == "N" ]; then
        [ $_fColor_force -eq 0 ] \
            && printf "`tput sgr0`" \
            || printf "\e[00m"

        return
    fi

    case "$color" in
        [01234567] )
            [ $_fColor_force -eq 0 ] \
                && printf "`tput setaf $color`" \
                || printf "\e[3${color}m"
            ;;
    esac

    case "$bgcolor" in
        [01234567] )
            [ $_fColor_force -eq 0 ] \
                && printf "`tput setab $bgcolor`" \
                || printf "\e[4${bgcolor}m"
            ;;
    esac

    if [ "$bold" == "1" ]; then
        [ $_fColor_force -eq 0 ] \
            && printf "`tput bold`" \
            || printf "\e[01m"
    fi

    if [ "$underline" == "1" ]; then
        [ $_fColor_force -eq 0 ] \
            && printf "`tput smul`" \
            || printf "\e[04m"
    fi
}
_fColor_usable=0
_fColor_force=0

_fN=""
_fRedB=""
_fYelB=""

Loxog() {
    local _stdin=`[ ! -t 0 ] && { \
        IFS='';
        while read pipeData; do echo "$pipeData"; done <&0;
        unset IFS
    }`
    local method="$1"; shift

    local color formatArgus

    case $method in
        com ) color=$_fN    ;; # common
        war ) color=$_fYelB ;; # warn
        err ) color=$_fRedB ;; # error
    esac

    formatArgus="$color%s$_fN\n"

    local idx val len

    [ -n "$*" ] && printf "$formatArgus" "$@" 1>&2

    [ -z "$_stdin" ] && return
    len=`echo "$_stdin" | wc -l`
    for idx in `seq 1 $len`
    do
        val=`echo "$_stdin" | sed -n "${idx}p"`
        printf "$formatArgus" "$val" 1>&2
    done
}

_onCtrlC() {
    local val
    for val in "$@"
    do
        _onCtrlC_cmd+=$val$_br
    done
    trap 'sh -c "echo ; $_onCtrlC_cmd echo"; exit' 2
}
_onCtrlC_cmd=""


##shStyle ###


[ -L "$0" ] && exec "`realpath "$0"`" "$@"

_stdin=`[ ! -t 0 ] && while read pipeData; do echo $pipeData; done <&0`

_args=("$@")
_origArgs=("$@")

argsShift() {
    local amount=$1

    if [ -z "$amount" ] || [ $amount -lt 1 ]; then amount=1; fi
    _args=("${_args[@]:$amount}")
}

tmp=`tput colors`
[ -t 1 ] && [ -n "$tmp" ] && [ $tmp -ge 8 ] && _fColor_usable=1
_fnForceColor() {
    [ "$1" == 1 ] && _fColor_force=1
    _fN=`_fColor N`
    _fRedB=`_fColor 1 1`
    _fYelB=`_fColor 3 1`
}
_fnForceColor

fnParseOption() {
    local fnHandleOpt="fnOpt_$_shCmd"

    local tmp args opt val cutLen errMsg
    args=("${_args[@]}")
    errMsg=""

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
            _fnForceColor 1
            tmp=1
        else
            $fnHandleOpt "$opt" "$val"
            tmp=$?
        fi
        case $tmp in
            0 )
                echo '請檢查 "'$fnHandleOpt'" 的錯誤回傳值。' 1>&2
                exit
                ;;
            # 使用 1 個參數
            1 )
                [ $cutLen -eq 2 ] && (( cutLen-- ))
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
        _args=("${args[@]}")
        return
    fi

    echo "$errMsg" | sed "1d" \
        | sed "s/^\(.\)/[$_fileName]: \1/" \
        | Loxog err
    exit 1
}

fnShowHelp() {
    local txtHelp=`fnHelp_$_shCmd`

    local bisUsage bisSubCmd bisOpt
    local usage
    bisUsage=` echo "$txtHelp" | grep "\[\[USAGE\]\]"`
    bisSubCmd=`echo "$txtHelp" | grep "\[\[SUBCMD\]\]"`
    bisOpt=`   echo "$txtHelp" | grep "\[\[OPT\]\]"`

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

    echo "$txtHelp$_br"
    exit
}


_shCmd=""
_shCmdLevel=0
_shScript "$@"
if [ $_shCmdLevel -eq 0 ]; then
    _shCmd="main"
    fnMain "$@"
    exit
fi
for tmp in `seq 0 $(( $_shCmdLevel -1 ))`
do _shCmd+="_${_args[ $tmp ]}"; done
argsShift $_shCmdLevel
_shCmd=${_shCmd:1}
fnMain_$_shCmd "${_args[@]}"

