# Little Wonder Garden — MVP product and engineering design (v1)

## Goal and audience

For children roughly **4–7 years old**, build a self-directed nature sandbox that encourages slow exploration and restful transitions. It is **designed to be gentle**, not proven to treat anxiety, regulate emotions, or improve learning. Validate through short sessions with the child and feedback from the parent.

## Principles

1. No levels, timers, scores, fail states, streaks or forced retention loops.
2. Large, forgiving tap/drag targets; support a child's imperfect gesture.
3. Calm feedback: subdued pastel contrast, small motions, optional sound, no blinking or surprise popups.
4. Tiny cognitive load: three to four primary actions, simple labels and visual icons.
5. Local-first, no identity data, no network; parents can stop and restore play.
6. A soft break prompt (not a forced lock), configurable by grown-ups.
7. Simple US English words for MVP; English and Burmese voice prompts as a later opt-in phase.

## MVP scope

**In:** Welcome, 3x3 Garden, Plant action, Water action, 0–3 stages, subtle sway, plant/water/bloom/bird WAV, pond tap, local save, Rest, parent settings with sound/reminder/reset, Android/iPad build configurations using the same engine source.

**Out:** scores/currency, NPC tasks, inventory, user profiles, cloud, localization/recorded voiceover, animation pipeline, Tiny Builder, full Pond minigame, ads/IAP, multiplayer, notifications.

## Screen specification (1280x800 reference)

| Screen | Regions | Action | Transition |
|---|---|---|---|
| Welcome | Title, flowers, centered 436x111 start button | Tap Let's Play | Garden |
| Garden | Top title/parent press, 190x100 left controls, 3x3 plots 202x126, pond at (1126,527), bottom message | Tap tools, tap/drag soil, tap pond, rest | Garden/Rest/Parent |
| Rest | Moon visual, message, big green button | Return | Garden |
| Grown-up Corner | Sound on/off, reminder on/off, reminder 5/10/15, 2-tap reset, Done | Change preference | Garden |

Use **uniform scale** so all main UI remains reachable on 4:3, 16:10, 16:9 tablet aspect ratios; letterbox gracefully and fill bars with neutral sky. Allow for notches/home indicators in device QA; keep interactive controls away from physical edges.

## Child journey

1. Welcome → Let's Play.
2. Plant → tap an empty patch: 0→1; low-volume seed cue.
3. Water → tap seed: 1→2; gentle green sprout animation.
4. Water → tap sprout: 2→3; flower appears; low-volume bloom cue.
5. Continue exploring other plots, drag across patches, tap pond, or stop.
6. Automatic local save on each progression event. Restart restores the garden.
7. Soft prompt after selected in-garden duration. Tap Back to Garden to resume; parent can turn it off or choose 5/10/15 minutes.

Tap an already-grown flower: reassuring feedback, no damage. Watering empty dirt: quiet reminder, no penalty. A low-frequency sway is the only ongoing animation; no sudden motion or flashing.

## Native app architecture

```text
                         One Godot 4.x GDScript codebase
                                     |
          +--------------------------+------------------------+
          |                          |                        |
   Presentation                 Game state                Persistence
   (Node2D + drawing)     (plots[9], tool, screen)  (save_store.gd, user://)
          |                          |                        |
     Touch input --------------> action validation ------------+
          |                          |
  AudioStreamPlayer         animation timing (slow)
          |                          |
          +--------------------------+
                     |
              Godot Export
                /     \
        Android APK/AAB  iPadOS app via Xcode
```

For growth beyond MVP, refactor monolithic `garden_game.gd` into dedicated components:

```
scenes/welcome.tscn, garden.tscn, rest.tscn, parent_settings.tscn
scripts/domain/garden_state.gd, garden_rules.gd
scripts/ui/garden_view.gd, touch_controller.gd
scripts/services/save_store.gd, audio_service.gd, localization.gd
assets/vector, audio, localization
```

**Maintain MVP simplicity:** defer scene splitting until UI/art and gameplay are validated. Native runtime packages on both platforms share gameplay source, but Android uses Android SDK signing and iPadOS requires macOS/Xcode and Apple signing.

## Save contract

```json
{
  "version": 1,
  "plots": [0, 1, 2, 3, 0, 0, 0, 0, 0],
  "sound_enabled": true,
  "break_enabled": true,
  "break_minutes": 10
}
```

Validate stage range 0..3, array length <=9 and interval 5..15 when loading. No PII or remote sync. Add migrations for future schema revisions.

## Acceptance criteria / definition of done

- [x] Source MVP: four screens, nine plots, tap/drag interactions, local JSON save adapter.
- [x] Source MVP: parent sound toggle, break reminder, reset confirmation.
- [x] Source MVP: 4 generated effects, no third-party SDK or network calls.
- [ ] Godot editor import succeeds without parse errors (**needs engine run**).
- [ ] Touch tests on a real Android tablet: plant, water, multiple fingers, orientation, audio, background/restore.
- [ ] iPad build on macOS/Xcode, touch + notch/home indicator testing.
- [ ] Accessibility review: 4:3/16:10/16:9, colored contrast, font readability, motor accessibility.
- [ ] Child-and-parent UX validation: 5–10 minute supervised play, record confusion points, overstimulation, ability to stop.
- [ ] Children’s privacy policy and store metadata review if public distribution.

## Early QA cases

| Test | Expected behavior |
|---|---|
| New install | Garden starts with 9 empty beds |
| Seed on empty | Bed becomes seeded; saved |
| Water seed twice | Sprout then flower; saved |
| Tap planted bed with Plant | Stage unchanged; no penalty |
| Water empty bed | Stage unchanged; gentle tip |
| Quit/relaunch | Plants/prefs restored from local save |
| Tap pond | One soft bird cue |
| Toggle sound off | No game cues, stage progression still works |
| Idle 10 min in Garden | Rest screen shown; Back returns |
| Press gear briefly | No parent panel |
| Hold gear 2.5 sec | Opens parent panel |
| Reset once | Confirmation prompt only |
| Reset twice | 9 empty beds; save overwritten |

## Backlog after child validation

**v1.1**: own sprite animation assets, gentle voiceover with downloadable optional languages, reduce-motion toggle, basic accessibility options, device-specific UI safe-area tuning. **v1.2**: a small mindful Pond activity. **v2**: Tiny Builder; optional parent-child joint play. Never make completion or scores the reward.

## External reference policies / build instructions

- https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
- https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html
- https://developer.apple.com/app-store/review/guidelines/
- https://support.google.com/googleplay/android-developer/answer/9893335?hl=en