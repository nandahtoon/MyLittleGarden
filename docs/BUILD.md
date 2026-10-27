# Build and validation instructions

## Godot
Use Godot 4.4+ (GDScript) with Compatibility renderer. Import `project.godot` and run F5. Headless import and smoke checks run in GitHub Actions; verify the latest run status before relying on them.

## Android
On Windows/macOS/Linux install matching Godot export templates, OpenJDK 17 and Android SDK. Configure Godot Editor Settings → Export → Android. Install an APK on a test tablet with USB debugging enabled. For Play distribution, create a signed AAB and complete policy review. Do not put signing credentials in the repository.

https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

## iPad
On macOS install Xcode and matching Godot iOS export templates. Export an Xcode project, set Apple development team and bundle ID and sign/deploy to an iPad. Do not commit provisioning profiles or secrets.

https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html

## Required checks before claiming MVP acceptance
- Godot editor import and run with no parse errors
- 9 beds plant/water/flower progression and persistence after restart
- gesture/drag behaviour, accidental touches, 4:3/16:10/16:9 layouts
- gentle audio with device volume differences
- safe areas, app suspend/resume and orientation on physical Android tablet and iPad
- parent hold-to-open, preferences, double-tap reset and gentle break prompt
- child-and-parent observed play test
- store privacy policies before public distribution

## Continuous Integration: Android debug APK (added October 2026)

The [Android debug APK workflow](../.github/workflows/android-debug.yml) builds an **unsigned-for-release, developer-debug-signed** APK from this repository's Godot source using Godot 4.4.1, Java 17 and Android SDK 34.

**Get a test APK**
1. Open the repository **Actions** tab and select **Android debug APK**.
2. Open a successful run for `main` (or a verified PR head).
3. Under **Artifacts**, download **LittleWonderGarden-Android-debug-APK** (GitHub sign-in may be required). Extract the ZIP and verify the supplied SHA-256 hash if desired.
4. Install `LittleWonderGarden-debug.apk` on a personal test Android tablet, allowing install from a trusted source only for this test.
5. Test touch, save/restore, sound, landscape fit and calm play with a parent present. Record anonymized results in [Issue #3](https://github.com/nandahtoon/MyLittleGarden/issues/3).

**Important limitations**
- A CI-green APK is not proof that a physical tablet has passed QA.
- The debug key is generated afresh on every CI run; if Android reports a signature mismatch when installing a newer APK, uninstall the older test build first. **Uninstalling deletes the local garden save**. Export/backup is not implemented.
- CI artifact retention is 14 days. This is a **test build**, not a Google Play release package.
- Android package ID: `io.github.nandahtoon.mylittlegarden`. Changing this later changes the on-device app identity and saved-data location.
- No production keystore, password, provisioning profile, API key or child identity belongs in this public repository.
- Apple iPad still requires a macOS/Xcode signed build and physical-device testing.
