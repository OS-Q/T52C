@echo off

PATH="%~dp0";%PATH%
af.exe --progress 1000 --prg %*
set status=%errorlevel%

exit %status%
