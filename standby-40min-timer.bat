echo.
echo Waiting For some time... 
TIMEOUT /T 2500 /NOBREAK
echo.
%windir%\System32\rundll32.exe powrprof.dll,SetSuspendState 0,1,0
echo.
pause >nul
