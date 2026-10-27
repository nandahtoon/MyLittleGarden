#!/usr/bin/env python3
"""Static design-bible and MVP screen-contract checks, no Godot runtime required.

Prevents accidental divergence across newly onboarded agents. Passing this
does NOT verify touch/render/device behavior, only inspectable source+docs.
"""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PATH = ROOT / "docs/contracts/screen-flow.v1.json"
data = json.loads(PATH.read_text(encoding="utf-8"))

assert data["schema"] == "mylittlegarden.screen-flow.v1"
assert data["canvas"]["width"] == 1280 and data["canvas"]["height"] == 800
screens = data["screens"]
screen_ids = [screen["id"] for screen in screens]
assert screen_ids == ["welcome", "garden", "rest", "parent"], screen_ids
assert sum(bool(screen.get("entry")) for screen in screens) == 1
assert screens[0]["entry"]
assert all(screen["actions"] for screen in screens)
transitions = data["transitions"]
assert len(transitions) >= 6
for transition in transitions:
    assert transition["from"] in screen_ids, transition
    assert transition["to"] in screen_ids, transition
    assert transition["event"] and transition["guard"], transition
assert {("welcome", "garden"), ("garden", "rest"), ("rest", "garden"),
        ("garden", "parent"), ("parent", "garden")} <= {
        (t["from"], t["to"]) for t in transitions
    }
garden = data["garden"]
assert garden["plots"] == 9 and garden["layout"]["rows"] == 3
assert garden["layout"]["cols"] == 3
assert [s["id"] for s in garden["states"]] == [0, 1, 2, 3]
assert garden["flower_order"] == [
    "cosmos", "sunflower", "tulip", "daisy", "poppy", "bluebell"
]
assert len(garden["transitions"]) == 6
assert data["storage"]["schema_version"] == 1
assert data["storage"]["path"] == "user://little_wonder_garden.json"
assert data["storage"]["identity_data"] is False
assert data["parent_settings"]["entry_hold_seconds"] == 2.5

required = [
    "AGENTS.md", "README.md",
    "docs/START_HERE.md", "docs/GAME_DESIGN.md",
    "docs/SCREEN_FLOW.md", "docs/STORYBOOK_BIBLE.md",
    "docs/ART_DIRECTION.md", "docs/DESIGN.md",
    "docs/WORK_PACKAGES.md", "docs/QA.md",
    "docs/REPOSITORY_POLICY.md", "scenes/main.tscn",
    "scripts/garden_game.gd", "scripts/save_store.gd",
]
for relative in required:
    assert (ROOT / relative).is_file(), f"Missing handoff or source file: {relative}"

game = (ROOT / "scripts/garden_game.gd").read_text(encoding="utf-8")
save = (ROOT / "scripts/save_store.gd").read_text(encoding="utf-8")
for screen_id in screen_ids:
    assert f'"{screen_id}"' in game, f"Missing screen in implementation: {screen_id}"
for art in ["seed", "sprout", *garden["flower_order"]]:
    assert (ROOT / f"assets/art/{art}.svg").is_file(), art
    assert f'"{art}"' in game, art
assert "PLOT_START := Vector2(314.0, 181.0)" in game
assert "PLOT_STEP := Vector2(237.0, 154.0)" in game
assert "PLOT_SIZE := Vector2(202.0, 126.0)" in game
assert "FILE_PATH := \"user://little_wonder_garden.json\"" in save
assert '\"version\": 1' in save

for relative in ("AGENTS.md", "README.md"):
    src = (ROOT / relative).read_text(encoding="utf-8")
    assert "docs/START_HERE.md" in src, f"{relative} must link to handoff entry point"
for relative in ("docs/START_HERE.md", "docs/GAME_DESIGN.md", "docs/SCREEN_FLOW.md"):
    src = (ROOT / relative).read_text(encoding="utf-8")
    assert "origin/main" in src or "main" in src
print("PASS: handoff docs and MVP machine flow contract match declared source boundaries")
print("NOTE: static check only — no runtime rendering, parent gesture or physical-device claims")
