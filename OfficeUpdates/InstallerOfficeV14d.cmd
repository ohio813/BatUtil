@echo off
title Installer for Microsoft Office Updates Script V14d by Burf
if not exist "%windir%\system32\reg.exe" goto :systemerror
if not exist "%windir%\system32\find.exe" goto :systemerror
if not exist "%windir%\system32\findstr.exe" goto :systemerror

if exist "%temp%\*.burf" (del "%temp%\*.burf")
cd /d "%~dp0"
"%windir%\system32\reg.exe" query "HKU\S-1-5-19" >nul 2>&1 && (
goto :admincheckok
) || (
echo      -------
echo  *** WARNING ***
echo      -------
echo.
echo.
echo ADMINISTRATOR PRIVILEGES NOT DETECTED!
echo ______________________________________
echo.
echo.
echo This script must be run with administrator privileges!
echo.
echo To do so, right click on this script and select 'Run As Administrator'
echo.
echo.
echo Press any key to exit...
pause >nul
goto :eof
)

:admincheckok
set loc=.
set prodver2010=0
set prodver2013=0
set prodver2016=0
set sp2010=2
set sp2013=1
set z=0

set arch=x86
"%windir%\system32\reg.exe" query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE | find /i "amd64" 1>nul && set arch=x64

:office2010check
if exist "%ProgramFiles%\Microsoft Office\Office14\OSPP.VBS" (
if %arch% equ x64 (set office2010=x64&set /a z+=1&set office2010b=64-bit {x64}) else (set office2010=x86&set /a z+=1&set office2010b=32-bit {x86})
goto :office2013check
)
if %arch% equ x64 (if exist "%ProgramFiles(x86)%\Microsoft Office\Office14\OSPP.VBS" (set office2010=x86&set /a z+=1&set office2010b=32-bit {x86}&goto :office2013check))

"%windir%\system32\reg.exe" query "hklm\SOFTWARE\Microsoft\Office\14.0\Common\InstallRoot" /v Path 1>"%temp%\offpath.burf" 2>nul&& goto :office2010arch
if %arch% equ x64 ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Wow6432Node\Microsoft\Office\14.0\Common\InstallRoot" /v Path 1>"%temp%\offpath.burf" 2>nul&& goto :office2010arch)
if errorlevel 1 goto :office2013check

:office2010arch
for /f "skip=2 tokens=2*" %%a in ('type "%temp%\offpath.burf"') do (set "offpath=%%b")
if exist "%offpath%\addins\otkloadr_x64.dll" (set office2010=x64&set /a z+=1&set office2010b=64-bit {x64}) else (if exist "%offpath%\addins\otkloadr.dll" (set office2010=x86&set /a z+=1&set office2010b=32-bit {x86}))

:office2013check
if exist "%ProgramFiles%\Microsoft Office\Office15\OSPP.VBS" (
if %arch% equ x64 (set office2013=x64&set /a z+=1&set office2013b=64-bit {x64}) else (set office2013=x86&set /a z+=1&set office2013b=32-bit {x86})
goto :office2016check
)
if %arch% equ x64 (if exist "%ProgramFiles(x86)%\Microsoft Office\Office15\OSPP.VBS" (set office2013=x86&set /a z+=1&set office2013b=32-bit {x86}&goto :office2016check))

"%windir%\system32\reg.exe" query "hklm\SOFTWARE\Microsoft\Office\15.0\Common\InstallRoot" /v Path 1>"%temp%\offpath.burf" 2>nul&& goto :office2013arch
if %arch% equ x64 ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Wow6432Node\Microsoft\Office\15.0\Common\InstallRoot" /v Path 1>"%temp%\offpath.burf" 2>nul&& goto :office2013arch)
if errorlevel 1 goto :office2016check

:office2013arch
for /f "skip=2 tokens=2*" %%a in ('type "%temp%\offpath.burf"') do (set "offpath=%%b")
if exist "%offpath%\addins\otkloadr_x64.dll" (set office2013=x64&set /a z+=1&set office2013b=64-bit {x64}) else (if exist "%offpath%\addins\otkloadr.dll" (set office2013=x86&set /a z+=1&set office2013b=32-bit {x86}))

