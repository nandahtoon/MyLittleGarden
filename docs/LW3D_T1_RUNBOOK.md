# LW3D-T1 Native 3D proof of concept — runbook

Status: Experimental standalone Godot 3D scene, not an approved release. Issue #14. Godot 4.4.1, GDScript, Compatibility renderer.

## Launch in the Godot editor
1. Check out feature branch feat/lw3d-t1-native-spike-20261121 and open project.godot with Godot 4.4.1.
2. Open scenes/prototypes/lw3d_spike.tscn and press F6 (Run Current Scene). F5 intentionally retains the current 2D Garden.
3. Desktop: W/A/S/D or arrows for movement, SPACE for jump, E near the gold beacon to LOOK. Mouse on-screen controls also work.
4. Android touch: drag left joystick; tap JUMP, LOOK, REST, GARDEN. Try moving and pressing action with separate fingers.
5. The gold beacon changes a bridge from grey to mint. This interaction is deliberately non-persistent. GARDEN returns to existing 2D garden without modifying saved data. REST toggles a calm pause.

## Install the isolated Android test APK
1. Open the exact feature-branch commit's GitHub Actions workflow named LW3D-T1 Native 3D prototype.
2. Confirm native-3d-scene-smoke and android-3d-test-apk jobs succeed at the exact commit.
3. Download the artifact LW3D-T1-native-debug-APK and install on a test Android device.
4. The CI runner temporarily changes only its local copy of project.godot and export_presets.cfg to launch the 3D scene using the separate Android package io.github.nandahtoon.mylittlegarden.spike. The GitHub source and original installed app remain unchanged.
5. Debug signing is ephemeral: APK upgrades may require uninstall/reinstall. Do not use this artifact for in-place save upgrade, Google Play or child beta distribution.
6. This test APK still exports all resources, including old 2D files. The final 3D-only package cleanup belongs to Issue #15 after replacement and save migration.

## Physical Android test checklist (all NOT RUN until evidenced)
- [ ] Actual GPU-rendered scene/screenshot on named Android model and OS; do not call headless logs device evidence.
- [ ] Joystick move, jump, camera tracking, beacon interaction, bridge material, REST and GARDEN work without stuck touches.
- [ ] Multitouch move + jump/action verified.
- [ ] Landscape safe areas, legibility, thumb reach, reduced-motion needs and comfortable camera checked.
- [ ] Offline use, background/resume and cold restart without crash checked.
- [ ] Measured sustained FPS, stutter, memory and thermals noted on the device; 30 FPS is a provisional target, not a passed result.
- [ ] Existing main 2D app and local v1 garden saves remain unchanged.
- [ ] Record PASS / FAIL / NOT RUN, commit SHA, Action run link, screenshot and rollback.

## Scope / limitations
This is a native 3D engine and touch feasibility spike: a procedural placeholder robot and one bounded island. It is not the final Nova GLB, game-ready animations, educational first mission, persisted 3D-world state, commercial artwork or a release candidate. No accounts, analytics, child identifiers, network service or new permissions.

## Owned files
- scripts/prototypes/lw3d_player.gd: CharacterBody3D and toy placeholder mesh.
- scripts/prototypes/lw3d_touch_hud.gd: touch UI, Rest and Garden.
- scripts/prototypes/lw3d_spike.gd: 3D world, camera, input integration, beacon.
- scenes/prototypes/lw3d_spike.tscn: standalone Godot scene.
- .github/workflows/lw3d-prototype.yml: headless validation and test-only 3D APK.
See docs/3D_START_HERE.md and docs/LEGACY_2D_CLEANUP_PLAN.md on PR #12; no 2D legacy removal before Issue #15 gates.
