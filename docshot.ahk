#NoEnv
; #Warn
#SingleInstance


; Copies image data from file to the clipboard.
FileToClipboard(PathToCopy,Method="copy")
   {
   FileCount:=0
   PathLength:=0

   ; Count files and total string length
   Loop,Parse,PathToCopy,`n,`r
      {
      FileCount++
      PathLength+=StrLen(A_LoopField)
      }

   pid:=DllCall("GetCurrentProcessId","uint")
   hwnd:=WinExist("ahk_pid " . pid)
   ; 0x42 = GMEM_MOVEABLE(0x2) | GMEM_ZEROINIT(0x40)
   hPath := DllCall("GlobalAlloc","uint",0x42,"uint",20 + (PathLength + FileCount + 1) * 2,"UPtr")
   pPath := DllCall("GlobalLock","UPtr",hPath)
   NumPut(20,pPath+0),pPath += 16 ; DROPFILES.pFiles = offset of file list
   NumPut(1,pPath+0),pPath += 4 ; fWide = 0 -->ANSI,fWide = 1 -->Unicode
   Offset:=0
   Loop,Parse,PathToCopy,`n,`r ; Rows are delimited by linefeeds (`r`n).
      offset += StrPut(A_LoopField,pPath+offset,StrLen(A_LoopField)+1,"UTF-16") * 2

   DllCall("GlobalUnlock","UPtr",hPath)
   DllCall("OpenClipboard","UPtr",hwnd)
   DllCall("EmptyClipboard")
   DllCall("SetClipboardData","uint",0xF,"UPtr",hPath) ; 0xF = CF_HDROP

   ; Write Preferred DropEffect structure to clipboard to switch between copy/cut operations
   ; 0x42 = GMEM_MOVEABLE(0x2) | GMEM_ZEROINIT(0x40)
   mem := DllCall("GlobalAlloc","uint",0x42,"uint",4,"UPtr")
   str := DllCall("GlobalLock","UPtr",mem)

   if (Method="copy")
      DllCall("RtlFillMemory","UPtr",str,"uint",1,"UChar",0x05)
   else if (Method="cut")
      DllCall("RtlFillMemory","UPtr",str,"uint",1,"UChar",0x02)
   else
      {
      DllCall("CloseClipboard")
      return
      }

   DllCall("GlobalUnlock","UPtr",mem)

   cfFormat := DllCall("RegisterClipboardFormat","Str","Preferred DropEffect")
   DllCall("SetClipboardData","uint",cfFormat,"UPtr",mem)
   DllCall("CloseClipboard")
   return
   }

^!2::

Reload

^!3::



Exit

F12::

RegRead, MyVideos, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, My Video
MyVideos := MyVideos . "\Captures\"
OutputDir := "C:\"

Send, #!{PrintScreen} 
Sleep, 500

Loop, %MyVideos%*.*
{
	CheckFile_Start := A_LoopFileTimeCreated
	If (CheckFile_Start > CheckFile_End)
	{
		CheckFile_End := A_LoopFileTimeCreated
		Out := A_LoopFileName

	}
}

FullPath := "C:\Users\silen\Videos\Captures\" . Out
FullPathSDR := StrReplace(FullPath, ".jxr", ".png")

;MsgBox, %FullPath%
FileToClipboard(FullPathSDR)
FileCopy, %FullPath%, %OutputDir%
FileCopy, %FullPathSDR%, %OutputDir%

Exit