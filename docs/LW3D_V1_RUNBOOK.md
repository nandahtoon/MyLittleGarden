# LW3D-V1 — Nova skinned model and first Rainbow Forest adventure

Status: IN PROGRESS, requires exact-head CI and real Android QA. Branch: feat/lw3d-v1-rainbow-nova-20261121. Base PR #16 (T1 scene/controls), not main.

## Experience
- One bounded, offline 3D forest with a rainbow bridge that has lost its colors.
- Two valid ways to help restore it:
  1. Shape solution: find the BLUE TRIANGLE matching the bridge. A nearby pink CIRCLE gently prompts a correction, without points, punishment or negative scoring.
  2. Nature solution: find the seed bed, LOOK to plant and LOOK to water, watching it grow.
- Mission completion changes bridge/forest colors and persists after a new game launch. Rest anytime or tap GARDEN to return to original 2D baseline during transition.

## Character asset facts
- assets/models/nova/nova.gltf: original real 3D embedded glTF scene (12 materialized mesh primitives, skin with 7 joints; Idle, Walk and Wave animation tracks).
- tools/pack_nova_glb.py converts this into a portable GLB model, checking binary buffer, skin and animations. GitHub CI includes a GLB artifact for reuse.
- Imported GLTF is instanced as NovaSkinnedModel; old T1 procedural placeholder visual hides only when real model loads. Idle, Walk and Wave state wiring added.
- Further art, rig quality, mobile performance and Blender authoring source refinements remain later work. The GLB is not a 2D concept image.

## Build and play
1. Use Godot 4.4.1 Compatibility; checkout this branch with PR #16 as its code base.
2. Open scenes/worlds/rainbow_forest_v1.tscn and press F6 (Run Current Scene). F5 still opens the old 2D main game intentionally.
3. Desktop W/A/S/D or arrow keys, SPACE jump and E interact; touch joystick on the left, LOOK/JUMP right, REST and GARDEN at top.
4. Try a circle (gentle hint), then blue triangle. In a clean progress fixture, use seed LOOK twice instead.
5. Restart the scene: the completed bridge remains colored.
6. Model export: python tools/pack_nova_glb.py assets/models/nova/nova.gltf build/assets/nova.glb.
7. GitHub Actions: LW3D-V1 Nova and Rainbow Forest workflow emits the model GLB artifact plus an isolated, debug-signed Android APK. CI runner temporarily changes only its checked-out local app main scene and package name to io.github.nandahtoon.mylittlegarden.rainbow; original repository project and package identity remain unchanged.

## Save, safety and limitations
- scripts/gameplay/rainbow_mission_save.gd creates user://lw3d_rainbow_progress_v1.json with mission ID, completion, solution and growth. It never touches original user://little_wonder_garden.json.
- JSON is local, no cloud, child profile, tracking, ads, external APIs or arbitrary AI chat. No invented educational-performance claims.
- Actual GLB visually imported and running on physical Android is **NOT VERIFIED** by headless tests; headless Dummy rendering can emit texture warnings.
- No 3D production world v2 save migration or original 2D cleanup yet. Those belong to Issue #15 and a controlled one-entrypoint cutover later.
- iPad/Xcode and physical tablet acceptance not established.

## Evidence gates
- Godot 3D scene loads and exact-head Mission Automated Test passes.
- Both approaches persist; wrong shape does not complete; v1 save untouched.
- CI emits 3D GLB binary and Android APK with distinct package; verify source SHA, hashes and artifacts.
- Android physical tests: actual scene screenshots, touch multi-finger, runtime crash check, 30 FPS *provisional target* measurement, suspend/resume, shader/material rendering, UI safe-area and child-facing accessibility.
- Do not merge production or publish publicly unless product owner reviews risks. This is a stacked draft PR against PR #16, and may be retargeted to main only after #16 merges and its checks rerun.
