# Build and validation instructions

## Godot
Use Godot 4.4+ (GDScript) with Compatibility renderer. Import `project.godot` and run F5. No Godot runtime checks have been completed in this initial GitHub import.

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
