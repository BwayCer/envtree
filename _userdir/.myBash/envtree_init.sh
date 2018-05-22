#!/bin/bash
# 初始化環境樹


_dirsh=`dirname "$0"`
ysPath=`realpath "$_dirsh/../.."`
ysUserdirPath=$ysPath/_userdir

val=""

fnSetLinkFile() {
    local filePath linkPath
    filePath="$1"
    linkPath="$2"

    local tmp regex fileInfo
    regex="s/\([0-9.]\+\w\) \(.\+\)/\2 (\1)/"

    if [ ! -e "$linkPath" ]; then
        ln -s "$filePath" "$linkPath"
    else
        if [ -L "$linkPath" ]; then
            fileInfo="$linkPath (鏈結文件)"
        elif [ -d "$linkPath" ]; then
            fileInfo="$linkPath (目錄)"
        else
            fileInfo=`ls -sh "$linkPath" | sed "$regex"`
        fi

        printf "文件已存在： %s\n" "$fileInfo"
        printf "是否覆蓋文件 (Yes/No)： "
        read tmp
        case $tmp in
            [Yy] | "Yes" | "yes" )
                [ -d "$linkPath" ] && rm -rf "$linkPath" || rm "$linkPath"
                ln -s "$filePath" "$linkPath"
                ;;
        esac
    fi
}


## 安裝預設應用程式

sh "$ysPath/capp/installDefaultApp.sh"


## ys, .ys 目錄 及 鏈結文件

[ "$ysPath" != "$HOME/ys" ] && fnSetLinkFile "$ysPath" "$HOME/ys"
fnSetLinkFile "$ysUserdirPath" "$HOME/.ys"
fnSetLinkFile "$ysPath/gitman" "$HOME/gitman"

for val in `ls -A $ysUserdirPath`
do
    fnSetLinkFile "$HOME/.ys/$val" "$HOME/$val"
done


## .bashrc 設定

if [ ! -f "$HOME/.bashrc" ]; then echo -e "# ~/.bashrc" > "$HOME/.bashrc"; fi
if [ -z "`grep "## 自訂 ##" "$HOME/.bashrc"`" ]; then
    echo -e "\n\n\n## 自訂 ##\n\nsource \$HOME/ys/.bash_envtree\n" >> "$HOME/.bashrc"
fi

echo "請執行 \`source $HOME/.bashrc\`"

