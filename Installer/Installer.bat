@echo off
set defdir=%~dp0
mkdir %USERPROFILE%\Downloads\installerfiles
mkdir %USERPROFILE%\Downloads\installerfiles\Data
mkdir %USERPROFILE%\Downloads\installerfiles\Data\Inf
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
echo ================================================================================================= >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
echo %date% %time% : Program Started >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
echo %date% %time% : Privileges changed to administrator  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
:collectdatauser
if exist %USERPROFILE%\Downloads\installerfiles\Data\Inf\RunOnce.txt goto setupvars
mkdir %USERPROFILE%\Downloads\installerfiles\Data
mkdir %USERPROFILE%\Downloads\installerfiles\Data\Inf
set /p name="Ird be a felhasznalo teljes nevet (vagy ceg nevet) EGYBE!: "
echo Telepitesi datum: %DATE% > %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
echo %name% gepe: >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
echo -------Windows verzio:%Version%------- >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
echo Processzor: >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
wmic cpu get caption, name, status >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
echo ------------------------------------------------- >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
echo Alaplap: >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
wmic baseboard get product,Manufacturer >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
echo ------------------------------------------------- >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
echo Memoria: >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
wmic memorychip get devicelocator, partnumber >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
wmic memorychip get devicelocator, capacity >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
echo ------------------------------------------------- >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
echo Egyeb Adatok:>> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
systeminfo >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
echo ------------------------------------------------- >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv
echo Collect.Data(%name%) Runned! > %USERPROFILE%\Downloads\installerfiles\Data\Inf\RunOnce.txt
echo %date% %time% : System Information Collected! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
echo Data collect was success!
copy %USERPROFILE%\Downloads\installerfiles\Data\Inf\%name%.csv %defdir%\AdatokGepekrol\%name%.csv
echo Copy was success!

:setupvars

set inserr=No installation errors found!
set nin=1-Install Firefox, Google Chrome, Winrar [x]
set tcmdstat=2-Install Total Commander [x]
set adobestat=3-Install Adobe Acrobat Reader DC [x]
set javastat=4-Install Java [x]
set abvstat=5-Install Abevjava [x]
set anydstat=6-Install AnyDesk [x]

wmic os get caption > %USERPROFILE%\Downloads\installerfiles\Data\Inf\OsType.txt

powershell -Command "Get-PnpDevice -Status 'ERROR' | Select-Object -Property InstanceID | Out-file %USERPROFILE%\Downloads\installerfiles\driver.txt
Set _File=%USERPROFILE%\Downloads\installerfiles\driver.txt
Set /a _Lines=0
For /f %%j in ('Find "" /v /c ^< %_File%') Do Set /a _Lines=%%j-4
find "InstanceId" %USERPROFILE%\Downloads\installerfiles\driver.txt
if %ERRORLEVEL% == 1 set status=No driver problems found!
if %ERRORLEVEL% == 0 set status=Found %_Lines% driver problem! Check driver.txt
echo %date% %time% : %status% >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
if %ERRORLEVEL% == 1 set status=                        No driver problems found!
if %ERRORLEVEL% == 0 set status=             Found %_Lines% driver problem! Check driver.txt
if %ERRORLEVEL% == 0 set statuscolor=0

