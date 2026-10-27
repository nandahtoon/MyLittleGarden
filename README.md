# Little Wonder Garden

**Cross-platform Godot 4.x starter game for Android tablets and Apple iPads.**

This is an **original source-code MVP prototype**. GitHub Actions produces an **Android debug APK artifact**, but no public store-ready release or tested iPad IPA exists. It uses the Godot engine to compile genuine installed apps (not a webview). There are **no plugins, third-party SDKs, ads, logins, analytics, trackers, or network calls**. The garden save file stays on the device. Illustration combines built-in 2D shapes with eight original, locally bundled SVG plant sprites, and sound effects are bundled as generated WAV files.

**Canonical source of truth / Git origin:** https://github.com/nandahtoon/MyLittleGarden (`main`). All accepted source, designs, specifications and changes belong here. See [repository policy](docs/REPOSITORY_POLICY.md).

## Start here — for the next ChatGPT chat, developer or AI agent

Read **[Durable Handoff / START_HERE](docs/START_HERE.md)**, then [Game Design Document](docs/GAME_DESIGN.md), [4-Screen Flow](docs/SCREEN_FLOW.md), [Screen Contract JSON](docs/contracts/screen-flow.v1.json), [Storybook Bible](docs/STORYBOOK_BIBLE.md), and [Work Packages](docs/WORK_PACKAGES.md). These files are versioned with code. **No prior chat transcript is required to continue responsibly.** Check current GitHub PRs, issues and CI before working, because handoff status is a dated snapshot.

Current Android emulator work is in [PR #9](https://github.com/nandahtoon/MyLittleGarden/pull/9); do not duplicate or automatically merge it. The storybook code has been observed rendering under an isolated Godot 4.7.2/Swangle test, but end-to-end Parent Settings QA has **not** passed. Mainline Godot 4.4.1 debug APKs compile; Android physical device and iPad acceptance remain open [Issue #3](https://github.com/nandahtoon/MyLittleGarden/issues/3).

## Start here — for a new ChatGPT chat, agent or developer

**Open [docs/START_HERE.md](docs/START_HERE.md) before making changes.** It provides the repository-first handoff, factual milestone evidence, open PRs, pending emulator/parent-gesture blockers, and a paste-ready developer instruction. This GitHub repository (not an attachment or previous chat) is the source of truth.

- [docs/GAME_DESIGN.md](docs/GAME_DESIGN.md) — game design document, goals, mechanics and evidence-based release gates
- [docs/SCREEN_FLOW.md](docs/SCREEN_FLOW.md) — authoritative four-screen journey and exact touch/state transitions
- [docs/contracts/screen-flow.v1.json](docs/contracts/screen-flow.v1.json) — machine-readable navigation and garden contract
- [docs/STORYBOOK_BIBLE.md](docs/STORYBOOK_BIBLE.md) — original story world, non-linear microstories, child-safe art and UI recipes
- [docs/WORK_PACKAGES.md](docs/WORK_PACKAGES.md) — agent work packages, ownership, dependencies and acceptance
- [docs/ART_DIRECTION.md](docs/ART_DIRECTION.md) — the eight original SVG illustrations
- [docs/DESIGN.md](docs/DESIGN.md) — original implementation-focused MVP snapshot (may be older than live CI)

**Design rule:** Current implementation, planned ideas and verified tests are different states. An APK that builds is not proof a child can play it. Do not merge new worlds or publish stores without approval.

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
├── assets/art/                  # Eight original local SVG plant sprites
│   ├── seed.svg, sprout.svg     # Growth stages 1 and 2
│   └── cosmos.svg, sunflower.svg, tulip.svg, daisy.svg, poppy.svg, bluebell.svg
├── assets/audio/                # Short low-volume sounds included with the game
│   ├── seed.wav
│   ├── water.wav
│   ├── bloom.wav
│   └── bird.wav
├── docs/
│   ├── START_HERE.md            # First read for developers and new AI chats
│   ├── GAME_DESIGN.md           # Source-backed game design document
│   ├── SCREEN_FLOW.md           # Four-screen UI state machine and hitboxes
│   ├── STORYBOOK_BIBLE.md       # Story world, characters, visual/copy rules
│   ├── WORK_PACKAGES.md         # Ownership, delivery milestones and gates
│   ├── contracts/screen-flow.v1.json  # Versioned behavior contract
│   ├── DESIGN.md                # Original engineering MVP snapshot
│   └── ART_DIRECTION.md         # Original sprite gallery
└── tools/
    ├── validate_structure.py    # Static source validation
    └── validate_design_contracts.py # Design link/state/source consistency
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

- The game uses original vector backgrounds and six distinct flower SVG illustrations loaded directly as Godot textures; project previews are **concept previews**, not captured Godot screenshots.
- Android debug APK export **has passed** on `main` in GitHub Actions ([example exact-main run](https://github.com/nandahtoon/MyLittleGarden/actions/runs/40448089799)). Native **device** QA is still missing; an iPad signed build has not been verified. Emulator Welcome/Garden/Bloom/Rest rendering and gameplay were observed only on an isolated test branch; **the parent long-press test and end-to-end emulator CI remained failing as of 2026-10-27**. See [current handoff](docs/START_HERE.md) and [Issue #3](https://github.com/nandahtoon/MyLittleGarden/issues/3).
- No spoken narration or Burmese localization yet; create those as a separate asset/localization milestone.
- No developed Pond/Builder activity yet; the small pond produces only a bird sound.
- No continuous real-time growing, no achievements or rewards, and deliberately no punishment/loss mechanic.
- Before public release, review the children's privacy and age-category rules for each store and provide a truthful privacy policy.

## Design / team guidance

See [START_HERE.md](docs/START_HERE.md) for developer onboarding, [WORK_PACKAGES.md](docs/WORK_PACKAGES.md) for ownership, [DESIGN.md](docs/DESIGN.md) for earlier engineering details and [QA.md](docs/QA.md) for test gates.

## Storybook art direction (v1 polish)

Browse the [original illustrated flower gallery](docs/ART_DIRECTION.md) to preview source assets; it is **not** a game-device screenshot.

The Garden and Welcome views now use local, original SVG art for seed, sprout and six flower types (cosmos, sunflower, tulip, daisy, poppy and bluebell). SVGs are kept as editable source under `assets/art/`. Each flower has a different appearance without loot, points or random reward mechanics. The larger pastel panels, improved soil beds, and subtle pond/butterfly decoration preserve the existing hit areas, offline-only save contract, break prompts, and parent settings. No downloaded assets or copyrighted character art are used.
