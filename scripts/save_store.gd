extends RefCounted
## Saves only local garden stages and parental preferences. No network or IDs.

const FILE_PATH := "user://little_wonder_garden.json"

static func load_data() -> Dictionary:
    if not FileAccess.file_exists(FILE_PATH):
        return {}
    var file := FileAccess.open(FILE_PATH, FileAccess.READ)
    if file == null:
        return {}
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if parsed is Dictionary:
        return parsed
    return {}


static func save_data(stages: Array[int], sound_enabled: bool, break_enabled: bool, break_minutes: int) -> void:
    var file := FileAccess.open(FILE_PATH, FileAccess.WRITE)
    if file == null:
        push_warning("Could not save the garden.")
        return
    var data := {
        "version": 1,
        "plots": stages,
        "sound_enabled": sound_enabled,
        "break_enabled": break_enabled,
        "break_minutes": break_minutes
    }
    file.store_string(JSON.stringify(data))
