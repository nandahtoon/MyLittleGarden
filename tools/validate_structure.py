"""Static repository smoke checks only; does NOT replace running Godot or device QA."""
from pathlib import Path
import re
import wave
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
required = [
    "project.godot", "scenes/main.tscn", "scripts/garden_game.gd",
    "scripts/save_store.gd", "README.md", "docs/DESIGN.md",
    "docs/REPOSITORY_POLICY.md", "docs/garden-screen-preview.svg",
    "docs/screen-flow.svg",
]
required += [f"assets/audio/{name}.wav" for name in ("seed","water","bloom","bird")]
plants = ("seed", "sprout", "cosmos", "sunflower", "tulip", "daisy", "poppy", "bluebell")
required += [f"assets/art/{name}.svg" for name in plants]
for path in required:
    assert (ROOT / path).is_file(), f"Missing: {path}"

project = (ROOT/"project.godot").read_text()
scene = (ROOT/"scenes/main.tscn").read_text()
game = (ROOT/"scripts/garden_game.gd").read_text()
save = (ROOT/"scripts/save_store.gd").read_text()
assert 'res://scenes/main.tscn' in project
assert 'res://scripts/garden_game.gd' in scene
assert '[rendering]' in project and 'gl_compatibility' in project
assert 'InputEventScreenTouch' in game and 'InputEventScreenDrag' in game
assert 'SaveStore.save_data(plots' in game
assert 'user://little_wonder_garden.json' in save
assert 'screen = "rest"' in game and 'screen = "parent"' in game
assert 'for i in range(9):' in game
for banned in ("HTTPRequest","OS.shell_open","Analytics","http://","https://"):
    assert banned not in game+save, banned
for name in ("seed","water","bloom","bird"):
    with wave.open(str(ROOT/f"assets/audio/{name}.wav"),"rb") as w:
        assert w.getframerate() >= 16000 and w.getnframes()>1000
for flower in plants:
    source = (ROOT / "assets" / "art" / f"{flower}.svg").read_text()
    svg = ET.fromstring(source)
    assert svg.tag == "{http://www.w3.org/2000/svg}svg", flower
    assert 'width' in svg.attrib and 'height' in svg.attrib, flower
    assert "http://" not in source.replace('xmlns="http://www.w3.org/2000/svg"', ""), flower
    assert f'"{flower}"' in game or f'{flower}.svg' in game, flower
for svg in ("garden-screen-preview.svg","screen-flow.svg"):
    data=(ROOT/"docs"/svg).read_text()
    assert "<svg" in data and "</svg>" in data
print("PASS: project structure, offline contract, eight SVG plant sprites, audio and design assets")
print("WARNING: does not establish Godot compile success, Android/iPad builds, or device UX QA")
