' 提示視窗


' 用法：
' cscript.exe //nologo walert.vbs 64 "你瞭解了嗎？" "示範"
' 號碼可參考：
' https://msdn.microsoft.com/zh-tw/vba/language-reference-vba/articles/msgbox-function


Set argu = WScript.Arguments

argu0 = argu.Item( 0 )
argu1 = argu.Item( 1 )
argu2 = argu.Item( 2 )

response = MsgBox( argu1, argu0, argu2 )

Wscript.Echo( response )