Set "WinVerAct="
echo %date% %time% : Checking activation >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
For /f "tokens=*" %%W in ('
    cscript /Nologo "C:\Windows\System32\slmgr.vbs" /xpr
') Do Set "WinVerAct= ActivationStatus: %%W"
if Not defined WinVerAct ( 
    Echo:No response from slmgr.vbs
    Exit /B 1
    echo %date% %time% : Error while checking activation >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
)
echo %date% %time% : Activation Status: %WinVerAct:~1% >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log

echo %date% %time% : Checking build version >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
Set "RegRoot=HKLM"
Set "RegKey=\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
Set "RegVal=DisplayVersion"
Set "Version="
For /F %%A In (
    'PowerShell -NoP -NoL "(GP '%RegRoot%:%RegKey%').%RegVal%" 2^>Nul'
) Do Set "Version=%%A" 
If Not Defined Version Exit /B
echo %date% %time% : Build number: %Version%  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
if %Version%==20H2 set Version=20H2 Newer build available use 11 option!

echo %date% %time% : Checking Windows Type  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
find "Home" %USERPROFILE%\Downloads\installerfiles\Data\Inf\OsType.txt
if %ERRORLEVEL% == 0 set ProductType= Windows 10 Home
find "Pro" %USERPROFILE%\Downloads\installerfiles\Data\Inf\OsType.txt
if %ERRORLEVEL% == 0 set ProductType= Windows 10 Pro
echo %date% %time% : Windows Type: %ProductType%  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log

:uac
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" | find  "0x0" >NUL
if "%ERRORLEVEL%"=="0"  set uac= UAC disabled ready for automatic install...
if "%ERRORLEVEL%"=="1"  set uac= UAC enabled
echo %date% %time% : UAC status: %uac%  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log

echo %date% %time% : Checking Installed Programs Status  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
:statcheck
if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" set nin=1-Installed Firefox, Google Chrome, Winrar! [/]
if exist "C:\totalcmd\TOTALCMD64.EXE" set tcmdstat=2-Installed Total Commander! [/]
find "Adobe Acrobat Reader DC Installed!" %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
if %errorlevel% == 0 set adobestat=3-Install Adobe Acrobat Reader DC [/]
find "Java Oracle Installed!" %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
if %errorlevel% == 0 set javastat=4-Install Java [/]
find "AnyDesk Installed!" %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
if %errorlevel% == 0 set anydstat=6-Install AnyDesk [/]
find "Abevjava Installed!" %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
if %errorlevel% == 0 set abvstat=5-Install Abevjava [/]

:menu
echo %date% %time% : In menu waiting for answer  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
cls
echo   ______                   __             ___    ___                   
echo  /\__  _\                 /\ \__         /\_ \  /\_ \                  
echo  \/_/\ \/     ___     ____\ \ ,_\    __  \//\ \ \//\ \      __   _ __  
echo     \ \ \   /' _ `\  /',__\\ \ \/  /'__`\  \ \ \  \ \ \   /'__`\/\`'__\
echo      \_\ \__/\ \/\ \/\__, `\\ \ \_/\ \L\.\_ \_\ \_ \_\ \_/\  __/\ \ \/ 
echo      /\_____\ \_\ \_\/\____/ \ \__\ \__/.\_\/\____\/\____\ \____\\ \_\ 
echo      \/_____/\/_/\/_/\/___/   \/__/\/__/\/_/\/____/\/____/\/____/ \/_/ 
echo ==============================================================================
echo 1-Install menu
echo.
echo 2-Check Windows Activation                       3-Check for Updates
echo.                                                                      
echo 4-Install Eset Antivirus                         5-Recheck Drivers
echo.
echo 6-Update to the latest build                     7-Reset Windows Update
echo.
echo 8-Free up space                                  9-Exit
echo.
echo                       Windows Product Type:%ProductType%
echo        %status%
Echo:               %WinVerAct:~1%    
echo         Windows build number: %Version% 
echo ==============================================================================
title Waiting for answer...

@set /p userinp=Choose an option: 
@set userinp=%userinp:~0,2%
@if "%userinp%"=="1" goto installmenu
@if "%userinp%"=="2" goto activation
@if "%userinp%"=="3" goto update
@if "%userinp%"=="4" goto esetinstall
@if "%userinp%"=="5" goto drivercheck
@if "%userinp%"=="6" goto updateassist
@if "%userinp%"=="7" goto wuauserv
@if "%userinp%"=="8" goto lowspacetoolsmenu
@if "%userinp%"=="9" goto exit
@if "%userinp%"=="99" goto help
if not "%userinp%"=="1" goto incorrect
if not "%userinp%"=="2" goto incorrect
if not "%userinp%"=="3" goto incorrect
if not "%userinp%"=="4" goto incorrect
if not "%userinp%"=="5" goto incorrect
if not "%userinp%"=="6" goto incorrect
if not "%userinp%"=="7" goto incorrect
if not "%userinp%"=="8" goto incorrect
if not "%userinp%"=="9" goto incorrect
if not "%userinp%"=="99" goto incorrect

:incorrect
title Waiting for answer...

@set /p userinp=Incorrect option! Please choose a correct option: 
@set userinp=%userinp:~0,2%
@if "%userinp%"=="1" goto installmenu
@if "%userinp%"=="2" goto activation
@if "%userinp%"=="3" goto update
@if "%userinp%"=="4" goto eset
@if "%userinp%"=="5" goto drivercheck
@if "%userinp%"=="6" goto updateassist
@if "%userinp%"=="7" goto wuauserv
@if "%userinp%"=="8" goto lowspacetoolsmenu
@if "%userinp%"=="9" goto exit
@if "%userinp%"=="99" goto help
if not "%userinp%"=="1" goto incorrect
if not "%userinp%"=="2" goto incorrect
if not "%userinp%"=="3" goto incorrect
if not "%userinp%"=="4" goto incorrect
if not "%userinp%"=="5" goto incorrect
if not "%userinp%"=="6" goto incorrect
if not "%userinp%"=="7" goto incorrect
if not "%userinp%"=="8" goto incorrect
if not "%userinp%"=="9" goto incorrect
if not "%userinp%"=="99" goto incorrect

:installmenu
cls
echo           Installation Status:
echo %nin%     %tcmdstat%
echo.                                                                       
echo %adobestat%            %javastat%           
echo.                                                                       
echo %abvstat%                           %anydstat%         
echo.

start /min /wait %defdir%gui.bat
if %uac% == "UAC enabled" goto menu
cls
color 4
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                          !!!!ENABLE UAC!!!!
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.

pause
color 7
goto menu

:esetinstall
cls
echo.
echo 1-ESET Smart Security Premium
echo 2-ESET Internet Security
echo 3-ESET NOD32 Antivirus                                                                                               
echo.
choice /c 123 /m "Choose an option: "
if "%ERRORLEVEL%" == "1" goto smart
if "%ERRORLEVEL%" == "2" goto internet
if "%ERRORLEVEL%" == "3" goto nod                                                                                           
goto menu

:smart
powershell -Command "Invoke-WebRequest https://download.eset.com/com/eset/tools/installers/live_essp/latest/eset_smart_security_premium_live_installer.exe -Outfile %USERPROFILE%\Downloads\installerfiles\ESET_Smart_Security_Premium.exe"
start /wait %USERPROFILE%\Downloads\installerfiles\ESET_Smart_Security_Premium.exe
echo %date% %time% : ESET Smart Security Premium Installed! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
goto menu

:internet
powershell -Command "Invoke-WebRequest https://download.eset.com/com/eset/tools/installers/live_eis/latest/eset_internet_security_live_installer.exe -Outfile %USERPROFILE%\Downloads\installerfiles\ESET_Internet_Security.exe"
start /wait %USERPROFILE%\Downloads\installerfiles\ESET_Internet_Security.exe 
echo %date% %time% : ESET Internet Security Installed! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
goto menu

:nod
powershell -Command "Invoke-WebRequest https://download.eset.com/com/eset/tools/installers/live_eav/latest/eset_nod32_antivirus_live_installer.exe -Outfile %USERPROFILE%\Downloads\installerfiles\ESET_NOD32_Antivirus.exe"
start /wait %USERPROFILE%\Downloads\installerfiles\ESET_NOD32_Antivirus.exe
echo %date% %time% : ESET NOD32 Antivirus Installed! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log 
goto menu

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


:tcmd
setlocal
echo %date% %time% : Installing Total Commander >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Downloading...
powershell -Command "Invoke-WebRequest https://totalcommander.ch/win/fixed/tcmd951x64.exe -Outfile %USERPROFILE%\Downloads\installerfiles\tcmd.exe"
title Downloading...
start /wait %USERPROFILE%\Downloads\installerfiles\tcmd.exe
title Installing...
echo %date% %time% : Total Commander Installed! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Logging...
endlocal


:adobe
setlocal
echo %date% %time% : Installing Adobe Acrobat Reader DC  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Downloading...
powershell -Command "Invoke-WebRequest https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/1900820071/AcroRdrDC1900820071_hu_HU.exe -Outfile %USERPROFILE%\Downloads\installerfiles\adobe.exe"
title Downloading...
start /wait %USERPROFILE%\Downloads\installerfiles\adobe.exe
title Installing...
echo %date% %time% : Adobe Acrobat Reader DC Installed! >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Logging...
endlocal


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


:updateassist
title Downloading...
powershell -Command "Invoke-WebRequest https://go.microsoft.com/fwlink/?LinkID=799445 -Outfile %USERPROFILE%\Downloads\installerfiles\update_assistant.exe"
title Downloading...
start /wait %USERPROFILE%\Downloads\installerfiles\update_assistant.exe
title Installing...
echo %date% %time% : Update Assistant Installed! Updating to the newest build...  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
title Logging...
goto statcheck
:rem
rmdir /S "%USERPROFILE%\Downloads\installerfiles"
goto menu
:activation
echo %date% %time% : Windows Activation Opened  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
start ms-settings:activation
goto menu
:update
echo %date% %time% : Windows Update Opened  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
start ms-settings:windowsupdate -action
goto menu
:drivercheck
powershell -Command "Get-PnpDevice -Status 'ERROR' | Select-Object -Property InstanceID | Out-file %USERPROFILE%\Downloads\installerfiles\driver.txt 
find "InstanceId" %USERPROFILE%\Downloads\installerfiles\driver.txt
if %ERRORLEVEL% == 1 set status=                        No driver problems found!
if %ERRORLEVEL% == 0 set status=             Found %_Lines% driver problem! Check driver.txt
goto menu
:wuauserv
choice /M "Do you want to delete windows update cache?"
if "%ERRORLEVEL%" == "1" goto updatecache
if "%ERRORLEVEL%" == "0" goto updatecache2
:updatecache
echo %date% %time% : Clearing Windows Update Cache >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
net stop wuauserv
net stop bits
net stop cryptsvc
rd /s /q %systemroot%\SoftwareDistribution
net start wuauserv
net start bits
net start cryptsvc
goto menu
:updatecache2
net stop wuauserv
net stop bits
net stop cryptsvc
net start wuauserv
net start bits
net start cryptsvc
echo %date% %time% : Windows Update Cache Cleared >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
goto menu
:winver
start /wait winver
goto menu
:lowspacetoolsmenu
cls
echo=============================
echo 1-Disksavvy(analyze storage)
echo 2-Revo Uninstaller
echo 3-Windows Storage Analyzer
echo 4-Go back to menu
echo=====================================================
fsutil volume diskfree c:
echo=====================================================
choice /c 1234 /m "Choose an option: "
if "%ERRORLEVEL%" == "1" GOTO Disksavvy
if "%ERRORLEVEL%" == "2" GOTO Revo
if "%ERRORLEVEL%" == "3" GOTO ms-storage
if "%ERRORLEVEL%" == "4" GOTO menu
 :Disksavvy
 title Downloading...
 powershell -Command "Invoke-WebRequest https://www.disksavvy.com/setups_x64/disksavvyult_setup_v13.7.14_x64.exe -Outfile %USERPROFILE%\Downloads\installerfiles\disksavvyult_setup_v13.exe"
 title Downloading...
 start /wait %USERPROFILE%\Downloads\installerfiles\disksavvyult_setup_v13.exe
 title Installing...
 goto lowspacetoolsmenu
 :Revo
 title Downloading...
 powershell -Command "Invoke-WebRequest https://84f32165f90955f0a9bf-5163f17629513b10d2c490ba0ea9c669.ssl.cf1.rackcdn.com/revosetup.exe -Outfile %USERPROFILE%\Downloads\installerfiles\revouninstaller.exe"
 title Downloading...
 start /wait %USERPROFILE%\Downloads\installerfiles\revouninstaller.exe
 title Installing...
 goto lowspacetoolsmenu
 :ms-storage
 start /wait Cleanmgr.exe
 goto lowspacetoolsmenu

:help
cls
echo=============================
echo __  __     _         __     
echo/\ \/\ \  /' \      /'__`\   
echo\ \ \ \ \/\_, \    /\_\L\ \  
echo \ \ \ \ \/_/\ \   \/_/_\_<_ 
echo  \ \ \_/ \ \ \ \  __/\ \L\ \
echo   \ `\___/  \ \_\/\_\ \____/
echo    `\/__/    \/_/\/_/\/___/ 
echo=============================
echo This is a batch file made by: Tamas Solymosi

echo Not responsible for any damage!
choice /c:1 /m "To go to menu press"
if "%ERRORLEVEL%" == "1" goto menu
:exit
echo %date% %time% : Program Closed  >> %USERPROFILE%\Downloads\installerfiles\Data\Inf\InstallLog.log
