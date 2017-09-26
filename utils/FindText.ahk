
/*
===========================================
  FindText - Capture screen image into text and then find it
  https://autohotkey.com/boards/viewtopic.php?f=6&t=17834

  Author  :  FeiYue
  Version :  5.3
  Date    :  2017-09-25

  Usage:
  1. Capture the image to text string.
  2. Test find the text string on full Screen.
  3. When test is successful, you may copy the code
     and paste it into your own script.
     Note: Copy the "FindText()" function and the following
     functions and paste it into your own script Just once.

===========================================
  Introduction of function parameters:

  returnArray := FindText( center point X, center point Y
    , Left and right offset to the center point W
    , Up and down offset to the center point H
    , Character "0" fault-tolerant in percentage
    , Character "_" fault-tolerant in percentage, text )

  parameters of the X,Y is the center of the coordinates,
  and the W,H is the offset distance to the center,
  So the search range is (X-W, Y-H)-->(X+W, Y+H).

  The fault-tolerant parameters allow the loss of specific
  characters, very useful for gray threshold model.

  Text parameters can be a lot of text to find, separated by "|".

  return is a array, contains the X,Y,W,H,Comment results of Each Find.

===========================================
*/

#NoEnv
#SingleInstance Force
SetBatchLines, -1
CoordMode, Mouse
CoordMode, Pixel
CoordMode, ToolTip
SetWorkingDir, %A_ScriptDir%
Menu, Tray, Icon, Shell32.dll, 23
Menu, Tray, Add
Menu, Tray, Add, Main_Window
Menu, Tray, Default, Main_Window
Menu, Tray, Click, 1
; The capture range can be changed by adjusting the numbers
;----------------------------
  ww:=35, hh:=12
;----------------------------
nW:=2*ww+1, nH:=2*hh+1
Gosub, MakeCaptureWindow
Gosub, MakeMainWindow
Gosub, Load_ToolTip_Text
OnExit, savescr
Gosub, readscr
return


F12::    ; Hotkey --> Reload
SetTitleMatchMode, 2
SplitPath, A_ScriptName,,,, name
IfWinExist, %name%
{
  ControlSend, ahk_parent, {Ctrl Down}s{Ctrl Up}
  Sleep, 500
}
Reload
return


Load_ToolTip_Text:
ToolTip_Text=
(LTrim
Capture   = Initiate Image Capture Sequence
Test      = Test Results of Code
Copy      = Copy Code to Clipboard
AddFunc   = Additional FindText() in Copy
U         = Cut the Upper Edge by 1
U3        = Cut the Upper Edge by 3
L         = Cut the Left Edge by 1
L3        = Cut the Left Edge by 3
R         = Cut the Right Edge by 1
R3        = Cut the Right Edge by 3
D         = Cut the Lower Edge by 1
D3        = Cut the Lower Edge by 3
Auto      = Automatic Cutting Edge`r`nOnly after Color2Two or Gray2Two
Similar   = Adjust color similarity as Equivalent to The Selected Color
SelCol    = Selected Image Color which Determines Black or Pixel White Conversion (Hex of Color)
Gray      = Grayscale Threshold which Determines Black or White Pixel Conversion (0-255)
Color2Two = Converts Image Pixels from Color to Black or White`r`nDepending on Selection Color and Sensitivity
Gray2Two  = Converts Image Pixels from Grays to Black or White`r`nDepending on Gray Threshold
Modify    = Allows for Pixel Cleanup of Black and White Image`r`nOnly After Gray2Two or Color2Two
Reset     = Reset to Original Captured Image
Invert    = Invert Images Black and White`r`nOnly after Color2Two or Gray2Two
Comment   = Optional Comment used to Label Code ( Within <> )
OK        = Create New FindText Code for Testing
Append    = Append Another FindText Search Text into Previously Generated Code
Close     = Close the Window Don't Do Anything
)
return

readscr:
f=%A_Temp%\~scr.tmp
FileRead, s, %f%
GuiControl, Main:, scr, %s%
s=
return

savescr:
f=%A_Temp%\~scr.tmp
GuiControlGet, s, Main:, scr
FileDelete, %f%
FileAppend, %s%, %f%
ExitApp

Main_Window:
Gui, Main:Show, Center
return

MakeMainWindow:
Gui, Main:Default
Gui, +AlwaysOnTop +HwndMain_ID
Gui, Margin, 15, 15
Gui, Color, DDEEFF
Gui, Font, s6 bold, Verdana
Gui, Add, Edit, xm w660 r25 vMyEdit -Wrap -VScroll
Gui, Font, s12 norm, Verdana
Gui, Add, Button, w220 gMainRun, Capture
Gui, Add, Button, x+0 wp gMainRun, Test
Gui, Add, Button, x+0 wp gMainRun Section, Copy
Gui, Font, s10
Gui, Add, Text, xm, Click Text String to See ASCII Search Text in the Above
Gui, Add, Checkbox, xs yp w220 r1 -Wrap Checked vAddFunc, Additional FindText() in Copy
Gui, Font, s12 cBlue, Verdana
Gui, Add, Edit, xm w660 h350 vscr Hwndhscr -Wrap HScroll
Gui, Show, NA, Capture Image To Text And Find Text Tool
;---------------------------------------
OnMessage(0x100, "EditEvents1")  ; WM_KEYDOWN
OnMessage(0x201, "EditEvents2")  ; WM_LBUTTONDOWN
OnMessage(0x200, "WM_MOUSEMOVE") ; Show ToolTip
return

