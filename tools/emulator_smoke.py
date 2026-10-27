#!/usr/bin/env python3
"""ADB-driven synthetic emulator smoke test; no child data or real identifiers."""
from __future__ import annotations

import base64
from io import BytesIO
import json
import os
from pathlib import Path
import re
import struct
import subprocess
import time

PKG = "io.github.nandahtoon.mylittlegarden"
APK = "build/LittleWonderGarden-emulator-debug.apk"
OUT = Path("build/emulator-evidence")
OUT.mkdir(parents=True, exist_ok=True)


def adb(*args: str, timeout: int = 35, check: bool = True, binary: bool = False):
    result = subprocess.run(["adb", *args], capture_output=True, timeout=timeout)
    if check and result.returncode:
        raise RuntimeError(
            f"adb {args!r} exited {result.returncode}: "
            f"{result.stderr.decode(errors='replace')[-1500:]}"
        )
    return result.stdout if binary else result.stdout.decode(errors="replace").strip()


def wait_for_garden_pixels(label: str, seconds: int = 18):
    """A Godot splash, Android home screen or flat grey canvas cannot pass visual QA."""
    from PIL import Image
    for i in range(seconds):
        data = adb("exec-out", "screencap", "-p", binary=True, timeout=40)
        if data[:8] == b"\\x89PNG\\r\\n\\x1a\\n":
            picture = Image.open(BytesIO(data)).convert("RGB")
            w, h = picture.size
            area = picture.crop((int(w*.15), int(h*.14), int(w*.85), int(h*.82)))
            tiny = list(area.resize((48, 30)).getdata())
            brightness = sum(sum(pixel) / 3 for pixel in tiny) / len(tiny)
            distinct = len(set(tiny))
            print(f"FRAME_WAIT {label} #{i+1}: brightness={brightness:.1f} distinct={distinct}", flush=True)
            if brightness > 135 and distinct > 18:
                return
        time.sleep(1)
    dump_app_diagnostics(f"{label} remained splash or blank grey instead of rendered game")
    raise AssertionError(f"{label} never produced a bright, illustrated Godot frame")


def screenshot(name: str):
    data = adb("exec-out", "screencap", "-p", binary=True, timeout=60)
    if len(data) < 24 or data[:8] != b"\x89PNG\r\n\x1a\n":
        raise RuntimeError(f"Invalid screenshot {name}, size={len(data)}")
    w, h = struct.unpack(">II", data[16:24])
    (OUT / f"{name}.png").write_bytes(data)
    print(f"Screenshot {name}: {w}x{h}, {len(data)} bytes", flush=True)
    try:
        from PIL import Image
        im = Image.open(BytesIO(data)).convert("RGB")
        field = im.crop((int(w*.10), int(h*.10), int(w*.90), int(h*.83)))
        unique = len(set(field.resize((48, 28)).getdata()))
        print(f"VISUAL_CHECK {name}: center color samples={unique}", flush=True)
        if unique < 16:
            raise AssertionError("Emulator displays a nearly blank scene; reject visual QA even if touch/save works")
    except ImportError:
        print("No Pillow visual check available", flush=True)
    # Encode a low-resolution preview in CI logs for remote visual diagnosis.
    try:
        from PIL import Image
        preview = BytesIO()
        Image.open(BytesIO(data)).convert("RGB").resize((480, 300)).save(
            preview, format="JPEG", quality=38, optimize=True
        )
        print(f"QA_IMAGE {name} {base64.b64encode(preview.getvalue()).decode()}", flush=True)
    except ImportError:
        print("Pillow not installed; full screenshots remain in CI artifact", flush=True)
    return w, h


def tap(x: int, y: int):
    adb("shell", "input", "tap", str(x), str(y))
    time.sleep(0.8)


def activity_snapshot():
    activity = adb("shell", "dumpsys", "activity", "activities", check=False)
    window = adb("shell", "dumpsys", "window", "windows", check=False)
    relevant = [line.strip() for line in (activity + "\n" + window).splitlines()
                if "topResumedActivity=" in line or "mCurrentFocus=" in line
                or "mFocusedApp=" in line or "mTopFocusedDisplayId" in line]
    return relevant[:18]


