vim-plug 管理器
=======


> 2017.07.21



## 前言


這麼巧， 距上一篇 Vim 管理器文章剛好一年了，
然後我要由 NeoBundle 跳槽到 [Dein](https://github.com/Shougo/dein.vim)。
（別打我， 官方叫我跳的）
<br>
本來是想這麼說的， 但一天半過去了， 我的插件還躺著！ 於是就放棄了。

本來會想更換管理器主要是想試試 Vim 7 才有的異步加載功能，
於是又在網上查了些資料， 然後就被說服來當 vim-plug 的信徒。

好吧！ 筆者必須坦言， 我只是背了幾個 Vim 指令而已，
Vim 腳本對我實在是太陌生。
不過我的插件復活了， 讚嘆 Vim-Plug 呀 XD



## 頁籤


* [簡介](#簡介)
* [安裝](#安裝)
* [使用代碼](#使用代碼)
* [異步加載](#異步加載)
* [參考](#參考)



## 簡介


[官網： junegunn/vim-plug: Minimalist Vim Plugin Manager - GitHub](https://github.com/junegunn/vim-plug)

![異步加載過程圖](https://raw.githubusercontent.com/junegunn/i/master/vim-plug/installer.gif)

__看到官網的這圖後就開始各種感恩和讚嘆！__


## 安裝


下載 [plug.vim](https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim)
到 `~/.vim/autoload` 資料夾。

```sh
wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -P ~/.vim/autoload
```


## 使用代碼


```vim
" >> vim-plug 管理器 -------

" 指定放置插件的目錄
" - 避免去使用 Vim 的規範目錄名稱， 如：`plugin`
call plug#begin('~/.vim/bundle')

    " 添加套件在此區塊內
    " - 請務必使用單引號

    " 中文說明文件
    Plug 'chusiang/vimcdoc-tw'

" 初始化插件系統
call plug#end()

" :PlugUpgrade   - 更新 vim-plug 管理器
" :PlugInstall   - 安裝未安裝的插件
" :PlugUpdate    - 安裝或更新插件
" :PlugClean     - 移除未使用的插件目錄
" :PlugStatus    - 查看目前插件狀態
```


最基礎的下載插件只需這麼簡單！

```
Plug 'chusiang/vimcdoc-tw'
```


## 異步加載


還是那句話， 其實我也不是很熟 ><
<br>
之後有用到什麼就再查、再補寫囉。


可以執行 `:PlugStatus` 查看插件目前狀態：

```
Finished. 0 error(s).
[======]

- L9: OK
- tagbar: OK (not loaded)
- FuzzyFinder: OK
- vimcdoc-tw: OK
- markdown-preview.vim: OK (not loaded)
```

全部都已安裝， 其中 `tagbar` 和 `markdown-preview.vim` 處在已安裝未被加載的狀態。


1 . 選項 `on` 的綁定當 `TagbarToggle` 功能被觸發時開始加載：

```vim
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
```

_原本有想說對 `chusiang/vimcdoc-tw` 綁定個 `help` 或是 `<F1>` 之類的， 不過沒有成功。_


2 . 選項 `for` 的綁定當指定檔案類型開啟時開始加載：

```vim
Plug 'BwayCer/markdown-preview.vim', { 'branch': 'linkInVm', 'for': 'markdown' }
autocmd! User markdown-preview.vim echom '[Bway.Plug] 標記減量預覽 已載入'
```

而 `autocmd` 好像是 `for` 特有的功能， 當加載完成後執行的腳本，
在這寫了 `echom` 做打印訊息之用。



## 參考


* [談談 vim plugin-manager | SSARCandy's Blog](https://ssarcandy.tw/2016/08/17/vim-plugin-manager/)

