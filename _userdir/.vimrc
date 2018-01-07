" >> vim-plug 管理器 -------

" 指定放置插件的目錄
" - 避免去使用 Vim 的規範目錄名稱， 如：`plugin`
call plug#begin('~/.vim/bundle')

    " 請務必使用單引號

    " >> 起頭設置 -------

        nmap <silent> z/rvc :source ~/.vimrc<CR>

        nmap z/rpi :PlugInstall<CR>
        nmap z/rpu :PlugUpdate<CR>
        nmap z/rpc :PlugClean<CR>
        " :PlugUpgrade   - 更新 vim-plug 管理器
        " :PlugInstall   - 安裝未安裝的插件
        " :PlugUpdate    - 安裝或更新插件
        " :PlugClean     - 移除未使用的插件目錄
        " :PlugStatus    - 查看目前插件狀態

        " 取消向下支援
        set nocompatible
        set t_Co=256


    " 中文說明文件
    Plug 'chusiang/vimcdoc-tw'

    " Vim 腳本的函式庫
    Plug 'vim-scripts/L9'

    " 查找文件 ； 依賴： L9
    Plug 'vim-scripts/FuzzyFinder'

        nmap Ff :FufFile<CR>
        nmap Fb :FufBuffer<CR>
        " nmap Fc :FufDir

    " 程式物件整理 需額外安裝 ctags
    Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }

        nmap <F8> :TagbarToggle<CR>

    " 標記減量預覽
    Plug 'BwayCer/markdown-preview.vim', { 'branch': 'linkInVm', 'for': 'markdown' }
    " autocmd! User markdown-preview.vim echo '[Bway.Plug] 標記減量預覽 已載入'

        nmap <F9> :MarkdownPreview<CR>
        nmap mdstop :MarkdownPreviewStop<CR>

    " Go 程式語言
    Plug 'fatih/vim-go'


    " >> 基礎設置 -------

        set fileformat=unix
        set enc=utf8
        syntax on

        " 滑鼠功能只在 Visual 模式下使用
        set mouse=v
        " 在 insert 模式啟用 backspace 鍵
        set backspace=2

        " 保留 99 個歷史指令
        set history=99

        " 顯示行號。
        set number
        " 顯示相對行號。
        set relativenumber

        " 使用空白取到 Tab。
        set expandtab
        " 縮排 (Tab) 位元數。
        set tabstop=4
        set shiftwidth=4
        " 依照檔案類型自動決定縮排樣式
        " filetype indent on

            " 設定縮排寬度
            function IndentTabWidth(width)
                let &tabstop = a:width
                let &shiftwidth = a:width
                echo '以 ' . a:width . ' 個單位縮排'
            endfunction

            nmap z/tab  :call IndentTabWidth(
            nmap z/tab2 :call IndentTabWidth(2)<CR>
            nmap z/tab4 :call IndentTabWidth(4)<CR>
            nmap z/tab8 :call IndentTabWidth(8)<CR>

        " 高亮游標行 (水平)。
        set cursorline
        " 高亮游標行列 (垂直)。
        set cursorcolumn

        " 顯示右下角的 行,列 目前在文件的位置 % 的資訊
        set ruler


    " >> 風格配置 -------

        " 啟用暗色背景模式。
        set background=dark

        " 設定行號為：粗體，前景色為深灰色，沒有背景色
        hi LineNr cterm=bold ctermfg=DarkGrey ctermbg=NONE


    " >> 狀態列 -------

        " 開啟狀態列
        set laststatus=2

        function Buf_total_num()
            return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
        endfunction

        function FileSize(f)
            let l:size = getfsize(expand(a:f))
            if l:size == 0 || l:size == -1 || l:size == -2
                return '[Empty]'
            endif
            if l:size < 1024
                return l:size . 'b'
            elseif l:size < 1024*1024
                return printf('%.1f', l:size/1024.0) . 'K'
            elseif l:size < 1024*1024*1024
                return printf('%.1f', l:size/1024.0/1024.0) . 'M'
            else
                return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'G'
            endif
        endfunction

        set statusline=%1*[B%{Buf_total_num()}-%n]%m%*
        set statusline+=%9*\ %y%r\ %*
        set statusline+=%8*\ %{FileSize(@%)}\ %*
        set statusline+=%<%7*\ %{&ff}\ \|\ %{\"\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}\ %*
        set statusline+=%3*\ %F\ %*
        set statusline+=%7*%=%*
        set statusline+=%8*\ %3.(%c%V%)\ %*
        set statusline+=%9*\ %l/%L\(%P\)\ %*

        hi User7 cterm=None ctermfg=237 ctermbg=250
        hi User8 cterm=None ctermfg=255 ctermbg=243
        hi User9 cterm=None ctermfg=250 ctermbg=237

        function StatuslineInsertMode(isInsert)
            if a:isInsert
                hi User1 cterm=None ctermfg=165 ctermbg=228
                hi User3 cterm=bold ctermfg=165 ctermbg=228
            else
                hi User1 cterm=None ctermfg=172 ctermbg=195
                hi User3 cterm=bold ctermfg=172 ctermbg=195
            endif
        endfunction
        autocmd InsertEnter * call StatuslineInsertMode(1)
        autocmd InsertLeave * call StatuslineInsertMode(0)

        call StatuslineInsertMode(0)


    " >> 緩衝區與切割視窗 -------

        " 儲存文件
        nmap z/s :w<CR>

        " 緩衝區列表
        nmap z/bl :ls<CR>
        " 前一個開啟的緩衝區
        nmap z/bm :b#<CR>
        " 上一個緩衝區
        nmap z/bk :bp<CR>
        " 下一個緩衝區
        nmap z/bj :bn<CR>

        " 解除安裝緩衝區
        nmap z/bd :bd<CR>

        " 順序地切換視窗
        nmap z/ww <C-w>w
        " 移動至左側的視窗
        nmap z/wh <C-w>h
        " 移動至下方的視窗
        nmap z/wj <C-w>j
        " 移動至上方的視窗
        nmap z/wk <C-w>k
        " 移動至右側的視窗
        nmap z/wl <C-w>l

        " 加寬視窗 [Num]
        nmap z/wrw :vertical resize +
        " 縮寬視窗 [Num]
        nmap z/wrW :vertical resize -
        " 加高視窗 [Num]
        nmap z/wrh :resize +
        " 縮高視窗 [Num]
        nmap z/wrH :resize -

        " Tmux
        function TmuxAttach()
            if system('tmux ls')=~#'^no server running'
                !tmux
            else
                !tmux attach
            endif
        endfunction

            nmap z/wt :call TmuxAttach()<CR>


    " >> 特殊動作 -------

        " 自動切換當前路徑至文件目錄。
        set autochdir

        " 對當前文件目錄操作。
        nmap z/dir :browse new .

        " 字數過長時換行。
        set wrap
        " 捲動時保留底下 3 行。
        set scrolloff=3

        " 自動縮排
        set ai

            nmap z/pas :set paste<CR>
            nmap z/pno :set nopaste<CR>

        " 摺疊 Folding
        set foldenable          " 啟用命令
        set foldcolumn=2        " 於左側欄上顯示 1 格寬的摺疊標誌訊息
        set foldmethod=indent
        set foldlevel=5         " method=indent

            " 依 shiftwidth 的縮排方式摺疊
            nmap z/fmi :set foldmethod=indent<CR>
            " 手動摺疊
            nmap z/fmm :set foldmethod=manual<CR>

        " 搜尋
        set incsearch       " 即時的關鍵字匹配 不須等到完全輸入完才顯示結果
        set hlsearch        " 標記關鍵字。
        set ic              " 搜尋不分大小寫。

        " 儲存前刪除多餘空白
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

        " :help sessionoptions
        set sessionoptions-=curdir
        set sessionoptions+=sesdir

        function RecordSession(act)
            let l:sessionPath = '~/.vim/myVim/Session.tmp.vim'
            let l:isFileExists = !empty(findfile(l:sessionPath))

            if !l:isFileExists
                call system('mkdir -p ~/.vim/myVim; touch ' . l:sessionPath)
            endif

            if a:act == 'clear'
                call system('cat /dev/null > ' . l:sessionPath)
            elseif a:act == 'save'
                mks! ~/.vim/myVim/Session.tmp.vim
            elseif a:act == 'restore'
                source ~/.vim/myVim/Session.tmp.vim
            endif
        endfunction

        let s:isRecordSession = 1
        function RecordSession_prompt(act)
            if s:isRecordSession
                if a:act == 'save'
                    if input('是否保存本次的會話群組？ [y: Yes, n: No] ') == 'y'
                        call RecordSession('save')
                    endif
                elseif a:act == 'restore' && !empty(system('cat ~/.vim/myVim/Session.tmp.vim'))
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


        " 常用命令提示
        function ZCommandHelp()
            echo "常用命令提示\n=======\n "

            echo '基礎：'
            echo "    z/H： 幫助 \t z/rvc： 更新 .vimrc"
            echo "    z/rs： 保存會話並退出 \t z/rq： 離開保存會話並退出"
            echo "    z/s： 儲存文件"

            echo ' '
            echo '插件管理：'
            echo "    z/rpi： 安裝未安裝的插件 \t z/rpu： 安裝或更新插件 \t z/rpc： 移除未使用的插件目錄"
            echo ' '
            echo '    查找文件：'
            echo "        Ff： 開啟指定路徑文件 \t Fb： 開啟指定緩衝區文件"

            echo ' '
            echo '緩衝區：'
            echo "    z/bl： 緩衝區列表"
            echo "    z/bm： 前一個開啟的緩衝區"
            echo "    z/bk： 上一個緩衝區 \t z/bj： 下一個緩衝區"
            echo "    z/bd： 解除安裝緩衝區"

            echo ' '
            echo '視窗：'
            echo "    <C-w> s： 切割水平視窗 \t <C-w> v： 切割垂直視窗 \t z/ww： 順序地切換視窗"
            echo "    z/wh： 移動至左側的視窗 \t z/wl： 移動至右側的視窗"
            echo "    z/wj： 移動至下方的視窗 \t z/wk： 移動至上方的視窗"
            echo "    z/wrh： 加高視窗 + [Num] \t z/wrH： 縮高視窗 + [Num]"
            echo "    z/wrw： 加寬視窗 + [Num] \t z/wrW： 縮寬視窗 + [Num]"
            echo "    z/wt： 開啟 Tmux"

            echo ' '
            echo '縮排：'
            echo "    z/tab： 設定縮排寬度 \t z/tab2 \t z/tab4 \t z/tab8"
            echo "    z/pas： 貼上模式 \t z/pno： 取消貼上模式"

            echo ' '
            echo '摺疊方式：'
            echo "    z/fmi： 依 shiftwidth 的縮排方式摺疊 \t z/fmm： 手動摺疊"
            echo "    zn： 禁用折疊 \t zN： 啟用折疊"
            echo "    za： 打開或關閉當前的折疊"
            echo "    zo： 打開當前的折疊 \t zc： 關閉當前打開的折疊"
            echo "    zr： 打開所有折疊 \t zm： 關閉所有折疊"
            echo "    zR： 打開所有折疊及其嵌套的折疊 \t zM： 關閉所有折疊及其嵌套的折疊"
            echo "    zj： 移動至下一個折疊 \t zk： 移動至上一個折疊"
            echo ' '
            echo '    手動摺疊命令：'
            echo '        zf[Num](jk)： 加上數字與方向指定摺疊範圍'
            echo '        zfa(<>, {}, ())： 指定項目的摺疊'
            echo '        zd： 移除所在位置的摺疊'

            echo ' '
            echo '額外功能：'
            echo "    z/dir： 對當前文件目錄操作"
        endfunction

        nmap z/H :call ZCommandHelp()<CR>

" 初始化插件系統
call plug#end()