def dump_app_diagnostics(reason: str):
    logs = adb("logcat", "-d", "-v", "brief", timeout=50, check=False)
    (OUT / "logcat.txt").write_text(logs[-700_000:], encoding="utf-8")
    terms = ("godot", PKG.lower(), "fatal exception", "fatal signal",
             "am_crash", "force finishing", "process died", "surfaceflinger",
             "egl_bad", "libc  :", "abort message", "renderer", "lwg_ci_", "shader", "egl", "gles")
    filtered = [line for line in logs.splitlines() if any(t in line.lower() for t in terms)]
    print("DIAGNOSTIC", reason, "PID", adb("shell", "pidof", PKG, check=False), flush=True)
    print("DIAGNOSTIC activity", activity_snapshot(), flush=True)
    print("DIAGNOSTIC filtered_logcat", "\n".join(filtered[-120:])[-26000:], flush=True)


def start():
    # Launch deterministically: monkey may report success while leaving Launcher visible.
    resolved = adb("shell", "cmd", "package", "resolve-activity", "--brief",
                   "-a", "android.intent.action.MAIN",
                   "-c", "android.intent.category.LAUNCHER", PKG, check=False)
    print("LAUNCHER_ACTIVITY", resolved, flush=True)
    result = adb("shell", "am", "start", "-W",
                 "-a", "android.intent.action.MAIN",
                 "-c", "android.intent.category.LAUNCHER",
                 "-p", PKG, timeout=65, check=False)
    print("LAUNCH_RESULT", result, flush=True)
    ready = False
    for _ in range(18):
        time.sleep(1)
        proc = adb("shell", "pidof", PKG, check=False)
        focused = activity_snapshot()
        if proc and any(PKG in line for line in focused):
            ready = True
            print("APP_READY", proc, focused, flush=True)
            break
    if not ready:
        dump_app_diagnostics("App failed to become foreground after launch")
        raise AssertionError("Godot Android activity did not remain in foreground; screenshots not valid")


def saved_state():
    # 'run-as' reads only the synthetic app's private save. No personal data involved.
    paths = adb("shell", "run-as", PKG, "find", ".", "-name", "little_wonder_garden.json")
    candidates = [p.strip() for p in paths.splitlines() if p.strip().endswith("little_wonder_garden.json")]
    if not candidates:
        print("DIAGNOSTIC run-as file tree:", adb("shell", "run-as", PKG, "find", ".", "-maxdepth", "6", "-type", "f", check=False)[:4000], flush=True)
        print("DIAGNOSTIC external files:", adb("shell", "ls", "-la", f"/sdcard/Android/data/{PKG}/files", check=False)[:1500], flush=True)
        print("DIAGNOSTIC app PID:", adb("shell", "pidof", PKG, check=False), flush=True)
        print("DIAGNOSTIC activity:", adb("shell", "dumpsys", "activity", "activities", check=False)[-2500:], flush=True)
        dump_app_diagnostics("Save file missing")
        raise AssertionError("Godot local save file not found (touch not received, or file not persisted)")
    raw = adb("shell", "run-as", PKG, "cat", candidates[0])
    state = json.loads(raw)
    print(f"Observed save: stages={state.get('plots')}, sound={state.get('sound_enabled')}, "
          f"break={state.get('break_enabled')}/{state.get('break_minutes')}", flush=True)
    return state


def expect(condition: bool, message: str):
    if not condition:
        raise AssertionError(message)
    print("PASS " + message, flush=True)


def check_crashes():
    logs = adb("logcat", "-d", "-v", "brief", timeout=45)
    (OUT / "logcat.txt").write_text(logs[-250_000:], encoding="utf-8")
    suspect = [s for s in logs.splitlines() if ("FATAL EXCEPTION" in s or
                "Fatal signal" in s or "ANR in " in s or "SCRIPT ERROR:" in s)]
    expect(not suspect, "no Android fatal crash / ANR / Godot script errors in captured logcat")


