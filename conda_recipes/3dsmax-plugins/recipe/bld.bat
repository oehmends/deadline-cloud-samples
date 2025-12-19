@echo off
setlocal enableextensions enabledelayedexpansion

rem Copy plugin payload into the conda prefix, preserving Program Files/ProgramData.
rem /E recursive, /I assume destination is a directory, /H copy hidden, /Y overwrite
xcopy "%SRC_DIR%\*" "%PREFIX%\" /E /I /H /Y >nul
if errorlevel 1 exit /b 1

exit /b 0
