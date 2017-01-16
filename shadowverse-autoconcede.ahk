;███████╗██╗    ██╗       ██████╗ ██████╗ ███╗   ██╗ ██████╗███████╗██████╗ ███████╗
;██╔════╝██║    ██║      ██╔════╝██╔═══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗██╔════╝
;███████╗██║ █╗ ██║█████╗██║     ██║   ██║██╔██╗ ██║██║     █████╗  ██║  ██║█████╗  
;╚════██║██║███╗██║╚════╝██║     ██║   ██║██║╚██╗██║██║     ██╔══╝  ██║  ██║██╔══╝  
;███████║╚███╔███╔╝      ╚██████╗╚██████╔╝██║ ╚████║╚██████╗███████╗██████╔╝███████╗
;╚══════╝ ╚══╝╚══╝        ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═════╝ ╚══════╝
                                                                                   

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

Click(x, y)
{
	Random, randX, 0, 20
	Random, randY, 0, 10
	mouseClick, left, x + randX, y + randY
}

Sleep(x)
{
	Random, randX, 0, 100
	sleep, x + randX
}