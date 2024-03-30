@echo off

PATH="%~dp0\..\flashloader\bin";%PATH%
agrv32flash.exe %*
set status=%errorlevel%

exit %status%
