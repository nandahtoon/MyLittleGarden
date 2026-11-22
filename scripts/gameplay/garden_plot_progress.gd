extends RefCounted
## LW3D-W2 separate local garden-plot progress, never touches legacy v1 or Rainbow saves.

const FILE_PATH := "user://lw3d_garden_plots_w2.json"
const VERSION := 1
const PLOT_COUNT := 4


static func defaults() -> Dictionary:
    return {"version": VERSION, "plots": [0, 0, 0, 0]}


static func _sanitize(data: Dictionary) -> Dictionary:
    var result := defaults()
    var source: Variant = data.get("plots", [])
    if not source is Array:
        return result
    var stages: Array = []
    for i in range(PLOT_COUNT):
        var stage := 0
        if i < source.size() and (source[i] is int or source[i] is float):
            stage = clampi(int(source[i]), 0, 3)
        stages.append(stage)
    result["plots"] = stages
    return result


static func load_progress() -> Dictionary:
    if not FileAccess.file_exists(FILE_PATH):
        return defaults()
    var file := FileAccess.open(FILE_PATH, FileAccess.READ)
    if file == null:
        return defaults()
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if not parsed is Dictionary:
        return defaults()
    if int(parsed.get("version", 0)) != VERSION:
        return defaults()
    return _sanitize(parsed)


static func save_progress(data: Dictionary) -> bool:
    var safe := _sanitize(data)
    var temporary := FILE_PATH + ".tmp"
    var file := FileAccess.open(temporary, FileAccess.WRITE)
    if file == null:
        push_warning("Could not write temporary W2 garden plot progress.")
        return false
    file.store_string(JSON.stringify(safe))
    file.flush()
    file = null
    var result := DirAccess.rename_absolute(
        ProjectSettings.globalize_path(temporary),
        ProjectSettings.globalize_path(FILE_PATH)
    )
    if result != OK:
        push_warning("Could not commit W2 garden plot progress.")
    return result == OK
