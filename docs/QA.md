# QA and Acceptance — Little Wonder Garden

The GitHub repository is the only source of truth. A green source/engine check **does not**
establish that exported Android or iPad apps work on hardware.

## Source and engine
- [x] Offline-first Godot source, nine garden plots, sound assets and local save code are in GitHub.
- [x] Repository structural validation passed on the original source-import commit.
- [x] Godot 4.4.1 headless editor import and launch passed on canonical main (see GitHub Actions at `78b5c8ec`).
- [ ] Desktop Godot editor visual inspection is completed.
- [x] On isolated PR #9 using Godot 4.7.2 + Swangle, actual Welcome/Garden/Flower and Rest emulator screenshots rendered: [run 40450371655](https://github.com/nandahtoon/MyLittleGarden/actions/runs/40450371655). **Experimental configuration only; not yet accepted for main or any physical device.**
- [ ] Check child-accessible target contrast/typography and correct clipping on common tablets.

## Android tablet
- [x] Android debug APK exported successfully on canonical main: [run 40448089799](https://github.com/nandahtoon/MyLittleGarden/actions/runs/40448089799). This is NOT real tablet or emulator acceptance.
- [ ] Install on an actual Android tablet; verify touch, drag, sound and volume.
- [ ] App suspend/relaunch restores plants, settings and sound preference.
- [ ] Check 4:3, 16:10 and 16:9 scaling and system navigation insets.

## iPad
- [ ] Export/build/sign via macOS + Xcode and install on iPad.
- [ ] Confirm taps, drags, audio, safe areas, rotation and suspend/restart.

## Child-centered experience
- [ ] Run a 5–10 minute parent-supervised child play session.
- [ ] Confirm no flashing, surprises, urgency, scores or forced engagement.
- [ ] Check grown-up hold 2.5s, two-confirmation reset and gentle break prompts.
- [ ] Verify no child data, analytics, ads, purchases or network calls.

## Release readiness
Do not publish to stores, or commit child identifying information, signing keys
or production credentials, without separate review and explicit authorization.

## Emulator and cross-agent handoff checkpoint — 2026-10-27

- **PASS in isolated emulator runs:** actual illustrated Welcome, 3×3 Garden, flower, Rest; synthetic seed/water/bloom, audio toggle and save/restart. These screenshots were collected using a Godot 4.7.2 + `-gpu swangle` test configuration, **not** canonical 4.4.1 APK runtime acceptance.
- **FAIL still open:** parent long-press 2.5-second trigger. [Latest analyzed failing run 40451931289](https://github.com/nandahtoon/MyLittleGarden/actions/runs/40451931289) has `LWG_CI_GEAR_HIT` events with correct transformed coordinates but no `LWG_CI_PARENT_OPEN`. Instrument press/move/release/timer and real Android hold behavior on [PR #9](https://github.com/nandahtoon/MyLittleGarden/pull/9); do not merge until checked or narrowed to diagnostics.
- **Intermittent engine/emulator startup issue:** older Godot 4.4.1 x86_64 runs crashed with SIGILL or blank frame; newer experimental mode sometimes exits at startup. Do not attribute to one root cause without controlled evidence.
- **NOT RUN / unverified:** ARM physical Android tablet, real iPad/Xcode build, parent-child supervised session, full accessibility/device scaling. Never claim these based on an APK export.
- Handoff: [START_HERE](START_HERE.md), [SCREEN_FLOW](SCREEN_FLOW.md), [Game Design](GAME_DESIGN.md), [Storybook Bible](STORYBOOK_BIBLE.md), [Work Packages](WORK_PACKAGES.md).
