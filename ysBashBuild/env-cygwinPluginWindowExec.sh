#!/bin/bash
# Cygwin 外掛 Window 執行文件


##shStyle ###


# loxog

# _br
# __filename
# _dirsh
# _fileName

# ysPath
# envCode


##shStyle ###


if ! which wget &> /dev/null ; then
    echo "未安裝 wget 依賴命令。" | loxog -f "$_fileName" --stderr err
    exit 1
fi


##shStyle 共享變數


open="cygstart"

cappPath=`cat "$_dirsh/../lib/_cappPath.config"`
cappBinPath="$cappPath/.bin"
cappPkgPath="$cappPath/.pkg"


##shStyle ###


fnMakeApp() {
    echo

    # check
    if [ -z "$fnMakeApp_name" ] || ! type fnMakeApp_runOk &> /dev/null ; then
       echo "## 未知項目 -> 無法處理。" | loxog war
       echo
       return
    fi

    echo "## $fnMakeApp_name"
    echo

    local rtnCode
    local appPkgPath
    local appName=$fnMakeApp_name
    local repoUrl=$fnMakeApp_repoUrl
    local appDirPath="$cappPath/$appName"

    if [ ! -d "$appDirPath" ]; then
        appPkgPath="$cappPath/`basename "$repoUrl"`"

        if [ ! -e "$appPkgPath" ]; then
            echo "--- 下載並執行安裝包 ---"
            echo

            wget -O "$appPkgPath" "$repoUrl"
        fi

        open "$appPkgPath"
        echo -n "__按 <Enter> 鍵繼續執行__"; read

        if type fnMakeApp_onInstall &> /dev/null ; then
            echo "--- 安裝後處理 ---"
            echo
            fnMakeApp_onInstall "$appName" "$appDirPath"
            echo
        fi
    fi

    echo "--- 執行與驗證 ---"
    echo
    fnMakeApp_runOk "$appName" "$appDirPath"
    rtnCode=$?
    echo

    printf "執行結果： "
    if [ $rtnCode -eq 0 ]; then
       echo "安裝成功。"
    else
       echo "安裝失敗。" | loxog war
    fi
    echo
}
fnTest_shClear() {
    unset fnMakeApp_name
    unset fnMakeApp_repoUrl
    unset -f fnMakeApp_onInstall
    unset -f fnMakeApp_runOk
}
# fnMakeApp_name=""       # 項目名稱
# fnMakeApp_repoUrl=""    # 儲存庫網址
# fnMakeApp_onInstall()   # 安裝後處理
# fnMakeApp_runOk()       # 執行與驗證

fnLinkCappExe() {
    local execFilePath execFileName
    local originPwd=$PWD

    rm -rf "$cappBinPath"
    mkdir -p "$cappBinPath"

    cd "$cappPath"

    ls -1d */bin/* | while read execFilePath
    do
        if [ ! -f "$execFilePath" ] || [[ ! "$execFilePath" =~ \.exe$ ]]; then
            continue
        fi

        execFileName=`basename "$execFilePath"`
        ln -sf "../$execFilePath" "$cappBinPath/${execFileName::-4}"
    done

    cd "$originPwd"
}


##shStyle ###


fnMakeApp_name="Git"
fnMakeApp_repoUrl="https://github.com/git-for-windows/git/releases/download/v2.20.1.windows.1/PortableGit-2.20.1-64-bit.7z.exe"
fnMakeApp_onInstall() {
    local appName="$1"
    local appDirPath="$2"

    local cmdName
    local appBinPath="$appDirPath/bin"

    for cmdName in "sh" "bash" "git"
    do
        mv "$appBinPath/${cmdName}.exe" "$appBinPath/gfw_${cmdName}.exe"
    done
}
fnMakeApp_runOk() {
    return
}
fnMakeApp


fnMakeApp_name="Golang"
fnMakeApp_repoUrl="https://dl.google.com/go/go1.11.5.windows-amd64.zip"
fnMakeApp_onInstall() {
    return
}
fnMakeApp_runOk() {
    return
}
fnMakeApp


fnLinkCappExe

