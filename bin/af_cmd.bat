@echo off

PATH="%~dp0";%PATH%
af.exe %*
set status=%errorlevel%

exit %status%