EditEvents1() {
  ListLines, Off
  if (A_Gui="Main") and (A_GuiControl="scr")
    SetTimer, ShowText, -100
}

EditEvents2() {
  ListLines, Off
  if (A_Gui="Capture")
    WM_LBUTTONDOWN()
  else
    EditEvents1()
}

ShowText:
ListLines, Off
Critical
ControlGet, i, CurrentLine,,, ahk_id %hscr%
ControlGet, s, Line, %i%,, ahk_id %hscr%
s := ASCII(s)
GuiControl, Main:, MyEdit, % Trim(s,"`n")
return

MainRun:
k:=A_GuiControl
WinMinimize
Gui, Hide
DetectHiddenWindows, Off
WinWaitClose, ahk_id %Main_ID%
if IsLabel(k)
  Gosub, %k%
Gui, Main:Show
GuiControl, Main:Focus, scr
return

Copy:
GuiControlGet, s,, scr
GuiControlGet, AddFunc
if AddFunc != 1
  s:=RegExReplace(s,"\n\K[\s;=]+ Copy The[\s\S]*")
Clipboard:=StrReplace(s,"`n","`r`n")
s=
return

Capture:
Gui, Mini:Default
Gui, +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000
WinSet, Transparent, 100
Gui, Color, Red
Gui, Show, Hide w%nW% h%nH%
;------------------------------
Hotkey, $*LButton, _LButton_Off, On
ListLines, Off
Loop {
  MouseGetPos, px, py
  if GetKeyState("LButton","P")
    Break
  Gui, Show, % "NA x" (px-ww) " y" (py-hh)
  ToolTip, % "The Mouse Pos : " px "," py
    . "`nPlease Move and Click LButton"
  Sleep, 20
}
KeyWait, LButton
Gui, Color, White
Loop {
  MouseGetPos, x, y
  if Abs(px-x)+Abs(py-y)>100
    Break
  Gui, Show, % "NA x" (x-ww) " y" (y-hh)
  ToolTip, Please Move Mouse > 100 Pixels
  Sleep, 20
}
ToolTip
ListLines, On
Hotkey, $*LButton, Off
Gui, Destroy
WinWaitClose
cors:=getc(px,py,ww,hh)
Gui, Capture:Default
GuiControl,, SelCol
GuiControl,, Gray
GuiControl,, Modify, % Modify:=0
GuiControl, Focus, Gray
Gosub, Reset
Gui, Show, Center
DetectHiddenWindows, Off
WinWaitClose, ahk_id %Capture_ID%
_LButton_Off:
return

WM_LBUTTONDOWN() {
  global
  ListLines, Off
  MouseGetPos,,,, mclass
  if !InStr(mclass,"progress")
    return
  MouseGetPos,,,, mid, 2
  For k,v in C_
    if (v=mid)
    {
      if (Modify and bg!="")
      {
        c:=cc[k], cc[k]:=c="0" ? "_" : c="_" ? "0" : c
        c:=c="0" ? "White" : c="_" ? "Black" : WindowColor
        Gosub, SetColor
      }
      else
        GuiControl, Capture:, SelCol, % cors[k]
      return
    }
}

getc(px, py, ww, hh) {
  xywh2xywh(px-ww,py-hh,2*ww+1,2*hh+1,x,y,w,h)
  if (w<1 or h<1)
    return, 0
  bch:=A_BatchLines
  SetBatchLines, -1
  ;--------------------------------------
  GetBitsFromScreen(x,y,w,h,Scan0,Stride,bits)
  ;--------------------------------------
  cors:=[], k:=0, nW:=2*ww+1, nH:=2*hh+1
  ListLines, Off
  fmt:=A_FormatInteger
  SetFormat, IntegerFast, H
  Loop, %nH% {
    j:=py-hh-y+A_Index-1
    Loop, %nW% {
      i:=px-ww-x+A_Index-1, k++
      if (i>=0 and i<w and j>=0 and j<h)
        c:=NumGet(Scan0+0,i*4+j*Stride,"uint")
          , cors[k]:="0x" . SubStr(0x1000000|c,-5)
      else
        cors[k]:="0xFFFFFF"
    }
  }
  SetFormat, IntegerFast, %fmt%
  ListLines, On
  cors.left:=Abs(px-ww-x)
  cors.right:=Abs(px+ww-(x+w-1))
  cors.up:=Abs(py-hh-y)
  cors.down:=Abs(py+hh-(y+h-1))
  SetBatchLines, %bch%
  return, cors
}

