# Little Wonder Garden: Living Worlds — 3D product strategy

**Edition:** 2026-11-21. **Status:** planned vision, not implemented. **Audience:** initially ages roughly 4–8 with caregiver support, child-ability settings; exact target age range and learning goals to validate through supervised research.

## Product promise
A kind, curious native 3D adventure world in which a child can **explore, experiment, help friends and change the world**, and see durable consequences of their discoveries. Not an answer-the-quiz-to-continue game, not a pressure-based engagement machine. First release: Android native, offline-first; future iPad from the same Godot project.

## Differentiation: design invariants
1. **Living World:** bridges restored, plants grown and friendships helped stay changed after restart. Save is stable, reversible and migrations tested.
2. **Multiple solutions:** core puzzles afford at least two child-understandable approaches; no hidden singular right path to most adventures.
3. **Integrated learning:** math, language, science, patterns, spatial reasoning and empathy arise naturally inside play. A garden or workshop response demonstrates learning; quiz overlays only when they clearly serve play.
4. **Companions with agency:** Nova (discovery/flying), Terra (gardening/patterns), Aqua (water/science), Pip (workshop/building; working name to avoid unreviewed Pyro/fire behavior). Bots guide through opt-in hints, not guilt or manipulative attachment.
5. **Living Storybook:** completed choices become a local illustrated recap. No child recordings, open AI chat or generated personal profiling.
6. **Healthy exit:** meaningful chapter endings, Rest anytime, reminder settings under parent control, no streaks, guilt reminders, high-pressure rewards, unbounded autoplay or artificial scarcity.
7. **Child privacy:** no ads, accounts, social chat, external analytics/SDKs or cloud sync in first release. A policy/owner review is required before any change.

## Game architecture from a player perspective
- **Wonder Home:** central calm home/garden and place for building; existing 2D garden stays accessible during transition; proposed future 3D home does not replace it until proven.
- **Rainbow Forest:** first bounded 3D micro-world; colors, shapes, observation, pattern bridges, safe platform mechanics.
- **Tinker Valley:** build/repair and explore mechanisms, simple logic and engineering.
- **Ocean Cove:** Aqua/underwater ecology and observation, not realistic drowning/violent hazard.
- **Star Observatory:** patterning, shadow, day/night, basic astronomy.
- Potential future creator content: visual-level builder, parent/child co-play, bilingual English/Burmese narration, storybook creator; each is separate gated scope.

## Interaction model
- Child first sees 1 clear goal, 1 navigational affordance and 1 obvious interaction.
- Nova guided third-person camera; forgiving touch joystick or tap-to-move pilot experiment; camera auto-centering with motion-reduction option.
- Contextual single action button; jump only where applicable. Avoid precision aiming, dense HUD and menu nesting.
- Mission micro-loop: Explore → Observe → Try → See consequence → Choose: Continue, Create, or Rest.
- On frustration: demonstrate, offer hint, simplify/skip; no wrong-answer shaming. Challenges can have several difficulty levels with **local user choice**, no covert child profiling.

## Educational framework — hypotheses, not claims of proven outcomes
For each learning mechanic, specify: age band, concept, observable child action, alternate solution, optional hint, exit and assessment without personal data. Example:
- Shapes: match Triangle, Circle, Square to rebuild bridge supports; observation = child physically picks compatible components; repeat in two contexts to examine transfer.
- Counting: supply three cog pieces to repair windmill; observation = manipulation and self-correction, not quiz grade.
- Nature: place seed in a suitable environment; observation = notice sunlight/water response with clear toy-like causal logic, not false scientific claims.
- Language: hear a word linked to a visible object, then use it to communicate within a story. Optional audio, subtitles, localization review.
- Creativity: build at least two viable structures to help a character cross; no single required answer.

## Age accessibility
- Ages ~4–5: guided exploration, simple locomotion, large touch targets, short spoken cues, minimal text.
- Ages ~6–8: optional traversal puzzles, basic number/word and science tasks, alternate solution routes.
- Older children could receive higher-complexity builder content later, but do not promise ages 9–12 support without testing.

## Companions & world content system
Design game-play ability contracts independent of visual costume. Assets have original ownership/licensing provenance. Character concept images are **not** GLB models; Blender model, UV/materials, rig, animation and mobile LOD are separate tasks.
- Nova: flight/glide with child-friendly guardrails and scan/observe.
- Terra: plant/grow/connect; non-violent nature skills.
- Aqua: buoyancy/marine observation.
- Pip: repair/construct, safe experimental loops.
All character abilities have animation states, touch/action mappings, contextual hints and fallback in performance-constrained devices.

## Creativity, progression and return interest
Return to a **meaningful place**, not to keep a streak. Progress: saved world changes, optional visible story chapters, expanded materials and creative tools. No penalty for absence. No daily login rewards. A child must be able to stop after a short chapter with a positive ending. Parents can control pacing and sound. Optional offline co-play is a research topic, not a first release requirement.

## Product boundaries
First 3D vertical slice is **one bot (Nova), one small Rainbow Forest area, one end-to-end shape/bridge mission**, touch control, hint, save, Rest and return to existing garden. Terra and additional chapters only after its evidence gates pass.
- No live AI chat, child voice/camera capture, user-generated network sharing, multiplayer, purchases, notifications, aggressive engagement loops or collection of child identifiers in first release.
- Art direction: distinctive original rounded toy-like characters, readable silhouette, saturated but moderated color, stable camera and reduced-motion option; render quality must be judged on entry Android devices.
- Do not market educational efficacy as clinically or academically proven; use observational claims and validation limits.

## Product design gates
G0: child-centered design and architecture approved.
G1: playable 3D controller and camera on real target Android class.
G2: one complete learning-through-play mission with world mutation + offline save and rest.
G3: 5 missions + supervised playtesting + regression, user confusion documented.
G4: commercial release decisions and policies independently reviewed by owner.
Details and dependencies: 3D_RELEASE_PLAN.md.

## Primary references (source facts, not blanket compliance certification)
- UNICEF RITEC Design Toolbox: https://www.unicef.org/childrightsandbusiness/workstreams/responsible-technology/online-gaming/ritec-design-toolbox
- UNICEF RITEC Research: https://www.unicef.org/innocenti/reports/responsible-innovation-technology-children
- American Academy of Pediatrics family media guidance: https://www.healthychildren.org/English/family-life/Media/Pages/How-to-Make-a-Family-Media-Use-Plan.aspx
