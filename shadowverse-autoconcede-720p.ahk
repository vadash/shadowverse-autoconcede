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

; Grab this with utils\FindText.ahk -> Capture -> Gray2Two -> Auto -> Edit it with L R U D buttons -> Ok -> Copy string from Text:=
bMulti := "|<>*114$61.Uy7US73s00EC3sT3Vw03A71wDlszwTq3Uy7wwTyDv8YT3ySDz7xAG7VzD7zXya1XkzbXzlzHVlsTnlzszdkswDtszwToswS7wwTyDuSSDXySDz7xDT7lzD7zXybzXszDXzlz7zlwTblzszVzsT7XszwTkTw7k3w0S7sTy7w3y0T3x"
bSolo := "|<>*115$52.k7s1w7z0CAD33kzsMFtsSDXz3l7zXwSDwTUDwDlszVy8Tkz3Xy7sUz7wCDszX1wTkszXyC3lzXXyDww77wCDszXwATkszXyDskz3Xy7szXXwSDwTUyCDlszly3swSDXzXl07k1y0C0C0zkDs1y1s"
bOK := "|<>*142$48.zk1zz0zyz00Ty0zsy00Dy0zkw3s7z0zUsDw3zUzVsDy3zUz3kTz1zUy7kTz0zUwDUTz0zUsTUTz0zUkzUzz0zUUzUzzUzU0z0zzUTU0z0zzUTU0T0zzUTU0D0zzUTUM70zzUTUs70zzUzUw3UzzUzUw3Uzz0zUy1UTz0zUz0UTz0zUz0UTz1zUzUU"
bEndTurn := "|<>*144$52.zzzzzzzw3zzzzzzzsE01zzzzzl00Dzzzzz63wzzzzzwQTzzzzzzllzzX1zy777zw01zU0QTzkC7w61lzzVwDkw73zy7sy7sQ0DsTXsTVk1zVyDXz77zy7swDwQTzsTXkzllzzVyD3z77zy7swDwQTzsTXszllzzVyDXz77zy7sy7sQDzsTXsTVkzzVyDkw700S3sTUUM"
bAgain := "|<>*138$53.sCz0Tky4701w0TVw04C3zsT3sC0y7zsz7sy1yDzsyDlw7wTklwTXsDsy03sz7kTlsQ7lyDUzXlwDXwT1z7XwT7sy3yC7syDlw3wQDlwTXs7swTXsz7k7lsS7lyDU63ksDXwT407k0C3sSC2Dk8Q7UwE"
bRetry := "|<>*150$60.01zzzszzzz0UzzztzzzzVsTzztzzzzlwTzztzzzzlwTkDU48EylwTU30A0UylwT7Vty3szlsSDltyDwzlsyDltyDwTlVyDXtyDwTk3yD3lyDySk3yA7lyDyClly0TlyDyAlky3zlyDzAlsyDzlyDz0lsS7zlyDz1lwT3zlyDzVlwDVzsy7zXUS3U0s63zXUy7s3wA7znzzzzzzzzzbU"
bRankLost := "|<>*101$46.zU01zz03U000000Q0000001U000000C0000000k000000D0zk000Dzzzs0Dzzzzzk0zzzzzz03zzzzzw0Tzzzzzk1zzzzzz07zzzzzw0Tzzzzzk1zzzzzz07zzzzzw0Tzzzzzk1zzzzzz07zzzzzw0Tzzs"

GAME_WIDTH := 1296
GAME_HEIGHT := 759

while True
{
	global X, Y, W, H
	WinGetPos, X, Y, W, H, Shadowverse	; Store window size/location
	If (W != GAME_WIDTH || H != GAME_HEIGHT) {
		ToolTip, "Resized game window to 720p"
		WinMove, Shadowverse,, 0, 0, GAME_WIDTH, GAME_HEIGHT	; Stretch to Screen-size
	}

	if FindTextNoClick(bMulti) || FindTextNoClick(bSolo) {
		ToolTip, "Creating ranked game"
		WinActivate, Shadowverse
		Click(466, 671) ;multi
		Sleep(3000)
		WinActivate, Shadowverse
		Click(634, 342) ;ranked
		Sleep(3000)
		WinActivate, Shadowverse
		Click(267, 229) ;deck1
		Sleep(3000)
		WinActivate, Shadowverse
		Click(792, 515) ;ok
	}

	WinActivate, Shadowverse
	FindTextClick(bOK)

	if FindTextNoClick(bEndTurn) {
		ToolTip, "Conceding"
		WinActivate, Shadowverse
		Click(46, 48) ;menu
		Sleep(3000)
		WinActivate, Shadowverse
		Click(648, 184) ;quit1
		Sleep(3000)
		WinActivate, Shadowverse
		Click(651, 523) ;quit2
	}

	WinActivate, Shadowverse
	if FindTextClick(bAgain) {
		ToolTip, "Creating another game"
		Sleep(3000)
		WinActivate, Shadowverse
		Click(267, 229) ;deck1
		Sleep(3000)
		WinActivate, Shadowverse
		Click(792, 515) ;ok
	}

	WinActivate, Shadowverse
	FindTextClick(bRetry)

	WinActivate, Shadowverse
	FindTextClick(bRankLost)

	Sleep(100)
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