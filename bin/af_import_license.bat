@echo off

PATH="%~dp0";%PATH%
af.exe --import_license %*
set status=%errorlevel%

exit %status%
