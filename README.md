# Little Wonder Garden

**Cross-platform Godot 4.x starter game for Android tablets and Apple iPads.**

This is an **original source-code MVP prototype**, not an already exported APK/IPA. It uses the Godot engine to compile genuine installed apps (not a webview). There are **no plugins, third-party SDKs, ads, logins, analytics, trackers, or network calls**. The garden save file stays on the device. All illustration is drawn using built-in 2D primitives, and sound effects are bundled as generated WAV files.

**Canonical source of truth / Git origin:** https://github.com/nandahtoon/MyLittleGarden (main). All accepted source, designs, specifications and changes belong here. See [repository policy](docs/REPOSITORY_POLICY.md).

## Play

1. Install the standard Godot 4.4+ editor from https://godotengine.org/download/ (GDScript, Compatibility renderer).
2. Open `project.godot` using **Import** in Godot's Project Manager.
3. Press **F6/F5** to run (F5 runs the main scene). Mouse click simulates a child's tap; mouse drag simulates touching multiple soil beds.
4. Tap **Let's Play**, choose **Plant** and tap a soil patch, then choose **Water** and tap it twice to see a flower. Tap the small pond to hear a bird. Use **Rest** any time.
5. In Garden, **press and hold** the top-right gear for 2.5 seconds to view parent settings (sound, 5/10/15-minute reminder, garden reset). This is only a convenience gate; it is **not** a security control or a store-compliant adult challenge for external links (none exist in this MVP).

## Source tree

```
LittleWonderGarden/
├── project.godot                 # Mobile orientation, rendering, main scene
├── scenes/
│   └── main.tscn                # Native Godot scene entry point
├── scripts/
│   ├── garden_game.gd           # Scene state, touch input, visuals, progression
│   └── save_store.gd            # Offline JSON save adapter; versioned format
├── assets/audio/                # Short low-volume sounds included with the game
│   ├── seed.wav
│   ├── water.wav
│   ├── bloom.wav
│   └── bird.wav
├── docs/
│   ├── DESIGN.md                # Product/gameplay/screen specifications
│   ├── garden-screen-preview.svg# Screen concept (not an engine screenshot)
│   └── screen-flow.svg          # Navigation diagram
└── tools/
    └── validate_structure.py   # Static project validation
```

## Build for Android tablets

- On Windows, install Godot's matching **Android export templates**, **OpenJDK 17**, and Android SDK. Configure Editor Settings > Export > Android with Java and Android SDK paths. Plug in a tablet with USB debugging and deploy a development **APK**; you can also export an APK file via Project > Export > Android.
- For a public Google Play release, configure signing, a production Android package ID, and an **AAB** package, along with all applicable store forms.
- Official instructions: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

## Build for iPad (iOS/iPadOS)

- Use **macOS + Xcode**. Install matching Godot iOS export templates; use Project > Export > iOS, provide an Apple team ID and Bundle ID, and open the exported Xcode project. Configure signing and deploy to an iPad with Xcode.
- You can do most gameplay and content development on Windows, but a **Mac with Xcode is needed for the actual iPad build/sign process**.
- Official instructions: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html

## App experience

- **Four screens:** Welcome, Garden, Rest, Grown-up Corner.
- **Three plant growth stages:** seed → sprout → flower (stored as ints 1, 2, 3; 0=empty).
- **Touch controls:** large action cards (190x100 reference px), nine soil patches (202x126 reference px); tap or drag.
- **Aspect:** 1280x800 design canvas scales uniformly and stays visible, letterboxing on dissimilar tablet aspect ratios. Background extends to edges. Check actual device safe areas before shipping.
- **Audio:** gentle, short, low-volume local effects. No autoplay music, no camera/mic/notifications.
- **Persistence:** `user://little_wonder_garden.json` (not cloud-backed). No names or identifying information.
- **Breaks:** gentle prompts only, by default every 10 minutes of Garden play; never forcibly locks the user out.

## Current limitations

- This first prototype uses original vector shapes and text; illustrative preview images are **concept previews**, not captured Godot screenshots.
- Android/iPad native packages have **not** been exported or tested from this environment. Device QA is required, especially safe areas, performance, audio levels and touch accuracy.
- No spoken narration or Burmese localization yet; create those as a separate asset/localization milestone.
- No developed Pond/Builder activity yet; the small pond produces only a bird sound.
- No continuous real-time growing, no achievements or rewards, and deliberately no punishment/loss mechanic.
- Before public release, review the children's privacy and age-category rules for each store and provide a truthful privacy policy.

## Design / team guidance

See [DESIGN.md](docs/DESIGN.md) for module ownership, acceptance criteria, touch input behavior, polish backlog, safety and QA matrix.