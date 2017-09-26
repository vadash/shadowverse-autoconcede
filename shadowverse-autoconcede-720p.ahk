;███████╗██╗    ██╗       ██████╗ ██████╗ ███╗   ██╗ ██████╗███████╗██████╗ ███████╗
;██╔════╝██║    ██║      ██╔════╝██╔═══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗██╔════╝
;███████╗██║ █╗ ██║█████╗██║     ██║   ██║██╔██╗ ██║██║     █████╗  ██║  ██║█████╗  
;╚════██║██║███╗██║╚════╝██║     ██║   ██║██║╚██╗██║██║     ██╔══╝  ██║  ██║██╔══╝  
;███████║╚███╔███╔╝      ╚██████╗╚██████╔╝██║ ╚████║╚██████╗███████╗██████╔╝███████╗
;╚══════╝ ╚══╝╚══╝        ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═════╝ ╚══════╝
; MAKE SURE GAME IN 1280 x 720 MODE WINDOWED
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Client
CoordMode, Pixel, Client
#WinActivateForce
#SingleInstance force                                                                                   
#Include %A_ScriptDir%\libs\RandomBezier.ahk
#Include %A_ScriptDir%\libs\FindText.ahk
#Include %A_ScriptDir%\libs\Resources.ahk

while True
{
	WinActivate, Shadowverse

	if FindTextClick(bMulti1) || FindTextClick(bMulti2) {
		Sleep(3000)
		Click(634, 342) ;ranked
		Sleep(3000)
		Click(267, 229) ;deck1
		Sleep(3000)
		Click(792, 515) ;ok
	}

	FindTextClick(bOK)

	if FindTextNoClick(bEndTurn) {
		Click(46, 48) ;menu
		Sleep(3000)
		Click(648, 184) ;quit1
		Sleep(3000)
		Click(651, 523) ;quit2
	}

	if FindTextClick(bAgain) {
		Sleep(3000)
		Click(267, 229) ;deck1
		Sleep(3000)
		Click(792, 515) ;ok
	}

	FindTextClick(bRetry)

	Sleep(250)
}

return

FindTextClick(needle) {
	if ok:=FindText(0,0,9000,9000,0.1,0.1,needle)
	{
		X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5
		CoordMode, Mouse
		Click(X+W//2, Y+H//2)
		CoordMode, Mouse, Client
		Return True
	}
	Return False
}

FindTextNoClick(needle) {
	Return FindText(0,0,9000,9000,0.1,0.1,needle)
}

Click(x, y) {
	MouseMove(x, y)
	sendinput {LButton down}
	Sleep(100)
	sendinput {LButton up}
	Sleep(100)
}

Sleep(x) {
	Random, randX, 0, x/5
	sleep, x + randX
}

MouseMove(x2, y2) {
	Random, randX, 0, 10
	Random, randY, 0, 10
	MouseGetPos, x1, y1
	dist := sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2))
	time := dist * 1
	RandomBezier(x1, y1, x2+randX, y2+randY, "T" time " P2-4")
}

;====== CLOSE SCRIPT ======
F10::
	ExitApp
return