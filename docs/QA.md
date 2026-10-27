# QA and Acceptance — Little Wonder Garden

The GitHub repository is the only source of truth. A green source/engine check **does not**
establish that exported Android or iPad apps work on hardware.

## Source and engine
- [x] Offline-first Godot source, nine garden plots, sound assets and local save code are in GitHub.
- [x] Repository structural validation passed on the original source-import commit.
- [ ] Godot 4.4.1 headless editor import and launch pass on the integration branch.
- [ ] Desktop Godot editor visual inspection is completed.
- [ ] SVG seed/sprout/six flower assets import and display on welcome/garden on emulator; check actual screenshot, not only saved state.
- [ ] Check child-accessible target contrast/typography and correct clipping on common tablets.

## Android tablet
- [ ] Export debug APK with Godot Android templates, SDK and JDK 17.
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
