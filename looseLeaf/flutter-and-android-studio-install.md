Flutter 和 Android Studio 安裝
=======


> 關於詳細安裝流程請見
> [Flutter 安裝 - HackMD](https://hackmd.io/WV7y6lkDTIqdTMNaJHoLxQ) 。


```sh
# cygwin bash

cappPath=`cat "./lib/_cappPath.config"`

# 安裝 Android Studio 於 `$cappPath/Android/Android Studio/` 目錄
# 安裝 Android SDK    於 `$cappPath/Android/Android Sdk/`    目錄

wbenv ANDROID_HOME     "`cygpath -w "$cappPath/Android/Android Sdk"`"
# wbenv path           "`cygpath -w "$cappPath/Android/Android Sdk/tools"`"
# wbenv path           "`cygpath -w "$cappPath/Android/Android Sdk/platform-tools"`"
# 目前知道為放置虛擬機的目錄
wbenv ANDROID_SDK_HOME "`cygpath -w "$cappPath/Android/.cacheSdkData"`"

# 安裝 Flutter        於 `$cappPath/flutter/` 目錄
# 使用 Cygwin 會有權限設定問題
tmp_PWD=$PWD
cd "$cappPath"
wbbash Wbgit clone -b stable https://github.com/flutter/flutter.git
cd "$tmp_PWD"

wbenv path "`cygpath -w "$cappPath/flutter/bin"`"

# 使用 Flutter 檢查依賴環境
#   * 依賴 git，檢查其環境變數的設置。
#   * 第一次必須要以 CMD 開啟，flutter 需要透過 CMD 工具下載
#     Dart SDK 至 `<flutter 目錄>/bin/cache/dart-sdk` 的位置。
cygstart cmd /k flutter doctor

wbenv path "`cygpath -w "$cappPath/flutter/bin/cache/dart-sdk/bin"`"

# Android Studio 僅需設置 flutter SDK 位置。
```

