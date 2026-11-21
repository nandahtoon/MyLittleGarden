#!/usr/bin/env python3
"""Pack an original embedded glTF 2.0 source into binary GLB without third-party deps.

Usage:
  python tools/pack_nova_glb.py assets/models/nova/nova.gltf build/assets/nova.glb
The authoritative editable checked-in asset is nova.gltf; CI attaches portable nova.glb.
"""
from __future__ import annotations
import base64
import json
from pathlib import Path
import struct
import sys

def pack(source: Path, destination: Path) -> dict:
    data = json.loads(source.read_text(encoding="utf-8"))
    assert data["asset"]["version"] == "2.0", "Expected glTF 2.0"
    assert len(data["buffers"]) == 1, "Expected a single embedded buffer"
    uri = data["buffers"][0].pop("uri")
    prefix = "data:application/octet-stream;base64,"
    assert uri.startswith(prefix), "External resources not allowed"
    blob = base64.b64decode(uri[len(prefix):], validate=True)
    assert len(blob) == data["buffers"][0]["byteLength"]
    for view in data["bufferViews"]:
        assert view["byteOffset"] + view["byteLength"] <= len(blob), "Out-of-bounds view"
    assert len(data.get("skins", [])) == 1, "Nova asset must retain its skeleton skin"
    names = {a["name"] for a in data.get("animations", [])}
    assert {"Idle", "Walk", "Wave"}.issubset(names), "Missing animation clip"
    raw_json = json.dumps(data, separators=(",", ":"), ensure_ascii=False).encode("utf-8")
    json_chunk = raw_json + b" " * (-len(raw_json) % 4)
    bin_chunk = blob + b"\x00" * (-len(blob) % 4)
    total = 12 + 8 + len(json_chunk) + 8 + len(bin_chunk)
    glb = b"glTF" + struct.pack("<II", 2, total)
    glb += struct.pack("<I4s", len(json_chunk), b"JSON") + json_chunk
    glb += struct.pack("<I4s", len(bin_chunk), b"BIN\x00") + bin_chunk
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(glb)
    assert destination.stat().st_size == total
    return {"binary_bytes": len(blob), "glb_bytes": total, "mesh_primitives": len(data["meshes"][0]["primitives"]), "animations": sorted(names)}

if __name__ == "__main__":
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("assets/models/nova/nova.gltf")
    dst = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("build/assets/nova.glb")
    print("PASS Nova GLB export:", json.dumps(pack(src, dst), sort_keys=True))
