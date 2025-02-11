@echo off
setlocal enabledelayedexpansion

REM
set "processName=FXServer.exe"

REM
tasklist /FI "IMAGENAME eq %processName%" 2>NUL | find /I /N "%processName%">NUL
if %ERRORLEVEL%==0 (
    REM
    taskkill /IM "%processName%" /F
    echo Processo '%processName%' encerrado.
)

REM
echo Iniciando processo '%processName%'
start ..\build\FXServer.exe +exec config.cfg

endlocal