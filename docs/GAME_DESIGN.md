# GAME DESIGN DOCUMENT — Little Wonder Garden

**Version:** GDD 1.0 (proposed baseline for implementation review). **Platform:** Godot native Android tablet + iPad. **Audience:** ages roughly 4–7, parent supervised. **Source of truth:** [repository policy](REPOSITORY_POLICY.md). Read with [SCREEN_FLOW](SCREEN_FLOW.md), [STORYBOOK_BIBLE](STORYBOOK_BIBLE.md), and [handoff](START_HERE.md). `DESIGN.md` documents the original MVP implementation snapshot; this file owns **product intent and future game rules**.

## 1. Vision, problem and success

**Vision:** a beautiful little storybook garden that responds to curious hands in gentle, predictable ways and makes stepping away easy.

**Player outcome:** in a short play session a child can independently notice a soil patch, plant, water a sprout to bloom, explore or take a rest—without points, a wrong answer, a task list or pressure to continue.

**Parent outcome:** the app feels age-appropriate, can run offline, can be muted, preserves a garden, and gives a gentle break option. The parent can supervise, change interval and clear data intentionally.

**Project outcome:** one version-controlled Godot source produces testable Android/iPad native builds with documented evidence and a development history another developer can reproduce.

**Not a medical or educational intervention:** do not market it as curing anxiety, ADHD, insomnia or emotional dysregulation. Use parent observations as UX feedback, not a clinical outcome.

## 2. Pillars / tradeoff rules

1. **Discovery over achievement:** bloom is a response, not an earned score.
2. **Predictability over random rewards:** the same action produces a clear result; flower species rotate by plot.
3. **Calm sensory feedback over spectacle:** mild audio, subtle motion, stable composition, mute always available.
4. **Independence with parent boundaries:** four readable screens and no complex onboarding; parent-only options are tucked away.
5. **Offline safety and ownership:** no account, ad, chat, purchases, metrics SDK, child identifier, external links in the child play area.
6. **Graceful exit:** Rest is always available, no penalty and no notification to return.

When a flashy or “gamified” idea competes with a pillar, the pillar wins unless the product owner explicitly approves an updated GDD.

## 3. Platform, inputs and presentation

| Property | MVP decision | Follow-up validation |
|---|---|---|
| Engine | Godot 4.x GDScript, shared native project | Version selected only after actual emulator/physical comparison |
| Primary devices | Android tablet; iPad | Native signed builds and touchscreen QA separately |
| Orientation | Landscape | Check Android system bars, iPad home indicator, safe-area and 4:3 |
| Reference canvas | 1280×800 | Uniform fit with coordinated input scaling, no clipped controls |
| Input | One-finger tap, forgiving drag; mouse desktop emulator | Test ADB touch and real fingers; multiple-touch conflicts not yet validated |
| Interaction time | No required duration | Parent-selectable gentle reminder, default 10 min; 5/15 options |
| Audio | Optional local seed/water/bloom/bird WAV | Confirm reasonable real-device volume; no autoplay |
| Save | `user://little_wonder_garden.json` version 1 | Reload, background/restore, corruption defense and migration before changes |

## 4. Current MVP mechanic — executable rules

**World:** one Garden with nine independently saved soil beds. **Tool:** Plant or Water, no inventory and no resource budget.

| Selected tool | Plot stage | New stage | Feedback |
|---|---:|---:|---|
| Plant | 0 | 1 seed | Quiet planting animation and local cue |
| Plant | 1, 2 or 3 | unchanged | “This little patch already has a plant.” |
| Water | 0 | unchanged | “Try planting a seed here first.” |
| Water | 1 | 2 sprout | Two small leaves, gentle water cue |
| Water | 2 | 3 flower | One illustrated flower, soft bloom cue |
| Water | 3 | unchanged | Flower remains, gentle rain cue |

Each plot's flower type is deterministic: plot index modulo six across cosmos, sunflower, tulip, daisy, poppy, bluebell. No hidden unlocks, quests, collectibles, badges, currency, timers, ads or unlock-screen interstitials.

**Micro-loop:** choose tool → act on one patch → see a small visible consequence → repeat if desired or take Rest. No external carrot or forced length.

**Non-plot interactions:** tapping the tiny pond plays a gentle bird cue if sound enabled; sound tool toggles saved setting; Rest can be entered at any time. Hold grown-up gear for 2.5 seconds, set sound/break interval, use two-step reset.

**Save invariant:** array length exactly nine in live state; each stage 0..3; fields `version`, `plots`, `sound_enabled`, `break_enabled`, `break_minutes`. The code clamps loaded stage values and interval. Test invalid/corrupt local JSON before calling it robust.

## 5. Teaching without instruction

MVP is not a formal curriculum. Child can discover “before/after,” noticing plant shapes and colors, hand-eye coordination and cause/effect. Do not include quizzes, grades, a progress tracker or a narrator who orders the child around.

First-time visit needs only three affordances:
- A dominant **Let's play** on Welcome.
- Illustrated **Plant** and **Water** action cards with very short labels.
- A distinct, tappable soil patch and immediate visual response.

One small contextual text cue can appear near the bottom, but gameplay must remain understandable if the child cannot read it or sound is off. For potential English/Myanmar narration, request language review and opt-in audio settings in a separate milestone.

## 6. Sensory design and accessibility

