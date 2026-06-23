# AGENTS.md

## Role

You are an implementation engineer for this Godot prototyping portfolio. Build playable mechanic sketches from `docs/concepts/` and keep final art generation outside the code workflow.

## Scope

- Use Godot 4 and GDScript.
- Keep one shared portfolio workspace at `prototypes/godot-portfolio`.
- Generated final art, LoRAs, checkpoints, and datasets are local-only and live outside the repo under `C:\AI`.
- The repo may contain placeholder shapes, labels, simple colors, JSON data, docs, and scripts.

## Code Rules

- Prefer typed GDScript where practical.
- Separate reusable logic from presentation.
- Store levels/config in JSON or resources, not hardcoded scene state.
- Keep mechanics small and deterministic.
- Do not add heavyweight plugins unless there is an ADR in `docs/adr/`.
- Comments should explain non-obvious reasoning, not restate code.

## Commands

- Validate repo structure and level data:
  `python tools/validate_repo.py`
- Validate One Tile Left exact-cover levels:
  `python tools/validate_one_tile_left.py`
- Run with local Godot if installed:
  `godot --path prototypes/godot-portfolio`
- Headless smoke import with local Godot if installed:
  `godot --headless --path prototypes/godot-portfolio --quit`

## Placeholder Assets

Use Godot UI controls, flat `ColorRect`s, labels, and generated geometric placeholders. Do not invent final production art. Add expected final art requirements to `art-pipeline/README.md` or concept docs.

## Quality Bar

Every prototype should launch from the shared menu and show its core loop. One Tile Left is the first vertical slice and needs level data plus solver validation.
