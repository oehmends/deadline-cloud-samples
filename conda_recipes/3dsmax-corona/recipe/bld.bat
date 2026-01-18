@echo off
setlocal enableextensions enabledelayedexpansion

set "MAX_VERSION=2025"

rem Install Corona to the expected Chaos path under the conda prefix.
set "TARGET_ROOT=%PREFIX%\Program Files\Chaos\Corona"
set "TARGET=%TARGET_ROOT%\Corona Renderer for 3ds Max\%MAX_VERSION%"
if not exist "%TARGET_ROOT%" mkdir "%TARGET_ROOT%"
if not exist "%TARGET%" mkdir "%TARGET%"

rem Use robocopy to preserve the full Corona payload (including empty dirs).
robocopy "%SRC_DIR%" "%TARGET_ROOT%" /E /COPY:DAT /DCOPY:DAT /R:3 /W:5 /NFL /NDL /NJH /NJS /NC /NS >nul
if %ERRORLEVEL% GEQ 8 exit /b 1

rem Add activation hooks to expose the Corona load path
set "ACTIVATE_DIR=%PREFIX%\etc\conda\activate.d"
set "DEACTIVATE_DIR=%PREFIX%\etc\conda\deactivate.d"
if not exist "%ACTIVATE_DIR%" mkdir "%ACTIVATE_DIR%"
if not exist "%DEACTIVATE_DIR%" mkdir "%DEACTIVATE_DIR%"

set "ACTIVATE_SH=%ACTIVATE_DIR%\%PKG_NAME%-%PKG_VERSION%-vars.sh"
set "DEACTIVATE_SH=%DEACTIVATE_DIR%\%PKG_NAME%-%PKG_VERSION%-vars.sh"
set "ACTIVATE_BAT=%ACTIVATE_DIR%\%PKG_NAME%-%PKG_VERSION%-vars.bat"
set "DEACTIVATE_BAT=%DEACTIVATE_DIR%\%PKG_NAME%-%PKG_VERSION%-vars.bat"

(
  echo #!/bin/sh
  echo export CORONA_3DSMAX_%MAX_VERSION%_LOAD_PATH=\"$(cygpath "%TARGET%")\"
) > "%ACTIVATE_SH%"

(
  echo #!/bin/sh
  echo unset CORONA_3DSMAX_%MAX_VERSION%_LOAD_PATH
) > "%DEACTIVATE_SH%"

echo set "CORONA_3DSMAX_%MAX_VERSION%_LOAD_PATH=%TARGET%" > "%ACTIVATE_BAT%"
echo set CORONA_3DSMAX_%MAX_VERSION%_LOAD_PATH= > "%DEACTIVATE_BAT%"

exit /b 0
