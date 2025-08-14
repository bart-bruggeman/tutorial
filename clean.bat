@echo off
cls

:: turn localisation of environment variables on
setlocal

:: initialize _generated directory
set "GENERATED_HOME=_generated"

:: validate arguments and clean up
if "%~1" neq "" (
    :: invalid number of arguments
    goto show_usage
)

:: clean up directory
if exist %GENERATED_HOME% rd /s /q %GENERATED_HOME% 2>nul

:: turn localisation of environment variables off
endlocal
exit /b

:: display usage
:show_usage
echo.
echo usage: %~nx0
echo.
exit /b 1
