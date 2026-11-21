# 3D-first delivery roadmap — scoped outcomes and gates

**Plan date:** 2026-11-21. **Status:** proposal; not an implementation report. **Goal:** one honest, child-safe, playable Android 3D slice before scaling content. AI implements; human product owner approves risky decisions and store publication.

## Dependencies and priority
Baseline QA (#9 emulator, #7 real Android, #8 iPad, #3 acceptance) and documentation (#11) are independent existing tracks. They cannot be marked complete from a successful APK export. The existing 2D MVP remains releasable only after its own acceptance.

New 3D work package prefix **LW3D** avoids collision with existing 2D M0–M5 backlog. Use topic branches and small PRs. A 3D task must not redefine v1 navigation or overwrite in-flight PR #11's GAME_DESIGN/AGENTS files.

## Stage / increment matrix

| ID | Stage & outcome | Minimal deliverable | Hard evidence gate | Status |
|---|---|---|---|---|
| LW3D-G0 | Governance and discovery | Baseline audit, repo 3D docs, owner risk decisions, device list | Documents reviewed; CI & open PRs refreshed; no code claims | PLANNED |
| LW3D-T1 | Technical spike | Blank 3D zone, controllable placeholder actor, guided camera, touch mapping | Debug APK runs on actual target Android; 30 FPS goal measured, not assumed | PLANNED |
| LW3D-A1 | Character art | Original Nova rigged GLB, idle/walk/run/jump/wave/interaction animations | Godot import, visual QA, performance and asset license register | PLANNED |
| LW3D-C1 | Reusable core | Input adapter, action rules, world state, versioned save adapter | Unit tests, legacy v1 Garden/Save regression, automated crash-free smoke | PLANNED |
| LW3D-V1 | Vertical slice | Rainbow Forest micro-world; one two-solution shape bridge mission, hints, Rest, return to Garden | E2E mission + persistent change after restart + actual Android touch | PLANNED |
| LW3D-U1 | Usability iteration | Onboarding, legible HUD, reduce motion, subtitles, accessible camera | Short caregiver-supervised playtest, documented confusion fixes | PLANNED |
| LW3D-B1 | Closed beta | 5 authored missions; Nova + only extra companion justified by tests; sound/graphics prefs | Device matrix, save upgrades, learning observation, no unresolved P0/P1 | PLANNED |
| LW3D-W2 | Creative expansion | Garden/Home builder, local Living Storybook, repeatable workshop modules | Asset, content, safety and recovery test suites; creative freedom confirmed | PLANNED |
| LW3D-W3 | New worlds | Terra/Aqua/Pip, Tinker Valley, Ocean Cove, then Observatory | Mission schema reused without new engine rewrite, art/QA gates per world | PLANNED |
| LW3D-R1 | Commercial Android | Signed AAB, target-age/data policy, parental gates, store assets | Human publication sign-off, legal/privacy review, real-device QA | BLOCKED ON APPROVAL |
| LW3D-R2 | iPad native | Same content, iPad control/safe areas, Xcode signing, Apple Kids review | Mac/Xcode signed install and physical iPad acceptance | BLOCKED ON TOOLS/APPROVAL |
| LW3D-X1 | Optional future features | Bilingual audio, local co-play, optional parent purchases or content packs | Separate ADR, parent/legal/accessibility approval; never implicit | IDEA ONLY |

## Critical path
1. Refresh branch/CI and resolve source-of-truth overlaps with PR #11; continue PR #9 without a competing emulator implementation.
2. G0 and Android hardware/device capability determination.
3. T1 placeholder-camera-input spike **before** expensive 3D model work.
4. A1 Nova prototype + C1 state/save contract in independent, non-overlapping PRs.
5. V1 complete mission + Android visual/device QA.
6. U1 child-and-caregiver observation and iteration before full world expansion.
7. B1 closed beta; only then commit substantial content art production and monetization discussions.

## Work package specification (mandatory)
Every issue/PR includes: ID, player outcome, implemented vs proposed, files/modules owned, owner and dependencies, allowed actions, privacy/age impact, technical approach, unit/integration/device QA, exact acceptance checks, performance/asset impact, save migration, localization, rollback, estimated scope band and decision blockers. Avoid vague 'improve UI' tickets.

## Release and test gates
- **G0:** current 2D user flows and saves not degraded; approved 3D architecture and target devices.
- **G1:** real Android native 3D interaction, camera stability, 30 FPS *target* evidenced on specified low-end test class; no claim of tested on other devices.
- **G2:** one first-to-finish mission, at least two methods, early Rest, audio optional, deterministic result and reopen persistence.
- **G3:** at least 5 authored missions, model/content QA, automated and human-device test coverage, parent-approved supervised UX results, no severe unresolved accessibility defect.
- **G4:** child privacy/legal/store compliance, IAP monetization decisions if any, release signing, target SDK, Play Console disclosures, owner review; only then distribution.
- Each gate uses Pass / Fail / Not Run with links, not arbitrary percentages. Missing device evidence => NOT RUN.

## Rollback and dependency safety
- Use a feature scene/flag for new 3D content, leaving v1 garden path accessible.
- Version new saves; keep a tested old-format migration path. Provide recovery from interrupted writes.
- Pin toolchain; change versions in an isolated ADR and comparison PR.
- Revert failed PRs and preserve evidence; never silently redefine an acceptance test to make it green.
- Don't fold a blocked policy decision into unrelated gameplay work.

## Release candidate checklist
Exact git tag/SHA; CI run links; APK/AAB checksums; export/Godot/Android SDK versions; license inventory; 3D asset provenance; cold install/update/resume/offline; representative real Android model; accessibility/reduced-motion/audio/localization; safe area; restart/save; privacy policy/store metadata; parent approval; rollback release artifact.
