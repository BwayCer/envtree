#!/bin/bash
# 腳本基礎 - 文字色彩


##shStyle 腳本環境


# 提供 3+1 種基本色變量
#   * _fN： 無色
#   * _fRedB： 粗體紅色
#   * _fGreB： 粗體綠色
#   * _fYelB： 粗體黃色
_fN=""
_fRedB=""
_fGreB=""
_fYelB=""


# _fColor <顏色表示值>
# 顏色表示值：
#   共四碼，分別表示： 字體色、粗體、背景色、底線。
#   字體色、背景色： 可表示值有 9 種
#     * N： 無設定
#     * 0： 黑 black
#     * 1： 紅 red
#     * 2： 綠 green
#     * 3： 黃 yellow
#     * 4： 藍 blue
#     * 5： 粉 magenta
#     * 6： 青 cyan
#     * 7： 白 white
#   粗體、底線： 可表示值有 2 種
#     * 0： 否
#     * 1： 是
#   例如：
#     * 紅色粗體： _fColor 11、_fColor 11N0
#     * 紅色粗體白底： _fColor 117、_fColor 1170
#     * 紅色粗體白底底線： _fColor 1171

_fColor() {
    local bgcolor underline
    local setFont=$1
    local color=${setFont:0:1}
    local bold=${setFont:1:1}

    [ $_fColor_usable -eq 0 ] && [ $_fColor_isForce -eq 0 ] && return

    if [ "$setFont" == "N" ]; then
        [ $_fColor_isForce -eq 0 ] \
            && printf "`tput sgr0`" \
            || printf "\e[00m"

        return
    fi

    case "$color" in
        [01234567] )
            [ $_fColor_isForce -eq 0 ] \
                && printf "`tput setaf $color`" \
                || printf "\e[3${color}m"
            ;;
    esac

    if [ "$bold" == "1" ]; then
        [ $_fColor_isForce -eq 0 ] \
            && printf "`tput bold`" \
            || printf "\e[01m"
    fi

    [ $setFont -lt 100 ] && return

    bgcolor=${1:2:1}
    underline=${1:3:1}

    case "$bgcolor" in
        [01234567] )
            [ $_fColor_isForce -eq 0 ] \
                && printf "`tput setab $bgcolor`" \
                || printf "\e[4${bgcolor}m"
            ;;
    esac

    if [ "$underline" == "1" ]; then
        [ $_fColor_isForce -eq 0 ] \
            && printf "`tput smul`" \
            || printf "\e[04m"
    fi
}

_fColor_usable=0
_fColor_isForce=0

# 是否輸出至終端
# 判斷支援多少顏色（但會有 \e[m 可用但 tput 無法的情況）
tmp=`tput colors`
[ -t 1 ] && [ -n "$tmp" ] && [ $tmp -ge 8 ] && _fColor_usable=1

# _fColor_force [是否使用強制色碼(\\e[m) (0|1)]
#   套用強制色碼並更新基本色變量
_fColor_force() {
    [ "$1" == 1 ] && _fColor_isForce=1
    _fN=`_fColor N`
    _fRedB=`_fColor 11`
    _fGreB=`_fColor 21`
    _fYelB=`_fColor 31`
}


##shStyle ###


_fColor_force

