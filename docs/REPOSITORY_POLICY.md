# Repository policy — MyLittleGarden

## Source of truth and origin

- **Canonical Git remote:** `https://github.com/nandahtoon/MyLittleGarden.git`
- **Canonical repository:** `nandahtoon/MyLittleGarden`
- **Integration branch:** `main`
- This repository, not chat attachments, ZIP archives or a local folder, is the authoritative source for source code, game design, build documentation and reviews.
- Work locally by cloning this repository and using `origin` for this URL. Do not treat another repository as upstream or source of truth.
- For nontrivial changes, use a topic branch + pull request, with build/QA evidence. Do not rewrite published `main` history.
- Never commit passwords, signing keys, keystores, certificates, identifying information about children, recordings or real child data.
- Any prototype or mockup must be labeled as such; do not call a static mockup an actual engine screenshot or claim native builds are tested until verified.
- Do not add SDKs, analytics, ads, accounts, cloud sync, chat or network permissions without explicit approval and a child-safety/privacy review.
- Favor calm interactions and offline-first persistence. No paywalls, scores, streaks or retention pressure.
- Keep `docs/DESIGN.md` and `README.md` aligned with implemented features; append QA evidence when tests have actually run.

## Development workflow

1. Pull latest `origin/main`, review open issues and design before changes.
2. Make one small cohesive, reversible change in a topic branch.
3. Run `python tools/validate_structure.py`, import the project in Godot and perform appropriate device QA.
4. Submit a PR describing changes, checks performed, unverified areas and risks.
5. Merge only after checks/review. Export/installable builds are a separate validated milestone.

## Platform export

- Windows/Linux editor can develop/test and export Android APK/AAB with the appropriate SDK, Java and Godot export templates.
- iPadOS signing and installation require macOS + Xcode and the appropriate Apple credentials.
- `main` currently contains **prototype source**, not published store-ready Android/iOS binaries.
