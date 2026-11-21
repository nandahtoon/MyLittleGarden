# MyLittleGarden — Pull Request evidence checklist

**Work package / linked issue:** <!-- LW3D-T1 or existing v1 issue -->
**Target branch:** main
**Exact head SHA:** <!-- update after final push -->
**Change category:** <!-- docs / gameplay / 3D art / save / CI / privacy / release -->
**Status:** <!-- Proposed | Implemented | Emulator verified | Real Android verified | iPad verified | Released -->

## Player outcome / scoped change
What can the child or parent do after this PR that they could not do before? What remains intentionally out of scope?

## Safety, privacy and permissions
- [ ] No child identifiers, photos, recordings, secrets or personal test data in code, logs or screenshots
- [ ] No new account, analytics SDK, ads, tracking, cloud, microphone, camera, chat, purchases or notifications; **if any are proposed, mark RED and link explicit human approval**
- [ ] No coercive engagement loops, streaks or pressure-based rewards
- [ ] New assets are original or have auditable license/attribution and commercial reuse rights
- [ ] Child-accessible controls, easy Rest/exit, appropriate feedback and accessible alternatives reviewed

## Contracts and compatibility
- [ ] Existing 2D Garden, controls, and v1 save behavior preserved or migration and regression tests supplied
- [ ] Gameplay, mission content contracts, UI states, architecture and docs updated for any actual change
- [ ] Godot version/renderer unchanged, or comparison ADR, device evidence and owner decision linked
- [ ] No overlap with active PR writer on the same files or behavior

## Evidence at this exact SHA
| Check | Pass / Fail / Not Run | Link / evidence / reason |
|---|---|---|
| Source/static checks | | |
| Godot import/headless smoke | | |
| Unit/integration/mission/save tests | | |
| Android debug APK export | | |
| Android emulator gameplay/screens | | |
| Physical Android touchscreen/performance | | |
| iPad/Xcode physical test | | |
| Accessibility/reduced motion/audio | | |
| Child/caregiver observation (if relevant) | | |

**Measured device/OS/Godot/renderer/FPS/memory:** <!-- no fabricated results -->
**Screenshots:** <!-- clearly label actual game captures versus concept art -->
**Known failures / blockers / not-run checks:**
**Risk classification:** GREEN / AMBER / RED
**Owner approval reference for AMBER/RED:**
**Rollback procedure:**

## Integrator / reviewer sign-off
- [ ] Latest PR head checks reviewed, not an earlier green commit
- [ ] Product-design and child-safety inconsistencies checked
- [ ] No failing P0/P1 condition hidden or bypassed
- [ ] Merge authorized; publication is a separate explicit owner decision

See docs/3D_START_HERE.md, docs/AI_DEVELOPMENT_GOVERNANCE.md and docs/3D_RELEASE_PLAN.md. For current 2D scope, AGENTS.md and docs/REPOSITORY_POLICY.md remain binding.
