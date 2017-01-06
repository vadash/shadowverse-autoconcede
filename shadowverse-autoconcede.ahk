CoordMode, Mouse, Client
CoordMode, Pixel, Client

while 1
{
	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/multi.png
	if (ErrorLevel == 0) {
		click, %foundX%, %foundY%
		sleep 2000
		mouseClick, left, 961, 532 ;click ranked
		sleep 2000
		mouseClick, left, 296, 368 ;click deck1
		sleep 2000
		mouseClick, left, 960, 782 ;click confirm deck
		sleep 2000
	}

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/ok.png
	if (ErrorLevel == 0) {
		click, %foundX%, %foundY%
	}

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/menu.png
	if (ErrorLevel == 0) {
		click, %foundX%, %foundY%
	}

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/quit.png
	if (ErrorLevel == 0) {
		click, %foundX%, %foundY%
	}

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/retry.png
	if (ErrorLevel == 0) {
		click, %foundX%, %foundY%
	}	

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/quit2.png
	if (ErrorLevel == 0) {
		click, %foundX%, %foundY%
	}

	imageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *64 img/again.png
	if (ErrorLevel == 0) {
		click, %foundX%, %foundY%
		sleep 2000
		mouseClick, left, 296, 368 ;click deck1
		sleep 2000
		mouseClick, left, 960, 782 ;click confirm deck
		sleep 2000
	}

	sleep, 1000
}

return