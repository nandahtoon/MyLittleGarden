# AI Developer Governance — accountable autonomous delivery

**Edition:** 2026-11-21. **Status:** proposed governance for MyLittleGarden 3D-first track. **Owner model:** AI tools do 100% of routine coding, tests, docs and PR preparation when authorized, but a responsible human owns product, data, licensing, monetization, child safety and publication decisions. There is no continuously running agent unless independently configured and authorized.

## Authority hierarchy
1. Binding platform law, child safety, secrets/licensing and repository policies.
2. Product owner explicit decisions recorded as ADRs/issues.
3. root AGENTS.md and repository policy, current main code/contract.
4. Approved 3D docs and active work-package acceptance. If a newer direction conflicts with a v1 product contract, record transition rather than overwriting it.
5. Prior chat, screenshots and AI suggestions are contextual **not proof**.

## AI-only engineering roles — logical responsibilities, not guaranteed separate agents
- **AI Director/Integrator:** read latest repo, dependencies, scope, choose one safe work unit, maintain ADRs and release board, detect overlaps.
- **AI Gameplay Engineer:** Godot scene/action/mission systems, save compatibility, domain tests; cannot grant itself privacy or commercial approval.
- **AI 3D Artist/Technical Animator:** Blender originals, character GLB, rig and LOD, animation and provenance/licensing manifest.
- **AI UI/Accessibility Designer:** child touch targets, stable camera, learnability, Rest, reduced-motion, captions, audio feedback.
- **AI QA/Release Engineer:** reproduce behavior, CI and device matrix, inspect actual visual artifacts and crash logs, issue stop/go evidence.
- **AI Independent Reviewer:** reason about spec/code/privacy contradictions, security, asset copyright and regressions without assuming tests passed.
- **Human Owner:** resolves RED choices and signs store publication. AI reviews do not substitute for human/parent supervised child UX validation or platform/legal judgment.

A single AI may act in several logical roles, but must explicitly distinguish code author from reviewer, and **cannot label self-generated opinions independent proof**.

## GREEN / AMBER / RED action policy
| Class | AI may proceed without fresh user approval? | Examples |
|---|---|---|
| GREEN | Yes, inside a scoped branch/PR with test evidence | research, code analysis, docs, isolated synthetic sample scenes, unit tests, lint, fix reproducible defect without schema/security changes |
| AMBER | Analysis/prototype allowed; integration requires specified evidence/owner decision | renderer/engine upgrade, large 3D art import, new traversal system, save schema migration, target age expansion, new 3D world scope |
| RED | Stop before action; human approval required | store publish/paid release, ads/IAP/analytics SDK, cloud or account/child data, camera/mic/voice recording, external APIs, public chat/multiplayer, child-facing AI conversations, large third-party asset license, destructive save migration, signing secrets |
Automatic merge is never justified solely because the same AI wrote and reviewed a PR. Any red decision may be researched and documented independently without taking the blocked action.

## Standard autonomous developer loop
1. **Discover:** fetch current main SHA, root policies, open issues/PRs/workflows, actual device evidence; distinguish DONE vs proposal vs unknown.
2. **Select:** one earliest independent unblocked scoped work package, assign owner boundary and risk class. Avoid PR #9/#11 path overlap.
3. **Research:** use official docs/policy for niche, changing rules; log URLs, checked dates, alternatives and uncertainty in research register.
4. **Plan:** acceptance tests and rollback before editing; confirm no save/schema break, privacy scope or child-facing manipulation.
5. **Implement:** new topic branch, one coherent reversible increment; assets must be original/licensed; maintain Godot/GDScript style and explicit contracts.
6. **Validate:** run structural validation, headless import/smoke, domain/integration and relevant Android jobs; inspect exact-head CI and actual on-device captures when required.
7. **Review:** an adversarial review pass for assumptions, accessibility, privacy, supply chain, test gaps, visual coherence and introduced effects; record evidence.
8. **PR:** provide links, test outputs, exact SHA, before/after, scope and rollback. Never hide failed checks or merge to bypass gates.
9. **Integrate:** only an authorized integrator may merge after gates; release only after user/owner approval and platform checks. On blocker, record precise reason and move to safe independent work.
10. **Learn:** update findings and tests, decisions, documentation and prioritized queue after evidence; avoid churn and speculative rewrites.

## Mandatory PR evidence template
- Work package / issue / current base SHA / exact head SHA / changed files.
- Design status: planned | implemented | tested-on-emulator | tested-on-real-device | released.
- Gameplay & 3D demo evidence: screenshots/video captured from actual game, or explicitly labeled mockup.
- Test grid: static, Godot import, unit, Android export, emulator, physical Android, iPad, accessibility; **Pass/Fail/Not Run** each.
- User impact: what child can now do; age band, learning, difficulty and exit path.
- Safety: offline/data/permissions, parental controls, third-party assets/SDK, educational claims.
- Regression: old 2D garden paths and v1 save fixtures.
- Performance: measured device details, FPS/thermals, crash evidence where relevant.
- Risks, decisions, blockers, reviewer findings and rollback link.

## Merge guardrails — recommendations to configure in GitHub
- Protected main branch and mandatory PR; block force-push and deletion.
- Required successful status checks: static validator, Godot headless, Android debug export; after stabilization, emulator gameplay smoke and mission/save regression.
- Minimum independent review where feasible, code-owner review for save/privacy/ci and 3D asset licenses. GitHub rulesets must be configured/verified by repository owner; this doc does **not** turn them on.
- CI least-privilege token permissions, pinned action revisions after controlled audit, no secrets printed or committed; debug signing is ephemeral and cannot silently become production signing.
- No direct AI force-merge, no skipped failing checks, no releasing from an unverified commit.
- Evidence must match *exact* final commit and build identifier, not a past green run.

## Child-safe AI requirements
- The developer AI may generate deterministic code/assets, documentation and offline content. Generative model output must be reviewed for copyright, quality and age appropriateness.
- No open-ended generative chatbot for a child in MVP, no collecting children's voice, photos or identifiers, no behavioral advertising/profiling, no unsolicited push reminders, no fear-of-missing-out rewards.
- No adult account/purchases flow embedded inside child gameplay.
- Adult long press is a convenience barrier and must not be represented as legally sufficient age verification. If regulated adult gating is required, separately design and verify it.
- Playtesting requires caregiver permission and minimal anonymized notes; no child identifiers or recordings in issue trackers.
- Learning scores should not be silently transmitted. Progress is stored locally.

## Incident policy
P0 = child safety/privacy breach, lost saves, public release/data exposure: stop release, quarantine branch, owner escalation, preserve secure minimal evidence and remediation. P1 = crashes, broken control, severe accessibility defect: block merge/release. P2 = visual/content polish: prioritized iteration. Do not claim monitoring detects events unless a mechanism is connected.

## Decisions and change control
Every material change gets ADR: context, decision class, owner approval reference if needed, options, sources checked and date, benefits, risks to 2D and 3D, migration, tests, rollback, review date. Review quarterly and before each release; policy sources must be rechecked at time of publication.

## Non-negotiable stop conditions
Unverifiable real-device claim, missing external approval, failing critical CI, unlicensed/unknown copyrighted 3D assets, personal child data exposure, unreviewed external AI/network feature, save corruption without recovery, unexplained renderer crashes. A truthful BLOCKED report is a valid outcome.
