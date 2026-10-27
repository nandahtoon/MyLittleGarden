# Storybook garden — art direction and sprite gallery

**Status:** original implementation assets on UI/UX PR #10. This is an asset preview, **not** a screenshot taken from Android or iPad. The canonical files under `assets/art/` are used by Godot.

## Flowers in the garden

| Cosmos | Sunflower | Tulip |
|:--:|:--:|:--:|
| ![Cosmos](../assets/art/cosmos.svg) | ![Sunflower](../assets/art/sunflower.svg) | ![Tulip](../assets/art/tulip.svg) |
| Daisy | Poppy | Bluebell |
| ![Daisy](../assets/art/daisy.svg) | ![Poppy](../assets/art/poppy.svg) | ![Bluebell](../assets/art/bluebell.svg) |

## Growth stages

| Seed | Sprout | Flower |
|:--:|:--:|:--:|
| ![Seed illustration](../assets/art/seed.svg) | ![Sprout illustration](../assets/art/sprout.svg) | ![Sunflower illustration](../assets/art/sunflower.svg) |

## Design tokens

- Palette: warm ivory `#fffdf6`, leaf green `#417957`, cool sky `#e9f7f1`, mint `#dcefdc`, sunflower `#ffc959`, cosmos `#ffb4ca`.
- Tap targets remain large; improve visual hierarchy without introducing any urgency, failure states, points or loops.
- Flowers vary deterministically by plot; no loot/random rewards. Slow sway is at most ~1.6 reference pixels. No flashing.
- All illustration is original SVG source, locally bundled and offline. No art asset requests or network dependencies.
- UI remains landscape at a 1280×800 reference size, with proportional scaling as already implemented.
- SVGs use fills, paths, strokes and simple linear gradients only, to be compatible with Godot's ThorVG importer. Test on target Android/iPad devices; these images do not prove exported rendering.

## Review checklist

- [ ] Every seed/sprout/bloom displays correctly in the Godot editor, emulator and physical tablet.
- [ ] Flowers remain visible when growing and no sprites cover controls.
- [ ] Welcome, Garden, Rest and Grown-up Corner are legible on 4:3 and 16:10 screens.
- [ ] Grown-up gestures, double-reset and controls still work.
- [ ] No animation flicker, audio surprises or unwanted touch areas.
- [ ] Supervised short child session confirms engagement and easy stopping.
