# AGENTS.md — MyLittleGarden

Repository: https://github.com/nandahtoon/MyLittleGarden
Source of truth: origin/main. Scope: Little Wonder Garden only.
Read README.md, docs/DESIGN.md and docs/REPOSITORY_POLICY.md first.
Never work in or copy code from unrelated MicroOps/RDMS repositories.
Prefer Godot 4.x GDScript, offline-first, simple scenes and no external SDKs.
Do not infer that Android/iPad builds or child UX tests have passed. Record actual evidence.
Never change account/privacy/ads/cloud model, add trackers or submit an app store release without explicit user authorization.
Preserve save-file compatibility; introduce migrations when the save schema changes.
No child identifiers, photos, audio recordings, secrets or real child data.
Before PR: run python tools/validate_structure.py and perform Godot headless import and manual device tests when available. State unavailable checks clearly.
