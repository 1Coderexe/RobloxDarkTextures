@echo off
setlocal

echo Special gamers past this point!!!!!
timeout /T 3 /NOBREAK
cls

:: Make stupid variables
set "downloadUrl=https://github.com/1Coderexe/SpecialDDown/raw/main/DarkTextures.zip"
set "tempFolder=%temp%\textures_zip"
set "destination=C:\Users\%username%\AppData\Local\Bloxstrap"

:: Check if the script is running with admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrator privileges.
    echo Requesting elevation...

    :: Relaunch the script with admin privileges using PowerShell
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Create a temp folder if it doesn't exist
if not exist "%tempFolder%" mkdir "%tempFolder%"

echo Allowing Powershell Usage...
:: Temporarily allow script execution for this session
powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force"

echo Downloading Files...
:: Download the ZIP file to the temp folder using PowerShell
powershell -Command "Invoke-WebRequest -Uri '%downloadUrl%' -OutFile '%tempFolder%\file.zip'"

echo Extracting Files...
:: Extract the contents of the ZIP file to the temp folder
powershell -Command "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%tempFolder%\file.zip', '%tempFolder%')"

echo Installing the required things...
:: has admin to install the shit.
echo Running with administrator privileges...

winget install Microsoft.DotNet.DesktopRuntime.6
winget install Microsoft.DotNet.AspNetCore.6
winget install bloxstrap

if not exist "C:\Users\%username%\AppData\Local\Bloxstrap\Versions" (
    echo Blockstrap doesn't exist????????? Waiting 5 seconds before retrying..
    timeout /T 5 /NOBREAK
    rmdir /S /Q "%tempFolder%"
)

if not exist "C:\Users\%username%\AppData\Local\Bloxstrap\Versions\" (
    echo Destination path does not exist Running Bloxstrap and restarting.
    start C:\Users\%username%\AppData\Local\Bloxstrap\Bloxstrap.exe
    echo Waiting 10 seconds then Restarting...
    timeout /T 10 /NOBREAK
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    rmdir /S /Q "%tempFolder%"
    pause
    exit /b
)

for /D %%D in ("C:\Users\%username%\AppData\Local\Bloxstrap\Versions\*") do (
    set "firstFolder=%%D"
    goto :foundVersion
)

:foundVersion
cd /d "%firstFolder%"
cd "PlatformContent\pc\textures\"
robocopy "%tempFolder%\DarkTextures" "." /E /IS /IT /NDL /NP /R:2 /W:2

echo Cleaning up Temp Files and Closing
rmdir /S /Q "%tempFolder%"
endlocal
