;███████╗██╗    ██╗       ██████╗ ██████╗ ███╗   ██╗ ██████╗███████╗██████╗ ███████╗
;██╔════╝██║    ██║      ██╔════╝██╔═══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗██╔════╝
;███████╗██║ █╗ ██║█████╗██║     ██║   ██║██╔██╗ ██║██║     █████╗  ██║  ██║█████╗  
;╚════██║██║███╗██║╚════╝██║     ██║   ██║██║╚██╗██║██║     ██╔══╝  ██║  ██║██╔══╝  
;███████║╚███╔███╔╝      ╚██████╗╚██████╔╝██║ ╚████║╚██████╗███████╗██████╔╝███████╗
;╚══════╝ ╚══╝╚══╝        ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═════╝ ╚══════╝
                                                                                   
#Include %A_ScriptDir%\libs\RandomBezier.ahk

CoordMode, Mouse, Client
CoordMode, Pixel, Client

while 1
{
	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/multi.png
	if (ErrorLevel == 0) {
		Click(foundX, foundY)
		Sleep(2000)
		Click(961, 532) ;click ranked
		Sleep(2000)
		Click(296, 368) ;click deck1
		Sleep(2000)
		Click(960, 782) ;click confirm deck
		Sleep(2000)
	}

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/ok.png
	if (ErrorLevel == 0) {
		Click(foundX, foundY)
	}

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/menu.png
	if (ErrorLevel == 0) {
		Click(foundX, foundY)
	}

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/quit.png
	if (ErrorLevel == 0) {
		Click(foundX, foundY)
	}

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/retry.png
	if (ErrorLevel == 0) {
		Click(foundX, foundY)
	}	

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/quit2.png
	if (ErrorLevel == 0) {
		Click(foundX, foundY)
	}

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/again.png
	if (ErrorLevel == 0) {
		Click(foundX, foundY)
		Sleep(2000)
		Click(296, 368) ;click deck1
		Sleep(2000)
		Click(960, 782) ;click confirm deck
		Sleep(2000)
	}

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/rank_lost.png
	if (ErrorLevel == 0) {
		Click(foundX, foundY)
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
	time := dist * 1.3 + 75
	RandomBezier(x1, y1, x2+randX, y2+randY, "T" time " P3-6")
}

;====== CLOSE SCRIPT ======
F12::
	ExitApp
return