環境樹 & YsBash 命令
=======


> 版本： v0.1.1

實現環境樹承諾的莊園。



## 要求


* [shbase^0.2.2](https://github.com/BwayCer/envtree/tree/module_shbase)
* [shTool^0.1.0](https://github.com/BwayCer/envtree/tree/module_shTool)



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
  note           顯示記事字條。
  edit           編輯相關文件。
  createModule   創建模組資料夾。


選項：

  -h, --help   幫助。
```


**設定文件：**

執行 `ysBash edit config` 命令來編輯設定文件。

（關於設定方式見
[./lib/_envtree.config.template](./lib/_envtree.config.template)）

