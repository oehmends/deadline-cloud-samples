# Conda build recipe for Cinema 4D Corona

## About

This recipe packages the Chaos Corona plug-in for Cinema 4D into a conda
package. It relies on the base `cinema4d` package at runtime (from the
`deadline-cloud` channel) and only copies the Corona plug-in payload staged
under `archive_files/`.

Corona versioning is driven from a single variable in
`recipe/meta.yaml` (`CORONA_VERSION`, default `13.2`). The same value is
reflected in the archive path (`cinema4d-corona-<version-with-dashes>`) and
`deadline-cloud.yaml`. Bump the version by setting an environment variable
when building or by editing the default in `meta.yaml`.

## Preparing the archive (Windows)

1. Install Cinema 4D 2025 on a Windows host (or use an existing fleet image).
2. Install Chaos Corona (e.g., 13.1, 13.2, or 14) and verify it renders inside
   Cinema 4D.
3. Collect the plug-in and optional licensing payload into a portable archive:
   - `C:\Program Files\Maxon Cinema 4D 2025\plugins\Corona`
   - Optional: `C:\Program Files\Common Files\ChaosGroup` if you want to ship
     `vrlclient.xml` or other Chaos licensing files.
4. Place the extracted files under
   `conda_recipes/archive_files/cinema4d-corona-<version-with-dashes>/win-64/`.
   Example for Corona 13.2: `cinema4d-corona-13-2/win-64/Corona/...`.

## Build the package on Deadline Cloud

If you have a package build queue configured, submit:

```
submit-package-job cinema4d-corona
```

The queue uses `deadline-cloud.yaml` to locate the staged archive and build for
`win-64`.

## Build locally (Windows host required)

`conda-build` for this recipe targets `win-64` and runs a `.bat` build script,
so build on Windows:

```
conda build cinema4d-corona/recipe --no-test
```

Set `CORONA_VERSION` if you want to override the default, e.g.:

```
set CORONA_VERSION=13.1
conda build cinema4d-corona/recipe --no-test
```

The resulting package will be under `conda-bld/win-64/`.

## Publish to an S3 conda channel

1. Sync your channel locally:
   ```
   aws s3 sync s3://<CHANNEL_BUCKET>/Conda/Default/win-64 ./temp-channel/win-64
   ```
2. Copy the built `.conda` file into `./temp-channel/win-64`.
3. Reindex:
   ```
   conda index --subdir win-64 --zst ./temp-channel
   ```
4. Sync back:
   ```
   aws s3 sync ./temp-channel/win-64 s3://<CHANNEL_BUCKET>/Conda/Default/win-64
   ```

Ensure your fleet/queue environment lists both the `deadline-cloud` channel
(for the base `cinema4d` package) and your S3 channel (for `cinema4d-corona`).