:office2016check
if exist "%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS" (
if %arch% equ x64 (set office2016=x64&set /a z+=1&set office2016b=64-bit {x64}) else (set office2016=x86&set /a z+=1&set office2016b=32-bit {x86})
goto :checkdone
)
if %arch% equ x64 (if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\OSPP.VBS" (set office2016=x86&set /a z+=1&set office2016b=32-bit {x86}&goto :checkdone))

"%windir%\system32\reg.exe" query "hklm\SOFTWARE\Microsoft\Office\16.0\Common\InstallRoot" /v Path 1>"%temp%\offpath.burf" 2>nul&& goto :office2016arch
if %arch% equ x64 ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Wow6432Node\Microsoft\Office\16.0\Common\InstallRoot" /v Path 1>"%temp%\offpath.burf" 2>nul&& goto :office2016arch)
if errorlevel 1 goto :checkdone

:office2016arch
for /f "skip=2 tokens=2*" %%a in ('type "%temp%\offpath.burf"') do (set "offpath=%%b")
if exist "%offpath%\addins\otkloadr_x64.dll" (set office2016=x64&set /a z+=1&set office2016b=64-bit {x64}) else (if exist "%offpath%\addins\otkloadr.dll" (set office2016=x86&set /a z+=1&set office2016b=32-bit {x86}))

:checkdone
cls
if %z% equ 0 goto :notinstalled
del "%temp%\offpath.burf"

:vercheck
if not defined office2010 goto :office2013ver

if %arch% equ x86 ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Microsoft\Office\14.0\Common\ProductVersion" /v LastProduct >"%temp%\prodver.burf")
if %arch% equ x64 (
if %office2010% equ x64 ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Microsoft\Office\14.0\Common\ProductVersion" /v LastProduct >"%temp%\prodver.burf") else ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Wow6432Node\Microsoft\Office\14.0\Common\ProductVersion" /v LastProduct >"%temp%\prodver.burf")
)
for /f "skip=2 tokens=3,*" %%G in ('type "%temp%\prodver.burf"') do (set prodver2010=%%G)

if not defined spinst (if not defined office2013 if not defined office2016 (goto :top))

:office2013ver
if not defined office2013 goto :office2016ver

if %arch% equ x86 ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Microsoft\Office\15.0\Common\ProductVersion" /v LastProduct >"%temp%\prodver.burf")
if %arch% equ x64 (
if %office2013% equ x64 ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Microsoft\Office\15.0\Common\ProductVersion" /v LastProduct >"%temp%\prodver.burf") else ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Wow6432Node\Microsoft\Office\15.0\Common\ProductVersion" /v LastProduct >"%temp%\prodver.burf")
)
for /f "skip=2 tokens=3,*" %%G in ('type "%temp%\prodver.burf"') do (set prodver2013=%%G)

if not defined spinst (if not defined office2016 (goto :top))

:office2016ver
if %arch% equ x86 ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Microsoft\Office\16.0\Common\ProductVersion" /v LastProduct >"%temp%\prodver.burf")
if %arch% equ x64 (
if %office2016% equ x64 ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Microsoft\Office\16.0\Common\ProductVersion" /v LastProduct >"%temp%\prodver.burf") else ("%windir%\system32\reg.exe" query "hklm\SOFTWARE\Wow6432Node\Microsoft\Office\16.0\Common\ProductVersion" /v LastProduct >"%temp%\prodver.burf")
)
for /f "skip=2 tokens=3,*" %%G in ('type "%temp%\prodver.burf"') do (set prodver2016=%%G)

if defined spinst (goto :spdone)

:top
cd /d "%loc%"
del "%temp%\prodver.burf"

echo If this message appears for an extended period of time, it is 
echo recommended that you close this script.
echo.
echo Please move the script to a folder that is closer to the location
echo of the Office updates.
echo.
echo If using WHDownloader, it is recommended that you place this script
echo in the same location as the WHDownloader executable.

