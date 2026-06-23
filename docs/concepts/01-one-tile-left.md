# 01 - One Tile Left

Genre: minimalist logic puzzle. Engine target: Godot. Price target: `$2.99` or free with ads.

Hook: Every level has exactly one solution, and the player can feel it.

Prototype mechanic: exact-cover tile puzzle. The board has one protected target tile. The player places a limited set of pieces so every other cell is covered exactly once while the target remains uncovered.

Production notes:
- JSON level data.
- Solver/validator is the central tool.
- Minimal generated art; use geometric UI and abstract backgrounds.
- Daily puzzle is a future retention feature.

Prototype done when:
- Several sample levels load from JSON.
- The player can select and place pieces.
- The level reports completion.
- Validation script confirms solution counts.
