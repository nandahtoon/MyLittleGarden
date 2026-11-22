# LW3D-W1 — Garden World & CC0 Nature Models (QA prototype)

**Status:** Implemented in additive branch `feat/lw3d-w1-garden-world-20261121`; not merged into main; not validated on real devices or children.
**Base:** PR #20 (LW3D-U1) -> PR #18 (LW3D-V1) -> PR #16 (LW3D-T1). Existing `main` starts the original 2D Garden on F5 by design.

## Actual additions

- `scripts/worlds/garden_world_w1.gd` is called by the existing Rainbow Forest mission scene; its terrain mesh **replaces** the T1 giant flat GrassIsland.
- Deterministic gently rolling hills built as a 32x32 grid of vertices, vertex-colored with greens and a physics trimesh collision surface. Mission triangle, circle, seed bed, rainbow bridge and Nova spawn areas remain level.
- Cottage with solid walls, decorative roof, door and windows; shallow decorative pond with rocks; branching stepping-stone trails; small vegetable patch; flower clusters, mushrooms, bushes, grass, trees and fences.
- **16 genuine bundled GLB model files**, placed as many instances. All models are local and require no gameplay network access.
- `tools/lw3d_w1_world_test.gd` verifies model imports, non-flat terrain, safe mission landings, collision, landmarks, Nova and marker preservation.
- `.github/workflows/lw3d-w1-garden-world.yml` does Godot import/mission regression and separately packages a unique-id **QA-only** Android debug APK. This is not a Play Store release.
- Does not change old 2D garden, original v1 save format, accounts, child data, ads or networking.

## Third-party asset provenance and commercial use

The following assets are by **Kenney** from **Nature Kit**, under **CC0-1.0** (public domain dedication). Source pack: https://kenney.nl/assets/nature-kit . Copied self-contained GLB exports from the CC0 pack mirror https://github.com/Hidencod/tge-assets/tree/main/packs/nature-kit after matching source blob SHAs. Each item remains in `assets/models/kenney_nature/<name>.glb`.

- Trees: `tree-oak`, `tree-default`, `tree-oak-fall`, `tree-cone`
- Plants: `plant-bush`, `plant-bushdetailed`, `grass`, `flower-purplea`, `flower-yellowa`, `flower-reda`
- Details: `rock-largea`, `rock-smalla`, `mushroom-redgroup`, `fence-simple`
- Farming: `crop-carrot`, `crop-pumpkin`

CC0 permits adaptation and commercial use without required attribution, but we credit Kenney here for provenance. Do not mix unverified licensed packs into the game; review individual asset license and source before committing any future model.

Quaternius Ultimate Stylized Nature is also a promising CC0 candidate, but **not imported** into this PR: https://quaternius.com/packs/ultimatestylizednature.html . Poly Pizza licenses vary by model, so none were imported.

## QA / how to see it

1. With Godot 4.4.1 Compatibility renderer, open the **W1 branch** and let the 16 bundled GLBs import.
2. Open `res://scenes/worlds/rainbow_forest_v1.tscn` in Godot and run **F6**. F5 still launches the unchanged old 2D entry point.
3. Try third-person movement/jump, Rest, Home, shape-match mission, separate plant and water actions. Visually inspect grass, trees, pond, cottage, path, terrain mesh, animation and overlapping controls.
4. Run `python tools/validate_structure.py`, then `godot --headless --path . --import` and `godot --headless --path . --script tools/lw3d_w1_world_test.gd` plus both V1/U1 existing regression scripts.
5. After a green exact-head GitHub workflow, download the Android debug QA APK from the action's artifact. Its temporary package ID is `io.github.nandahtoon.mylittlegarden.rainbow.w1`, avoiding overwriting original/older QA builds.
6. Physical Android QA still required: real rendering, performance, collision seams, scene obstacles, camera comfort, multitouch, audio, suspend/resume, thermal/memory. iPad/Xcode and adult-supervised child playtests also not yet performed.

## Important limitations / W2 candidates

- Garden rocks, trees, crops, fences, pond water and steps are primarily scenery. Terrain and cottage walls have collisions, but **all** decorative GLBs do not yet have individual collision shapes. Verify safe paths on a device before claiming full navigability.
- The shallow pond and extra vegetable beds are decorative; planting/watering still occurs in the existing mission bed. New interactions, animals, map transitions, interactive farm plots and NPC schedules should be separate, testable increments.
- Terrain vertices/colors are deliberately low-cost and fixed for phone/tablet; W2 can add chunked terrain, gentle textures, audio ambience, richer bridge/pond art and a child-friendly map selector after W1 visual QA.
- No store readiness or physical-device quality claims are made by an automated/headless render alone.

## Reversal

Close/revert this stacked branch; the 2D game main and old save data are unchanged.