if defined office2010 (
for /f "delims=" %%G in ('dir /b /s *2010*%office2010%*.exe') do (echo %%G>>"%temp%\update1.burf")
"%windir%\system32\findstr.exe" /i /v "kb2687455" "%temp%\update1.burf" >"%temp%\update1a.burf"
"%windir%\system32\findstr.exe" /i /v "superseded" "%temp%\update1a.burf" >"%temp%\filelist1.burf"
for /f %%G in ('type "%temp%\filelist1.burf"') do (set /a c+=1)
)

if defined office2013 (
for /f "delims=" %%G in ('dir /b /s *2013*%office2013%*.exe') do (echo %%G>>"%temp%\update2.burf")
"%windir%\system32\findstr.exe" /i /v "kb2817430" "%temp%\update2.burf" >"%temp%\update2a.burf"
"%windir%\system32\findstr.exe" /i /v "superseded" "%temp%\update2a.burf" >"%temp%\filelist2.burf"
for /f %%G in ('type "%temp%\filelist2.burf"') do (set /a c+=1)
)

if defined office2016 (
for /f "delims=" %%G in ('dir /b /s *2016*%office2016%*.exe') do (echo %%G>>"%temp%\update3.burf")
"%windir%\system32\findstr.exe" /i /v "kb2817430" "%temp%\update3.burf" >"%temp%\update3a.burf"
"%windir%\system32\findstr.exe" /i /v "superseded" "%temp%\update3a.burf" >"%temp%\filelist3.burf"
for /f %%G in ('type "%temp%\filelist3.burf"') do (set /a c+=1)
)

if defined office2010 (if %prodver2010% lss 14.0.7015.1000 (set sp2010=0))
if defined office2013 (if %prodver2013% lss 15.0.4569.1506 (set sp2013=0))

set /a sp=sp2010+sp2013 >nul
if %sp% neq 3 (goto :spinstall)

if not defined c (goto :nofiles)

"%windir%\system32\reg.exe" query "hklm\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products" /f "(KB" /s /d 1>"%temp%\installed.burf" 2>nul
"%windir%\system32\find.exe" /i "Update" "%temp%\installed.burf" >"%temp%\installed2.burf"
"%windir%\system32\find.exe" /i "Hotfix" "%temp%\installed.burf" >>"%temp%\installed2.burf
for /f "delims=() tokens=2" %%G in ('type "%temp%\installed2.burf"') do (echo %%G) >>"%temp%\installed3.burf"

if not exist "%temp%\installed3.burf" set fullinstall=1&set count=&set c=&goto :fullinstall
if defined office2010 ("%windir%\system32\findstr.exe" /i /v /g:"%temp%\installed3.burf" "%temp%\filelist1.burf" >"%temp%\installer1.burf")
if defined office2013 ("%windir%\system32\findstr.exe" /i /v /g:"%temp%\installed3.burf" "%temp%\filelist2.burf" >"%temp%\installer2.burf")
if defined office2016 ("%windir%\system32\findstr.exe" /i /v /g:"%temp%\installed3.burf" "%temp%\filelist3.burf" >"%temp%\installer3.burf")

:fullinstall
if defined fullinstall (
if exist "%temp%\filelist1.burf" (copy /y "%temp%\filelist1.burf" "%temp%\installer1.burf" >nul)
if exist "%temp%\filelist2.burf" (copy /y "%temp%\filelist2.burf" "%temp%\installer2.burf" >nul)
if exist "%temp%\filelist3.burf" (copy /y "%temp%\filelist3.burf" "%temp%\installer3.burf" >nul)
)

if exist "%temp%\installer1.burf" (for /f %%G in ('type "%temp%\installer1.burf"') do (set /a C2010+=1))
if exist "%temp%\installer2.burf" (for /f %%G in ('type "%temp%\installer2.burf"') do (set /a C2013+=1))
if exist "%temp%\installer3.burf" (for /f %%G in ('type "%temp%\installer3.burf"') do (set /a C2016+=1))
if defined office2010 (if not defined C2010 (del "%temp%\installer1.burf"))
if defined office2013 (if not defined C2013 (del "%temp%\installer2.burf"))
if defined office2016 (if not defined C2016 (del "%temp%\installer3.burf"))
set /a c=C2010+C2013+C2016 >nul

