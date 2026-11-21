# Little Wonder Garden — 3D-first AI delivery entrypoint

**Plan edition:** 2026-11-21, strategy v2.0. **Status:** proposed planning artifacts; no 3D implementation or approved store release is implied. **Canonical origin:** https://github.com/nandahtoon/MyLittleGarden ; integration branch main.

## Read in this order
1. Root AGENTS.md and docs/REPOSITORY_POLICY.md — live repository boundaries remain binding.
2. Existing docs/DESIGN.md and docs/QA.md; if PR #11 has merged, read docs/START_HERE.md, GAME_DESIGN.md, SCREEN_FLOW.md, STORYBOOK_BIBLE.md, WORK_PACKAGES.md. These describe the **existing 2D baseline**, not a completed 3D build.
3. This index and 3D_PRODUCT_STRATEGY.md — new product direction and differentiation.
4. 3D_TECH_ARCHITECTURE.md — shared native engine and module ownership.
5. 3D_RELEASE_PLAN.md — dependencies, release gates, and scoped work packages.
6. AI_DEVELOPMENT_GOVERNANCE.md — permissions, approval matrix, evidence and agent loop.
7. RESEARCH_AND_MONITORING.md — research register, monitoring checks, learning experiments and review cadence.
8. Refresh actual GitHub issues, PRs, current main SHA, workflows and exact-head CI results. These are the current source of truth for implementation status.

## Important coexistence and precedence rule
The 2D garden remains a functioning baseline and historical v1 behavior. 3D-first is the **approved product direction**, not a claim that scenes, assets, controls or schema already exist. Do not replace the older v1 navigation, save contract, docs or tested flow with hypothetical 3D text. Preserve current game behavior until a separate approved, tested 3D implementation PR ships. Where contracts conflict, raise a decision record and migrate intentionally. PR #11 (documentation/handoff) and PR #9 (emulator QA) were open when this plan was authored: coordinate rather than writing the same files.

## Baseline evidence snapshot — must be refreshed
- Repository main inspected: 78b5c8ecc4be6c6c97e52d62e7290b5fa602cf9a (2026-10-27). Verify again before work.
- Existing scenes/main.tscn, scripts/garden_game.gd, scripts/save_store.gd, 2D SVG assets, Android debug export, Godot headless CI.
- Open PR #9: Android emulator smoke test, unresolved end-to-end parent hold at last documented checkpoint. Open PR #11: 2D game bible and cross-agent handoff.
- A successful APK export does not prove device acceptance; physical Android and iPad tests remain separate.
- Current codebase versioned v1 local save has plots[9], sound_enabled, break_enabled, break_minutes; new 3D state must not break it.
- Engine and renderer policy: current build pins Godot 4.4.1, Compatibility. Do not opportunistically upgrade based on an isolated emulator experiment; evaluate change with a compatibility matrix.

## Delivery principle
One reversible, vertical, evidenced work package per PR. No overlapping writers on the same path or branch. All new 3D code starts behind a separate scene entry/flag, with the 2D fallback intact. Human owner explicitly approves scope expansion, data, money, toolchain switch, licenses and store submission. AI can implement and propose; AI cannot claim independent physical testing or human approval.

## Start prompt for the next AI developer
Work only in nandahtoon/MyLittleGarden. Read AGENTS.md, REPOSITORY_POLICY.md and the 3D documents linked in docs/3D_START_HERE.md. Refresh main, open PRs/issues and CI. Preserve current 2D gameplay and versioned save. Select the earliest unblocked 3D work package in 3D_RELEASE_PLAN.md. Do one coherent reversible increment on a topic branch, with code, test, docs, rollback and exact-head evidence. Never merge on failing checks or publish a store build. Do not add child telemetry, accounts, ads, voice recording, third-party services or payments without owner approval and child-safety/privacy review. End with DONE / WORKING / BLOCKED, link, SHA, tested vs untested, next safe action.