Test:
GuiControlGet, s, Main:, scr
s:="#NoEnv`nMenu, Tray, Click, 1`nGui, _ok_:Show, Hide, _ok_"
  . s "`nExitApp`n#SingleInstance off`n"
Try {
  Ahk:=A_IsCompiled ? A_ScriptDir "\AutoHotkey.exe":A_AhkPath
  s:=RegExReplace(s, "\R", "`r`n")
  oExec:=ComObjCreate("WScript.Shell").Exec(Ahk . " /r *")
  oExec.StdIn.Write(s)
  oExec.StdIn.Close()
  DetectHiddenWindows, On
  WinWait, _ok_ ahk_class AutoHotkeyGUI,, 3
  WinWaitClose, _ok_ ahk_class AutoHotkeyGUI,, 3
  Sleep, 1000
}
catch {
  MsgBox, 4096, Error, Can't Run AHK Script!, 3
}
return

MakeCaptureWindow:
WindowColor:="0xCCDDEE"
Gui, Capture:Default
Gui, +LastFound +AlwaysOnTop +ToolWindow +HwndCapture_ID
Gui, Margin, 15, 15
Gui, Color, %WindowColor%
Gui, Font, s14, Verdana
ListLines, Off
w:=800//nW+1, h:=(A_ScreenHeight-300)//nH+1, w:=h<w ? h:w
Loop, % nH*nW {
  j:=A_Index=1 ? "" : Mod(A_Index,nW)=1 ? "xm y+-1" : "x+-1"
  Gui, Add, Progress, w%w% h%w% %j% -Theme
}
ListLines, On
Gui, Add, Button, xm+95  w45 gUpCut Section, U
Gui, Add, Button, x+0    wp gUpCut3, U3
Gui, Add, Text,   xm+310 yp+6 Section, Color Similarity  0
Gui, Add, Slider
  , x+0 w250 vSimilar Page1 NoTicks ToolTip Center, 100
Gui, Add, Text,   x+0, 100
Gui, Add, Button, xm     w45 gLeftCut, L
Gui, Add, Button, x+0    wp gLeftCut3, L3
Gui, Add, Button, x+15   w70 gRun, Auto
Gui, Add, Button, x+15   w45 gRightCut, R
Gui, Add, Button, x+0    wp gRightCut3, R3
Gui, Add, Text,   xs     w160 yp, Selected  Color
Gui, Add, Edit,   x+15   w140 vSelCol
Gui, Add, Button, x+15   w150 gRun, Color2Two
Gui, Add, Button, xm+95  w45 gDownCut, D
Gui, Add, Button, x+0    wp gDownCut3, D3
Gui, Add, Text,   xs     w160 yp, Gray Threshold
Gui, Add, Edit,   x+15   w140 vGray
Gui, Add, Button, x+15   w150 gRun Default, Gray2Two
Gui, Add, Checkbox, xm   y+21 gRun vModify, Modify
Gui, Add, Button, x+5    yp-6 gRun, Reset
Gui, Add, Button, x+15   gRun, Invert
Gui, Add, Text,   x+15   yp+6, Add Comment
Gui, Add, Edit,   x+5    w100 vComment
Gui, Add, Button, x+15   w85 yp-6 gRun, OK
Gui, Add, Button, x+10   gRun, Append
Gui, Add, Button, x+10   gCancel, Close
Gui, Show, Hide, Capture Image To Text
WinGet, s, ControlListHwnd
C_:=StrSplit(s,"`n"), s:=""
return

Run:
Critical
k:=A_GuiControl
if IsLabel(k)
  Goto, %k%
return

Modify:
GuiControlGet, Modify
return

SetColor:
c:=c="White" ? 0xFFFFFF : c="Black" ? 0x000000
  : ((c&0xFF)<<16)|(c&0xFF00)|((c&0xFF0000)>>16)
SendMessage, 0x2001, 0, c,, % "ahk_id " . C_[k]
return

Reset:
if !IsObject(cc)
  cc:=[], gc:=[], pp:=[]
left:=right:=up:=down:=k:=0, bg:=""
Loop, % nH*nW {
  cc[++k]:=1, c:=cors[k], gc[k]:=(((c>>16)&0xFF)*299
    +((c>>8)&0xFF)*587+(c&0xFF)*114)//1000
  Gosub, SetColor
}
Loop, % cors.left
  Gosub, LeftCut
Loop, % cors.right
  Gosub, RightCut
Loop, % cors.up
  Gosub, UpCut
Loop, % cors.down
  Gosub, DownCut
return

Color2Two:
GuiControlGet, Similar
GuiControlGet, r,, SelCol
if r=
{
  MsgBox, 4096, Tip
    , `n  Please Select a Color First !  `n, 1
  return
}
Similar:=Round(Similar/100,2), n:=Floor(255*3*(1-Similar))
color:=r "@" Similar, k:=i:=0
rr:=(r>>16)&0xFF, gg:=(r>>8)&0xFF, bb:=r&0xFF
Loop, % nH*nW {
  if (cc[++k]="")
    Continue
  c:=cors[k], r:=(c>>16)&0xFF, g:=(c>>8)&0xFF, b:=c&0xFF
  if Abs(r-rr)+Abs(g-gg)+Abs(b-bb)<=n
    cc[k]:="0", c:="Black", i++
  else
    cc[k]:="_", c:="White", i--
  Gosub, SetColor
}
bg:=i>0 ? "0":"_"
return

