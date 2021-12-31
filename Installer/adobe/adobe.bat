set defdir=%~dp0
start %USERPROFILE%\Downloads\installerfiles\adobe.exe
timeout 40 > NUL
start /wait %defdir%adobeaut.exe
exit