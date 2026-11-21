extends RefCounted
## Separate, offline LW3D-V1 mission progress. Never overwrites the legacy garden v1 save.
## This is a transition-sidecar, not the final cross-game SaveService migration.

const FILE_PATH := "user://lw3d_rainbow_progress_v1.json"
const MISSION_ID := "rainbow_bridge_001"

static func defaults() -> Dictionary:
    return {"version": 1, "mission_id": MISSION_ID, "completed": false, "approach": "", "seed_stage": 0}


static func load_progress() -> Dictionary:
    if not FileAccess.file_exists(FILE_PATH):
        return defaults()
    var file := FileAccess.open(FILE_PATH, FileAccess.READ)
    if file == null:
        return defaults()
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if not parsed is Dictionary:
        return defaults()
    if parsed.get("mission_id") != MISSION_ID or int(parsed.get("version", 0)) != 1:
        return defaults()
    var result := defaults()
    result["completed"] = bool(parsed.get("completed", false))
    var path := str(parsed.get("approach", ""))
    result["approach"] = path if path in ["", "shape", "nature"] else ""
    result["seed_stage"] = clampi(int(parsed.get("seed_stage", 0)), 0, 2)
    return result


static func save_progress(value: Dictionary) -> bool:
    var safe := defaults()
    safe["completed"] = bool(value.get("completed", false))
    var approach := str(value.get("approach", ""))
    safe["approach"] = approach if approach in ["", "shape", "nature"] else ""
    safe["seed_stage"] = clampi(int(value.get("seed_stage", 0)), 0, 2)
    var temporary_path := FILE_PATH + ".tmp"
    var file := FileAccess.open(temporary_path, FileAccess.WRITE)
    if file == null:
        push_warning("Could not write temporary Rainbow mission progress.")
        return false
    file.store_string(JSON.stringify(safe))
    file.flush()
    file = null
    var result := DirAccess.rename_absolute(
        ProjectSettings.globalize_path(temporary_path),
        ProjectSettings.globalize_path(FILE_PATH)
    )
    if result != OK:
        push_warning("Could not safely commit Rainbow mission progress.")
    return result == OK
