#!/usr/bin/env python3
"""Validate repository structure for the cloud-first Godot portfolio."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "AGENTS.md",
    "art-pipeline/README.md",
    "docs/adr/0001-shared-godot-portfolio.md",
    "docs/implementation-plan.md",
    "prototypes/godot-portfolio/project.godot",
    "prototypes/godot-portfolio/scenes/Main.tscn",
    "prototypes/godot-portfolio/scripts/Main.gd",
    "prototypes/godot-portfolio/scripts/core/prototype_base.gd",
    "prototypes/godot-portfolio/levels/one_tile_left/sample_levels.json",
]

PROTOTYPE_IDS = [
    "one_tile_left",
    "lumen",
    "tidy_hearth",
    "last_train_home",
    "glasshouse",
    "postcards",
    "lighthouse",
    "signal",
    "ink_tea",
    "hollow_year",
]


def main() -> int:
    errors: list[str] = []

    for relative in REQUIRED_FILES:
        if not (ROOT / relative).is_file():
            errors.append(f"missing required file: {relative}")

    for index in range(1, 11):
        concept = ROOT / "docs" / "concepts" / f"{index:02d}-"
        if not list(concept.parent.glob(f"{index:02d}-*.md")):
            errors.append(f"missing concept brief for index {index:02d}")

    for prototype_id in PROTOTYPE_IDS:
        script = ROOT / "prototypes" / "godot-portfolio" / "scripts" / "prototypes" / f"{prototype_id}.gd"
        if not script.is_file():
            errors.append(f"missing prototype script: {script.relative_to(ROOT)}")

    level_file = ROOT / "prototypes" / "godot-portfolio" / "levels" / "one_tile_left" / "sample_levels.json"
    if level_file.is_file():
        try:
            levels = json.loads(level_file.read_text(encoding="utf-8"))
            if len(levels) < 3:
                errors.append("One Tile Left should include at least 3 sample levels")
        except json.JSONDecodeError as exc:
            errors.append(f"invalid One Tile Left JSON: {exc}")

    if errors:
        for error in errors:
            print(f"[FAIL] {error}")
        return 1

    print("[OK] repository structure is valid")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
