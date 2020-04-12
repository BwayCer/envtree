環境樹
=======


> 養護工： 張本微 Bway.Cer <bwaycer@gmail.com> (https://bwaycer.github.io/)

在 GitHub 上栽種我的文字樹，建造專屬我的莊園。



**頁籤**<br>
　- [安裝方式](#安裝方式) - [目錄結構](#目錄結構) -



## 安裝方式


1. 下載環境樹專案： `git clone --recursive --shallow-submodules https://github.com/BwayCer/envtree.git ~/ys`
2. 編輯設定文件　： `~/ys/init.ysBash edit config`
3. 建立環境　　　： `~/ys/init.ysBash plant -f host`
4. 選用環境　　　：
    1. (在主機上) `~/ys/init.ysBash which host` (需刪除 "已存在路徑" 的文件)
    2. (在容器內) `docker.ysOnce --image <映像文件名稱> --home-pick $__ysBashPath/envfile/hostHome bash`


（關於設定文件的設定方式見
[設定文件樣板](https://github.com/BwayCer/envtree/tree/module/envtree/lib/_envtree.config.template)）


若非 Linux 環境請先建立 docker 容器：

```
sudo docker build -t local/mizin:bwaycer -f ~/ys/vmfile/mizin/bwaycer.dockerfile ~/ys/vmfile/mizin
sudo docker run --rm -it --user 1000 -v $HOME/ys:/home/bwaycer/ys local/mizin:bwaycer bash
```


**(作者專用)** 設定子模組使用 SSH 的連接方式：

```sh
# git@2.25.0 提供 `git submodule set-url` 的功能
git config --file .gitmodules --get-regexp url |
  grep "https://github.com/BwayCer/" | sed "s/^submodule\.\(.*\)\.url/\1/" |
  while read line
  do
      rtUrl=`cut -d " " -f 2 <<< "$line"`
      git submodule set-url "`cut -d " " -f 1 <<< "$line"`" "git@github.com:${rtUrl:19}"
  done
```



## 目錄結構


```
─┬ 專案目錄/ (Ys 目錄)
 ├─┬ lib.capp/ --------------------- capp 程式庫 (放置符合 YsBash 規範的專案)
 │ ├── shbase/ --------------------- -- 腳本基礎專案
 │ └── envtree/ -------------------- -- YsBash 環境建置工具專案
 ├── vmfile/ ----------------------- 虛擬容器文件目錄
 ├─┬ envfile/ ---------------------- 配置文件目錄
 │ ├─┬ sharehome/ ------------------ -- 目錄內的文件將與其它家目錄共享
 │ │ ├── .bash_history ------------- -- -- 命令歷史記錄
 │ │ ├── .bashrc ------------------- -- -- 運行命令環境設定
 │ │ └── .ys ----------------------- -- -- link -> /path/to/ys
 │ ├─┬ [<name>Home/ ...] ----------- -- 特定的環境家目錄
 │ │ ├─┬ capp/ --------------------- -- -- YsBash 依 capp 程式庫所導出的文件
 │ │ │ ├── bin/ -------------------- -- -- -- capp 層的可執行文件目錄
 │ │ │ ├── ysBash.bashrc ----------- -- -- -- 家目錄的 bashrc 文件
 │ │ │ └── ysBash.build ------------ -- -- -- 家目錄的環境建置文件
 │ │ └── .ys ----------------------- -- -- link -> /path/to/ys (copy ./envfile/sharehome/ys)
 │ └── ysBash.envtree.config ------- -- YsBash 的設置文件
 ├─┬ gitman/ ----------------------- 碼農農場 (輯客)
 │ ├── bin/ ------------------------ -- 碼農的可執行文件目錄
 │ └── Desktop/ -------------------- -- 桌面
 └── init.ysBash ---------------- 初始化執行文件
```

