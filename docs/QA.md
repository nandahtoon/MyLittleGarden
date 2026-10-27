# QA and Acceptance — Little Wonder Garden

**Status snapshot: October 27, 2026.** This is not live CI. Read [START_HERE](START_HERE.md), [SCREEN_FLOW](SCREEN_FLOW.md) and [Issue #3](https://github.com/nandahtoon/MyLittleGarden/issues/3), then inspect current commits/PRs/runs before claiming success.

The **canonical repository** is the sole source of truth. Static/engine/build passes do not prove a real child can use the app safely. Use PASS, FAIL and NOT RUN with concrete evidence; never manufacture progress percentages.

## 1. Verified versus outstanding

| Check | Current evidence | Result |
|---|---|---|
| Project structure + 8 SVG plant assets | GitHub source and original static validation runs on main | PASS, code-level |
| Godot headless import/launch | Successful headless workflow on main; consult current Actions tab for exact head | PASS, headless only |
| Android 4.4.1 debug APK export | [main branch CI run 40448089799](https://github.com/nandahtoon/MyLittleGarden/actions/runs/40448089799) | PASS, export only |
| Storybook Welcome/Garden/flower/Rest on Android emulator | [isolated run 40450371655](https://github.com/nandahtoon/MyLittleGarden/actions/runs/40450371655), Godot 4.7.2 + Swangle | Observed, **not** full acceptance |
| Android emulator full parent-flow smoke | [open PR #9](https://github.com/nandahtoon/MyLittleGarden/pull/9), last examined head contained `LWG_CI_GEAR_HIT` but no Parent open | FAIL (not merged) |
| Real Android ARM tablet | No supervised test evidence | NOT RUN |
| Real iPad (Xcode signed native build) | No native device evidence | NOT RUN |
| Parent–child 5–10 minute play | No anonymous session feedback on record | NOT RUN |
| App-store privacy compliance / public distribution | No release approval | NOT RUN; do not ship |

**Caveat:** Godot version, GPU mode and ABI changed between emulator experiments; isolated rendering success does **not** prove one root cause or guarantee 4.4.1 `main` builds work on hardware. Parent hold must be diagnosed separately.

## 2. Automated and contract checks

- `python tools/validate_structure.py`: offline source/project/audio/SVG checks.
- `python tools/validate_design_contracts.py`: relative documentation links, v1 four-screen navigation/garden states, flower references, parent rules and local save consistency. **Static only**.
- `godot --headless --path . --import`, then `godot --headless --path . --quit-after 30` with matching engine/tools.
- `Android debug APK` workflow: export and artifact archive, not physical installation.
- `Android emulator smoke` PR #9: APK + real emulator screenshots/state assertions. Must finish green before marking emulator acceptance.

Log the **exact Git commit**, workflow URL, engine version and artifact/screenshots. Never use screenshot previews from unrelated heads as release proof. Don't commit children's identities, recordings or serials.

## 3. Native acceptance checklist

| ID | Android emulator | Physical Android | Physical iPad | Evidence required |
|---|---|---|---|---|
| FLOW-01 | Open | NOT RUN | NOT RUN | Launch foreground, real Welcome & Garden screenshot, no home/grey splash false pass |
| FLOW-02 | Partly passed in isolated run | NOT RUN | NOT RUN | Seed, sprout, flower and all nine beds including drag |
| FLOW-03 | Sound state passed; audible volume unknown | NOT RUN | NOT RUN | Pond cue, mute works, no surprises |
| FLOW-04 | Rest visual observed; timed reminder not yet verified | NOT RUN | NOT RUN | Voluntary and timed entry, return without lost save |
| FLOW-05 | **FAIL** | NOT RUN | NOT RUN | 2.5-second hold must open visibly; short press must not |
| FLOW-06 | NOT RUN end-to-end | NOT RUN | NOT RUN | 5/10/15 options, double reset, cancel safely |
| FLOW-07 | Restart save passed in isolated run | NOT RUN | NOT RUN | Relaunch, background/resume, airplane/offline |
| FLOW-08 | 1280×800 emulator capture only | NOT RUN | NOT RUN | 4:3 / 16:10 / 16:9 safe area & text legibility |
| FLOW-09 | Export only | NOT RUN | NOT RUN | Installed native Android ARM and signed iPad binaries |

Attach evidence to Issue #3 or an appropriate linked PR. Build artifact links may expire; design docs should remain durable.

## 4. Child-centered test protocol (only when hardware works)

With a parent present, spend no more than a voluntary short 5–10-minute exploratory session; the child can stop at any moment. Without making any video/voice recording, anonymously note whether the child recognized the big Play button, found Plant and Water, noticed the flower, used/accepted Rest, and whether sounds or visuals seemed overstimulating. Avoid asking leading questions and avoid collecting names, photos, dates of birth, health/diagnosis details or identifying information.

Do **not** infer “calming” benefits from a screenshot or one session. Adjust controls, pacing and sensory load based on observation.

## 5. Release gate and escalation

Do not publish, distribute as a child-ready release, add analytics/network/accounts, or commit signing credentials. Never present 4.4.1 build success as a full Android device pass. Coordinate native emulator QA on existing PR #9; if it is flaky, retain failure logs and scope any workarounds explicitly to CI until comparative evidence supports a production change. New features/Pond/Builder require separate approval and updated game/screen contracts.
