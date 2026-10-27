# Android development APK workflow

A portable Godot 4.4.1 build runs in GitHub Actions via the
[`Android debug APK` workflow](https://github.com/nandahtoon/MyLittleGarden/actions/workflows/android-debug-apk.yml).
It builds **one ARM64 debug APK** for supervised testing, not a signed Play Store release.

## Download and install

1. Open Actions → **Android debug APK** → choose a successful workflow run.
2. Download the **MyLittleGarden-Android-debug-APK** artifact and extract the ZIP.
3. Install `MyLittleGarden-debug.apk` on a test Android tablet, e.g. using
   `adb install -r MyLittleGarden-debug.apk` after enabling Android developer USB debugging.
4. Check plant/water, tap and drag, low-volume audio, autosave after force-close,
   parent settings, gentle rest transition and 4:3 / 16:10 aspect ratios.
5. Record physical device, Android version, outcome and actual defects in GitHub Issues.

## Safety and limits

- The workflow creates `export_presets.cfg` only within the CI job, with no release secrets.
- It uses the generic **debug** keystore from the temporary Godot CI environment.
  Do not publish or treat this as a production release build.
- Artifact retention is seven days; the APK is not uploaded to GitHub Releases.
- The Android application identifier is a provisional development identifier.
- Android tablet QA and a real iPad/Xcode build are **not** proven by an APK export.
- Do not add analytics, advertisements, child accounts or runtime internet permissions.
