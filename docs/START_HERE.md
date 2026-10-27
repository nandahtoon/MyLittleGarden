# START HERE — Durable project handoff for any AI developer or new chat

**Repository / canonical origin:** https://github.com/nandahtoon/MyLittleGarden.git
**Integration branch:** `origin/main`
**Scope:** Little Wonder Garden only. **Date of this checkpoint:** 2026-10-27. **Source commit inspected:** `78b5c8ecc4be6c6c97e52d62e7290b5fa602cf9a`. Status details are a snapshot, not live—always re-query GitHub before starting.

> This is the first file a new AI developer or ChatGPT session should read. Chat content, ZIPs and mockups are **not** source of truth. Never say you completed a run you didn't verify. Continue from GitHub state, not an old transcript.

## 1. Read sequence (mandatory)

1. **[AGENTS.md](../AGENTS.md)**: boundaries and agent behavior.
2. **[REPOSITORY_POLICY](REPOSITORY_POLICY.md)**: canonical origin, PR/review, secrets and child-data safety.
3. **[GAME_DESIGN](GAME_DESIGN.md)**: product intent, pillars, implemented/proposed split, acceptance and risk.
4. **[SCREEN_FLOW](SCREEN_FLOW.md)** and [machine flow contract](contracts/screen-flow.v1.json): exact screens, events, state graph and hit areas.
5. **[STORYBOOK_BIBLE](STORYBOOK_BIBLE.md)** + [ART_DIRECTION](ART_DIRECTION.md): original world, content, palette and SVG assets.
6. **[DESIGN](DESIGN.md)** + [QA](QA.md): earlier engineering snapshot and device test requirements.
7. **[WORK_PACKAGES](WORK_PACKAGES.md)**: work packages, ownership boundaries, milestones and evidence.
8. Relevant `scripts/`, `scenes/`, `assets/`, `project.godot`, export preset, GitHub Actions workflows, open PRs, issues and current CI logs.

