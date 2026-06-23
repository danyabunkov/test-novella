#!/usr/bin/env bash
set -euo pipefail

GODOT_VERSION="${GODOT_VERSION:-4.7}"
ROOT="${PWD}/.godot-bin"
ZIP="${ROOT}/godot-${GODOT_VERSION}-linux.x86_64.zip"
URL="https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip"

mkdir -p "${ROOT}"
if [[ ! -f "${ZIP}" ]]; then
  curl -L "${URL}" -o "${ZIP}"
fi
unzip -o "${ZIP}" -d "${ROOT}"
find "${ROOT}" -type f -name "Godot*_linux.x86_64" -print -quit
