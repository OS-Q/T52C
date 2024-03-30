@echo off

PATH="%~dp0";%PATH%
Supra.exe %*
set status=%errorlevel%

exit %status%
