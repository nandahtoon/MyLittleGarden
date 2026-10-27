# STORYBOOK BIBLE — Little Wonder Garden

**Edition:** 1.0, original creative direction. **Product:** calm offline 2D tablet sandbox for approximately ages 4–7. **Implementation status:** current Garden uses original SVG sprites and code-drawn landscape; story prompts/characters and additional worlds below are design proposals until separately implemented and verified.

**What “Storybook” means here:** an illustrated children's picture-book **art style and non-linear micro-narrative**, not the Storybook.js web-component tool. Game code is native Godot, not a browser UI. UI components can still use the visual recipes below.

## 1. Creative north star

**Working promise:** *A little garden is yours. Touch gently; something lovely grows. You can leave and come back.*

Child feelings to support: curious, safe to explore, able to stop. No claims of treatment/therapy. There is no winning, losing, urgency or required reading. "Garden" is a place, not a course, grade or chore list.

### Setting: Meadowlight Garden

A small, cozy garden at the edge of a rolling meadow. Two soft clouds drift overhead; the pond softly ripples; a butterfly passes sometimes. Each soil patch feels hand-painted and welcoming. The environment changes only as a response to a child's choice. **Don't** introduce frightening storms, drought, plant death, scavenging, hunger, punishment or unpredictable scary surprises.

Storybook pacing: little wonder → child chooses an action → slow, readable response → quiet observation → an easy chance to pause.

### Character policy

**Current MVP:** the **garden itself** is the main character. There are no required NPC dialogues or character voices. The butterfly and small pond are ambient wildlife only.

**Future optional guide, not approved for MVP:** **Pip the Seed**, an expressive but nonverbal seed who appears only in a few discovery illustrations; never follows the child, interrupts a touch, asks them to stay, or nags. Keep gender-neutral, culturally flexible, original appearance. Never mimic known franchise characters.

Companions in later content may be visual-only (a snail crossing a stone or a dragonfly by water). They are **not collectible** and cannot be lost or harmed.

## 2. Visual language / mood board in words

| Layer | What it should look like | What to avoid |
|---|---|---|
| Background | Mint morning sky `#e9f7f1`, softly overlapping grassy hills `#dcefdc`, warm sunshine, puffy clouds | Hard contrast, glossy game-store look, flashing weather |
| UI cards | Warm ivory `#fffdf6`, rounded 24–48px corners, subtle green shadow | Tiny controls, dark overlays, busy popup stacks |
| Actions | Deep leaf green `#417957` CTAs, picture + short verb, active selection also marked by shape/position | Relying only on color or inaccessible miniature text |
| Flowers | Distinct silhouettes, gentle outlines, imperfect organic symmetry, pale highlights and tactile leaves | Photorealistic flowers, trademarked characters, reward explosions |
| Soil | Warm clay brown with flecks and rounded edges; blank plots clearly invite action | Bare technical grid or skeletal placeholder icons |
| Pond | Blue-green concentric ripples, lily leaves, one quiet audio cue | Splashes, sharp looped waves, interactive complexity in v1 |
| Motion | Slow butterfly drift, ~1–2 logical pixel sway on blooms | Strobes, bouncing timers, rapid particle effects |
| Sound | Optional local sound, gentle short effects around -14 dB in current code; honor mute | Loud autoplay, endless music, random startle |

**Current original assets (already implemented):** `assets/art/seed.svg`, `sprout.svg`, `cosmos.svg`, `sunflower.svg`, `tulip.svg`, `daisy.svg`, `poppy.svg`, `bluebell.svg`. See [Art Direction](ART_DIRECTION.md). These are source illustrations, not screenshots. Six flower species are assigned by plot index for predictable discovery. Do not accidentally redefine this as randomized inventory.

## 3. Story arcs, not levels

These “pages” are **emotional beats**, not unlockable levels. Each stands alone and may be replayed in any order.

| Arc | Trigger | Child-facing idea | On-screen action | End condition |
|---|---|---|---|---|
| The Little Beginning | First seed in any plot | Small things can start quietly | Plant → seed settles in soil | Immediately returns to free play |
| The Green Hello | Water a seed | Something new is here | Tiny pair of leaves appears | No reward screen |
| The Flower Smile | Water a sprout | Colors brighten the garden | One distinctive flower blooms | Leave the flower alive |
| The Pond's Whisper | Tap pond | The meadow has quiet sounds | Small ripple; optional bird cue | Fade naturally |
| The Garden's Rest | Child taps Rest or gentle timer fires | We can rest and return | Calm moon card, Back button | Child chooses to return or leave |

**Do not force arcs to appear in a prescribed sequence across the whole garden.** Each plot uses the same simple state progression; children can ignore the rest.

## 4. Copy / microstory writing kit

All child-facing copy should be short, warm, affirmative, neutral and nonjudgmental. UI actions use plain verbs. English strings are the MVP reference; Burmese narration/localization needs a separate content/voice QA PR.

