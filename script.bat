@echo off
setlocal

:: Set script directories
set "SCRIPT_DIR=%~dp0"
set "SRC_DIR=%SCRIPT_DIR%src\"
set "DEST_DIR=C:\Program Files\WinRAR\"

:: Set the paths for the encoded files
set "ENCODED_RARREG_KEY=%SRC_DIR%encoded_rarreg_key.txt"
set "ENCODED_ASCII_ART=%SRC_DIR%encoded_ascii_art.txt"

:: Define color codes for output
set "RESET=[0m"
set "GREEN=[32m"
set "RED=[31m"

:: Check for administrator rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    :: If not admin, print a message and exit
    echo %RED%You need to run this script as Administrator. Please right-click the script and choose "Run as Administrator".%RESET%
    pause
    exit /b
)

:: Now running with admin privileges
echo %GREEN%Running with administrative privileges...%RESET%
echo Decoding encoded files...

:: Decode rarreg.key
powershell -Command "[System.IO.File]::WriteAllBytes('%TEMP%\rarreg.key', [System.Convert]::FromBase64String((Get-Content '%ENCODED_RARREG_KEY%' -Raw)))"
if %errorlevel% neq 0 (
    echo %RED%Failed to decode rarreg.key file.%RESET%
    pause
    exit /b
)

:: Decode ASCII Art
powershell -Command "[System.IO.File]::WriteAllBytes('%TEMP%\ascii_art.txt', [System.Convert]::FromBase64String((Get-Content '%ENCODED_ASCII_ART%' -Raw)))"
if %errorlevel% neq 0 (
    echo %RED%Failed to decode ASCII art file.%RESET%
    pause
    exit /b
)

:: Display ASCII art
type %TEMP%\ascii_art.txt

:: Prompt for user input
echo %GREEN%1. Activate%RESET%
echo %RED%2. Exit%RESET%
set /p choice=Choose an option (1 or 2): 

:: Handle user choice
if "%choice%"=="1" (
    echo Verifying source file...
    if not exist "%TEMP%\rarreg.key" (
        echo %RED%Source file not found. Please verify.%RESET%
        pause
        exit /b
    )
    echo Source file exists.
    
    echo Verifying destination directory...
    if not exist "%DEST_DIR%" (
        echo %RED%Destination directory not found.%RESET%
        pause
        exit /b
    )
    echo Destination directory exists.

    echo %GREEN%Activated%RESET%
    copy "%TEMP%\rarreg.key" "%DEST_DIR%"
    if %errorlevel% neq 0 (
        echo %RED%Failed to copy the file.%RESET%
    )
    pause
) else if "%choice%"=="2" (
    echo Exiting...
    pause
    exit
) else (
    echo %RED%Invalid choice. Please run the script again and choose 1 or 2.%RESET%
)

:: Wait for user to press a key before closing
pause
endlocal
