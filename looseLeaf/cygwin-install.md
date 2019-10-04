希格溫安裝
=======


可在視窗系統中模擬 Linux 命令行的操作。



## 頁籤


* [安裝](#安裝)
  * [更新安裝程式](#更新安裝程式)
* [程式包資訊](#程式包資訊)



## 安裝


由 [官網](https://cygwin.com/)
下載希格溫 Cygwin 安裝程式。

> 此工具兼具安裝及程式包管理功能，
> 當下次有需要更新或安裝新程式包時也是由此工具來達成。


**步驟：**

  1. Cygwin Net Release Setup Program >> 下一步
  2. Choose A DownLoad Source >> Install from Local Directory >> 下一步
  3. Select Root Install Directory >> 選擇跟目錄安裝位置 >> 下一步
  4. Select Local Package Directory >> 選擇本地程式庫位置 >> 下一步
  5. Select Packages >> 選擇安裝 vim、openssh >> 下一步
  6. Resolving Dependencies >> 相關依賴 >> 下一步


**先選擇一個下載資源；**

  * Install from Intermet： 從網路選擇程式包下載並安裝。
  * Download Without Installing： 從網路選擇程式包下載。
  * Install from Local Directory： 從本地選擇程式包安裝。

第一、二項都會將下載回來的程式包儲放為本地的程式庫，等同小型鏡像站。


**選擇目錄位置；**

要選擇的目錄有兩個：

  * 跟目錄： 主程式安裝的地方。
  * 程式庫： 程式庫安裝或儲放的地方。


**選擇程式包：**

此處的程式包是被官方所收入的，
並非每種 Linux 可用的都有支援。
但只要被收入進去，
安裝變得簡單，
也不用煩惱相關依賴問題。

> 在臺灣的讀者推薦使用
> http://ftp.ntu.edu.tw, http://ftp.yzu.edu.tw/
> 鏡像站。



### 更新安裝程式


在安裝前系統會檢查當前程式版本，
若有可更新版本時將出現以下提示：

```
The current ini file is from a newer version of setup-x86_64.exe.
if you have any trouble installing, please download a fresh version
from http://www.cygwin.com/setup-x86_64.exe

# 當前 ini 文件是依照較新版本的 setup-x86_64.exe 設定。
# 若在安裝時遇到任何問題，請從 http://www.cygwin.com/setup-x86_64.exe 下載較新版本。
```



## 程式包資訊


_此資訊為作者的程式包資訊， 僅供參考。_

  * chere: Cygwin Prompt Here context menus
  * ctags: A C programming language indexing and/or cross-reference tool
  * curl: Multi-protocol file transfer tool
  * dos2unix: Line Break Conversion
  * git: Distributed version control system
  * openssh: The OpenSSH server and client programs
  * ping: A basic network tool to test IP network connectivity
  * procps-ng: System and process monitoring utilities
  * psmisc: Utilities for managing processes on your system
  * python3: Meta-package for Python 3 default version
  * python37: Py3K language interpreter
  * tmux: Terminal multiplexer
  * tree: Display graphical directory tree
  * vim: Vi IMproved - enhanced vi deitor
  * wget: Utility to retrieve files from the WWW via HTTP and FTP


| picked | Package                 | Version
|:------:|:-------                 |:-------
|        | \_autorebase            | 001007-1
|        | alternatives            | 1.3.30c-10
|        | base-cygwin             | 3.8-1
|        | base-files              | 4.3-2
|        | bash                    | 4.4.12-3
|        | binutils                | 2.29-1
|        | bzip2                   | 1.0.8-1
|        | ca-certificates         | 2.32-1
| *      | chere                   | 1.4-1
|        | coreutils               | 8.26-2
|        | crypto-policies         | 20190218-1
|        | csih                    | 0.9.11-1
| *      | ctags                   | 5.8-1
| *      | curl                    | 7.66.0-1
|        | cygrunsrv               | 1.62-1
|        | cygutils                | 1.4.16-2
|        | cygwin                  | 3.0.7-1
|        | dash                    | 0.5.9.1-1
|        | diffutils               | 3.5-2
| *      | dos2unix                | 7.4.1-1
|        | editrights              | 1.03-1
|        | file                    | 5.32-1
|        | findutils               | 4.6.0-1
|        | gawk                    | 5.0.1-1
|        | getent                  | 2.18.90-4
| *      | git                     | 2.21.0-1
|        | grep                    | 3.0-2
|        | groff                   | 1.22.4-1
|        | gzip                    | 1.8-1
|        | hostname                | 3.13-1
|        | info                    | 6.7-1
|        | ipc-utils               | 1.0-2
|        | less                    | 530-1
|        | libargp                 | 20110921-3
|        | libattr1                | 2.4.48-2
|        | libblkid1               | 2.33.1-1
|        | libbrotlicommon1        | 1.0.7-1
|        | libbrotlidec1           | 1.0.7-1
|        | libbz2_1                | 1.0.8-1
|        | libcom_err2             | 1.44.5-1
|        | libcrypt0               | 2.1-1
|        | libcrypt2               | 4.4.4-1
|        | libcurl4                | 7.66.0-1
|        | libdb5.3                | 5.3.28-2
|        | libedit0                | 20130712-1
|        | libevent2.0_5           | 2.0.22-1
|        | libexpat1               | 2.2.6-1
|        | libfdisk1               | 2.33.1-1
|        | libffi6                 | 3.2.1-2
|        | libgcc1                 | 7.4.0-1
|        | libgdbm4                | 1.13-1
|        | libgdbm6                | 1.18.1-1
|        | libgdbm_compat4         | 1.18.1-1
|        | libgmp10                | 6.1.2-1
|        | libgnutls30             | 3.6.9-1
|        | libgssapi_krb5_2        | 1.15.2-2
|        | libhogweed4             | 3.4.1-1
|        | libiconv                | 1.14-3
|        | libiconv2               | 1.14-3
|        | libidn2_0               | 2.2.0-1
|        | libintl8                | 0.19.8.1-2
|        | libk5crypto3            | 1.15.2-2
|        | libkrb5_3               | 1.15.2-2
|        | libkrb5support0         | 1.15.2-2
|        | liblzma5                | 5.2.4-1
|        | libmetalink3            | 0.1.2-1
|        | libmpfr6                | 4.0.2-1
|        | libncursesw10           | 6.1-1.20190727
|        | libnettle6              | 3.4.1-1
|        | libnghttp2_14           | 1.37.0-1
|        | libnsl2                 | 1.2.0-1
|        | libopenldap2_4_2        | 2.4.48-1
|        | libp11-kit0             | 0.23.15-1
|        | libpcre1                | 8.43-1
|        | libpipeline1            | 1.5.1-1
|        | libpkgconf3             | 1.6.0-1
|        | libpopt-common          | 1.16-2
|        | libpopt0                | 1.16-2
|        | libprocps7              | 3.3.15-1
|        | libpsl5                 | 0.21.0-1
|        | libreadline7            | 7.0.3-3
|        | libsasl2_3              | 2.1.26-11
|        | libsigsegv2             | 2.10-2
|        | libsmartcols1           | 2.33.1-1
|        | libsqlite3_0            | 3.28.0-1
|        | libssh-common           | 0.8.7-1
|        | libssh4                 | 0.8.7-1
|        | libssl1.0               | 1.0.2t-1
|        | libssl1.1               | 1.1.1d-1
|        | libssp0                 | 6.4.0-4
|        | libstdc++6              | 7.4.0-1
|        | libtasn1_6              | 4.14-1
|        | libtirpc-common         | 1.1.4-1
|        | libtirpc3               | 1.1.4-1
|        | libunistring2           | 0.9.10-1
|        | libuuid-devel           | 2.33.1-1
|        | libuuid1                | 2.33.1-1
|        | login                   | 1.13-1
|        | man-db                  | 2.7.6.1-1
|        | mintty                  | 3.0.5-1
|        | ncurses                 | 6.1-1.20190727
| *      | openssh                 | 8.0p1-2
|        | openssl                 | 1.1.1d-1
|        | p11-kit                 | 0.23.15-1
|        | p11-kit-trust           | 0.23.15-1
|        | perl                    | 5.26.3-2
|        | perl-Error              | 0.17028-1
|        | perl-Scalar-List-Utils  | 1.52-1
|        | perl-TermReadKey        | 2.38-1
|        | perl_autorebase         | 5.26.3-2
|        | perl_base               | 5.26.3-2
| *      | ping                    | 1.9.4-1
|        | pkg-config              | 1.6.0-1
|        | pkgconf                 | 1.6.0-1
| *      | procps-ng               | 3.3.15-1
| *      | psmisc                  | 22.20-1
|        | publicsuffix-list-dafsa | 20190717-1
|        | python-pip-wheel        | 19.2.3-1
|        | python-setuptools-wheel | 41.2.0-1
| *      | python3                 | 3.6.8-1
|        | python36                | 3.6.9-1
| *      | python37                | 3.7.4-1
|        | rebase                  | 4.4.4-1
|        | rsync                   | 3.1.2-1
|        | run                     | 1.3.4-2
|        | sed                     | 4.4-1
|        | tar                     | 1.29-1
|        | terminfo                | 6.1-1.20190727
|        | terminfo-extra          | 6.1-1.20190727
| *      | tmux                    | 2.6-1
| *      | tree                    | 1.7.0-1
|        | tzcode                  | 2019c-1
|        | tzdata                  | 2019c-1
|        | util-linux              | 2.33.1-1
| *      | vim                     | 8.1.1772-1
|        | vim-common              | 8.1.1772-1
|        | vim-minimal             | 8.1.1772-1
| *      | wget                    | 1.19.1-2
|        | which                   | 2.20-2
|        | xxd                     | 8.1.1772-1
|        | xz                      | 5.2.4-1
|        | zlib0                   | 1.2.11-1

