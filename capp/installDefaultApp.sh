#!/bin/bash
# 安裝預設應用程式


__filename=`realpath "$0"`
_dirsh=`dirname "$__filename"`


tmp=""
ysPath=`realpath "$_dirsh/.."`
ysUserdirPath=$ysPath/_userdir

case `uname` in
    *CYGWIN* ) cmdPlatformCode=2 ;; # Cygwin
    * )        cmdPlatformCode=1 ;; # Linux
esac



## vim-plug

if [ -n "`echo " 1 2 " | grep " $cmdPlatformCode "`" ]; then
    tmp="$ysUserdirPath/.vim/autoload"
    if [ ! -f "$tmp/plug.vim" ]; then
        mkdir -p "$tmp"
        tmpB="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        curl $tmpB > "$tmp/plug.vim"
    fi
fi


## nvm

if [ -n "`echo " 1 " | grep " $cmdPlatformCode "`" ]; then
    if [ ! -d "$ysUserdirPath/.nvm" ]; then
        [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.tmp"
        export NVM_DIR="$ysUserdirPath/.nvm"
        curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
        [ -f "$HOME/.bashrc.tmp" ] && mv "$HOME/.bashrc.tmp" "$HOME/.bashrc"
    fi
    if ! type node > /dev/null 2>&1 ; then
        source "$ysUserdirPath/.nvm/nvm.sh"
        nvm install --lts
        if ! type node > /dev/null 2>&1 ; then
            nvm use --delete-prefix node
        fi
    fi
fi


## nodeApp

if [ -n "`echo " 1 " | grep " $cmdPlatformCode "`" ]; then
    if ! type npm > /dev/null 2>&1 ; then
        echo -e "\e[31m未安裝 nodeApp。 找不到 npm，請試圖安裝 node 或者 nvm。\e[00m"
    elif [ ! -f "$_dirsh/lib/nodeApp/package.json" ] ; then
        echo -e "\e[31m未安裝 nodeApp。 找不到 \"$_dirsh/lib/nodeApp/package.json\"。\e[00m"
    elif [ ! -d "$_dirsh/lib/nodeApp/node_modules" ]; then
        tmp=$PWD
        cd "$_dirsh/lib/nodeApp"
        npm install
        cd $tmp
    fi
fi

