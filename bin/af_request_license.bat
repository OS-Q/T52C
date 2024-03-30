@echo off

PATH="%~dp0";%PATH%
af.exe --request_license %*
set status=%errorlevel%

exit %status%
