# Legacy 2D audit and 3D-only production cutover

Status: PLANNED / source-backed audit (2026-11-21). NO original 2D files deleted yet. Snapshot main SHA: 78b5c8ecc4be6c6c97e52d62e7290b5fa602cf9a. Refresh before implementing.

## Product decision
Future **production app is 3D-first**. Do not ship a permanently duplicated 2D and 3D game. Preserve the current playable 2D baseline until its 3D replacements, native testing and save migration are verified. Record an immutable/recoverable historical Git tag BEFORE deleting legacy source. Do NOT move unused 2D assets into an in-project archive folder: the current Android export uses all_resources and might still package them.

## Audited file-to-decision matrix

| Current main location | Observed facts | Immediate action | Eventual 3D production action |
|---|---|---|---|
| project.godot / scenes/main.tscn | One Node2D main scene running garden_game.gd | KEEP | One verified 3D boot/main entry; switch via controlled PR |
| scripts/garden_game.gd | 539 lines; draws four screens and handles input, 9 plots, parent, rest and audio | KEEP until replacement | Remove after 3D game/parent/Rest validated; no duplicate controllers |
| garden_game.gd dead candidates | _draw_flower has no call sites in inspected file. COLOR_CREAM, COLOR_GROUND, COLOR_GREEN, COLOR_WATER only have declarations | FLAG, not delete merely for tidiness | Delete with scoped test or as part of gated legacy removal |
| scripts/save_store.gd | v1 local JSON with plots[9] and parent preferences | KEEP | Reuse/migrate old saves with v1-to-v2 fixtures, interruption recovery; no silent reset |
| assets/art/ (8 SVG) | All eight are loaded by current scene | KEEP | Replace with original 3D visuals, remove only after no runtime references |
| assets/audio/ (4 WAV) | All four are referenced by game | KEEP | Reuse if suitable or replace; remove unused after dependency scan |
| docs/garden-screen-preview.svg and screen-flow.svg | Concept/docs assets, required by existing validator | KEEP | Archive through Git history/tag after 3D docs and tests replace them |
| README, AGENTS, docs/REPOSITORY_POLICY | Existing onboarding and rules; PR #11 edits README/AGENTS | KEEP / NO CONFLICT | Reconcile one 3D authoritative entrypoint after PR #11 and #12 reviews |
| docs/DESIGN, ART_DIRECTION, BUILD, QA | Historical 2D product/design/QA | KEEP labelled v1 | Preserve history via Git tag; current 3D docs become authoritative once cutover approved |
| .github/workflows and tools/validate_structure.py | CI explicitly tests 2D scene, garden file and eight SVGs | KEEP | Update at SAME COMMIT as 3D scene switch, replacing assertions with 3D + migration tests |
| export_presets.cfg | App package ID io.github.nandahtoon.mylittlegarden and debug signing | KEEP | Preserve identity for in-place upgrades, validate signed updates and package resource exclusions |
| .gitignore | Excludes Godot caches, builds and secrets | KEEP | Review during release artifact audit |
| PR #9 | Existing emulator QA with previous parent long-press blocker | DO NOT COLLIDE | Resolve from actual evidence before ending baseline verification |
| PR #11 | Existing 2D game bible/handoff/contract proposal | DO NOT COLLIDE | Reconcile documents after review; do not silently rewrite its v1 contract |
| PR #12 | 3D design/governance PR | This cleanup spec belongs here | Merge only after review and exact-head CI; currently docs only |

Conclusion: the SVG/WAV art and garden entry are NOT currently unused; deleting them now breaks the only runnable game. Inspected dead-function/constant candidates are not proof of device-level removal safety.

## Anti-confusion source of truth
- IMPLEMENTED NOW = legacy 2D source on main and v1 save.
- PROPOSED = 3D architecture, Nova and Rainbow Forest, 3D product release plan.
- ARCHIVED = immutable old v1 git tag after created, not a second Android build or an in-project archive.
- Only one production main scene, one game state/mission service and one versioned save contract.
- AI must classify each planned change as keep/reuse/replace/archive/delete with exact file list and impact.
- 3D-first does not mean converting the old 2D art automatically into rigged 3D models.

## Clean target (proposed, NOT created)
- scenes/boot.tscn : single native entry
- scenes/worlds/wonder_home_3d.tscn and rainbow_forest_3d.tscn
- scenes/characters/nova.tscn
- scripts/core, gameplay, characters, ui and services
- assets/models : original, licensed, optimized Blender/GLB assets
- assets/audio : referenced sounds only
- content/missions : declarative authored mission definitions
- tests : save migrations, domain logic, scene, touchscreen and native QA
- docs : one active 3D game bible plus historical revision links

## Replacement-driven cleanup sequence
C0. Refresh main / PR #9 / PR #11 / PR #12. Baseline runtime/tests. Record what references each file, collect v1 save fixtures, and make recoverable tag only when authorized and verified.
C1. Create isolated 3D technical spike and 3D boot prototype without changing current entry or deleting the old game.
C2. Implement 3D Garden/Rest/Parent equivalents and mission/world-save; test v1-save import, corrupt file, restart, background/resume and rollback.
C3. In one controlled PR switch the app to ONE 3D entry; update 2D-specific CI assertions and docs in that same PR, with 2D regression evidence before removal.
C4. In a separate reversible PR delete now-obsolete 2D source, 2D-only art, preview resources and duplicated UI from active tree after an export-resource reference inventory.
C5. Analyze release APK/AAB content: no old 2D assets/scenes or prototype models, unused SDKs, embedded secrets, debug test-only assets; compare output hash/size and real device behavior.
C6. Mark legacy issues and docs archived with links; do not close or merge older QA PRs without precise disposition and evidence.

## Release cleanup gate (all mandatory)
- [ ] Recoverable v1 baseline tag exists and exact SHA is recorded.
- [ ] One production entry point and nonduplicated game logic/controls.
- [ ] No obsolete 2D resources in exported 3D APK/AAB; evidence from actual artifact inspection.
- [ ] New 3D source import, automated mission/end-to-end tests and native Android QA pass at exact head.
- [ ] Existing user v1 save is migrated safely or explicitly owner-approved incompatibility documented.
- [ ] Parent settings, Rest, touch, audio and accessibility behavior kept/replaced with test evidence.
- [ ] No 2D-specific tests deceptively green by disabling them; they are replaced with meaningful 3D tests.
- [ ] Assets have original/commercial-rights provenance; no redundant placeholders, trackers or unnecessary permissions.
- [ ] One active game design document, screen flow and AI-agent handoff; historical docs clearly version-marked.
- [ ] Cleanup change is separate from Godot engine/renderer upgrades and monetization/store publication.
- [ ] Exact commit CI links, real device tests, asset manifest and rollback evidence reviewed.

## Work package ownership
- LW3D-C0 (GREEN): dependency map, v1 baseline fixture and reviewed archival plan. Git tag action only after verifying owner policy.
- LW3D-C1 (AMBER): ready-to-cutover 3D runtime, controller, 3D garden/parent, mission, migrated save.
- LW3D-C2 (AMBER; blocked on C1): production entry switch, obsolete file deletion and coordinated test rewrite.
- LW3D-C3 (RED at public release): signed Android artifact, clean resource inventory and store/privacy approval.
Treat deletion as justified by replacements and tests, NOT by filename alone. Every AI PR must list file ownership, actual test results (PASS/FAIL/NOT RUN) and rollback.
