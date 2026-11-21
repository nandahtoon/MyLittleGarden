# Research, learning and monitoring operating plan

**Edition:** 2026-11-21. **Scope:** ongoing human-in-the-loop product research, development monitoring and post-launch quality. **Current state:** research plan and CI monitoring design only; no background watchdog, scheduled job, analytics service or child telemetry has been enabled here.

## Research principles and evidence ladder
- Evidence types: Official (current authoritative rule/engine docs) > measured device/test output > caregiver/child observation with consent > transparent team hypothesis > concept art / other titles.
- Label every claim as VERIFIED, OBSERVED, HYPOTHESIS or UNKNOWN; attach date, source, version and limitations.
- Benchmark genre/design without copying protected art, characters, music, written content or distinctive level layouts.
- Prioritize offline, age-appropriate accessible play and the child's agency above session time metrics.
- Update research links before version/SDK/renderer/store changes; policy interpretation is not legal certification.

## Research workstreams and decision questions
| Workstream | Questions | Method and artifact | Initial checkpoint |
|---|---|---|---|
| R1 Child-centered play | Can children understand the goal, choose freely and stop comfortably? | UNICEF RITEC + AAP desk research; caregiver-approved 5–10 minute observation; anonymized notes | Before vertical slice beta |
| R2 Competitive landscape | What feels distinctive among modern kids 3D exploration/building games? | Pattern comparison matrix: control, camera, hints, pricing, privacy, platform and accessibility; original designs only | Before full art pipeline |
| R3 Godot mobile 3D | Which renderer/version/graphics tier produces stable 3D and touch? | Compare pinned 4.4.1 Compatibility vs alternatives on actual devices; FPS/thermal/visual logs, ADR | Before choosing engine upgrade |
| R4 3D production | Can original characters be modeled, rigged, optimized and reused cheaply? | Nova GLB prototype, LOD/material/rig import benchmarks and provenance register | Before world art scale |
| R5 Educational design | Which integrated activities yield observable problem-solving/transfer? | Specific hypotheses, mechanics traceability matrix, caregiver observations; no claim of learning improvement without study | Each mission set |
| R6 Children compliance | Do data, permissions, ads, disclosures, age rating and store rules match release? | COPPA/Google Play Families/Apple Kids official review, legal/owner decisions; privacy/data inventory | Before every store submission |
| R7 Localization & inclusion | Are cues understandable in US English and optional Burmese; motion/vision limits? | Native speaker, accessibility and child usability review, not only machine translation | Before localized content |
| R8 Commercial risk | What pricing and content expansion serve parents without manipulating children? | Parent interviews (adult participants), platform terms check and owner decision | After verified beta |

## Monitor without collecting children's private data
### Every pull request (automated where configured)
- Exact SHA and required CI: project structure, Godot parse/import/smoke, mission/domain/save tests, Android debug artifact, dependency/license scan.
- No severe errors, no failed critical tests; broken 2D flow regression blocks 3D merge.
- Publish test evidence in GitHub CI/PR metadata, **not** raw child device identifiers or recordings.

### Weekly development review (manual or explicitly authorized automation)
- Open PRs vs owners, stale blockers, failing runs, new defects, current head and branch conflicts.
- Milestones: gate Pass/Fail/Not Run, oldest P0/P1, regression trend and known crash tickets.
- Check if research questions or policy sources became stale; route decisions to owner.
- Output: 1-page status with DONE / IN PROGRESS / BLOCKED / NEXT, exact links, risk and recommended reversible next work. No percentages without denominators.

### At each prototype or beta build
- Android cold start, real device FPS/frame stability, memory, thermals, battery if measurable, touch mis-taps, camera discomfort and accessibility.
- Data corruption/upgrade tests and mission completion on a clean and migrated fixture.
- Independent child-and-caregiver qualitative observation with caregiver permission, no storing identities/photos/recordings in repository.
- Detect overstimulation and ability to take a break; prioritize experience quality over maximizing playtime.

### After public release (only if and when published)
- Google Play Android vitals and crash/ANR rates from developer console where available, aggregated and access-controlled; these are platform reports, not permission to install extra child tracking SDKs.
- Store reviews/support tickets with careful avoidance of child personal data; privacy policy accuracy and incident response.
- Release KPI: stability, educational task clarity, parental trust, healthy stopping, opt-in parent feedback; never obsess over daily active minutes.
- Investigate regressions, triage by safety/functional/severity and prepare hotfix via exact source commit/rollback path.

## Initial threshold proposal (not passed evidence)
- 0 unresolved P0/P1 for beta release.
- All required CI checks green **at exact commit**.
- Real-device 30 FPS target for named Android entry device after measured selection; do not treat generic simulator speed as physical performance.
- Core user path clear to most supervised trial children, with observed confusion recorded (avoid statistical claims from tiny samples).
- Local save survives restart and existing v1 save migration tests.
- No request for Internet/camera/microphone/storage-identifying permissions in child MVP.
Any target can be revised by ADR using real device observation, not silently weakened to pass.

## Research record template
ID | date checked | question | hypothesis | primary URLs | engine/store versions | evidence | quality (high/medium/low) | options | decision | owner | review-by date | linked issue/ADR.

## Learning experiment template
Learning objective; player action; age band; multiple ways to solve; expected observable behavior; onboarding and hint; motion/voice alternatives; nonjudgmental fail/skip; measurement without PII; participant caregiver consent; observation summary; changed game decision.

## Research to roadmap feedback loop
Question → Source comparison → Prototype/experiment → Evidence & privacy check → ADR or mission change → Targeted PR → CI + device verification → user observation → iterate / accept / defer.

## Monitoring responsibilities
- AI integrator: inspect CI and work queue when invoked or under an explicitly created scheduled task.
- AI QA reviewer: preserve exact run links and compare screenshot evidence, not conceptual art.
- Human owner: approve RED risk, release and commercial decisions.
- No monitoring is claimed to be actively running; future recurring automation needs explicit setup, a defined cadence and authorized access.

## Primary official sources to recheck
- Godot system requirements: https://docs.godotengine.org/en/stable/about/system_requirements.html
- Godot renderers: https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html
- Android export: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
- UNICEF RITEC: https://www.unicef.org/innocenti/reports/responsible-innovation-technology-children
- AAP family media plan: https://www.healthychildren.org/English/family-life/Media/Pages/How-to-Make-a-Family-Media-Use-Plan.aspx
- FTC COPPA guidance: https://www.ftc.gov/business-guidance/resources/complying-coppa-frequently-asked-questions
- COPPA amendments Federal Register HTML: https://www.govinfo.gov/content/pkg/FR-2025-04-22/html/2025-05904.htm
- Google Play Families: https://support.google.com/googleplay/android-developer/answer/9893335?hl=en
- Google Play policy: https://support.google.com/googleplay/android-developer/answer/18265346?hl=en
- Google Play Android vitals: https://developer.android.com/google/play/vitals
- Apple Kids and review rules: https://developer.apple.com/kids/ and https://developer.apple.com/app-store/review/guidelines/
All URLs reflect research checked on 2026-11-21 and must be reverified before action; do not treat citations as a compliance signoff.
