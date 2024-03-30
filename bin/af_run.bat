@echo off

PATH="%~dp0";%PATH%
af.exe --batch %*
set status=%errorlevel%

exit %status%
