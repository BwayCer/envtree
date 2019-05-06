Hyper-V 虛擬機
=======


> 2019.03.03



## 頁籤


* [設定登錄按鈕樣板](#設定登錄按鈕樣板)
* [客製化登入按鈕](#客製化登入按鈕)
* [參考](#參考)



## 啟用方法


**啟用：**

```sh
# 找出 Hyper-V 的程式包
find /cygdrive/c/Windows/servicing/Packages/*Hyper-V*.mum | cut -d "/" -f 7 > hyperVPkgList.txt
```

```bat
REM 以下命令須執行於系統管理員的 cmd
REM `Dism`： 部署映像服務和管理。
REM https://msdn.microsoft.com/zh-tw/library/windows/hardware/dn938351
for /f %i in ('findstr /i . hyperVPkgList.txt 2^>nul') do Dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%i"
Dism /online /enable-feature /featurename:Microsoft-Hyper-V-All /LimitAccess /ALL
```


**關閉：**

```bat
REM 以下命令須執行於系統管理員的 cmd
REM `bcdedit`： 管理開機引導設定資料 (BCD, Boot Configuration Data)。
REM https://msdn.microsoft.com/zh-tw/library/windows/hardware/mt45068
bcdedit /set hypervisorlaunchtype off
Dism /online /disable-feature /featurename:Microsoft-Hyper-V-All /Remove
```



## 與 VMware 共存的方式


當 Hyper-V 被啟用後，
開啟 VMware 虛擬機將會出現以下訊息：

```
VMware Player and Device/Credential Guard are not compatible. VMware
Player can be run after disabling Device/Credential Guard. Please visit
http://www.vmware.com/go/turnoff_CG_DG for more details.
```

此問題於官方的 [2146361 號文章](https://kb.vmware.com/s/article/2146361)
中有做出說明，
再由此處繼續搜尋就會找到以下的解決辦法。

**執行完以下命令後需要重新開機。**

```bat
REM 以下命令須執行於系統管理員的 cmd
bcdedit /set hypervisorlaunchtype off
```

```bat
REM 以下命令須執行於系統管理員的 cmd
bcdedit /set hypervisorlaunchtype auto
```



## 參考


* [Windows 10 上的 Hyper-V | Microsoft Docs](https://docs.microsoft.com/zh-tw/virtualization/hyper-v-on-windows/)
* [win10家庭版如何取消hyper-v角色 - Microsoft Community](https://answers.microsoft.com/zh-hans/windows/forum/all/win10家庭版如何/dbed5740-f2f2-4ae1-b661-34abaeacc819)
* [VMware Workstation 与 Device/Credential Guard 不兼容？ - 知乎](https://www.zhihu.com/question/64511903)



## 備註


```
# 忘記用途的命令 ^^
alias open.settings='su powershell start "ms-settings:"'
alias open.hyperV='su /cygdrive/c/Windows/System32/mmc.exe "C:\Windows\System32\virtmgmt.msc"'
```