Gray2Two:
GuiControl, Focus, Gray
GuiControlGet, Threshold,, Gray
if Threshold=
{
  Loop, 256
    pp[A_Index-1]:=0
  Loop, % nH*nW
    if (cc[A_Index]!="")
      pp[gc[A_Index]]++
  IP:=IS:=0
  Loop, 256
    k:=A_Index-1, IP+=k*pp[k], IS+=pp[k]
  NewThreshold:=Floor(IP/IS)
  Loop, 20 {
    Threshold:=NewThreshold
    IP1:=IS1:=0
    Loop, % Threshold+1
      k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
    IP2:=IP-IP1, IS2:=IS-IS1
    if (IS1!=0 and IS2!=0)
      NewThreshold:=Floor((IP1/IS1+IP2/IS2)/2)
    if (NewThreshold=Threshold)
      Break
  }
  GuiControl,, Gray, %Threshold%
}
color:="*" Threshold, k:=i:=0
Loop, % nH*nW {
  if (cc[++k]="")
    Continue
  if (gc[k]<Threshold+1)
    cc[k]:="0", c:="Black", i++
  else
    cc[k]:="_", c:="White", i--
  Gosub, SetColor
}
bg:=i>0 ? "0":"_"
return

gui_del:
cc[k]:="", c:=WindowColor
Gosub, SetColor
return

LeftCut3:
Loop, 3
  Gosub, LeftCut
return

LeftCut:
if (left+right>=nW)
  return
left++, k:=left
Loop, %nH% {
  Gosub, gui_del
  k+=nW
}
return

RightCut3:
Loop, 3
  Gosub, RightCut
return

RightCut:
if (left+right>=nW)
  return
right++, k:=nW+1-right
Loop, %nH% {
  Gosub, gui_del
  k+=nW
}
return

UpCut3:
Loop, 3
  Gosub, UpCut
return

UpCut:
if (up+down>=nH)
  return
up++, k:=(up-1)*nW
Loop, %nW% {
  k++
  Gosub, gui_del
}
return

DownCut3:
Loop, 3
  Gosub, DownCut
return

DownCut:
if (up+down>=nH)
  return
down++, k:=(nH-down)*nW
Loop, %nW% {
  k++
  Gosub, gui_del
}
return

getwz:
wz=
if bg=
  return
ListLines, Off
k:=0
Loop, %nH% {
  v=
  Loop, %nW%
    v.=cc[++k]
  wz.=v="" ? "" : v "`n"
}
ListLines, On
return

Auto:
Gosub, getwz
if wz=
{
  MsgBox, 4096, Tip
    , `nPlease Click Color2Two or Gray2Two First !, 1
  return
}
While InStr(wz,bg) {
  if (wz~="^" bg "+\n")
  {
    wz:=RegExReplace(wz,"^" bg "+\n")
    Gosub, UpCut
  }
  else if !(wz~="m`n)[^\n" bg "]$")
  {
    wz:=RegExReplace(wz,"m`n)" bg "$")
    Gosub, RightCut
  }
  else if (wz~="\n" bg "+\n$")
  {
    wz:=RegExReplace(wz,"\n\K" bg "+\n$")
    Gosub, DownCut
  }
  else if !(wz~="m`n)^[^\n" bg "]")
  {
    wz:=RegExReplace(wz,"m`n)^" bg)
    Gosub, LeftCut
  }
  else Break
}
wz=
return

