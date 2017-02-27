;███████╗██╗    ██╗       ██████╗ ██████╗ ███╗   ██╗ ██████╗███████╗██████╗ ███████╗
;██╔════╝██║    ██║      ██╔════╝██╔═══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗██╔════╝
;███████╗██║ █╗ ██║█████╗██║     ██║   ██║██╔██╗ ██║██║     █████╗  ██║  ██║█████╗  
;╚════██║██║███╗██║╚════╝██║     ██║   ██║██║╚██╗██║██║     ██╔══╝  ██║  ██║██╔══╝  
;███████║╚███╔███╔╝      ╚██████╗╚██████╔╝██║ ╚████║╚██████╗███████╗██████╔╝███████╗
;╚══════╝ ╚══╝╚══╝        ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═════╝ ╚══════╝
                                                                                   
#Include %A_ScriptDir%\libs\RandomBezier.ahk
#Include %A_ScriptDir%\libs\FindText.ahk
#Include %A_ScriptDir%\libs\Resources.ahk

CoordMode, Mouse

while 1
{
	WinActivate, Shadowverse

	if FindText(717,1002,bMulti,"*121",100,50,X,Y,0.1,0.1) {
		Click(X, Y)
		Sleep(3000)
		Click(961, 532) ;click ranked
		Sleep(3000)
		Click(296, 368) ;click deck1
		Sleep(3000)
		Click(1200, 775) ;click ok
		Sleep(3000)
	}

	if FindText(1739,532,bOk,"*155",100,50,X,Y,0.1,0.1) {
		Click(X, Y)
	}

	if FindText(69,66,bMenu,"*96",100,50,X,Y,0.1,0.1) {
		Click(X, Y)
	}

	if FindText(959,277,bQuit,"*142",9999,9999,X,Y,0.1,0.1) {
		Click(X, Y)
	}

	if FindText(1174,955,bRetry,"*161",100,50,X,Y,0.1,0.1) {
		Click(X, Y)
	}

	if FindText(1004,979,bBattleAgain,"*150",100,50,X,Y,0.1,0.1) {
		Click(X, Y)
		Sleep(3000)
		Click(296, 368) ;click deck1
		Sleep(3000)
		Click(1200, 775) ;click ok
		Sleep(3000)
	}

	imageSearch, X, Y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/rank_lost.png
	if (ErrorLevel == 0) {
		Click(X, Y)
	}	

	Sleep(250)
}

return

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
F12::
	ExitApp
return