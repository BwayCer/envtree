不完整希格溫命令小冊
=======


**查找已安裝或未安裝的程式包資訊**

```
cygcheck -c | grep cygwin

# 雖然找不到 vim 所需的 libpython3.7m.dll 程式包
# 但透過此命令仍可得到可參考的相關程式包 (ex: python37)
cygcheck -p libpython3.7m.dll
```


**新增 Cygwin 捷徑到 menutext 右鍵選單中的命令**

```
chere -if -t mintty -s bash -e Cygwin
```

