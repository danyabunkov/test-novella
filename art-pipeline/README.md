# Local Art Pipeline

Final art generation is local-only. Do not install ComfyUI, kohya_ss, diffusion models, checkpoints, LoRAs, or datasets in cloud.

## Local Install

Expected local root:

```text
C:\AI
```

Launchers:

```text
C:\AI\bin\comfyui.cmd
C:\AI\bin\comfyui-manager.cmd
C:\AI\bin\kohya.cmd
```

## Shared Folders

```text
C:\AI\models\checkpoints
C:\AI\models\loras
C:\AI\models\vae
C:\AI\models\controlnet
C:\AI\models\clip
C:\AI\models\clip_vision
C:\AI\models\unet
C:\AI\models\upscale_models
C:\AI\models\embeddings
C:\AI\datasets
C:\AI\outputs
C:\AI\workflows
```

ComfyUI reads the shared model folders through `extra_model_paths.yaml`.

## Importing Final Assets

Generated production assets should be reviewed locally, then copied into the relevant project folder under:

```text
prototypes/godot-portfolio/art/final/<prototype-id>/
```

Use descriptive names:

```text
background_greenhouse_orchid_room_v01.webp
sprite_guest_sailor_neutral_v01.png
ui_tile_world_01_v01.png
```

Do not commit raw datasets, model checkpoints, LoRA training outputs, or large iteration batches unless explicitly approved.

## Placeholder Rule

Until final assets exist, use Godot shapes, labels, simple colors, and documented dimensions. Code should not depend on final art being present.
