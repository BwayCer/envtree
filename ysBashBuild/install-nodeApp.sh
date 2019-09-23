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


nodeAppPath=`realpath "$_dirsh/.."`
userdirPath="$nodeAppPath/userdir"

pkgConfigFilePath="$nodeAppPath/lib/pkg.config.yml"

nodeBinDirPath="$nodeAppPath/node_bin"
nodeAppPkgDirName="node_appPkg"
nodeAppPkgDirPath="$nodeAppPath/$nodeAppPkgDirName"

lnkNodeAppExecSh_A='#!/bin/sh
exec "'
lnkNodeAppExecSh_B='" "$@"
'


##shStyle ###


fnLink_toFileList() {
    local infoTxt="$1"

    local originPath linkPath

    while read line
    do
        originPath=`cut -d " " -f 2- <<< "$line"`
        linkPath=`  cut -d " " -f 1  <<< "$line"`
        ln -sf "$originPath" "$linkPath"
    done <<< "`grep "." <<< "$infoTxt" | sed "s/ ----*= / /g"`"
}
fnLinkUserdir() {
    local dirPath=$1

    local line

    find "$dirPath" -maxdepth 1 | sed "1d" | while read line
    do
        fnLink_toHome "$line"
    done
}

fnCheckNode() {
    local tmp

    if ! type node &> /dev/null || ! type npm &> /dev/null ; then
        loxog -f "$_fileName" --stderr err \
            "未安裝 nodeApp。 請安裝 node 及 npm。"
        exit 1
    fi
}

fnBuild_nvm() {
    local nvmDirPath="$userdirPath/.nvm"

    [ -d "$nvmDirPath" ] && return

    local nvmRepositoryPath="https://raw.githubusercontent.com/creationix/nvm/master/install.sh"
    local bashrcTmpFilePath="$HOME/.bashrc.origin.installNvm.tmp"

    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$bashrcTmpFilePath"
    export NVM_DIR="$nvmDirPath"
    mkdir "$NVM_DIR"
    curl "$nvmRepositoryPath" | bash
    [ -f "$bashrcTmpFilePath" ] && mv "$bashrcTmpFilePath" "$HOME/.bashrc"
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
    # shbase 找不到會自動退出
    source shbase "yamlParse.lib.sh"

    if ! type fnYamlParse &> /dev/null ; then
        loxog -f "$_fileName" --stderr err \
            '找不到 "yamlParse.lib.sh" 文件。'
        exit 1
    fi

    local key
    local pkgAlone depsList linkList depsMsg
    local collectivePkgList=()
    local alonePkgList=()

    fnYamlParse "$pkgConfigFilePath" "nodeApp"
    # nodeApp_forceUpdate=0
    # nodeApp_pkgRegistry=()
    # pkgs_{pkgName}_name=""
    # pkgs_{pkgName}_version=""
    # pkgs_{pkgName}_alone=0
    # pkgs_{pkgName}_links=()

    for key in "${nodeApp_pkgRegistry[@]}"
    do
        eval "pkgAlone=\${nodeApp_pkgs_${key}_alone}"
        [ $pkgAlone -eq 0 ] \
            && collectivePkgList+=("$key") \
            || alonePkgList+=("$key")
    done

    depsList=()
    linkList=()
    for key in "${collectivePkgList[@]}"
    do
        eval "`printf '
            depsList+=("\\\\\"${%s}\\\\\": \\\\\"${%s}\\\\\"")
            linkList+=("${%s[@]}")
        ' "nodeApp_pkgs_${key}_name" \
          "nodeApp_pkgs_${key}_version" \
          "nodeApp_pkgs_${key}_links"
        `"
    done
    fnBuild_nodeApp_install "collective" "$nodeApp_forceUpdate" "${depsList[@]}"
    fnBuild_nodeApp_lnk "collective" "${linkList[@]}"
    fnBuild_nodeApp_installEmit "collective"

    for key in "${alonePkgList[@]}"
    do
        eval "`printf '
            depsMsg="\\\\\"${%s}\\\\\": \\\\\"${%s}\\\\\""
            linkList=("${%s[@]}")
        ' "nodeApp_pkgs_${key}_name" \
          "nodeApp_pkgs_${key}_version" \
          "nodeApp_pkgs_${key}_links"
        `"
        fnBuild_nodeApp_install "$key" "$nodeApp_forceUpdate" "$depsMsg"
        fnBuild_nodeApp_lnk "$key" "${linkList[@]}"
        fnBuild_nodeApp_installEmit "$key"
    done
}
fnBuild_nodeApp_install() {
    local name="$1"
    local forceUpdate=$2
    shift 2
    local args=("$@")

    local idx lastIdx
    local depsMsg=""

    for ((idx=0, lastIdx=${#args[@]} - 1; idx <= lastIdx ; idx++))
    do
        depsMsg+="$_br    ${args[idx]}"
        [ $idx -eq $lastIdx ] || depsMsg+=","
    done

    local prevPwd="$PWD"
    local pkgDirPath="$nodeAppPkgDirPath/$name"
    [ -d "$pkgDirPath" ] || mkdir "$pkgDirPath"
    cd "$pkgDirPath"
    [ $forceUpdate -eq 0 ] || rm "package-lock.json"
    printf "$fnBuild_nodeApp_pkgJson" "$name" "$depsMsg" > "package.json"
    npm install
    cd "$prevPwd"
}
fnBuild_nodeApp_pkgJson='{
  "name": "node-app-for-bwaycer-%s",
  "version": "0.0.0",
  "description": "節點應用程式。",
  "license": "CC0-1.0",
  "dependencies": {%s
  }
}'
fnBuild_nodeApp_lnk() {
    local name="$1"; shift
    local args=("$@")

    local cmdName cmdFilePath shCode
    local nodeBinPartPath="$nodeAppPkgDirPath/$name/node_modules/.bin"

    for cmdName in "${args[@]}"
    do
        cmdFilePath="$nodeBinPartPath/$cmdName"

        if [ ! -e "$cmdFilePath" ]; then
            echo "找不到 \"$cmdFilePath\" 路徑不是節點命令。" \
                | loxog -f "$_fileName" war
            continue
        fi

        cmdFilePath=`realpath "$cmdFilePath"`
        shCode="$lnkNodeAppExecSh_A$cmdFilePath$lnkNodeAppExecSh_B"
        echo "$shCode" > "$nodeBinDirPath/$cmdName"
        chmod 755 "$nodeBinDirPath/$cmdName"
    done
}
fnBuild_nodeApp_installEmit() {
    local moduleDirName="$1"

    case "$moduleDirName" in
        gitbook )
            if [ ! -d "$userdirPath/.gitbook" ]; then
                [ -d "$HOME/.gitbook" ] \
                    && mv "$HOME/.gitbook" "$userdirPath" \
                    || mkdir "$userdirPath/.gitbook"
            fi
            ;;
    esac
}


##shStyle ###


[ -d "$userdirPath"       ] || mkdir -p "$userdirPath"
[ -d "$nodeAppPkgDirPath" ] || mkdir -p "$nodeAppPkgDirPath"

[ ! -d "$nodeBinDirPath" ] || rm -rf "$nodeBinDirPath"
mkdir -p "$nodeBinDirPath"

# 安裝 nvm
# if [ $[$envCode & 1] -ne 0 ]; then
#     fnBuild_nvm
#     fnBuild_nvm_enable
# fi

fnCheckNode
fnBuild_nodeApp

fnLinkUserdir "$userdirPath"
fnLink_toFileList "
$ysPath/gitman/ ---= $nodeAppPath/lib/.eslintrc.yml
"

