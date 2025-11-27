#!/bin/sh

set -xeuo pipefail

# The version without the update number
MAX_VERSION=${PKG_VERSION%.*}
AUTODESK_ROOT="Autodesk"
INSTALL_DIR="$PREFIX/$AUTODESK_ROOT/3ds Max $MAX_VERSION"

mkdir -p "$PREFIX/$AUTODESK_ROOT"

# Move the extracted files into the install location. Using cmd handles paths with spaces reliably.
cmd <<EOF
move "$SRC_DIR\\3dsmax" "$PREFIX\\$AUTODESK_ROOT\\3ds Max $MAX_VERSION"
EOF

# Ensure 3ds Max's bundled Python has pip and pywin32 available for automation.
"$INSTALL_DIR\\Python\\python.exe" -m ensurepip
"$INSTALL_DIR\\Python\\python.exe" -m pip install pywin32

mkdir -p "$PREFIX/etc/conda/activate.d"
mkdir -p "$PREFIX/etc/conda/deactivate.d"

# See https://docs.conda.io/projects/conda/en/latest/dev-guide/deep-dives/activation.html
# for details on activation. The Deadline Cloud sample queue environments use bash
# to activate environments on Windows, so always produce both .bat and .sh files.

cat <<EOF > "$PREFIX/etc/conda/activate.d/$PKG_NAME-$PKG_VERSION-vars.sh"
export ADSK_3DSMAX_VERSION=$MAX_VERSION
export ADSK_3DSMAX_LOCATION="\$CONDA_PREFIX/Autodesk/3ds Max $MAX_VERSION"
export ADSK_3DSMAX_PYTHON="\$CONDA_PREFIX/Autodesk/3ds Max $MAX_VERSION/Python/python.exe"
export ADSK_3DSMAX_BATCH_EXE="\$CONDA_PREFIX/Autodesk/3ds Max $MAX_VERSION/3dsmaxbatch.exe"
export PATH="\$(cygpath "\$CONDA_PREFIX/Autodesk/3ds Max $MAX_VERSION"):\$PATH"
export PYTHONPATH="\$(cygpath "\$CONDA_PREFIX/Autodesk/3ds Max $MAX_VERSION/Python"):\$(cygpath "\$CONDA_PREFIX/Autodesk/3ds Max $MAX_VERSION/Python/Scripts"):\$PYTHONPATH"
EOF
cat "$PREFIX/etc/conda/activate.d/$PKG_NAME-$PKG_VERSION-vars.sh"

cat <<EOF > "$PREFIX/etc/conda/activate.d/$PKG_NAME-$PKG_VERSION-vars.bat"
set "ADSK_3DSMAX_VERSION=$MAX_VERSION"
set "ADSK_3DSMAX_LOCATION=%CONDA_PREFIX%\\Autodesk\\3ds Max $MAX_VERSION"
set "ADSK_3DSMAX_PYTHON=%CONDA_PREFIX%\\Autodesk\\3ds Max $MAX_VERSION\\Python\\python.exe"
set "ADSK_3DSMAX_BATCH_EXE=%CONDA_PREFIX%\\Autodesk\\3ds Max $MAX_VERSION\\3dsmaxbatch.exe"
set "3DSMAX_EXECUTABLE=%CONDA_PREFIX%\\Autodesk\\3ds Max $MAX_VERSION\\3dsmaxbatch.exe"
set "PATH=%CONDA_PREFIX%\\Autodesk\\3ds Max $MAX_VERSION;%PATH%"
set "PYTHONPATH=%CONDA_PREFIX%\\Autodesk\\3ds Max $MAX_VERSION\\Python;%CONDA_PREFIX%\\Autodesk\\3ds Max $MAX_VERSION\\Python\\Scripts;%PYTHONPATH%"
EOF
cat "$PREFIX/etc/conda/activate.d/$PKG_NAME-$PKG_VERSION-vars.bat"

cat <<EOF > "$PREFIX/etc/conda/deactivate.d/$PKG_NAME-$PKG_VERSION-vars.sh"
export PATH="\${PATH/\$(cygpath "\$CONDA_PREFIX/Autodesk/3ds Max $MAX_VERSION"):/}"
export PYTHONPATH="\${PYTHONPATH/\$(cygpath "\$CONDA_PREFIX/Autodesk/3ds Max $MAX_VERSION/Python/Scripts"):/}"
export PYTHONPATH="\${PYTHONPATH/\$(cygpath "\$CONDA_PREFIX/Autodesk/3ds Max $MAX_VERSION/Python"):/}"
unset ADSK_3DSMAX_BATCH_EXE
unset ADSK_3DSMAX_PYTHON
unset ADSK_3DSMAX_LOCATION
unset ADSK_3DSMAX_VERSION
EOF
cat "$PREFIX/etc/conda/deactivate.d/$PKG_NAME-$PKG_VERSION-vars.sh"

cat <<EOF > "$PREFIX/etc/conda/deactivate.d/$PKG_NAME-$PKG_VERSION-vars.bat"
set "PATH=%PATH:%CONDA_PREFIX%\\Autodesk\\3ds Max $MAX_VERSION;=%"
set "PYTHONPATH=%PYTHONPATH:%CONDA_PREFIX%\\Autodesk\\3ds Max $MAX_VERSION\\Python;=%"
set "PYTHONPATH=%PYTHONPATH:%CONDA_PREFIX%\\Autodesk\\3ds Max $MAX_VERSION\\Python\\Scripts;=%"
set 3DSMAX_EXECUTABLE=
set ADSK_3DSMAX_BATCH_EXE=
set ADSK_3DSMAX_PYTHON=
set ADSK_3DSMAX_LOCATION=
set ADSK_3DSMAX_VERSION=
EOF
cat "$PREFIX/etc/conda/deactivate.d/$PKG_NAME-$PKG_VERSION-vars.bat"
