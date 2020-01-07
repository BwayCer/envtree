環境樹 & YsBash 命令
=======


> 版本： v0.7.2

實現環境樹承諾的莊園。



## 依賴


* [shbase^0.4.3](https://github.com/BwayCer/envtree/tree/module/shbase)



## 使用說明


**初始化執行工具：**

執行 [`./envtree.ysBash`](./envtree.ysBash)
文件會依預期的依賴模組目錄路徑來建立基本環境並執行 YsBash 命令。


**YsBash 命令範例：**

```
$ ysBash --help
環境樹設置
===


用法： [命令] [選項]


命令：

  info           顯示資訊。
  plant          種植環境樹。
  which          在本地家目錄引入環境家目錄的連結。
  edit           編輯相關文件。
  createModule   創建模組資料夾。


選項：

  -h, --help   幫助。
```


**設定文件：**

執行 `ysBash edit config` 命令來編輯設定文件。

（關於設定方式見
[./lib/_envtree.config.template](./lib/_envtree.config.template)）

