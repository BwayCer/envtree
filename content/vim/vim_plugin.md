插件
=======


> 2018.02.24



## 頁籤


* [中文說明文件](#中文說明文件)
* [Vim 腳本的函式庫](#vim-腳本的函式庫)
* [查找文件](#查找文件)
* [命令行著色](#命令行著色)
* [程式碼目錄](#程式碼目錄)
* [標記減量預覽](#標記減量預覽)
* [文本除錯引擎](#文本除錯引擎)
* [谷歌程式碼風格](#谷歌程式碼風格)
* [Go 程式語言](#go-程式語言)
* [Vim 的命令行](#vim-的命令行)



## 中文說明文件


> [GitHub chusiang/vimcdoc-tw: zh-cn to zh-tw with opencc from vimcdoc.](https://github.com/chusiang/vimcdoc-tw)


```vim
Plug 'chusiang/vimcdoc-tw'
" :help
```



## Vim 腳本的函式庫


> [GitHub vim-scripts/L9: Vim-script library](https://github.com/vim-scripts/L9)


```vim
Plug 'vim-scripts/L9'
```

_功能不清楚， 是
[查找文件](#查找文件)
的依賴。_



## 查找文件


> [GitHub vim-scripts/FuzzyFinder: buffer/file/command/tag/etc explorer with fuzzy matching](https://github.com/vim-scripts/FuzzyFinder)


_依賴：
[Vim 腳本的函式庫](#vim-腳本的函式庫)
。_


```vim
Plug 'vim-scripts/FuzzyFinder'
" :FufFile     - 查找文件
" :FufBuffer   - 查找緩衝區
```



## 命令行著色


> [GitHub chrisbra/Colorizer: color hex codes and color names](https://github.com/chrisbra/Colorizer)


```vim
Plug 'chrisbra/Colorizer'
" :ColorClear       - 恢復原狀
" :ColorHighlight   - 著色
```



## 程式碼目錄


> [GitHub majutsushi/tagbar: Vim plugin that displays tags in a window, ordered by scope](https://github.com/majutsushi/tagbar)


_需額外安裝
[ctags](http://ctags.sourceforge.net/)
。_


```vim
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" :TagbarToggle
```



## 標記減量預覽


> [GitHub iamcco/markdown-preview.vim: Real-time markdown preview plugin for vim](https://github.com/iamcco/markdown-preview.vim)


**由於筆者是以虛擬機上使用 Vim， 所以才會使用修改原作後的插件。**


```vim
Plug 'BwayCer/markdown-preview.vim', { 'for': 'markdown' }
" :MarkdownPreview       - 預覽標記減量
" :MarkdownPreviewStop   - 關閉預覽標記減量
```



<br><br><br><hr>

**關注中， 不過或許因某些原因不適安裝。**



## 文本除錯引擎


> [GitHub w0rp/ale: Asynchronous Lint Engine](https://github.com/w0rp/ale)


**需等到 Vim 8 升級後才能安裝。**


```vim
Plug 'w0rp/ale'
" set statusline+=%5*『\ %{exists('g:loaded_ale')?ALEGetStatusLine():''}』%*
" set statusline+=%5*%{exists('g:loaded_fugitive')?fugitive#statusline():''}%*
```



## 谷歌程式碼風格


> [GitHub google/vim-codefmt](https://github.com/google/vim-codefmt)


_依賴： 相關的格式化程式包。_


```vim
Plug 'google/vim-codefmt'
" augroup autoformat_settings
"     Alternative: autocmd FileType python AutoFormatBuffer autopep8
" augroup END
```



## Go 程式語言


> [GitHub fatih/vim-go: Go development plugin for Vim](https://github.com/fatih/vim-go)


```vim
Plug 'fatih/vim-go'
```



## Vim 的命令行


> [GitHub majutsushi/tagbar: Vim plugin that displays tags in a window, ordered by scope](https://github.com/majutsushi/tagbar)


```vim
Plug 'rosenfeld/conque-term'
" :ConqueTermSplit bash
```

