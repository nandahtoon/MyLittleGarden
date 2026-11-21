# 3D-first native technical architecture

**Status:** proposal, no 3D implementation. **Core stack:** existing Godot 4/GDScript, Blender, GLB/glTF, GitHub Actions, offline Godot Resources/JSON saves; Kotlin only for separately approved Android platform integration. iPad is a later Mac/Xcode validated build, not assumed.

## Baseline constraints
- Preserve old scenes/main.tscn, scripts/garden_game.gd and scripts/save_store.gd with their v1 save migration contract during transition.
- Engine presently validated in CI as Godot 4.4.1 with Compatibility rendering. An emulator branch has tried a later Godot version and different software renderer; it does not prove a safe engine-wide upgrade. Version changes require a separate compatibility experiment on emulator and physical devices.
- Use one native Godot project. **3D-first** means design new gameplay as 3D rather than writing new 2D adventure to translate later. The legacy 2D garden can remain only **temporarily** inside the native project while 3D gameplay and save migration are validated. The final 3D production build must exclude superseded 2D scenes/art and duplicate logic under LEGACY_2D_CLEANUP_PLAN.md.
- No internet permission, external SDK, personal identifier, server, accounts or telemetry for MVP.

## Proposed module ownership (new paths, not claims of existing files)
- game/core: flow coordinator, dependency boundaries, features/scene routing.
- game/domain: deterministic mission state, companion abilities, inventory/placement (only if approved), learning contracts, choice history.
- game/worlds: instanced bounded worlds; WorldState stores **semantic IDs and actions**, not raw scene node paths.
- game/characters: character models/controllers, animation state machines, ability interfaces.
- game/presentation: 3D scenes, camera rig, world interactions, audio/particles and performance tiers.
- game/ui: touch controls, subtitles, pictograms, Rest, parental settings, accessible hints.
- game/content: Resource schemas for world/mission/puzzle/companion definitions; authored and versioned, with validators.
- game/services: SaveService with v1 read support plus forward migrations, localization and optional local event debug mode. Child usage telemetry not permitted by default.
- tests: unit tests for mission/save/domain, smoke scene launch, screenshot goldens, scripted touch integration.
New files should use clear scene/script naming; avoid one huge orchestration script.

## Data flow
Input (touch/keyboard) → Input Adapter → Gameplay Action → Domain Rules → World State → Snapshot/Save; Rendering/Camera/Audio observe approved state changes. Domain Rules never directly depend on on-screen UI widgets or device-specific input positions. Missions are declarative; 3D scene adapters translate state consequences into visual effects.

## Mission content contract (example proposal)
Fields: mission_id, version, world_id, prerequisite_ids, supported_age_band, narrative_beat, child_goal, available_approaches, learning_intent, interaction_targets, gentle_hints, success_predicate, world_effects, safe_stop_point, localization_keys, visual/audio-accessibility alternatives, automated_test_case. A mission must be replayable from a clean fixture and tested on a saved state.

## Save and compatibility
Current v1 fields must be loaded without loss. V2 may add a namespace containing world facts, mission completions, garden links and companion unlocks. Use migration v1→v2 and corruption fallback with safe reset requiring parental confirmation. No child name, photo, voice, birthday, device identifier, precise location or online profile.
Save acceptance: cold start, resume, force close, version upgrade, interrupted write, backup/recovery and deterministic world-visual replay. Use an atomic file-write strategy where feasible.

## Mobile performance and asset budgets — proposed, validate on named devices
- First tested target: Android 10+ tablet/phone class to be selected after device inventory; product target is a decision, not Godot's global minimum requirement.
- Baseline: 30 FPS sustained as design target on entry supported device; frame time, p95 stutter and memory measured during scene traversal. Establish actual numeric limits from first instrumented prototype.
- Prefer Compatibility renderer while proving low-end performance. Compare Mobile/Vulkan only in a separate tech decision; avoid renderer-specific visual dependencies early.
- One bounded zone loaded at a time, occlusion/culling, mesh LOD/instancing, baked lighting where suitable, limited particles, reduced-motion, resolution scaling and texture compression.
- Blender assets: original source .blend kept versioned per asset workflow, optimized GLB/glTF export with controlled units, origin, collision hull, materials, rig, LOD and animation names. Never treat concept image as rigged model.
- Standard automated artifact: Godot headless import, domain tests, Android debug APK, install/smoke on emulator where reliable, screenshots/logs; physical Android QA gate separately.

## Technical decision records
Record ADR for: engine upgrade, renderer, target Android versions, 3D camera style, movement type, input accessibility, save v2, world content schema, dependencies/licenses, AI use and optional backend. Each record states alternatives, evidence, risks, user approval and rollback.

## Verification by layer
Unit: deterministic action rules, mission branching, hints, save migration.
Integration: touch inputs, camera, animation, **temporary** legacy Garden ↔ 3D scene transition, final 3D-home cutover, pause/Rest, migrated save, and clean exported asset inventory.
Device: Android real device FPS/thermals/long-play/offline/sleep-resume and accessibility; iPad separately.
Visual: inspect actual Godot renders, not concept art. PR must label mock screenshots versus running game evidence.

## Official references
- https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
- https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html
- https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
