FromCharset = "Shift-JIS" '乱码所在系统编码
ToCharset = "UTF-8" '乱码原始系统编码

If WScript.Arguments.Count<1 Then
	WScript.Echo "请把需从" & FromCharset & "改变到" & ToCharset & "编码的文本文件拖到本脚本上运行"
	WScript.Quit
End If
'将参数（文件列表）存入类
Set Files = WScript.Arguments

Function gTs(FilePath1,FilePath2,charset1,charset2)
	dim str
	str = ""
	Set adostream = CreateObject("ADODB.Stream")
	With adostream
		.Type = 2
		.Open
		.Charset = charset1
		.Position = 0
		.LoadFromFile FilePath1
		str = .readtext
		.close
	End With
	Set adostream = Nothing
	Set adostream = CreateObject("ADODB.Stream")
	With adostream
		.Type = 2
		.Open
		.Charset = charset2
		.Position = 0
		.writetext str
		.SaveToFile FilePath2, 2
		.flush
		.close
	End With
	Set adostream = Nothing
End Function

set fso=createobject("scripting.filesystemobject")
for i = 0 to Files.Count-1
	set file = fso.getFile(Files(i))
	'截取文件名
	str = Left(Files(i),InStrRev(Files(i),".")-1)
	newfname = replace(Files(i),str,str & "_U")
	gTs file,newfname,FromCharset,ToCharset
next
set fso=nothing
msgbox "完成" & Files.Count & "个"

WScript.Quit