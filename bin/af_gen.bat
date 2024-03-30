@echo off

PATH="%~dp0";%PATH%
af.exe --gen %*
set status=%errorlevel%

exit %status%
