$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$Root = "C:\AI"
$Downloads = Join-Path $Root "_downloads"
$Bin = Join-Path $Root "bin"
$Log = Join-Path $Root "local-ai-install.log"

function Ensure-Dir {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Write-Step {
    param([string]$Message)
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$stamp] $Message"
}

function Download-File {
    param(
        [string]$Url,
        [string]$OutFile,
        [long]$MinBytes = 1
    )
    if (Test-Path -LiteralPath $OutFile) {
        $existing = Get-Item -LiteralPath $OutFile
        if ($existing.Length -ge $MinBytes) {
            Write-Step "Already downloaded: $OutFile"
            return
        }
        Write-Step "Removing incomplete download: $OutFile"
        Remove-Item -LiteralPath $OutFile
    }
    Write-Step "Downloading: $Url"
    Invoke-WebRequest -Uri $Url -OutFile $OutFile
}

function Extract-Zip {
    param(
        [string]$Archive,
        [string]$Destination
    )
    Ensure-Dir $Destination
    Write-Step "Extracting ZIP: $Archive"
    Expand-Archive -LiteralPath $Archive -DestinationPath $Destination -Force
}

function Extract-7z {
    param(
        [string]$SevenZip,
        [string]$Archive,
        [string]$Destination
    )
    Ensure-Dir $Destination
    Write-Step "Extracting 7z: $Archive"
    & $SevenZip x $Archive "-o$Destination" -y | Write-Host
    if ($LASTEXITCODE -ne 0) {
        throw "7z extraction failed with exit code $LASTEXITCODE"
    }
}

function Write-Launcher {
    param(
        [string]$Path,
        [string]$Content
    )
    Set-Content -LiteralPath $Path -Encoding ASCII -Value $Content
}

Ensure-Dir $Root
Ensure-Dir $Downloads
Ensure-Dir $Bin
Ensure-Dir (Join-Path $Root "models")
Ensure-Dir (Join-Path $Root "models\checkpoints")
Ensure-Dir (Join-Path $Root "models\loras")
Ensure-Dir (Join-Path $Root "models\vae")
Ensure-Dir (Join-Path $Root "models\controlnet")
Ensure-Dir (Join-Path $Root "models\clip")
Ensure-Dir (Join-Path $Root "models\clip_vision")
Ensure-Dir (Join-Path $Root "models\unet")
Ensure-Dir (Join-Path $Root "models\upscale_models")
Ensure-Dir (Join-Path $Root "models\embeddings")
Ensure-Dir (Join-Path $Root "datasets")
Ensure-Dir (Join-Path $Root "outputs")
Ensure-Dir (Join-Path $Root "workflows")

Start-Transcript -Path $Log -Append | Out-Null
try {
    Write-Step "Local AI stack install root: $Root"

    $SevenZip = Join-Path $Bin "7zr.exe"
    Download-File "https://www.7-zip.org/a/7zr.exe" $SevenZip 100000

    $ComfyArchive = Join-Path $Downloads "ComfyUI_windows_portable_nvidia.7z"
    $ComfyInstallDir = Join-Path $Root "ComfyUI"
    Download-File "https://github.com/comfyanonymous/ComfyUI/releases/latest/download/ComfyUI_windows_portable_nvidia.7z" $ComfyArchive 100000000

    $ComfyRoot = $null
    if (Test-Path -LiteralPath $ComfyInstallDir) {
        $ComfyRoot = Get-ChildItem -LiteralPath $ComfyInstallDir -Directory -Recurse -ErrorAction SilentlyContinue |
            Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName "run_nvidia_gpu.bat") } |
            Select-Object -First 1
    }
    if (-not $ComfyRoot) {
        Extract-7z $SevenZip $ComfyArchive $ComfyInstallDir
        $ComfyRoot = Get-ChildItem -LiteralPath $ComfyInstallDir -Directory -Recurse |
            Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName "run_nvidia_gpu.bat") } |
            Select-Object -First 1
    }
    if (-not $ComfyRoot) {
        throw "ComfyUI portable root was not found after extraction."
    }

    $ComfyAppDir = Join-Path $ComfyRoot.FullName "ComfyUI"
    $ExtraModels = @"
ai_stack:
  base_path: C:\AI\models
  checkpoints: checkpoints
  loras: loras
  vae: vae
  controlnet: controlnet
  clip: clip
  clip_vision: clip_vision
  unet: unet
  upscale_models: upscale_models
  embeddings: embeddings