**Doc ownership policy:**
- `GAME_DESIGN.md` defines game goals, scope, release gates.
- `SCREEN_FLOW.md` and JSON are the normative **navigation, input and stage contract**.
- `STORYBOOK_BIBLE.md` is normative for original creative writing/art direction; optional features are proposals.
- `DESIGN.md` is an engineering MVP snapshot; do not blindly treat old unchecked QA boxes as live status.
- GitHub Actions + linked runs provide evidence of tests, and [Issue #3](https://github.com/nandahtoon/MyLittleGarden/issues/3) tracks unresolved native device acceptance.
- Code controls **actual current implementation**. If code and normative contract disagree, record a gap; fix by PR with tests, not by pretending either is verified.

## 2. Confirmed product state vs unknowns (as of this checkpoint)

| Area | Verified evidence | Remaining |
|---|---|---|
| Canonical source | `main` has four-screen Godot 4.x starter, garden logic, save, audio and original SVG art (PR #10 merged) | No public store launch |
| Android APK | `main` Android debug build and source/headless checks successful at `78b5c8ec`; [Android run](https://github.com/nandahtoon/MyLittleGarden/actions/runs/40448089799) | Real ARM tablet installation and acceptance pending |
| Android emulator | On **isolated PR #9** test runner using Godot 4.7.2 and `-gpu swangle`, screenshot evidence shows actual Welcome/Garden/Sprout/Flower/Rest; seed/water/save/restart/sound assertions passed in [run 40450371655](https://github.com/nandahtoon/MyLittleGarden/actions/runs/40450371655) | End-to-end test **failed** at parent gear long press; intermittent emulator startup failure in some runs; this is **not** proof the current 4.4.1 `main` APK works visually |
| Parent settings | Implemented in code; source contract uses 2.5s hold and double-tap reset | Emulator not fully passing; [PR #9](https://github.com/nandahtoon/MyLittleGarden/pull/9) remains open |
| iPad | Source architecture designed for shared Godot code | No signed Mac/Xcode iPad export or device acceptance |
| Child UX | Original, no score, no ad/account/cloud design | No actual parent-supervised child observation result |

**Recent root-cause evidence / precise unresolved question:**
- Earlier emulated Godot 4.4.1 x86_64 runs crashed with `SIGILL` in `libgodot_android.so` or showed splash/grey. Main APK builds do not verify runtime.
- A **separate** Godot 4.7.2 + Swangle emulator-only build produced verified illustrated frames; changing Godot and renderer simultaneously **does not isolate a single root cause**. Do not change `main` engine version just from that.
- [PR #9 latest failed run 40451931289](https://github.com/nandahtoon/MyLittleGarden/actions/runs/40451931289) includes CI-only logs `LWG_CI_GEAR_HIT` with transformed touch positions near `(1206,57)`, but no `LWG_CI_PARENT_OPEN`; thus touches arrive in the gear, while the 2.5-second hold transition remains unverified. Check the press/move/release/timer flow instead of just guessing tap positions.

**Safe next debugging increment:** instrument `_press`, `_move_touch`, `_release` and `_process` hold state over time; test a repeatable held-touch event with proper Android event timing, compare with a real tablet and avoid masking failure. Preserve failure screenshots/logcat, do not merge PR #9 until full QA passes or clearly reduce its scope to a diagnostic-only PR.

## 3. How to start a new developer session

Clone the exact canonical origin, then inspect remote state:

```bash
git clone https://github.com/nandahtoon/MyLittleGarden.git
cd MyLittleGarden
git remote -v
git fetch origin --prune
git checkout main
git pull --ff-only origin main
git rev-parse HEAD
git status --short
python tools/validate_structure.py
```

If GitHub CLI is available:

```bash
gh pr list -R nandahtoon/MyLittleGarden --state open
gh issue view 3 -R nandahtoon/MyLittleGarden
gh run list -R nandahtoon/MyLittleGarden --limit 10
```

Before touching the emulator workflow, inspect PR #9's **latest** head, jobs and logs. This handoff is a snapshot, so these can be newer than the links above. Run the Godot headless CI version declared by the workflow; Android/iPad exports require the matching installed templates and SDKs. Never claim device testing from a CI source check.

## 4. Parallel work and agent boundaries

Use **one integrator** and at most one writer for any file/branch. Work packages in [WORK_PACKAGES](WORK_PACKAGES.md) can run in parallel when they touch disjoint files:

| Role | Owns | Does not do |
|---|---|---|
| Product / Storybook | `docs/GAME_DESIGN.md`, `STORYBOOK_BIBLE.md`, original art briefs | Quietly add new mechanics |
| UX / Screens | `docs/SCREEN_FLOW.md`, matching JSON and screen tests | Change save schema without migration |
| Gameplay | `scripts/garden_game.gd`, scene interaction logic, focused PR | Modify live privacy/currency/store policies |
| Native/QA | `.github/workflows/`, emulator scripts, debug export, evidence | Mark physical devices tested without a real run |
| Integrator | Scope, GitHub issues, PR review, doc/code consistency and decisions | Force-merge failing tests or rewrite `main` |

If overlapping files or an existing active PR have the same outcome, coordinate in that PR instead of creating duplicate implementations. Avoid “autonomous churn”: one reversible increment with observed outcome at a time.

## 5. Standard work loop / evidence model

**Discover → decide → implement → validate → document → PR → check exact-head CI → merge only when safe.**

1. Read `origin/main`, `AGENTS.md`, project bible and relevant open PR/issue. Decide what is fact, proposal or unverified.
2. Pick a single GREEN (safe, clear) work package. If a decision is needed (new world, child privacy, store release, expensive assets, engine-wide change), mark AMBER/RED and limit work to research/design.
3. Use `feat/`, `fix/`, `test/` or `docs/` branch from the latest `main`. Work within one ownership boundary.
4. Modify code, docs and contracts together. Include `save_store.gd` migration if persisted schema changes.
5. Run static validator, Godot import/headless smoke, targeted emulator/device tests when available. Record **commands and exit states**, specific output/captures, commit SHA, versions, and unresolved checks.
6. Open PR linked to issue and work package. Do not treat old CI runs for a different SHA as evidence; inspect the PR's **exact head** and `main` after merge.
7. Merge only after passing required checks with credible visual evidence; update `QA.md` and Issue #3 if relevant. Stop and report an explicit blocker if tests aren't possible.

**Evidence record template (copy into PR comment):**

```yaml
repo: nandahtoon/MyLittleGarden
base_branch: main
head_sha: "<exact GitHub commit SHA>"
work_package: "M1-... or D-..."
change: "..."
implemented_vs_proposed: "implemented | docs_only | experiment"
checks:
  structure: "pass/fail/not-run + command/link"
  godot_import: "pass/fail/not-run + version"
  android_apk: "pass/fail/not-run + workflow URL"
  emulator_render: "pass/fail/not-run + screenshot artifact and platform"
  parent_long_press: "pass/fail/not-run + input trace"
  android_tablet: "pass/fail/not-run"
  ipad: "pass/fail/not-run"
risk: "..."
rollback: "revert PR / documented procedure"
open_blockers: ["..."]
```

No child name, photo, recording, device serial, email, private account data, keystore or secret in CI evidence.

## 6. A paste-ready request for another ChatGPT / AI developer

> Work only in `https://github.com/nandahtoon/MyLittleGarden` and treat `origin/main` as canonical. First read `AGENTS.md`, `docs/START_HERE.md`, `docs/GAME_DESIGN.md`, `docs/SCREEN_FLOW.md`, `docs/contracts/screen-flow.v1.json`, `docs/STORYBOOK_BIBLE.md`, `docs/WORK_PACKAGES.md` and the latest open PRs, Issue #3 and CI. Do not assume the snapshot status is current. Respect calm/child-safe offline rules, save schema and one-writer-per-file governance. Choose one unblocked coherent work package, implement in a new topic branch or coordinate with the existing PR owner, run actual checks and inspect exact-head CI. Provide evidence, update contracts/docs, and submit a PR. Do not claim emulator/physical tablet/iPad acceptance without verification, do not merge failing checks or publish to stores. Report blockers precisely.

## 7. Decision log and current priorities

| Priority | Outcome | Acceptance | Status at handoff |
|---|---|---|---|
| P0 | Reliable Android emulator launch and **all** UI interactions including Parent | FLOW-01..07 green on same test head; screenshots show storybook art | Open PR #9; partial pass + parent failure |
| P1 | Align new design docs/contracts and QA tests | GDD, Screen Flow, Storybook Bible, Work Packages versioned in main | Documentation change in progress on this handoff branch |
| P2 | Real Android tablet user test | Actual ARM APK, sound, safe area, touch/save/parent tested | Not verified |
| P3 | iPad native build | Mac + Xcode and actual iPad install | Not verified |
| P4 | Optional microstories/Pond/Builder | Separate user-approved design/contract after base works | Ideas only |

**Human approval required** for cloud, children’s data, recording, ads, payments, new third-party SDKs, store submission, new world scope or a permanent unsupported engine/toolchain switch. Routine reversible documentation/tests and local synthetic assets can proceed in scoped PRs.
