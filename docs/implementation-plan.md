# Implementation Plan

## Phase 1: Portfolio Skeleton

- Normalize concept briefs into `docs/concepts/`.
- Keep one shared Godot workspace at `prototypes/godot-portfolio`.
- Build a menu that launches all prototype sketches.
- Add validation scripts that work without the Godot editor.

## Phase 2: Mechanic Sketches

- Implement one small, playable interaction per concept.
- Give every prototype a completion state.
- Keep visuals as placeholder UI controls.
- Prioritize deterministic logic over polish.

## Phase 3: One Tile Left Vertical Slice

- Store puzzle levels as JSON.
- Validate levels with an exact-cover solver.
- Provide several sample levels.
- Keep mechanics suitable for expansion into 120 production levels.

## Phase 4: Cloud CI

- Run Python validation on every push/PR.
- Optionally run Godot headless import when a CI image or installed binary is available.
- Keep ComfyUI, kohya_ss, checkpoints, LoRAs, and datasets out of cloud.
