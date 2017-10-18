#!/bin/bash
# 一鍵完成


__dirname=`dirname $0`
userFolder=$1

folderCopy() {
    local soureFolder=$1
    local targetFolder=$2

    for fileName in $(ls -A $soureFolder)
    do
        case "$fileName" in
            "$3" | "$4" | "$5" | "$6" | "$7" | "$8" | "$9" ) ;;
            * )
                cp -ri $soureFolder/$fileName $targetFolder/
                ;;
        esac
    done
}

folderCopy $__dirname $userFolder "autoFinish.sh"
$userFolder/install_vim-plug.sh