- No flashing, camera zoom surprises, abrupt screen transitions, hard punishments, rapid flashing rewards, or startling sounds.
- Stable background horizon and gentle movement; plan a **Reduce Motion** parent preference before adding more animation.
- Text must stay readable on an actual tablet; the fallback font in current code is a known polish item. Test at typical handheld viewing distances.
- Communicate active tool by icon/label + stripe/shape, not green alone. Include a visible focused/pressed state in future polish if feedback supports it.
- Keep Rest and Sound accessible inside the Garden and avoid gestures requiring precision. Parent gear should support a tested long-press but must not be mislabeled as real adult verification.
- Watch for sensory discomfort and disengagement during short parent-supervised sessions; respect the child's wish to stop immediately.

## 7. Scope and version gates

| Release stage | Included | Explicitly excluded | Go/no-go evidence |
|---|---|---|---|
| **M0 — design/source baseline** | 4 screens, 3×3 Garden, growth mechanic, eight SVG sprites, sound, local save, architecture/docs | New world, IAP, cloud, metrics | Contract and repo checks green; design review |
| **M1 — Android emulator acceptance** | Real illustrated screens, tap/drag, plant/water/bloom, sound, save, Rest and Parent flows | Publish/store | Emulator screenshots **and** automated tests from same commit; no crash |
| **M2 — Android tablet acceptance** | ARM APK install, touch/sound/suspend/safe-area/parent reset on physical tablet | Public release | Parent-supervised device checklist, anonymized screenshots |
| **M3 — iPad acceptance** | Xcode signed test app, identical mechanics, safe areas/resume/audio | Public release | Mac/Xcode logs and physical iPad evidence |
| **M4 — gentle polish** | Legibility, safe-area tuning, reduce motion, refined sprites, optional localization exploration | Mandatory story/tutorial | Short supervised UX observation; no new regressions |
| **M5 — expansion decision** | Optional microstories/Pond/Builder design review | Unapproved features | Separate screen contract, privacy/safety and scope approval |

**Important:** A checked Android APK export does **not** complete M1/M2; CI compilation does not prove UI renders or parent gestures work. iPad has not been verified.

## 8. Measurable acceptance, not fake progress percentages

- **Functionality:** all FLOW-01 through FLOW-07 tests (see [SCREEN_FLOW](SCREEN_FLOW.md)) pass and no obvious crashes in tested scenarios.
- **Visual:** actual Android emulator captures Welcome/Garden empty/seed/sprout/flower/Rest/Parent at the same head commit; not just concept SVG.
- **Platform:** an Android ARM test tablet and iPad test unit separately demonstrate touch/save/safe-area/audio.
- **Usability:** conduct a non-recorded, 5–10 minute parent-supervised observational test. Note the number of times the parent had to explain a control, any mistaken touches, willingness to stop and any unsettling feedback. **No biometric/child-identity collection**.
- **Safety:** no tracking, ads, data sync, payments, aggressive engagement prompts; broken save file must fail safely.
- **Performance:** developer records actual device startup, memory, frame stability and crash/ANR data; do not invent numerical targets without measuring device class first.

A test is **Not run**, **Fail** or **Pass with evidence**; never “90% complete” on a checklist where critical entry or crash behavior is unknown.

## 9. Product-risk register

| ID | Risk | Consequence | Mitigation and owner |
|---|---|---|---|
| R1 | Engine emulator draws splash/grey or native crashes | Misleading CI-green APK | Separate emulator visual/interaction gate; QA engineer |
| R2 | Parent long-press not recognized through system insets | Parents cannot configure app | Instrument physical/input mappings; test event timing + safer gesture; gameplay/QA |
| R3 | Tablet aspect or home indicator clips UI | Frustration, accidental press | 4:3/16:10/16:9 screenshot matrix; UI engineer |
| R4 | Device signing key regenerated each CI run | Old APK cannot update; uninstall deletes local garden | Label debug-only, warn before uninstall; release engineering |
| R5 | Save schema changed without migration | Lost garden | Versioned migration + compatibility tests; game state engineer |
| R6 | Too much animation/audio or obligation | Poor fit for calm play | Child-centered UX review, low motion, opt-in voice; design |
| R7 | Public store child-privacy noncompliance | Rejection or privacy risk | Separate store readiness review, no third-party SDK; product |
| R8 | Agents work from chat attachments/stale branches | Conflicting code/design | Strict `origin/main` and PR governance; coordinator |

## 10. Roadmap idea bank (design only)

- **Garden v1.1:** flower reveal variety, smoother organic sprites, optional reduce motion, better onboarding symbols and non-blocking hint.
- **The Pond v1.2:** a separate, unhurried water world only if user approves new screen navigation.
- **Tiny Builder v2:** place/undo wooden blocks and bridges without collapse failure.
- **Optional picture-book microstories:** “Little Beginning,” “Green Hello,” “Flower Smile,” “Pond's Whisper,” “Garden's Rest,” always skippable and not data-tracked.
- **Localization:** English + Myanmar text/voice with human language review. No voice recording from children.

Ideas above are **not implemented** and not commitments. For original creative content see [STORYBOOK_BIBLE](STORYBOOK_BIBLE.md). For the **current** code-specific state machine and exact hit areas use [SCREEN_FLOW](SCREEN_FLOW.md).

## 11. Definition of done for each PR

A PR contains linked outcome/issue, exact base+head commit, changed screen/state contracts, before/after evidence, tests actually run, limitations, accessibility/privacy impacts and rollback plan. Update contracts/docs alongside code. Parent-facing changes receive parent-flow tests, persisted-state changes receive migration tests, art changes receive on-device visual checks. No unapproved store publishing and no merging knowingly failed required UI tests.
