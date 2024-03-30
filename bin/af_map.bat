@echo off

PATH="%~dp0\..\map\bin";%PATH%
yosys.exe %*
set status=%errorlevel%

exit %status%