if %c% equ 0 (set alreadyinstalled=1&goto :finished)

:instupdates
if exist "%temp%\installer1.burf" (set year=2010&set office=%office2010b%&for /f "delims=" %%G in ('type "%temp%\installer1.burf"') do (set installer=%%G&call :start))
if exist "%temp%\installer2.burf" (set year=2013&set office=%office2013b%&for /f "delims=" %%G in ('type "%temp%\installer2.burf"') do (set installer=%%G&call :start))
if exist "%temp%\installer3.burf" (set year=2016&set office=%office2016b%&for /f "delims=" %%G in ('type "%temp%\installer3.burf"') do (set installer=%%G&call :start))

goto :finished

:start
call :title
echo.
echo Installing updates for Microsoft Office %year% %office%
echo.
echo Installation of all updates may take considerable time.
echo Please be patient!
echo.
echo. 
set /a count+=1
echo Installing update %count% of %c% total:
echo.
echo %installer%
"%installer%" /quiet /norestart
goto :eof

:finished
call :title
echo.
if defined fullinstall (set alreadyinstalled=)
if defined alreadyinstalled (
echo All updates found are already installed.
) else (
echo Finished processing and installing:
echo.
if defined C2010 (echo %C2010% updates for Micorosft Office 2010.)
if defined C2013 (echo %C2013% updates for Microsoft Office 2013.)
if defined C2016 (echo %C2016% updates for Microsoft Office 2016.)
)

echo.
echo.
if not defined fullinstall (goto :installprompt)
echo.
echo.
echo Press any key to exit...
pause >nul
goto :cleanup

:installprompt
echo Would you like to reprocess all updates?
echo  Y.  Yes
echo  N.  Exit
echo  X.  Also exits!
echo.
echo.
echo Please note that in almost all circumstances the reprocessing of
echo all updates is unnecessary.
echo.
echo.
choice /c YNX /N /M "Please enter your selection> "
if errorlevel 3 goto :cleanup
if errorlevel 2 goto :cleanup
if errorlevel 1 set fullinstall=1&set count=&set c=&goto :fullinstall

pause >nul
goto :cleanup

:cleanup
if exist "%temp%\*.burf" del "%temp%\*.burf"
if exist "%temp%\opatchinstall*.log" del "%temp%\opatchinstall*.log"
if exist "%temp%\*_MSPLOG.LOG" del "%temp%\*_MSPLOG.LOG"
cls
goto :eof

:nofiles
call :title
echo There are no updates for Office found in the current folder or its
echo subfolders. Please run this script from the same location as the
echo update files, or enter the location of the update files by selecting
echo option 'A' in the menu below.
echo.
echo The update files must be Office update files and have the .exe
echo filename extension. They also must be for the correct version of Office
echo (2010/2013/2016) and be for the correct architecture (x86/x64).
echo This is listed below the installer title at the top of the page.
echo.
echo A. Select location of updates
echo.
echo X. Exit
echo.
echo.
choice /c AX /N /M "Please enter your selection> "
if errorlevel 2 goto :cleanup

call :title
echo Please enter the location where the updates reside.
echo.
echo For ease of navigation you can locate the folder in Windows Explorer.
echo To do this, click on the space at the end of the address bar which will
echo highlight the current folder location.  Copy the address to the clipboard
echo by pressing (ctrl-c) or click the right mouse button and selecting copy.
echo.
echo Paste the copied location into the script by clicking with the right mouse
echo button on this window and selecting paste.
echo --------------------------------------------------------------------------
echo.
echo Please enter location of updates then press enter:
set /P loc=
goto :top

