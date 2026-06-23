#!/usr/bin/env python3
"""Validate One Tile Left exact-cover levels."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEVEL_FILE = ROOT / "prototypes" / "godot-portfolio" / "levels" / "one_tile_left" / "sample_levels.json"


def piece_cells(piece: dict, origin: tuple[int, int]) -> frozenset[tuple[int, int]]:
    ox, oy = origin
    return frozenset((ox + int(x), oy + int(y)) for x, y in piece["cells"])


def valid_placements(level: dict, piece: dict) -> list[frozenset[tuple[int, int]]]:
    size = int(level["size"])
    target = tuple(level["target"])
    origins = piece.get("allowed_origins")
    if origins is None:
        origins = [(x, y) for y in range(size) for x in range(size)]

    placements: list[frozenset[tuple[int, int]]] = []
    for raw_origin in origins:
        cells = piece_cells(piece, (int(raw_origin[0]), int(raw_origin[1])))
        if target in cells:
            continue
        if any(x < 0 or y < 0 or x >= size or y >= size for x, y in cells):
            continue
        if len(cells) != len(piece["cells"]):
            continue
        placements.append(cells)
    return placements


def count_solutions(level: dict, limit: int = 2) -> int:
    size = int(level["size"])
    target = tuple(level["target"])
    board = {(x, y) for y in range(size) for x in range(size)}
    required = board - {target}
    placements_by_piece = [valid_placements(level, piece) for piece in level["pieces"]]

    if any(not placements for placements in placements_by_piece):
        return 0

    count = 0

    def search(piece_index: int, covered: set[tuple[int, int]]) -> None:
        nonlocal count
        if count >= limit:
            return
        if piece_index == len(placements_by_piece):
            if covered == required:
                count += 1
            return
        for placement in placements_by_piece[piece_index]:
            if covered.intersection(placement):
                continue
            if not placement.issubset(required):
                continue
            search(piece_index + 1, covered | set(placement))

    search(0, set())
    return count


def validate_level(level: dict) -> list[str]:
    errors: list[str] = []
    for key in ("id", "name", "size", "target", "pieces"):
        if key not in level:
            errors.append(f"missing key: {key}")
    if errors:
        return errors

    size = int(level["size"])
    target = level["target"]
    if len(target) != 2 or not (0 <= int(target[0]) < size and 0 <= int(target[1]) < size):
        errors.append("target is outside board")

    pieces = level["pieces"]
    if not pieces:
        errors.append("level has no pieces")
    for piece in pieces:
        if "id" not in piece or "cells" not in piece:
            errors.append(f"piece is missing id/cells: {piece}")
            continue
        if not piece["cells"]:
            errors.append(f"piece {piece['id']} has no cells")

    solution_count = count_solutions(level)
    if solution_count != 1:
        errors.append(f"expected exactly 1 solution, got {solution_count}")
    return errors


def main() -> int:
    levels = json.loads(LEVEL_FILE.read_text(encoding="utf-8"))
    failed = False
    for level in levels:
        errors = validate_level(level)
        if errors:
            failed = True
            print(f"[FAIL] {level.get('id', '<unknown>')}:")
            for error in errors:
                print(f"  - {error}")
        else:
            print(f"[OK] {level['id']}: exactly one solution")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