OK:
Append:
Invert:
Gosub, getwz
if wz=
{
  MsgBox, 4096, Tip
    , `nPlease Click Color2Two or Gray2Two First !, 1
  return
}
if A_ThisLabel=Invert
{
  wz:="", k:=0, bg:=bg="0" ? "_":"0"
  color:=InStr(color,"-") ? StrReplace(color,"-"):"-" color
  Loop, % nH*nW
    if (c:=cc[++k])!=""
    {
      cc[k]:=c="0" ? "_":"0", c:=c="0" ? "White":"Black"
      Gosub, SetColor
    }
  return
}
Gui, Hide
if A_ThisLabel=Append
{
  add(towz(color,wz))
  return
}
px1:=px-ww+left+(nW-left-right)//2
py1:=py-hh+up+(nH-up-down)//2
s:= StrReplace(towz(color,wz),"Text.=","Text:=")
  . "`nif ok:=FindText(" px1 "," py1
  . ",150000,150000,0,0,Text)`n"
  . "{`n  CoordMode, Mouse"
  . "`n  X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5"
  . "`n  MouseMove, X+W//2, Y+H//2`n}`n"
  . "MsgBox,4096,, % ok ? ""Test success !"" : ""Test failed !""`n"
if !A_IsCompiled
{
  FileRead, fs, %A_ScriptFullPath%
  fs:=SubStr(fs,fs~="i)\n[;=]+ Copy The")
}
GuiControl, Main:, scr, %s%`n%fs%
s:=wz:=fs:=""
return

towz(color,wz) {
  global Comment
  GuiControlGet, Comment
  SetFormat, IntegerFast, d
  wz:=StrReplace(StrReplace(wz,"0","1"),"_","0")
  wz:=InStr(wz,"`n")-1 . "." . bit2base64(wz)
  return, "`nText.=""|<" Comment ">" color "$" wz """`n"
}

add(s) {
  global hscr
  s:=RegExReplace("`n" s "`n","\R","`r`n")
  ControlGet, i, CurrentCol,,, ahk_id %hscr%
  if i>1
    ControlSend,, {Home}{Down}, ahk_id %hscr%
  Control, EditPaste, %s%,, ahk_id %hscr%
}

WM_MOUSEMOVE()
{
  ListLines, Off
  static CurrControl, PrevControl
  CurrControl := A_GuiControl
  if (CurrControl!=PrevControl)
  {
    PrevControl := CurrControl
    ToolTip
    if CurrControl !=
      SetTimer, DisplayToolTip, -1000
  }
  return

  DisplayToolTip:
  ListLines, Off
  k:="ToolTip_Text"
  TT_:=RegExMatch(%k%,"m`n)^" . CurrControl
    . "\K\s*=.*", r) ? Trim(r,"`t =") : ""
  MouseGetPos,,, k
  WinGetClass, k, ahk_id %k%
  if k = AutoHotkeyGUI
  {
    ToolTip, %TT_%
    SetTimer, RemoveToolTip, -5000
  }
  return

  RemoveToolTip:
  ToolTip
  return
}


;===== Copy The Following Functions To Your Own Code Just once =====


; Note: parameters of the X,Y is the center of the coordinates,
; and the W,H is the offset distance to the center,
; So the search range is (X-W, Y-H)-->(X+W, Y+H).
; err1 is the character "0" fault-tolerant in percentage.
; err0 is the character "_" fault-tolerant in percentage.
; Text can be a lot of text to find, separated by "|".
; ruturn is a array, contains the X,Y,W,H,Comment results of Each Find.

FindText(x,y,w,h,err1,err0,text)
{
  xywh2xywh(x-w,y-h,2*w+1,2*h+1,x,y,w,h)
  if (w<1 or h<1)
    return, 0
  bch:=A_BatchLines
  SetBatchLines, -1
  ;--------------------------------------
  GetBitsFromScreen(x,y,w,h,Scan0,Stride,bits)
  ;--------------------------------------
  sx:=0, sy:=0, sw:=w, sh:=h, arr:=[]
  Loop, 2 {
  Loop, Parse, text, |
  {
    v:=A_LoopField
    IfNotInString, v, $, Continue
    Comment:="", e1:=err1, e0:=err0
    ; You Can Add Comment Text within The <>
    if RegExMatch(v,"<([^>]*)>",r)
      v:=StrReplace(v,r), Comment:=Trim(r1)
    ; You can Add two fault-tolerant in the [], separated by commas
    if RegExMatch(v,"\[([^\]]*)]",r)
    {
      v:=StrReplace(v,r), r1.=","
      StringSplit, r, r1, `,
      e1:=r1, e0:=r2
    }
    StringSplit, r, v, $
    color:=r1, v:=r2
    StringSplit, r, v, .
    w1:=r1, v:=base64tobit(r2), h1:=StrLen(v)//w1
    if (r0<2 or h1<1 or w1>sw or h1>sh or StrLen(v)!=w1*h1)
      Continue
    ;--------------------------------------------
    if InStr(color,"-")
    {
      r:=e1, e1:=e0, e0:=r, v:=StrReplace(v,"1","_")
      v:=StrReplace(StrReplace(v,"0","1"),"_","0")
    }
    mode:=InStr(color,"*") ? 1:0
    color:=RegExReplace(color,"[*\-]") . "@"
    StringSplit, r, color, @
    color:=Round(r1), n:=Round(r2,2)+(!r2)
    n:=Floor(255*3*(1-n)), k:=StrLen(v)*4
    VarSetCapacity(ss, sw*sh, Asc("0"))
    VarSetCapacity(s1, k, 0), VarSetCapacity(s0, k, 0)
    VarSetCapacity(rx, 8, 0), VarSetCapacity(ry, 8, 0)
    len1:=len0:=0, j:=sw-w1+1, i:=-j
    ListLines, Off
    Loop, Parse, v
    {
      i:=Mod(A_Index,w1)=1 ? i+j : i+1
      if A_LoopField
        NumPut(i, s1, 4*len1++, "int")
      else
        NumPut(i, s0, 4*len0++, "int")
    }
    ListLines, On
    e1:=Round(len1*e1), e0:=Round(len0*e0)
    ;--------------------------------------------
    if PicFind(mode,color,n,Scan0,Stride,sx,sy,sw,sh
      ,ss,s1,s0,len1,len0,e1,e0,w1,h1,rx,ry)
    {
      rx+=x, ry+=y
      arr.Push([rx,ry,w1,h1,Comment])
    }
  }
  if (arr.MaxIndex())
    Break
  if (A_Index=1 and err1=0 and err0=0)
    err1:=0.05, err0:=0.05
  else Break
  }
  SetBatchLines, %bch%
  return, arr.MaxIndex() ? arr:0
}

PicFind(mode, color, n, Scan0, Stride
  , sx, sy, sw, sh, ByRef ss, ByRef s1, ByRef s0
  , len1, len0, err1, err0, w, h, ByRef rx, ByRef ry)
{
  static MyFunc
  if !MyFunc
  {
    x32:="5589E583EC408B45200FAF45188B551CC1E20201D08945F"
    . "48B5524B80000000029D0C1E00289C28B451801D08945D8C74"
    . "5F000000000837D08000F85F00000008B450CC1E81025FF000"
    . "0008945D48B450CC1E80825FF0000008945D08B450C25FF000"
    . "0008945CCC745F800000000E9AC000000C745FC00000000E98"
    . "A0000008B45F483C00289C28B451401D00FB6000FB6C02B45D"
    . "48945EC8B45F483C00189C28B451401D00FB6000FB6C02B45D"
    . "08945E88B55F48B451401D00FB6000FB6C02B45CC8945E4837"
    . "DEC007903F75DEC837DE8007903F75DE8837DE4007903F75DE"
    . "48B55EC8B45E801C28B45E401D03B45107F0B8B55F08B452C0"
    . "1D0C600318345FC018345F4048345F0018B45FC3B45240F8C6"
    . "AFFFFFF8345F8018B45D80145F48B45F83B45280F8C48FFFFF"
    . "FE9A30000008B450C83C00169C0E803000089450CC745F8000"
    . "00000EB7FC745FC00000000EB648B45F483C00289C28B45140"
    . "1D00FB6000FB6C069D02B0100008B45F483C00189C18B45140"
    . "1C80FB6000FB6C069C04B0200008D0C028B55F48B451401D00"
    . "FB6000FB6C06BC07201C83B450C730B8B55F08B452C01D0C60"
    . "0318345FC018345F4048345F0018B45FC3B45247C948345F80"
    . "18B45D80145F48B45F83B45280F8C75FFFFFF8B45242B45488"
    . "3C0018945488B45282B454C83C00189454C8B453839453C0F4"
    . "D453C8945D8C745FC00000000E9E3000000C745F800000000E"
    . "9C70000008B45F80FAF452489C28B45FC01D08945F48B45408"
    . "945E08B45448945DCC745F000000000EB708B45F03B45387D2"
    . "E8B45F08D1485000000008B453001D08B108B45F401D089C28"
    . "B452C01D00FB6003C31740A836DE001837DE00078638B45F03"
    . "B453C7D2E8B45F08D1485000000008B453401D08B108B45F40"
    . "1D089C28B452C01D00FB6003C30740A836DDC01837DDC00783"
    . "08345F0018B45F03B45D87C888B551C8B45FC01C28B4550891"
    . "08B55208B45F801C28B45548910B801000000EB2990EB01908"
    . "345F8018B45F83B454C0F8C2DFFFFFF8345FC018B45FC3B454"
    . "80F8C11FFFFFFB800000000C9C25000"
    x64:="554889E54883EC40894D10895518448945204C894D288B4"
    . "5400FAF45308B5538C1E20201D08945F48B5548B8000000002"
    . "9D0C1E00289C28B453001D08945D8C745F000000000837D100"
    . "00F85000100008B4518C1E81025FF0000008945D48B4518C1E"
    . "80825FF0000008945D08B451825FF0000008945CCC745F8000"
    . "00000E9BC000000C745FC00000000E99A0000008B45F483C00"
    . "24863D0488B45284801D00FB6000FB6C02B45D48945EC8B45F"
    . "483C0014863D0488B45284801D00FB6000FB6C02B45D08945E"
    . "88B45F44863D0488B45284801D00FB6000FB6C02B45CC8945E"
    . "4837DEC007903F75DEC837DE8007903F75DE8837DE4007903F"
    . "75DE48B55EC8B45E801C28B45E401D03B45207F108B45F0486"
    . "3D0488B45584801D0C600318345FC018345F4048345F0018B4"
    . "5FC3B45480F8C5AFFFFFF8345F8018B45D80145F48B45F83B4"
    . "5500F8C38FFFFFFE9B60000008B451883C00169C0E80300008"
    . "94518C745F800000000E98F000000C745FC00000000EB748B4"
    . "5F483C0024863D0488B45284801D00FB6000FB6C069D02B010"
    . "0008B45F483C0014863C8488B45284801C80FB6000FB6C069C"
    . "04B0200008D0C028B45F44863D0488B45284801D00FB6000FB"
    . "6C06BC07201C83B451873108B45F04863D0488B45584801D0C"
    . "600318345FC018345F4048345F0018B45FC3B45487C848345F"
    . "8018B45D80145F48B45F83B45500F8C65FFFFFF8B45482B859"
    . "000000083C0018985900000008B45502B859800000083C0018"
    . "985980000008B45703945780F4D45788945D8C745FC0000000"
    . "0E90B010000C745F800000000E9EC0000008B45F80FAF45488"
    . "9C28B45FC01D08945F48B85800000008945E08B85880000008"
    . "945DCC745F000000000E9800000008B45F03B45707D368B45F"
    . "04898488D148500000000488B45604801D08B108B45F401D04"
    . "863D0488B45584801D00FB6003C31740A836DE001837DE0007"
    . "8778B45F03B45787D368B45F04898488D148500000000488B4"
    . "5684801D08B108B45F401D04863D0488B45584801D00FB6003"
    . "C30740A836DDC01837DDC00783C8345F0018B45F03B45D80F8"
    . "C74FFFFFF8B55388B45FC01C2488B85A000000089108B55408"
    . "B45F801C2488B85A80000008910B801000000EB2F90EB01908"
    . "345F8018B45F83B85980000000F8C05FFFFFF8345FC018B45F"
    . "C3B85900000000F8CE6FEFFFFB8000000004883C4405DC390"
    MCode(MyFunc, A_PtrSize=8 ? x64:x32)
  }
  return, DllCall(&MyFunc, "int",mode
    , "uint",color, "int",n, "ptr",Scan0, "int",Stride
    , "int",sx, "int",sy, "int",sw, "int",sh
    , "ptr",&ss, "ptr",&s1, "ptr",&s0
    , "int",len1, "int",len0, "int",err1, "int",err0
    , "int",w, "int",h, "int*",rx, "int*",ry)
}

xywh2xywh(x1,y1,w1,h1,ByRef x,ByRef y,ByRef w,ByRef h)
{
  SysGet, zx, 76
  SysGet, zy, 77
  SysGet, zw, 78
  SysGet, zh, 79
  left:=x1, right:=x1+w1-1, up:=y1, down:=y1+h1-1
  left:=left<zx ? zx:left, right:=right>zx+zw-1 ? zx+zw-1:right
  up:=up<zy ? zy:up, down:=down>zy+zh-1 ? zy+zh-1:down
  x:=left, y:=up, w:=right-left+1, h:=down-up+1
}

GetBitsFromScreen(x,y,w,h,ByRef Scan0,ByRef Stride,ByRef bits)
{
  VarSetCapacity(bits,w*h*4,0), bpp:=32
  Scan0:=&bits, Stride:=((w*bpp+31)//32)*4
  Ptr:=A_PtrSize ? "UPtr" : "UInt", PtrP:=Ptr . "*"
  win:=DllCall("GetDesktopWindow", Ptr)
  hDC:=DllCall("GetWindowDC", Ptr,win, Ptr)
  mDC:=DllCall("CreateCompatibleDC", Ptr,hDC, Ptr)
  ;-------------------------
  VarSetCapacity(bi, 40, 0), NumPut(40, bi, 0, "int")
  NumPut(w, bi, 4, "int"), NumPut(-h, bi, 8, "int")
  NumPut(1, bi, 12, "short"), NumPut(bpp, bi, 14, "short")
  ;-------------------------
  if hBM:=DllCall("CreateDIBSection", Ptr,mDC, Ptr,&bi
    , "int",0, PtrP,ppvBits, Ptr,0, "int",0, Ptr)
  {
    oBM:=DllCall("SelectObject", Ptr,mDC, Ptr,hBM, Ptr)
    DllCall("BitBlt", Ptr,mDC, "int",0, "int",0, "int",w, "int",h
      , Ptr,hDC, "int",x, "int",y, "uint",0x00CC0020|0x40000000)
    DllCall("RtlMoveMemory","ptr",Scan0,"ptr",ppvBits,"ptr",Stride*h)
    DllCall("SelectObject", Ptr,mDC, Ptr,oBM)
    DllCall("DeleteObject", Ptr,hBM)
  }
  DllCall("DeleteDC", Ptr,mDC)
  DllCall("ReleaseDC", Ptr,win, Ptr,hDC)
}

base64tobit(s)
{
  ListLines, Off
  Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    . "abcdefghijklmnopqrstuvwxyz"
  SetFormat, IntegerFast, d
  StringCaseSense, On
  Loop, Parse, Chars
  {
    i:=A_Index-1, v:=(i>>5&1) . (i>>4&1)
      . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1)
    s:=StrReplace(s,A_LoopField,v)
  }
  StringCaseSense, Off
  s:=SubStr(s,1,InStr(s,"1",0,0)-1)
  s:=RegExReplace(s,"[^01]+")
  ListLines, On
  return, s
}

bit2base64(s)
{
  ListLines, Off
  s:=RegExReplace(s,"[^01]+")
  s.=SubStr("100000",1,6-Mod(StrLen(s),6))
  s:=RegExReplace(s,".{6}","|$0")
  Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    . "abcdefghijklmnopqrstuvwxyz"
  SetFormat, IntegerFast, d
  Loop, Parse, Chars
  {
    i:=A_Index-1, v:="|" . (i>>5&1) . (i>>4&1)
      . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1)
    s:=StrReplace(s,v,A_LoopField)
  }
  ListLines, On
  return, s
}

ASCII(s)
{
  if RegExMatch(s,"(\d+)\.([\w+/]{3,})",r)
  {
    s:=RegExReplace(base64tobit(r2),".{" r1 "}","$0`n")
    s:=StrReplace(StrReplace(s,"0","_"),"1","0")
  }
  else s=
  return, s
}

MCode(ByRef code, hex)
{
  ListLines, Off
  bch:=A_BatchLines
  SetBatchLines, -1
  VarSetCapacity(code, StrLen(hex)//2)
  Loop, % StrLen(hex)//2
    NumPut("0x" . SubStr(hex,2*A_Index-1,2), code, A_Index-1, "char")
  Ptr:=A_PtrSize ? "UPtr" : "UInt"
  DllCall("VirtualProtect", Ptr,&code, Ptr
    ,VarSetCapacity(code), "uint",0x40, Ptr . "*",0)
  SetBatchLines, %bch%
  ListLines, On
}

; You can put the text library at the beginning of the script,
; and Use Pic(Text,1) to add the text library to Pic()'s Lib,
; Use Pic("comment1|comment2|...") to get text images from Lib
Pic(comments, add_to_Lib=0) {
  static Lib:=[]
  if (add_to_Lib)
  {
    re:="<([^>]*)>[^$]+\$\d+\.[\w+/]{3,}"
    Loop, Parse, comments, |
      if RegExMatch(A_LoopField,re,r)
        Lib[Trim(r1)]:=r
  }
  else
  {
    text:=""
    Loop, Parse, comments, |
      text.="|" . Lib[Trim(A_LoopField)]
    return, text
  }
}

FindTextOCR(nX, nY, nW, nH, err1, err0, Text, Interval=5) {
  OCR:="", Right_X:=nX+nW
  While (ok:=FindText(nX, nY, nW, nH, err1, err0, Text))
  {
    ; For multi text search, This is the number of text images found
    Loop, % ok.MaxIndex()
    {
      ; X is the X coordinates of the upper left corner
      ; and W is the width of the image have been found
      i:=A_Index, x:=ok[i].1, y:=ok[i].2
        , w:=ok[i].3, h:=ok[i].4, comment:=ok[i].5
      ; We need the leftmost X coordinates
      if (A_Index=1 or x<Left_X)
        Left_X:=x, Left_W:=w, Left_OCR:=comment
    }
    ; If the interval exceeds the set value, add "*" to the result
    OCR.=(A_Index>1 and Left_X-Last_X>Interval ? "*":"") . Left_OCR
    ; Update nX and nW for next search
    x:=Left_X+Left_W, nW:=(Right_X-x)//2, nX:=x+nW, Last_X:=x
  }
  Return, OCR
}


/***** C source code of machine code *****

int __attribute__((__stdcall__)) PicFind(int mode
  , unsigned int c, int n, unsigned char * Bmp
  , int Stride, int sx, int sy, int sw, int sh
  , char * ss, int * s1, int * s0
  , int len1, int len0, int err1, int err0
  , int w, int h, int * rx, int * ry)
{
  int x, y, o=sy*Stride+sx*4, j=Stride-4*sw, i=0;
  int r, g, b, rr, gg, bb, e1, e0;
  if (mode==0)  // Color Mode
  {
    rr=(c>>16)&0xFF; gg=(c>>8)&0xFF; bb=c&0xFF;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
      {
        r=Bmp[2+o]-rr; g=Bmp[1+o]-gg; b=Bmp[o]-bb;
        if (r<0) r=-r; if (g<0) g=-g; if (b<0) b=-b;
        if (r+g+b<=n) ss[i]='1';
      }
  }
  else  // Gray Threshold Mode
  {
    c=(c+1)*1000;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
        if (Bmp[2+o]*299+Bmp[1+o]*587+Bmp[o]*114<c)
          ss[i]='1';
  }
  w=sw-w+1; h=sh-h+1;
  j=len1>len0 ? len1 : len0;

  for (x=0; x<w; x++)
  {
    for (y=0; y<h; y++)
    {
      o=y*sw+x; e1=err1; e0=err0;
      for (i=0; i<j; i++)
      {
        if (i<len1 && ss[o+s1[i]]!='1' && (--e1)<0)
          goto NoMatch;
        if (i<len0 && ss[o+s0[i]]!='0' && (--e0)<0)
          goto NoMatch;
      }
      rx[0]=sx+x; ry[0]=sy+y;
      return 1;
      NoMatch:
      continue;
    }
  }
  return 0;
}

*/


;================= The End =================

;
