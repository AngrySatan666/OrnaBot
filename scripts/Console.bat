@echo off
REM =========================================
REM run.bat –– launch elevated cmd in parent folder
REM =========================================

:: 1. Get the full path to the script's directory (removes trailing backslash)
set "CURDIR=%~dp0"
set "CURDIR=%CURDIR:~0,-1%"

:: 2. Remove the last path segment to get the parent directory
for %%i in ("%CURDIR%") do set "PARENT_DIR=%%~dpi"
set "PARENT_DIR=%PARENT_DIR:~0,-1%"

:: 3. Use PowerShell to launch cmd.exe as Administrator in the parent directory
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Start-Process cmd.exe -ArgumentList '/k cd /d \"%PARENT_DIR%\"' -Verb RunAs"

exit /b