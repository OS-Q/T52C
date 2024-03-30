@echo off

PATH="%~dp0";%PATH%
af.exe --setup %*
set status=%errorlevel%

exit %status%
