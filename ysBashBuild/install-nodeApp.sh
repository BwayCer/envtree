#!/bin/bash
# 安裝節點應用程式


##shStyle ###


# loxog

# _br
# __filename
# _dirsh
# _fileName

# ysPath
# envCode


##shStyle 共享變數


userdirPath=`realpath "$_dirsh/../userdir"`

nodeBinDirPath="$_dirsh/node_bin"
nodeAppPkgDirName="node_appPkg"
nodeAppPkgDirPath="$_dirsh/$nodeAppPkgDirName"


##shStyle ###


fnLink_toHome() {
    local lnPath="$1"
    ln -sf "$lnPath"   "$HOME"
}
fnLinkUserdir() {
    local line

    find "$userdirPath" -maxdepth 1 | sed "1d" | while read line
    do
        fnLink_toHome "$line"
    done
}

fnCheckNode() {
    local tmp

    if type node &> /dev/null && type npm &> /dev/null ; then
        return
    fi

    if type node &> /dev/null && type npm &> /dev/null ; then
        loxog -f "$_fileName" --stderr err \
            "未安裝 nodeApp。 找不到 npm，請安裝 node 或者 nvm。"
        exit 1
    fi
}

fnBuild_nvm() {
    [ -d "$userdirPath/.nvm" ] && return

    local nvmRepositoryPath="https://raw.githubusercontent.com/creationix/nvm/master/install.sh"
    local nvmDirPath="$userdirPath/.nvm"
    local bashrcTmpFilePath="$HOME/.bashrc.origin.installNvm.tmp"

    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$bashrcTmpFilePath"
    export NVM_DIR="$nvmDirPath"
    mkdir -p "$NVM_DIR"
    curl "$nvmRepositoryPath" | bash
    [ -f "$HOME/.bashrc.tmp" ] && mv "$bashrcTmpFilePath" "$HOME/.bashrc"
}
fnBuild_nvm_enable() {
    if type node &> /dev/null && type npm &> /dev/null ; then
        return
    fi

    local nvmDirPath="$userdirPath/.nvm"
    local nvmShFilePath="$nvmDirPath/nvm.sh"

    source "$nvmShFilePath"
    export NVM_DIR="$nvmDirPath"
    nvm use --delete-prefix node &> /dev/null
    if [ $? -ne 0 ]; then
        nvm install --lts
        if ! type node &> /dev/null ; then
            nvm use --delete-prefix node
        fi
    fi
}

fnBuild_nodeApp() {
    local moduleDirPath

    ls -1 "$nodeAppPkgDirPath" | while read moduleDirPath
    do
        if [ ! -d "$moduleDirPath" ]; then
            fnBuild_nodeApp_warnNotNodeApp "$moduleDirPath/$moduleDirPath"
            continue
        fi
        # 已安裝
        [ -d "$moduleDirPath/node_modules" ] && continue
        # 不存在安裝文件
        if [ ! -f "$moduleDirPath/package.json" ]; then
            fnBuild_nodeApp_warnNotNodeApp "$moduleDirPath/$moduleDirPath"
            continue
        fi

        fnBuild_nodeApp_npmInstall "$moduleDirPath"

        case "$moduleDirName" in
            alone-gitbook )
                if [ ! -d "$userdirPath/.gitbook" ]; then
                    [ -d "$HOME/.gitbook" ] \
                        && mv "$HOME/.gitbook" "$userdirPath" \
                        || mkdir -p "$userdirPath/.gitbook"
                fi
                ;;
        esac
    done
}
fnBuild_nodeApp_warnNotNodeApp() {
    local appPath="$1"
    loxog -f "$_fileName" war \
        "\"$appPath\" 路徑不是節點應用程式。"
}
fnBuild_nodeApp_npmInstall() {
    local moduleDirPath="$1"

    local cmdName
    local originPath="$_PWD"
    local moduleDirName=`basename "$moduleDirPath"`
    local binDirRelativePath="$moduleDirName/node_modules/.bin"

    cd "$moduleDirPath"
    npm install

    case "$moduleDirName" in
        collective )
            ls -1 "$binDirRelativePath" | while read cmdName
            do
                ln -sf \
                    "../$nodeAppPkgDirName/$binDirRelativePath/$cmdName" \
                    "$nodeBinDirPath"
            done
            ;;
        alone-* )
            cmdName=${moduleDirName:6}
            ln -sf \
                "../$nodeAppPkgDirName/$binDirRelativePath/$cmdName" \
                "$nodeBinDirPath"
            ;;
    esac
}


##shStyle ###


# 安裝 nvm
if [ $[$envCode & 1] -ne 0 ]; then
    fnBuild_nvm
    fnBuild_nvm_enable
fi

fnCheckNode
fnBuild_nodeApp

fnLinkUserdir

