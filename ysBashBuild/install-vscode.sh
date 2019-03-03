#!/bin/bash
# Visual Studio Code 隨身版


##shStyle ###


# loxog

# _br
# __filename
# _dirsh
# _fileName

# ysPath
# envCode


##shStyle ###


fnBuild_vscode() {
    local tmp tmpB
    local txt

    tmp="/cygdrive/c/Users/$USER/AppData/Roaming/Code"
    tmpB="$tmp/vscodePortable.txt"
    if [ -d $tmp ]; then
        mkdir "$tmp"
        chmod 500 "$tmp"

        txt="Visual Studio Code 隨身版"
        txt+="\n"
        txt+="\n修改此資料夾權限可使 vscode 無法建立使用者別的目錄。"
        txt+="\n"
        txt+="\n- 擁有者： You"
        txt+="\n- - 權限： SYSTEM           完全控制     非繼承   這個資料夾、子資料夾及檔案"
        txt+="\n- - 權限： Administrators   完全控制     非繼承   這個資料夾、子資料夾及檔案"
        txt+="\n- - 權限： You              讀取和執行   非繼承   這個資料夾、子資料夾及檔案"
        txt+="\n"
        echo "$txt" > "$tmpB"
    elif [ ! -f "$tmpB" ]; then
        echo "\"$tmp\" 位置已存在目錄。" \
            | loxog -f "$_fileName" --stderr err
        return 1
    fi
}


##shStyle ###


fnBuild_vscode

