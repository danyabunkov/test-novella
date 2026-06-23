# Cloud Agent Prompt

```text
You are working in the GitHub repository for a Godot game prototyping portfolio.

Goal:
Build a cloud-first Godot development pipeline and implement around 10 playable prototype concepts based on the repository markdown design docs. Work autonomously. Do not ask the user for routine decisions; make conservative engineering choices and document them.

Important constraints:
- Do not install ComfyUI, kohya_ss, Stable Diffusion models, Flux models, LoRA training tools, or image-generation assets in cloud.
- Image generation and LoRA training are local-only and will be handled separately.
- Use placeholder art in the repo.
- Use Godot 4 and GDScript.
- Prefer headless validation/build commands that work in CI.
- Keep the repo clean and maintainable.
- If docs are mojibake/encoding-broken, recover or normalize the needed design content into clean UTF-8 docs before implementation.

Read first:
- README.md
- 00-production-bible-setup (1).md
- 01-ten-games-design.md
- 02-templates-prompts-checklists.md

Deliverables:
1. Create a clear repo structure for the portfolio: docs/, prototypes/, tools/, art-pipeline/, and .github/workflows/ if CI is feasible.
2. Extract or summarize the 10 concepts from the design docs into clean UTF-8 files under docs/concepts/.
3. Create root-level AGENTS.md with coding rules, Godot/GDScript conventions, test/build commands, placeholder asset rules, and a rule that generated final art is external/local.
4. Decide the Godot project layout: one shared Godot workspace with prototype scenes selectable from a menu, or separate Godot project folders per prototype. Choose the cleaner option for CI and iteration, then document it in docs/adr/.
5. Implement playable prototypes for all 10 concepts at mechanic-sketch quality.
6. Prioritize project 1, One Tile Left, as the first vertical slice with level data, validation/solver if needed, sample levels, and tests or validation scripts.
7. Add setup, validation, and build/export automation where practical.
8. Add art-pipeline/README.md explaining that ComfyUI/kohya_ss live locally under C:\AI and defining how generated assets are imported.
9. Finish with a clear summary: what was built, how to run it, how to test it, what remains for local art generation, and next recommended steps.

Implementation standards:
- Keep code simple and readable.
- Use typed GDScript where practical.
- Separate mechanics logic from presentation.
- Use data files for levels/config where reasonable.
- Do not add heavyweight plugins unless justified in docs/adr/.
- Do not block on missing art; create simple placeholder shapes/colors/text labels.
- Do not use network services except for installing Godot/headless dependencies or CI setup if needed.
- If there is ambiguity, choose the smallest practical implementation and document the assumption.

Start by reading the docs, creating a short plan in the repo, then implement.
```