def main():
    print("Android " + adb("shell", "getprop", "ro.build.version.release"), flush=True)
    print("ABI " + adb("shell", "getprop", "ro.product.cpu.abi"), flush=True)
    adb("wait-for-device")
    adb("shell", "wm", "size", "1280x800")
    adb("shell", "wm", "density", "240")
    adb("shell", "settings", "put", "system", "accelerometer_rotation", "0")
    adb("shell", "settings", "put", "system", "user_rotation", "1")
    adb("logcat", "-c")
    print(adb("install", "-r", APK, timeout=180), flush=True)
    print("Start main launcher", flush=True)
    start()
    print("FOCUS", activity_snapshot(), flush=True)
    wait_for_garden_pixels("Welcome")
    w, h = screenshot("01-welcome")
    expect(w > h, "app is in landscape presentation")
    # Design is 1280x800. Android bars/insets are small; taps target generous hit areas.
    fx = w / 1280.0
    fy = h / 800.0
    def design_tap(x: int, y: int):
        tap(int(x*fx), int(y*fy))
    design_tap(640, 618)  # Welcome -> Garden
    wait_for_garden_pixels("Garden")
    screenshot("02-garden-empty")
    # Require the Garden to render differently from Welcome; a home/blank frame is not gameplay evidence.
    from PIL import Image, ImageChops
    a = Image.open(OUT / "01-welcome.png").convert("RGB").resize((128, 80))
    b = Image.open(OUT / "02-garden-empty.png").convert("RGB").resize((128, 80))
    bounds = ImageChops.difference(a, b).getbbox()
    expect(bounds is not None, "Welcome and Garden visuals actually differ")

    # A tap should persist a stage-1 seed.
    design_tap(412, 242)
    one = saved_state()
    expect(len(one["plots"]) == 9 and one["plots"][0] == 1, "tap soil plants seed on bed 1")
    screenshot("03-seeded")

    # Water twice: seed->sprout->flower.
    design_tap(134, 355)
    design_tap(412, 242)
    two = saved_state()
    expect(two["plots"][0] == 2, "watering seed produces sprout")
    design_tap(412, 242)
    three = saved_state()
    expect(three["plots"][0] == 3, "second watering produces flower")
    screenshot("04-flower")

    # Persist audio toggle across process restart.
    design_tap(140, 476)
    muted = saved_state()
    expect(muted["sound_enabled"] is False, "audio toggle updates persisted setting")
    adb("shell", "am", "force-stop", PKG)
    time.sleep(1)
    start()
    wait_for_garden_pixels("Restarted welcome")
    screenshot("05-restarted")
    restored = saved_state()
    expect(restored["plots"][0] == 3 and restored["sound_enabled"] is False,
           "garden and sound preference survive force-stop/relaunch")
    design_tap(640, 614)  # Welcome -> Garden after restart
    screenshot("06-garden-restored")

    design_tap(133, 592)
    screenshot("07-rest")
    design_tap(640, 600)  # Rest -> Garden

    # Hold top-right gear for 2.5s to enter grown-up corner.
    adb("shell", "input", "swipe", str(int(1205*fx)), str(int(64*fy)),
        str(int(1205*fx)), str(int(64*fy)), "3200", timeout=20)
    time.sleep(1)
    screenshot("08-parent")
    design_tap(600, 433)  # Parent: break interval 10->15
    settings = saved_state()
    expect(settings["break_minutes"] == 15, "grown-up long press and reminder setting")
    design_tap(640, 503)  # First tap arms reset only
    armed = saved_state()
    expect(armed["plots"][0] == 3, "first garden-reset tap preserves plants")
    design_tap(640, 503)  # Second tap clears
    clear = saved_state()
    expect(all(p == 0 for p in clear["plots"]), "second reset tap clears all nine plots")
    screenshot("09-parent-after-reset")

    check_crashes()
    dump_app_diagnostics("Completed emulator QA")
    summary = {
        "platform": "Android emulator API 34 x86_64",
        "viewport": [w, h],
        "tests": [
            "install_and_landscape", "launch_and_navigate", "plant_seed",
            "water_sprout", "water_flower", "audio_persistence",
            "restart_persistence", "rest", "parent_hold", "reminder_setting",
            "two_step_reset", "logcat_fatal_error_scan"
        ],
        "physical_device_tested": False,
        "ipad_tested": False,
    }
    (OUT / "result.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    print("EMULATOR_SMOKE_PASSED", flush=True)


if __name__ == "__main__":
    try:
        main()
    finally:
        # Upload screenshots/logcat also when an assertion fails.
        try:
            adb("logcat", "-d", "-v", "brief", timeout=45, check=False)
            log = adb("logcat", "-d", "-v", "brief", timeout=45, check=False)
            (OUT / "logcat.txt").write_text(log[-250_000:], encoding="utf-8")
        except Exception as exc:
            print(f"Warning: logcat capture failed: {exc}", flush=True)
