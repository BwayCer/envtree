環境樹日誌
=======


> 授權： [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.zh_TW)

> 版本： v1.1



## 簡介


在輯中心栽種我的文字樹，建造屬於我的莊園。



## 初始化


執行 [`ysBash init`](https://github.com/BwayCer/envtree/tree/master/capp/bash_completion)
命令初始化環境：

  1. 整理 [自動補齊命令目錄](https://github.com/BwayCer/envtree/tree/master/capp/bash_completion)
     內的程式包。
     [（程式碼）](https://github.com/BwayCer/envtree/blob/master/capp/lib/envtree/ysBash#L220)
  1. 整理 [`proFile.config`](https://github.com/BwayCer/envtree/blob/master/capp/lib/envtree/proFile.config)
     文件設定。
     [（程式碼）](https://github.com/BwayCer/envtree/blob/master/capp/lib/envtree/ysBash#L230)
  1. 安裝 [vim-plug 管理器](/content/vim/manager_vim_plug.md)。
     [（程式碼）](https://github.com/BwayCer/envtree/blob/master/capp/lib/envtree/ysBash_installDefaultApp#L8)
  1. 安裝 [nvm 管理器](https://github.com/creationix/nvm)。
     [（程式碼）](https://github.com/BwayCer/envtree/blob/master/capp/lib/envtree/ysBash_installDefaultApp#L19)
  1. 安裝 [nodeApp 程式包](https://github.com/BwayCer/envtree/tree/master/capp/lib/nodeApp)。
     [（程式碼）](https://github.com/BwayCer/envtree/blob/master/capp/lib/envtree/ysBash_installDefaultApp#L42)
  1. 創建 `ys`、`.ys` 及 [`_userdir`](https://github.com/BwayCer/envtree/tree/master/_userdir)
     目錄的鏈結文件。
     [（程式碼）](https://github.com/BwayCer/envtree/blob/master/capp/lib/envtree/ysBash#L291)


寫入 `.proFile.ysBash` 文件的運行命令：
（`source ~/.bashrc` 運行時被載入）

  1. 位於 [`capp/bash_completion`](https://github.com/BwayCer/envtree/blob/master/capp/bash_completion)
     目錄的自動補齊命令程式包。
  1. 關於 [`proFile.config`](https://github.com/BwayCer/envtree/blob/master/capp/lib/envtree/proFile.config)
     文件設定。
  1. 顯示 [`ysBash_note`](https://github.com/BwayCer/envtree/blob/master/capp/lib/envtree/ysBash_note)
     記事字條。

