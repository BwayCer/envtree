插件
=======


> 2017.07.23



## 頁籤


* [中文說明文件](#中文說明文件)
* [Vim 腳本函式庫](#vim-腳本函式庫)
* [查找文件](#查找文件)
* [程式物件整理](#程式物件整理)
* [標記減量預覽](#標記減量預覽)
* [文本除錯引擎](#文本除錯引擎)



## 中文說明文件


> [chusiang/vimcdoc-tw: zh-cn to zh-tw with opencc from vimcdoc. - GitHub](https://github.com/chusiang/vimcdoc-tw)


```vim
Plug 'chusiang/vimcdoc-tw'

    " :help
```



## Vim 腳本函式庫


> [vim-scripts/L9: Vim-script library - GitHub](https://github.com/vim-scripts/L9)


```vim
Plug 'vim-scripts/L9'
```

_功能不清楚， 是
[查找文件](#查找文件)
的依賴。_



## 查找文件


> [vim-scripts/FuzzyFinder: buffer/file/command/tag/etc explorer with fuzzy matching - GitHub](https://github.com/vim-scripts/FuzzyFinder)


_依賴：
[Vim 腳本函式庫](#vim-腳本函式庫)
。_

```vim
Plug 'vim-scripts/FuzzyFinder'

    nmap Ff :FufFile
    nmap Fb :FufBuffer
```



## 程式物件整理


> [majutsushi/tagbar: Vim plugin that displays tags in a window, ordered by scope - GitHub](https://github.com/majutsushi/tagbar)


_需額外安裝
[ctags](http://ctags.sourceforge.net/)
。_


```vim
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }

    nmap <F8> :TagbarToggle<CR>
```



## 標記減量預覽


> [iamcco/markdown-preview.vim: Real-time markdown preview plugin for vim - GitHub](https://github.com/iamcco/markdown-preview.vim)


___由於筆者是以虛擬機上使用 Vim， 所以才會使用修改原作後的插件。___


```vim
Plug 'BwayCer/markdown-preview.vim', { 'for': 'markdown' }

    nmap <F9> :MarkdownPreview<CR>
    nmap mdstop :MarkdownPreviewStop<CR>
```



## 文本除錯引擎


> [w0rp/ale: Asynchronous Lint Engine - GitHub](https://github.com/w0rp/ale)


**需等到 Vim 8 升級後才能安裝。**


```vim
" Plug 'w0rp/ale'
" set statusline+=%5*『\ %{exists('g:loaded_ale')?ALEGetStatusLine():''}』%*
" set statusline+=%5*%{exists('g:loaded_fugitive')?fugitive#statusline():''}%*
```

