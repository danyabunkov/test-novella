# ADR 0001: Shared Godot Portfolio Workspace

## Status

Accepted

## Context

The repository contains ten concepts with mixed final engines. The immediate goal is not final production but mechanic sketches that can run in cloud CI and be reviewed quickly. Running ten separate Godot projects would duplicate setup, CI, placeholder UI, and launch instructions.

## Decision

Use one shared Godot 4 project at `prototypes/godot-portfolio`. It contains a menu scene that launches each prototype as a self-contained `Control` view. Shared UI and helper code live under `scripts/core/`; prototype-specific logic lives under `scripts/prototypes/`; level data lives under `levels/`.

## Consequences

- CI validates one Godot project instead of ten.
- Shared placeholder UI and data loading are reused.
- Non-Godot final concepts are still represented as Godot mechanic sketches, not final engine commitments.
- If a concept graduates to production, it can be extracted into its own repository or engine later.
