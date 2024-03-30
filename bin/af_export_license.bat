@echo off

PATH="%~dp0";%PATH%
af.exe --export_license %*
set status=%errorlevel%

exit %status%
