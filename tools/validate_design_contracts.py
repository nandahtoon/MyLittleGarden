"""Read-only, offline design/implementation contract checks (not device QA).

Works with Python 3.12 stdlib only. Any change to screens, plot states, saves,
storybook art or onboarding links must update the versioned contract and docs.
"""
from __future__ import annotations

import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
CONTRACT_PATH = ROOT / "docs/contracts/screen-flow.v1.json"


def fail(message: str) -> None:
    raise AssertionError(message)


def require(condition: bool, reason: str) -> None:
    if not condition:
        fail(reason)


def check_markdown_link_targets(filename: str) -> None:
    """Check relative links in tracked entrypoint documents; no network needed."""
    doc = ROOT / filename
    require(doc.exists(), f"Missing handoff document: {filename}")
    content = doc.read_text(encoding="utf-8")
    for target in re.findall(r"!?(?:\[[^\]]*\])\(([^)]+)\)", content):
        target = target.split("#", 1)[0].split("?", 1)[0].strip()
        if not target or target.startswith(("http:", "https:", "mailto:", "data:")):
            continue
        if target.startswith("<") and target.endswith(">"):
            target = target[1:-1]
        resolved = (doc.parent / target).resolve()
        require(resolved.is_relative_to(ROOT), f"Link escapes repo in {filename}: {target}")
        require(resolved.exists(), f"Broken local link in {filename}: {target}")


def main() -> None:
    required_docs = (
        "AGENTS.md", "README.md", "docs/START_HERE.md",
        "docs/GAME_DESIGN.md", "docs/SCREEN_FLOW.md",
        "docs/STORYBOOK_BIBLE.md", "docs/WORK_PACKAGES.md",
        "docs/ART_DIRECTION.md", "docs/REPOSITORY_POLICY.md",
        "docs/QA.md",
    )
    for path in required_docs:
        check_markdown_link_targets(path)

    contract = json.loads(CONTRACT_PATH.read_text(encoding="utf-8"))
    game = (ROOT / "scripts/garden_game.gd").read_text(encoding="utf-8")
    save = (ROOT / "scripts/save_store.gd").read_text(encoding="utf-8")
    require(contract["schema"] == "mylittlegarden.screen-flow.v1", "Unknown screen-flow schema")
    canvas = contract["canvas"]
    require((canvas["width"], canvas["height"]) == (1280, 800), "Canvas reference mismatch")
    require("Vector2(1280.0, 800.0)" in game, "Game design canvas differs")
    screens = contract["screens"]
    ids = [x["id"] for x in screens]
    require(ids == ["welcome", "garden", "rest", "parent"], "Unexpected screen states/order")
    require(sum(x.get("entry", False) for x in screens) == 1, "Exactly one entry screen required")
    require('"welcome"' in game and '"parent"' in game, "Screen identifiers absent from code")
    require(set(ids) == {t["from"] for t in contract["transitions"]}.union(
        {t["to"] for t in contract["transitions"]}
    ), "Transition graph references missing screen IDs or is disconnected")

    plots = contract["garden"]
    require(plots["plots"] == 9, "Expected nine plots")
    require(plots["layout"]["rows"] == 3 and plots["layout"]["cols"] == 3, "Expected a 3x3 grid")
    require(plots["layout"]["start"] == [314, 181], "Plot origin diverged from code")
    require(plots["layout"]["step"] == [237, 154], "Plot spacing diverged from code")
    require(plots["layout"]["size"] == [202, 126], "Plot size diverged from code")
    require("Vector2(314.0, 181.0)" in game and "Vector2(237.0, 154.0)" in game, "Plot start/step mismatch")
    require("Vector2(202.0, 126.0)" in game, "Plot hit size mismatch")
    require([s["id"] for s in plots["states"]] == [0, 1, 2, 3], "Garden state progression drift")
    require("plots[i] = 1" in game and "plots[i] += 1" in game, "Gameplay progression missing")
    require("for i in range(9):" in game, "Nine plots not initialized")

    flowers = ["cosmos", "sunflower", "tulip", "daisy", "poppy", "bluebell"]
    require(plots["flower_order"] == flowers, "Flower order drift")
    require(all(f'"{name}"' in game for name in flowers), "Game flower sprites don't match contract")
    for sprite in ["seed", "sprout", *flowers]:
        require((ROOT / "assets/art" / f"{sprite}.svg").is_file(), f"Missing storybook sprite: {sprite}")

    parent = contract["parent_settings"]
    require(parent["entry_hold_seconds"] == 2.5 and "parent_press_seconds >= 2.5" in game,
            "Parent hold contract mismatch")
    require(parent["reminder_choices_minutes"] == [5, 10, 15], "Reminders differ from contract")
    require("break_minutes = 5 if break_minutes == 15 else break_minutes + 5" in game,
            "Reminder cycle mismatch")
    require("if reset_confirmation:" in game, "Two-step reset invariant missing")

    storage = contract["storage"]
    require(storage["path"] == "user://little_wonder_garden.json", "Save location changed")
    require(storage["schema_version"] == 1, "Save migration required before version change")
    for key in storage["keys"]:
        require(f'"{key}"' in save, f"Save field missing: {key}")
    require("HTTPRequest" not in game + save, "Network request added to offline gameplay")

    for title in ["GAME_DESIGN.md", "SCREEN_FLOW.md", "STORYBOOK_BIBLE.md", "WORK_PACKAGES.md"]:
        require(title in (ROOT / "docs/START_HERE.md").read_text(encoding="utf-8"),
                f"Handoff reading order missing: {title}")

    print("PASS: handoff links, v1 screen-flow JSON, nine plots, six original flowers, local save, parent rules")
    print("LIMITATION: static source checks are NOT emulator visuals, physical Android/iPad QA or child UX evidence")


if __name__ == "__main__":
    main()
