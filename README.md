# Godot Prototype Portfolio

Cloud-first portfolio for ten game prototype concepts. Code and CI live in this repository; final image generation and LoRA training are local-only under `C:\AI`.

## Structure

- `docs/concepts/` - clean UTF-8 concept briefs
- `docs/adr/` - architecture decisions
- `prototypes/godot-portfolio/` - shared Godot 4 workspace with a launcher menu
- `tools/` - validation and setup scripts
- `art-pipeline/` - local ComfyUI/kohya workflow notes

## Validate

```bash
python tools/validate_repo.py
python tools/validate_one_tile_left.py
```

## Run With Godot

```bash
godot --path prototypes/godot-portfolio
```

Headless smoke import:

```bash
godot --headless --path prototypes/godot-portfolio --quit
```

## Local Art

Use `scripts/install_local_ai_stack.ps1` to install/update local ComfyUI and kohya_ss under `C:\AI`. Do not install image generation tools in cloud.
