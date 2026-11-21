# LW3D-U1 — Child Touch UI/UX and Character Motion QA

**Status:** Implemented on an isolated stacked branch; physical Android and child testing are NOT RUN. Depends on Rainbow Forest PR #18 and 3D Foundation PR #16. No production/main switch, 2D cleanup or store release.

## Scope / reasons
Older prototype HUD was designed around a single screen resolution, long one-line hints, generic LOOK action. The original skinned Nova model did not follow character yaw/bob. Holding the keyboard E action repeated every frame, accidentally completing both steps of the plant/water educational mission.

## Improvements delivered
- Rainbow-specific responsive HUD and controls: mission goal + contextual hint, optional '?' HELP, MATCH/PLANT/WATER/LOOK, large joystick and JUMP, HOME and REST overlay.
- Virtual stick canceled when entering Rest or losing window focus.
- The real Nova glTF scene follows CharacterBody3D facing and subtle bob while playing Idle, Walk and Wave clips.
- One keyboard E hold is one action; rapid accidental touch taps are throttled, so planting and watering require separate deliberate interactions.
- No telemetry, child identifiers, accounts, paid features, tracking, ads or external services.

## Files
- scripts/ui/rainbow_child_hud.gd — responsive child HUD, same input API as original T1 only.
- scripts/gameplay/rainbow_forest_v1.gd — prompt and animation facing, action gating.
- tools/lw3d_v1_test.gd — legacy mission tests updated to model distinct deliberate actions.
- tools/lw3d_u1_test.gd — joystick/rest/help/context/scene/visual facing/headless regression.
- .github/workflows/lw3d-u1-child-ux.yml — headless CI plus distinct-package test Android APK.

## QA instructions
1. Checkout the branch with Godot 4.4.1 Compatibility; open scenes/worlds/rainbow_forest_v1.tscn with F6, not F5 (which intentionally still starts old 2D main).
2. Review latest exact-head workflow LW3D-U1 Child UX and Native QA; two jobs must pass.
3. Download the restricted GitHub Actions artifact LW3D-U1-child-ux-Android-APK and extract the APK for a supervised device test. Unique Android package ID io.github.nandahtoon.mylittlegarden.rainbow.u1 prevents replacing the original Garden or older public V1 preview.
4. On the Android device walk with left joystick, JUMP, LOOK or PLANT/WATER, test help and Rest, watch actual model facing; verify saved Rainbow Mission after restart.
5. Record actual Android model class / Android version without identifying device IDs, FPS/thermal/memory and actual screenshots. CI build is not a substitute for physical testing.

## Test matrix
- [ ] Godot import, headless world scene and both mission routes and save / reload at exact SHA.
- [ ] Layout and button separation in 1280x800 and 640x360 landscape.
- [ ] Rest cancels held joystick and allows intentional resume; HOME exits without corrupting save.
- [ ] Context changes to PLANT and WATER near seed and MATCH near triangle.
- [ ] Actual Nova model faces direction of movement, not fixed world heading.
- [ ] Keyboard E hold and accidental double tap do not skip growth.
- [ ] Debug APK builds separately and has valid SHA-256.
- [ ] Physical Android displays correct scene/animations and touch UI without clipping; no crash/ANR in logs; pause/resume and 30 FPS provisional target measured.
- [ ] Older 2D game/source/screens/save unchanged.
- [ ] Parent/caregiver UX observation with permission and no child identifying data.

## Limitations
This work is an iterative prototype. Not tested on physical Android or iPad yet, not ready for production/main cutover and not a full native 3D commercial game. No audio narration, formal accessibility certification, final 3D Garden or advanced original animation yet. The existing public V1 short link points to the older QA preview, not the new U1 build. Legacy cleanup is gated by Issue #15 and the governance rules of PR #12.

## Next
Android real device verification, visual/animation polish from screenshots, then Terra companion and 3D Garden Builder only after first world quality gates are proven.
