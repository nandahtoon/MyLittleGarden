# AGENTS.md — MyLittleGarden

Repository: https://github.com/nandahtoon/MyLittleGarden
Source of truth: origin/main. Scope: Little Wonder Garden only.
**MANDATORY start:** Read docs/START_HERE.md, docs/GAME_DESIGN.md, docs/SCREEN_FLOW.md, docs/contracts/screen-flow.v1.json, docs/STORYBOOK_BIBLE.md, docs/WORK_PACKAGES.md, docs/REPOSITORY_POLICY.md, then README.md, docs/DESIGN.md and latest open PRs/Issue #3/CI. Do not work from stale chat summaries.
Never work in or copy code from unrelated MicroOps/RDMS repositories.
Prefer Godot 4.x GDScript, offline-first, simple scenes and no external SDKs.
Do not infer that Android/iPad builds or child UX tests have passed. Record actual evidence.
Never change account/privacy/ads/cloud model, add trackers or submit an app store release without explicit user authorization.
Preserve save-file compatibility; introduce migrations when the save schema changes.
No child identifiers, photos, audio recordings, secrets or real child data.
Before PR: run python tools/validate_structure.py and perform Godot headless import and manual device tests when available. State unavailable checks clearly.

## Durable handoff and cross-agent governance

- Every new AI chat or developer begins at [docs/START_HERE.md](docs/START_HERE.md), queries live GitHub, and selects one package in [docs/WORK_PACKAGES.md](docs/WORK_PACKAGES.md).
- Canonical normative contracts: [docs/SCREEN_FLOW.md](docs/SCREEN_FLOW.md) and [docs/contracts/screen-flow.v1.json](docs/contracts/screen-flow.v1.json) for screens/input; [docs/GAME_DESIGN.md](docs/GAME_DESIGN.md) for gameplay/scope; [docs/STORYBOOK_BIBLE.md](docs/STORYBOOK_BIBLE.md) for art and writing.
- Preserve **current vs proposed vs verified** labels. A concept illustration is not an emulator capture, an APK build is not tablet QA, and one passing subtest is not a green end-to-end run.
- At most one writer to an overlapping feature/file/branch. Coordinate ongoing Android emulator work on existing PR #9; do not create a duplicate QA implementation or change the production engine version from an isolated experiment.
- Use topic branches and linked PRs, inspect **exact-head** CI and acceptance artifacts, update normative docs when behavior changes. Do not merge knowingly failing tests; docs-only changes can merge on static/docs verification without pretending device QA passed.
- Required checks before changing docs and flow contracts: `python tools/validate_structure.py` and `python tools/validate_design_docs.py`; record Godot import/native checks truthfully where relevant.
