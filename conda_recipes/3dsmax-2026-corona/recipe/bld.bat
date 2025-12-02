@echo off
setlocal enableextensions enabledelayedexpansion

rem Install Corona to the expected Chaos path under the conda prefix.
set "TARGET=%PREFIX%\Program Files\Chaos\Corona\Corona Renderer for 3ds Max\2026"
if not exist "%TARGET%" mkdir "%TARGET%"

rem /E recursive, /I assume destination is a directory, /H copy hidden, /Y overwrite
xcopy "%SRC_DIR%" "%TARGET%" /E /I /H /Y >nul
if errorlevel 1 exit /b 1

exit /b 0
