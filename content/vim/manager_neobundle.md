NeoBundle 管理器
=======


> 2016.07.21



## 頁籤


* [安裝](#安裝)
* [設定](#設定)
* [參考](#參考)



## 安裝


```sh
$ mkdir -p ~/.vim/bundle
$ git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
```



## 設定


在 .vimrc 加入以下程式碼，並依其規則加入套件：

```sh
">> NeoBundle 套件管理工具設定 -----

if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" NeoBundle 管理套件包
NeoBundleFetch 'Shougo/neobundle.vim'

">> >> 添加套件 > 開始 -----
" 加入欲安裝的套件： NeoBundle '<套件路徑>' （套件路徑： https://github.com/<套件路徑>）


">> >> 添加套件 > 結束 -----
call neobundle#end()

" 幫助簡介：
" :NeoBundleList     - 套件包清單
" :NeoBundleInstall  - 安裝或更新套件包
" :NeoBundleClean    - 確認或自動批准移除不被使用的套件包
" 檢查安裝
NeoBundleCheck

filetype plugin indent on " 必須寫入此行!



">> 套件設定 -----

">> -----
```



## 參考


* [GitHub - Shougo\/neobundle.vim: Next generation Vim package manager](https://github.com/Shougo/neobundle.vim)
* [\[完全用 GNU\/Linux 工作\] 12. Vim 套件管理 - NeoBundle - iT邦幫忙::IT知識分享社群](http://ithelp.ithome.com.tw/question/10131427)
* [vi/vim使用进阶: 开启文件类型检测 – 易水博客](http://easwy.com/blog/archives/advanced-vim-skills-filetype-on/)

