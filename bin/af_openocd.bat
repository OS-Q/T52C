@echo off

PATH="%~dp0\..\openocd\bin";%PATH%
openocd.exe %*
set status=%errorlevel%

exit %status%