| Event | Primary copy | Optional future gentle voice | Avoid |
|---|---|---|---|
| Welcome | “A little place to grow.” | “Welcome to your little garden.” | “Come back every day!” |
| Tap Plant | “Touch a patch of soil to plant.” | “Where will your seed go?” | “Plant nine seeds now!” |
| Seed planted | “A tiny seed is sleeping in the soil.” | “A cozy place for a seed.” | “Good job! +10 points!” |
| Water seed | “Look! A little sprout!” | “Two little leaves say hello.” | “Hurry, water faster!” |
| Flower blooms | “A flower says hello!” | “Look at its colors.” | “You won a flower!” |
| Water empty | “Try planting a seed here first.” | — | “Wrong!” |
| Plant over filled plot | “This little patch already has a plant.” | — | “No space left!” |
| Tap pond | “Listen! A little bird is nearby.” | — | “Find the hidden prize!” |
| Rest | “Your garden is resting.” | “You can come back another time.” | “Don't go!” |
| Parent settings | “Grown-up Corner” | — | Adult controls described as child tasks |

**Content limits:** optional floating message <= 75 characters where possible; one idea at a time; never cover soil hitboxes; no compulsory voice. No guilt-inducing push notifications or marketing copy.

## 5. Picture-book layout language: reusable UI recipes

| Recipe | Content + placement | Contract |
|---|---|---|
| `GardenHeader` | Left-aligned garden name + tiny subtitle; parent gear top right | Parent gesture must not overlap system bars or accidental drag |
| `PrimaryStoryButton` | One clearly dominant large rounded deep-green button on Welcome/Rest | Hit region consistent with drawing and input transformation |
| `ActionCard` | Icon + verb with visible active state; Plant/Water/Sound/Rest | Active state conveyed by shape/strip and color; no accidental tap |
| `SoilPatch` | Tactile rounded soil and state-specific plant illustration | One of 0/1/2/3 stages only; state preserved after restart |
| `MicroStoryCaption` | Warm cream low-contrast panel under Garden, never modal | Single sentence, auto-clear, unobtrusive |
| `PondDecoration` | Tiny animated water ripple, optional bird | Optional; never distract from planting |
| `ParentOption` | Large row and text label/value in centered ivory card | Parent-entered only; confirm reset twice; clear exit |

For nontrivial visual changes, provide concept frames or Godot screenshots for **all four** screens plus an **empty/seed/sprout/flower** sequence. **Concept frames must be labeled mockups.** Device/emulator screenshots must identify actual runtime and commit.

## 6. Content card template (future use)

Each new story beat requires this card *before* artwork or code:

```yaml
story_id: first-bloom
version: 1
status: proposed # proposed | approved | implemented | device-verified
trigger: plot_stage_changed_to_3
scene: garden # never interrupt with a new mandatory screen
duration_seconds: 2.5
interaction: optional_none
visual: one flower glows softly once; no flash
audio: bloom.wav, controlled by sound_enabled
text_en: "A flower says hello!"
text_my: null # requires native speaker review before release
skip_rule: child can tap another plot immediately
safety: no time pressure, scores, data capture or random rewards
qa_evidence: null
```

## 7. Future gentle expansion — explicitly OUT of the MVP

### Peaceful Pond (candidate v1.2)

Tap ripples, feed illustrated fish in a **simple non-competitive** way, spot leaf shapes, listen to ambient water. No fish health, hunger meter, timed collection or virtual currency. Return to Garden anytime. **New full-screen route only after an approved navigation update.**

### Tiny Builder (candidate v2)

Drag soft wooden blocks to make imaginary nests, bridges and little houses. Snap gently, undo freely, no physics collapse surprise. No scored puzzle. Reuse offline state conventions. This is a separate mini-world, **not** part of current Garden MVP.

### Optional parent-child shared moments

A parent can say, “Which flower would you like to water?” The app need not record voice, names or choices. No recorded child audio, social features or profiles.

## 8. Art production pipeline / licensing

1. Write a brief covering silhouette, stage, palette, size and inclusive mood.
2. Create **original** layered/vector master illustration; keep editable source committed in `assets/art/` or an agreed source folder. Do not download unlicensed art or imitate popular franchises.
3. Export clean device-appropriate SVG/PNG at required scale. Verify Godot's importer, outline legibility and transparency.
4. Match `_draw_plot` drawing rectangles, preserve touch areas and floor/flower placement; use non-random layout.
5. Test PNG/Godot screenshot at 4:3, 16:10, 16:9, including readability at tablet viewing distance.
6. Check performance, frame-rate cap, size, no seizure-risk flashes, mute and suspend/resume.
7. Merge with screenshots + test evidence; maintain [SCREEN_FLOW](SCREEN_FLOW.md) if actions or scenes change.

**Never** report that concept sketches or isolated image assets are proof of native-game quality. Existing successful Android emulator captures show storybook art at an isolated test branch, but whole-flow QA is not complete.

## 9. Creative quality bar

The MVP feels “finished enough to test with a child” only when a first-time observer can find Plant, seed a patch, water to flower, discover Rest, and stop without adult explanation; a grown-up can configure reminders and safely reset; images are actually visible; sounds and animations do not surprise. Confirm via supervised 5–10 minute observations (anonymous notes only), not speculative claims.

**Next approval gate:** separate art/content PR for optional microstories or Pip; do not silently add them to code. For screen behavior refer to [SCREEN_FLOW](SCREEN_FLOW.md), for executable rules refer to [GAME_DESIGN](GAME_DESIGN.md).
