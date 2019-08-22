視窗麻煩
=======


## 頁籤


* [安裝](#安裝)
  * [希格溫](#希格溫)
  * [巧克力程式包管理工具](#巧克力程式包管理工具)



## 安裝


### 希格溫


見 [希格溫安裝](./cygwin-install.md)。



### 巧克力程式包管理工具


[官網](https://chocolatey.org/)

```sh
# cygwin bash

cappPath=`cat "./lib/_cappPath.config"`

wbenv "ChocolateyInstall"       "`cygpath -w "$cappPath/chocolatey"`"
wbenv "ChocolateyToolsLocation" "`cygpath -w "$cappPath/chocoModule"`"
# 環境變數設定完成後需要重開終端機

cygstart cmd /k @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" \
    -NoProfile -InputFormat None -ExecutionPolicy Bypass \
    -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
```


**程式包：**

  * [`choco install git.portable`](https://chocolatey.org/packages/git.portable)
  * [`choco install ffmpeg`](https://chocolatey.org/packages/ffmpeg)

