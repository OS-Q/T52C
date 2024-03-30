@echo off

PATH="%~dp0";%PATH%
Downloader.exe %*
set status=%errorlevel%

exit %status%