"@
    Set-Content -LiteralPath (Join-Path $ComfyAppDir "extra_model_paths.yaml") -Encoding UTF8 -Value $ExtraModels
    Write-Launcher (Join-Path $Bin "comfyui.cmd") "@echo off`r`ncd /d `"$($ComfyRoot.FullName)`"`r`ncall run_nvidia_gpu.bat`r`n"
    Write-Launcher (Join-Path $Bin "comfyui-manager.cmd") "@echo off`r`ncd /d `"$($ComfyRoot.FullName)`"`r`npython_embeded\python.exe -s ComfyUI\main.py --listen 127.0.0.1 --port 8188 --enable-manager`r`n"
    Write-Step "ComfyUI ready: $($ComfyRoot.FullName)"

    $UvZip = Join-Path $Downloads "uv-x86_64-pc-windows-msvc.zip"
    $UvDir = Join-Path $Root "uv"
    Download-File "https://github.com/astral-sh/uv/releases/latest/download/uv-x86_64-pc-windows-msvc.zip" $UvZip 1000000
    if (-not (Get-ChildItem -LiteralPath $UvDir -Recurse -Filter "uv.exe" -ErrorAction SilentlyContinue | Select-Object -First 1)) {
        Extract-Zip $UvZip $UvDir
    }
    $UvExe = Get-ChildItem -LiteralPath $UvDir -Recurse -Filter "uv.exe" | Select-Object -First 1
    if (-not $UvExe) {
        throw "uv.exe was not found after extraction."
    }
    Write-Step "uv ready: $($UvExe.FullName)"

    $env:UV_CACHE_DIR = Join-Path $Root "uv-cache"
    $env:UV_PYTHON_INSTALL_DIR = Join-Path $Root "uv-python"
    Ensure-Dir $env:UV_CACHE_DIR
    Ensure-Dir $env:UV_PYTHON_INSTALL_DIR

    $KohyaDir = Join-Path $Root "kohya_ss"
    if (-not (Test-Path -LiteralPath $KohyaDir)) {
        Write-Step "Cloning kohya_ss"
        git clone --recursive https://github.com/bmaltais/kohya_ss.git $KohyaDir
        if ($LASTEXITCODE -ne 0) {
            throw "git clone kohya_ss failed with exit code $LASTEXITCODE"
        }
    } else {
        Write-Step "kohya_ss already exists: $KohyaDir"
    }

    Write-Step "Installing Python 3.11 for kohya_ss through uv"
    & $UvExe.FullName python install 3.11
    if ($LASTEXITCODE -ne 0) {
        throw "uv python install failed with exit code $LASTEXITCODE"
    }

    Write-Step "Syncing kohya_ss dependencies through uv"
    Push-Location $KohyaDir
    try {
        & $UvExe.FullName sync --python 3.11
        if ($LASTEXITCODE -ne 0) {
            Write-Step "uv sync failed; kohya_ss source is present, but dependencies need manual follow-up."
        }
    } finally {
        Pop-Location
    }

    Write-Launcher (Join-Path $Bin "kohya.cmd") "@echo off`r`nset UV_CACHE_DIR=C:\AI\uv-cache`r`nset UV_PYTHON_INSTALL_DIR=C:\AI\uv-python`r`ncd /d C:\AI\kohya_ss`r`n`"$($UvExe.FullName)`" run --python 3.11 kohya_gui.py`r`n"

    $Readme = @"
# Local AI Stack

Installed under `C:\AI`.

## Launchers

- ComfyUI: `C:\AI\bin\comfyui.cmd`
- kohya_ss: `C:\AI\bin\kohya.cmd`

## Shared Model Folders

- Checkpoints: `C:\AI\models\checkpoints`
- LoRA: `C:\AI\models\loras`
- VAE: `C:\AI\models\vae`
- ControlNet: `C:\AI\models\controlnet`
- CLIP: `C:\AI\models\clip`
- CLIP Vision: `C:\AI\models\clip_vision`
- UNet/Diffusion models: `C:\AI\models\unet`
- Upscalers: `C:\AI\models\upscale_models`
- Embeddings: `C:\AI\models\embeddings`

ComfyUI reads these folders through `extra_model_paths.yaml`.
"@
    Set-Content -LiteralPath (Join-Path $Root "README-local-ai.md") -Encoding UTF8 -Value $Readme

    Write-Step "Install finished."
    Write-Step "Launch ComfyUI: C:\AI\bin\comfyui.cmd"
    Write-Step "Launch kohya_ss: C:\AI\bin\kohya.cmd"
} finally {
    Stop-Transcript | Out-Null
}
