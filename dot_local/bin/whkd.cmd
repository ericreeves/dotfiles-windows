PowerShell -Command "Set-ExecutionPolicy Unrestricted" >> "%TEMP%\StartupLog.txt" 2>&1
PowerShell %USERPROFILE%\.local\bin\whkd.ps1 >> "%TEMP%\StartupLog.txt" 2>&1