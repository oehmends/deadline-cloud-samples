@echo off
setlocal enableextensions enabledelayedexpansion

set "MAX_VERSION=2025"

rem Copy plugin payload into the conda prefix, preserving Program Files/ProgramData.
rem /E recursive, /I assume destination is a directory, /H copy hidden, /Y overwrite
xcopy "%SRC_DIR%\*" "%PREFIX%\" /E /I /H /Y >nul
if errorlevel 1 exit /b 1

rem Add activation hooks to expose plug-in paths for Chaos products.
set "ACTIVATE_DIR=%PREFIX%\etc\conda\activate.d"
set "DEACTIVATE_DIR=%PREFIX%\etc\conda\deactivate.d"
if not exist "%ACTIVATE_DIR%" mkdir "%ACTIVATE_DIR%"
if not exist "%DEACTIVATE_DIR%" mkdir "%DEACTIVATE_DIR%"

set "ACTIVATE_SH=%ACTIVATE_DIR%\%PKG_NAME%-%PKG_VERSION%-vars.sh"
set "DEACTIVATE_SH=%DEACTIVATE_DIR%\%PKG_NAME%-%PKG_VERSION%-vars.sh"
set "ACTIVATE_BAT=%ACTIVATE_DIR%\%PKG_NAME%-%PKG_VERSION%-vars.bat"
set "DEACTIVATE_BAT=%DEACTIVATE_DIR%\%PKG_NAME%-%PKG_VERSION%-vars.bat"

set "VRAY_MAIN=%PREFIX%\ProgramData\Autodesk\ApplicationPlugins\VRay3dsMax%MAX_VERSION%\bin"
set "VRAY_PLUGINS=%PREFIX%\ProgramData\Autodesk\ApplicationPlugins\VRay3dsMax%MAX_VERSION%\bin\plugins"
set "PHX_BIN=%PREFIX%\Program Files\Chaos\Phoenix FD\3ds Max %MAX_VERSION% for x64\bin"
set "PHX_PLUGINS=%PREFIX%\Program Files\Chaos\Phoenix FD\3ds Max %MAX_VERSION% for x64\bin\plugins"

(
  echo #!/bin/sh
  echo export VRAY_FOR_3DSMAX%MAX_VERSION%_MAIN=\"$(cygpath "%VRAY_MAIN%")\"
  echo export VRAY_FOR_3DSMAX%MAX_VERSION%_PLUGINS=\"$(cygpath "%VRAY_PLUGINS%")\"
  echo export PHX_FOR_3DSMAX%MAX_VERSION%_BIN=\"$(cygpath "%PHX_BIN%")\"
  echo export PHX_FOR_3DSMAX%MAX_VERSION%_STNDPLUGS=\"$(cygpath "%PHX_PLUGINS%")\"
) > "%ACTIVATE_SH%"

(
  echo #!/bin/sh
  echo unset VRAY_FOR_3DSMAX%MAX_VERSION%_MAIN
  echo unset VRAY_FOR_3DSMAX%MAX_VERSION%_PLUGINS
  echo unset PHX_FOR_3DSMAX%MAX_VERSION%_BIN
  echo unset PHX_FOR_3DSMAX%MAX_VERSION%_STNDPLUGS
) > "%DEACTIVATE_SH%"

(
  echo set "VRAY_FOR_3DSMAX%MAX_VERSION%_MAIN=%VRAY_MAIN%"
  echo set "VRAY_FOR_3DSMAX%MAX_VERSION%_PLUGINS=%VRAY_PLUGINS%"
  echo set "PHX_FOR_3DSMAX%MAX_VERSION%_BIN=%PHX_BIN%"
  echo set "PHX_FOR_3DSMAX%MAX_VERSION%_STNDPLUGS=%PHX_PLUGINS%"
) > "%ACTIVATE_BAT%"

(
  echo set VRAY_FOR_3DSMAX%MAX_VERSION%_MAIN=
  echo set VRAY_FOR_3DSMAX%MAX_VERSION%_PLUGINS=
  echo set PHX_FOR_3DSMAX%MAX_VERSION%_BIN=
  echo set PHX_FOR_3DSMAX%MAX_VERSION%_STNDPLUGS=
) > "%DEACTIVATE_BAT%"

exit /b 0
