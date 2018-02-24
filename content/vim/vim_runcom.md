運行命令
=======


> 2018.02.24



## 頁籤


* [命令集](#命令集)
* [儲存前刪除多餘空白](#儲存前刪除多餘空白)
* [恢復前次的檔案群組](#恢復前次的檔案群組)
* [參考](#參考)



## 命令集


筆者將所有命令以 `z/` 當前綴來設置，
關於可用的命令請用 `z/H` 查看。


> 註：
> 每個命令的設置都會讓該指令延緩執行以聽取是單按鍵輸入或是指令輸入，
> 因此不要在基本命令（如： `i`、`p` ...）上添加命令。


```
常用命令提示
=======

基礎：
    z/H : 幫助       z/rvc : 更新 .vimrc
    z/s : 儲存文件   z/rs  : 保存會話、文件並退出   z/rq : q! 退出

插件管理：
    z/rpi : 安裝未安裝的插件   z/rpu : 安裝或更新插件   z/rpc : 移除未使用的插件目錄

    查找文件：
        Ff : 開啟指定路徑文件   Fb : 開啟指定緩衝區文件

    程式碼目錄：
        <F8> : 開啟/關閉

    命令行著色：
        z/rcc : 預設/著色切換

    標記減量預覽：
        z/rmd : 預覽標記減量    z/rmdstop : 關閉預覽標記減量

緩衝區：
    z/bl : 緩衝區列表
    z/bm : 前一個開啟的緩衝區
    z/bk : 上一個緩衝區         z/bj : 下一個緩衝區
    z/bd : 解除安裝緩衝區

視窗：
    <C-w> s : 切割水平視窗       <C-w> v : 切割垂直視窗       z/ww : 順序地切換視窗
    z/wh    : 移動至左側的視窗   z/wl    : 移動至右側的視窗
    z/wj    : 移動至下方的視窗   z/wk    : 移動至上方的視窗
    z/wrh   : 加高視窗 + [Num]   z/wrH   : 縮高視窗 + [Num]
    z/wrw   : 加寬視窗 + [Num]   z/wrW   : 縮寬視窗 + [Num]

    z/wtl   : 分頁列表           z/wte   : 新增分頁
    z/wtp   : 上一分頁           z/wtn   : 下一分頁

    <C-z>   : 背景工作           z/wt    : 開啟 Tmux

縮排：
    z/tab : 設定縮排寬度 ( z/tab2、z/tab4、z/tab8 )
    z/pas : 貼上模式       z/pno : 取消貼上模式

摺疊方式：
    z/fmi : 依 shiftwidth 的縮排方式摺疊   z/fmm : 手動摺疊
    zn    : 禁用折疊                       zN    : 啟用折疊
    za    : 打開或關閉當前的折疊
    zo    : 打開當前的折疊                 zc    : 關閉當前打開的折疊
    zr    : 打開所有折疊                   zm    : 關閉所有折疊
    zR    : 打開所有折疊及其嵌套的折疊     zM    : 關閉所有折疊及其嵌套的折疊
    zj    : 移動至下一個折疊               zk    : 移動至上一個折疊

    手動摺疊命令：
        zf[Num](jk)     : 加上數字與方向指定摺疊範圍
        zfa(<>, {}, ()) : 指定項目的摺疊
        zd : 移除所在位置的摺疊

額外功能：
    z/dir : 對當前文件目錄操作
```



## 儲存前刪除多餘空白


```vim
function RemoveTrailingWhitespace()
    if &ft != "diff"
        let b:curcol = col(".")
        let b:curline = line(".")
     silent! %s/\v +$//
        silent! %s/(\s*\n)\+\%$//
        call cursor(b:curline, b:curcol)
    endif
endfunction
autocmd BufWritePre * call RemoveTrailingWhitespace()
```



## 恢復前次的檔案群組


```vim
set sessionoptions-=curdir
set sessionoptions+=sesdir

function RecordSession(act)
    let l:sessionPath = '~/ys/capp/vim/Session.vim'
    let l:isFileExists = !empty(findfile(l:sessionPath))

    if !l:isFileExists
        call system('mkdir -p ~/ys/capp/vim; touch ' . l:sessionPath)
    endif

    if a:act == 'clear'
        call system('cat /dev/null > ' . l:sessionPath)
    elseif a:act == 'save'
        mks! ~/ys/capp/vim/Session.vim
    elseif a:act == 'restore'
        source ~/ys/capp/vim/Session.vim
    endif
endfunction

let s:isRecordSession = 1
function RecordSession_prompt(act)
    if s:isRecordSession
        if a:act == 'save'
            if input('是否保存本次的會話群組？ [y: Yes, n: No] ') == 'y'
                call RecordSession('save')
            endif
        elseif a:act == 'restore' && !empty(system('cat ~/ys/capp/vim/Session.vim'))
            if input('是否恢復上次的會話群組？ [y: Yes, n: No] ') == 'y'
                call RecordSession('restore')
            elseif input('是否清除上次的會話群組？ [y: Yes, n: No] ') == 'y'
                call RecordSession('clear')
            endif
        endif
    endif
endfunction

function RecordSession_quick(act)
    let s:isRecordSession = 0
    if a:act == 'save'
        call RecordSession('save')
        exe 'x'
    else
        exe 'q!'
    endif
    let s:isRecordSession = 1
endfunction

nmap z/rs :call RecordSession_quick('save')<CR>
nmap z/rq :call RecordSession_quick('noSave')<CR>
autocmd VimLeavePre * call RecordSession_prompt('save')
autocmd VimEnter * call RecordSession_prompt('restore')
```


更詳細資訊可見：
  `:help mksession`
  、
  `:help sessionoptions`
  。



## 參考


* [個人化自己的vim文字編輯器(.vimrc設定教學) | MagicLen](https://magiclen.org/vimrc/)
* [VIM :map - 豆瓣](https://www.douban.com/group/topic/10866937/)
* [vi/vim使用进阶: 使用会话和viminfo – 易水博客](http://easwy.com/blog/archives/advanced-vim-skills-session-file-and-viminfo/)
* [Vim - 編輯緩衝區以及編輯視窗 (Buffers and Windows) - OpenFoundry](https://www.openfoundry.org/tw/tech-column/2383-vim--buffers-and-windows)
* [语虚: VIM学习笔记 状态行(statusline)](http://yyq123.blogspot.tw/2009/10/vim-statusline.html)
* [纯手工制作一个漂亮的 statusline - 知乎专栏](https://zhuanlan.zhihu.com/p/24642631)