:notinstalled
call :title
echo It appears you do not have Microsoft Office 2010/2013/2016 installed on
echo this system. This installer supports the traditional MSI versions of
echo Microsoft Office. ClickToRun versions are not supported.
echo.
echo If you do have Microsoft Office 2010/2013/2016 installed, please re-run
echo the Office installer and choose to repair the installation.
echo.
echo.
echo Press any key to exit...
pause >nul
goto :cleanup

:title
cls
echo -----------------------------------------------------
echo Microsoft Office Automated Update Install Script V14d by Burf
echo -----------------------------------------------------
if defined office2010 (echo Microsoft Office 2010 %office2010b% %prodver2010%)
if defined office2013 (echo Microsoft Office 2013 %office2013b% %prodver2013%)
if defined office2016 (echo Microsoft Office 2016 %office2016b% %prodver2016%)
echo.
goto :eof

:spinstall
set spinst2010=0
set spinst2013=0
call :title

if %sp2010% neq 2 ("%windir%\system32\findstr.exe" /i "kb2687455" "%temp%\update1.burf" >"%temp%\spinst2010.burf")
if %sp2010% neq 2 (if %errorlevel% equ 1 (set spinst2010=1))

if %sp2013% neq 1 ("%windir%\system32\findstr.exe" /i "kb2883095" "%temp%\update2.burf" >"%temp%\spinst2013.burf")
if %sp2013% neq 1 (if %errorlevel% equ 1 (set spinst2013=1))

set /a spinst=spinst2010+spinst2013 >nul

if %spinst% neq 0 (
echo The following service pack{s} were not found:
if %spinst2010% neq 0 (echo Microsoft Office 2010 %office2010b% Service Pack 2 {KB2687455})
if %spinst2013% neq 0 (echo Microsoft Office 2013 %office2013b% Serivce Pack 1 {KB2817430})
echo.
echo Relevant service packs must be installed before the other updates.
echo Please download and install the relevant service packs, and rerun
echo this script to install remaining updates.
echo.
echo.
echo.
echo Press any key to exit...
pause >nul
goto :cleanup
)

if %sp2010% neq 2 (if %spinst2010% equ 0 (set year=2010&set office=%office2010b%&for /f "delims=" %%G in ('type "%temp%\spinst2010.burf"') do (set installer=%%G&call :spinstall2)))
if %sp2013% neq 1 (if %spinst2013% equ 0 (set year=2013&set office=%office2013b%&for /f "delims=" %%G in ('type "%temp%\spinst2013.burf"') do (set installer=%%G&call :spinstall2)))

goto :spdone

:spinstall2
echo.
echo Please be patient during the install process, as it may take some time...
echo.
echo Installing service pack for Microsoft Office %year% %office%
"%installer%" /quiet /norestart
goto :eof

:spdone
goto :vercheck
if defined office2010 (if %prodver2010% lss 14.0.7015.1000 (goto :fail))
if defined office2013 (if %prodver2013% lss 15.0.4569.1506 (goto :fail))

call :title
echo.
if %sp2010% neq 2 (echo Service Pack 2 for Microsoft Office 2010 installed.)
if %sp2013% neq 1 (echo Service Pack 1 for Microsoft Office 2013 installed.)
echo.
echo Please restart the computer to finalise the service pack installation.
echo.
echo.
echo Please use WHDownloader to download and install remaining updates if
echo you have not already done so, and use this script to install them.
echo.
echo New updates come out monthly, so ensure you keep up to date!
echo.
echo.
echo.
echo Press any key to exit...
pause >nul
goto :cleanup

:fail
call :title
echo.
echo Installation of service pack failed. Please try installing
echo this manually.
echo.
echo You may need to redownload the service pack installer, or
echo reinstall Microsoft Office.
echo.
echo.
echo.
echo Press any key to exit...
pause >nul
goto :cleanup

:systemerror
echo.
echo System files required for this script appear to be missing.
echo.
echo Script cannot continue. If these files are missing, it's
echo possible that other files are also missing.
echo.
echo A reinstallation of Windows may be required!
echo.
echo.
pause >nul
goto :eof