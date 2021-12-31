set defdir=%~dp0
start %USERPROFILE%\Downloads\installerfiles\tcmd.exe
TIMEOUT 1 >nul
start /wait %defdir%tcmdaut.exe
exit
