# 3dsmax-plugins conda package

This package repackages a collection of Autodesk 3ds Max plug-ins into a conda-installable bundle. It should be installed alongside the matching `3dsmax` conda package.

## Contents
- Plug-in payload for 3ds Max 2025 sourced from `archive_files/3dsmax-plugins/win-64`.
- Windows-only build that copies the payload into the conda prefix, preserving the `Program Files` and `ProgramData` layout.

## Usage
1. Ensure the `3dsmax` conda package for the matching major version is installed.
2. Install this package via your conda channel (e.g., `conda install 3dsmax-plugins`).
3. Activate the environment; the plug-ins will live under the 3ds Max plug-ins directories.

## Building the archive payload
If you need to refresh the archive payload:
1. Install the plug-ins for 3ds Max 2025 on a Windows OS.
2. Copy the plug-in payload from `C:\3DSMAX-PLUGINS\win-64` into `archive_files/3dsmax-plugins/win-64/` in this repo.
3. Build the conda package (`conda build conda_recipes/3dsmax-plugins/recipe`).

## Notes
- Platform: `win-64` only.
- License: Vendor licenses (see vendor sites).
- Documentation: https://help.autodesk.com/view/3DSMAX/2025/ENU/
