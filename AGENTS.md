# AGENTS.md — Little Wonder Garden

**Canonical origin:** https://github.com/nandahtoon/MyLittleGarden.git
**Canonical integration branch:** `origin/main`
**Project scope:** Little Wonder Garden only. Do not work in other projects or copy from MicroOps/RDMS.

## Mandatory startup for any new chat or AI developer

1. Read [START_HERE](docs/START_HERE.md) **first**, then [Repository Policy](docs/REPOSITORY_POLICY.md).
2. Read [Game Design](docs/GAME_DESIGN.md), [Screen Flow](docs/SCREEN_FLOW.md), [screen contract](docs/contracts/screen-flow.v1.json), [Storybook Bible](docs/STORYBOOK_BIBLE.md), [Work Packages](docs/WORK_PACKAGES.md), and relevant source files.
3. Query **live** current `main`, issues, open PRs and workflows; documentation's snapshot is not live status. Existing [PR #9](https://github.com/nandahtoon/MyLittleGarden/pull/9) owns the Android emulator diagnostic work—do not duplicate it.
4. Choose **one** unblocked, reversible package with nonoverlapping file ownership. A new screen or story idea is not automatically approved code.
5. Implement code, contract, docs and tests together; run `python tools/validate_structure.py` and `python tools/validate_design_contracts.py` plus Godot import and targeted device tests when possible.
6. Open a PR with exact SHA, actual commands/results, screenshots where visual verification is required, risks and rollback. **No merge of failing required checks.** Mark unavailable tests as NOT RUN rather than PASS.

## Non-negotiable product and privacy boundaries

- Ages approximately 4–7; offline-first calm storybook sandbox. No pressure, scores, streaks, ads, IAP, account, tracking, chat, child recordings, or network SDKs.
- No child identifiers, names, photos, voice, real child data, production passwords, keystores or signing material in Git or CI logs.
- Do not change child privacy/business model or publish Play/App Store releases without explicit authorization.
- Preserve version 1 offline save compatibility; any save format change needs a migration + tests before merging.
- Android CI APK success is **not** real-device pass. iPad requires macOS/Xcode, signing and real iPad QA; do not claim evidence without it.
- The parent gear 2.5-second hold is still an **unresolved emulator QA case** as of the handoff snapshot. Treat design and runtime claims separately.
- Art concept/mockups do not count as screenshots of exported runtime.
- Use Godot 4.x and native exports. Production version/renderer changes require targeted comparative evidence and review.

**Next person entrypoint:** [docs/START_HERE.md](docs/START_HERE.md). All project knowledge belongs in this repo, never only in chat.
