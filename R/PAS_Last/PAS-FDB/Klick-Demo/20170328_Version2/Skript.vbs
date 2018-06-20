dim fso, vbpath
Set fso = CreateObject("Scripting.FileSystemObject")
vbpath = fso.GetParentFolderName(WScript.ScriptFullName)
' use better name, no leading "\" for .BuildPath
prefix = "file:\\\"
suffix = "klickdemo.html"
' use std method
fspec = fso.BuildPath(prefix, vbpath)
fspec = fso.BuildPath(fspec, suffix)
' no param lst () when calling a sub
'fspec = """" & fspec & """" '
' check again
' MsgBox fspec


Dim objIE
' Set objShell = CreateObject("Wscript.Shell")
Set objIE = CreateObject("InternetExplorer.Application")
objIE.Navigate(fspec)
objIE.FullScreen = True
' objIE.Visible = True