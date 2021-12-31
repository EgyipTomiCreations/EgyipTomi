set defdir=%~dp0
:1
find "Firefox" %USERPROFILE%\Downloads\installerfiles\Data\Inf\CHOICES.txt
if %ERRORLEVEL% == 0 call :ninite
:2
find "AnyDesk" %USERPROFILE%\Downloads\installerfiles\Data\Inf\CHOICES.txt
if %ERRORLEVEL% == 0 call :anydesk
:3
find "Total Commander" %USERPROFILE%\Downloads\installerfiles\Data\Inf\CHOICES.txt
if %ERRORLEVEL% == 0 call :tcmd
:4
find "Adobe" %USERPROFILE%\Downloads\installerfiles\Data\Inf\CHOICES.txt
if %ERRORLEVEL% == 0 call :adobe
:5
find "Java" %USERPROFILE%\Downloads\installerfiles\Data\Inf\CHOICES.txt
if %ERRORLEVEL% == 0 call :java
:6
exit

:ninite
setlocal
echo %date% %time% : Installing Firefox, Google Chrome, Winrar  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Downloading...
powershell -Command "Invoke-WebRequest https://ninite.com/chrome-firefox-winrar/ninite.exe -Outfile %USERPROFILE%\Downloads\installerfiles\ninite.exe"
title Downloading...
start /wait %USERPROFILE%\Downloads\installerfiles\ninite.exe
title Installing...
echo %date% %time% : Firefox, Google Chrome, Winrar Installed! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Logging...
endlocal
goto 2

:tcmd
setlocal
echo %date% %time% : Installing Total Commander >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Downloading...
powershell -Command "Invoke-WebRequest https://totalcommander.ch/win/fixed/tcmd951x64.exe -Outfile %USERPROFILE%\Downloads\installerfiles\tcmd.exe"
title Downloading...
start /wait %defdir%\tcmd\tcmd.bat
title Installing...
echo %date% %time% : Total Commander Installed! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Logging...
endlocal
goto 4

:adobe
setlocal
echo %date% %time% : Installing Adobe Acrobat Reader DC  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Downloading...
powershell -Command "Invoke-WebRequest https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/1900820071/AcroRdrDC1900820071_hu_HU.exe -Outfile %USERPROFILE%\Downloads\installerfiles\adobe.exe"
title Downloading...
start /wait %defdir%adobe\adobe.bat
title Installing...
echo %date% %time% : Adobe Acrobat Reader DC Installed! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Logging...
endlocal
goto 5

:java
setlocal
echo %date% %time% : Installing Java Oracle  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Downloading...
powershell -Command "Invoke-WebRequest https://javadl.oracle.com/webapps/download/AutoDL?BundleId=244584_d7fc238d0cbf4b0dac67be84580cfb4b -Outfile %USERPROFILE%\Downloads\installerfiles\java.exe"
title Downloading...
start /wait %USERPROFILE%\Downloads\installerfiles\java.exe
title Installing...
echo %date% %time% : Java Oracle Installed! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Logging...
echo %date% %time% : Installing Abevjava >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Downloading...
powershell -Command "Invoke-WebRequest https://nav.gov.hu/data/cms532517/abevjava_install_oracle_jre.exe -Outfile %USERPROFILE%\Downloads\installerfiles\anyk.exe"
title Downloading...
start /wait %USERPROFILE%\Downloads\installerfiles\anyk.exe
title Installing...
echo %date% %time% : Abevjava Installed! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Logging...
endlocal
goto 6

:anydesk
setlocal
echo %date% %time% : Installing AnyDesk >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Downloading...
powershell -Command "Invoke-WebRequest https://download.anydesk.com/AnyDesk.exe -Outfile %USERPROFILE%\Downloads\installerfiles\anydesk.exe"
title Downloading...
start /wait %USERPROFILE%\Downloads\installerfiles\anydesk.exe
title Installing...
echo %date% %time% : AnyDesk Installed! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Logging...
endlocal
goto 3