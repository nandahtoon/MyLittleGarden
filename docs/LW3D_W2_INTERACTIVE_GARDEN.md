# LW3D-W2 — Interactive garden beds and natural obstacle collision

**Status:** additive W2 QA branch stacked on W1. Not merged into production/main. Physical Android/iPad child QA not yet verified.

## Changes built
- Four separate 3D vegetable beds in the southwest/east garden field. Each starts as bare soil, and offers context-sensitive PLANT → WATER → WATER controls from the existing right-hand action button.
- Actual bundled Kenney GLB carrot and pumpkin crop models scale from sprouts to mature plants; seed uses a tiny colored sphere. The four plot stages are independent and restore on next app launch.
- The older Rainbow Bridge puzzle (triangle vs. seed) remains; gardening is available **even after** the bridge mission is completed.
- Trees and large rocks have simple StaticBody3D / CylinderShape3D collisions sized to the objects. Small flowers, grass and mushrooms intentionally have no collision, to avoid trapping children.
- Each vegetable bed has a collider, while the rolling terrain and cottage continue to use W1 collisions.
- Offline sidecar save: `user://lw3d_garden_plots_w2.json`. Version 1 schema: `{"version":1,"plots":[0,0,0,0]}`, valid stage 0..3; clamped/sanitized, written via temporary file + rename. Does **not** touch the old 2D garden save `user://little_wonder_garden.json` or the existing Rainbow mission save.
- Godot headless checks cover grow/persist/restart, nearby action, collider existence, crop models and existing mission behavior.
- Separate Android QA debug APK uses unique test package `io.github.nandahtoon.mylittlegarden.rainbow.w2` to avoid replacing prior W1 APK.

## How to play
1. Checkout W2 branch with Godot 4.4.1 Compatibility; open `scenes/worlds/rainbow_forest_v1.tscn` and use F6. F5 is intentionally still the old 2D game.
2. Use the joystick to find the four small soil beds in the decorative farm area, around X=9..11, Z=-8..-9.
3. Approach a bed: yellow action changes from LOOK to PLANT. Tap once to add a seed.
4. The action becomes WATER; tap twice on separate presses to grow a vegetable. Progress saves immediately.
5. Walk to another bed; each has its own independent growth state. Try restarting the scene and returning.
6. Try the original Rainbow Bridge mission as well to verify no regressions.

## Safety, accessibility, testing and outstanding issues
- No identities, ads, accounts, telemetry, network dependencies or child personal data.
- Plots show contextual English labels; localized narration, accessibility and actual child playtesting are later milestones.
- World decorations mostly remain non-collidable by design; only large trees and rocks now have approximated cylinder obstacles. Fence and pond collision behavior require real-device evaluation. Avoid adding more colliders before checking that all routes remain accessible.
- Android headless/CI success does **not** prove real device graphics, multitouch comfort, FPS/thermals or iPad build quality.
- Test code deletes only its W2 fixture save in CI; do not run destructive fixture tests against a real player's user data directory.
- W2 is stacked on W1 PR #21 -> U1 #20 -> V1 #18 -> T1 #16. Merge only in dependency order after checks/physical QA and explicit authorization. **No** production/main cutover, replacement of 2D game, user-data migration, or Play Store release in this PR.

## Asset license
Reuses the 16 locally bundled Kenney CC0 glTF 3D models from W1. See `docs/LW3D_W1_GARDEN_WORLD.md` for precise provenance and CC0 terms.
