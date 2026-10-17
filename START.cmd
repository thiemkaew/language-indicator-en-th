@echo off
setlocal
cd /d "%~dp0"
if not exist "language-indicator.exe" (
  echo Missing language-indicator.exe. Extract the complete download first.
  pause
  exit /b 1
)
start "" "%~dp0language-indicator.exe"
