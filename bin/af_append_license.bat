@echo off

PATH="%~dp0";%PATH%
af.exe --append_license %*
set status=%errorlevel%

exit %status%
