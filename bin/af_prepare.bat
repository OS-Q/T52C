@echo off

PATH="%~dp0";%PATH%
af.exe --prepare %*
set status=%errorlevel%

exit %status%
