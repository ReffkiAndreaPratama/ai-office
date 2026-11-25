# ============================================
# AI Dev Setup - Install Script (Komputer Baru)
# Jalankan sebagai Administrator:
# powershell -ExecutionPolicy Bypass -File setup-new-pc.ps1
# ============================================

Write-Host "=== AI Dev Setup - New PC ===" -ForegroundColor Cyan
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# --- 1. Restore configs ---
Write-Host "`n[1/6] Restoring configs..." -ForegroundColor Cyan
$configDir = "$scriptDir\..\configs"

if (Test-Path "$configDir\gemini-skills") {
    New-Item -ItemType Directory -Force "$env:USERPROFILE\.gemini\config" | Out-Null
    Copy-Item "$configDir\gemini-skills" "$env:USERPROFILE\.gemini\config\skills" -Recurse -Force
    Write-Host "  OK  Antigravity skills (74)" -ForegroundColor Green
}
if (Test-Path "$configDir\mcp_config.json") {
    Copy-Item "$configDir\mcp_config.json" "$env:USERPROFILE\.gemini\config\mcp_config.json" -Force
    Write-Host "  OK  Antigravity MCP" -ForegroundColor Green
}
if (Test-Path "$configDir\cursor-mcp.json") {
    New-Item -ItemType Directory -Force "$env:USERPROFILE\.cursor" | Out-Null
    Copy-Item "$configDir\cursor-mcp.json" "$env:USERPROFILE\.cursor\mcp.json" -Force
    Write-Host "  OK  Cursor MCP" -ForegroundColor Green
}
if (Test-Path "$configDir\opencode-config") {
    New-Item -ItemType Directory -Force "$env:USERPROFILE\.config\opencode" | Out-Null
    Copy-Item "$configDir\opencode-config\*" "$env:USERPROFILE\.config\opencode\" -Recurse -Force
    Write-Host "  OK  OpenCode config" -ForegroundColor Green
}
if (Test-Path "$configDir\aftman") {
    Copy-Item "$configDir\aftman" "$env:USERPROFILE\.aftman" -Recurse -Force
    $curPath = [System.Environment]::GetEnvironmentVariable("PATH","User")
    if ($curPath -notlike "*\.aftman\bin*") {
        [System.Environment]::SetEnvironmentVariable("PATH","$env:USERPROFILE\.aftman\bin;$curPath","User")
    }
    Write-Host "  OK  Aftman + Rojo" -ForegroundColor Green
}
if (Test-Path "$configDir\obsidian.json") {
    New-Item -ItemType Directory -Force "$env:APPDATA\obsidian" | Out-Null
    Copy-Item "$configDir\obsidian.json" "$env:APPDATA\obsidian\obsidian.json" -Force
    Write-Host "  OK  Obsidian vault config" -ForegroundColor Green
}

# --- 2. Node.js ---
Write-Host "`n[2/6] Node.js..." -ForegroundColor Cyan
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
    Write-Host "  OK  Already installed: $(node --version)" -ForegroundColor Green
} else {
    winget install OpenJS.NodeJS --accept-source-agreements --accept-package-agreements --silent
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
    Write-Host "  OK  Node.js installed" -ForegroundColor Green
}

# --- 3. npm global packages ---
Write-Host "`n[3/6] npm global packages..." -ForegroundColor Cyan
foreach ($pkg in @("godot-mcp","9router")) {
    npm install -g $pkg 2>&1 | Out-Null
    Write-Host "  OK  $pkg" -ForegroundColor Green
}

# --- 4. Apps via winget ---
Write-Host "`n[4/6] Installing apps..." -ForegroundColor Cyan
foreach ($app in @(
    @{Id="Git.Git";Name="Git"},
    @{Id="Obsidian.Obsidian";Name="Obsidian"},
    @{Id="Ollama.Ollama";Name="Ollama"}
)) {
    winget install --id $app.Id --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
    Write-Host "  OK  $($app.Name)" -ForegroundColor Green
}

# --- 5. Ollama model ---
Write-Host "`n[5/6] Ollama llama3.2 model..." -ForegroundColor Cyan
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
$ollamaBin = "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe"
if (Test-Path $ollamaBin) {
    Start-Process $ollamaBin -ArgumentList "serve" -WindowStyle Minimized
    Start-Sleep 4
    Write-Host "  Pulling llama3.2 (~3.8GB, 10-20 menit)..." -ForegroundColor Yellow
    & $ollamaBin pull llama3.2
    Write-Host "  OK  llama3.2 ready" -ForegroundColor Green
} else {
    Write-Host "  Ollama belum terinstall - install manual lalu jalankan: ollama pull llama3.2" -ForegroundColor Yellow
}

# --- 6. Manual install reminder ---
Write-Host "`n[6/6] Install manual berikut ini:" -ForegroundColor Cyan
Write-Host "  Cursor      -> https://cursor.com" -ForegroundColor Yellow
Write-Host "  Antigravity -> https://antigravity.google/download" -ForegroundColor Yellow
Write-Host "  VS Code     -> https://code.visualstudio.com" -ForegroundColor Yellow
Write-Host "  Godot       -> https://godotengine.org/download (atau Steam)" -ForegroundColor Yellow
Write-Host "  Roblox Studio -> https://create.roblox.com" -ForegroundColor Yellow
Write-Host ""
Write-Host "Setelah install semua:" -ForegroundColor Cyan
Write-Host "  1. Ekstrak D-Games.zip -> D:\Games" -ForegroundColor White
Write-Host "  2. Jalankan: powershell -File D:\Games\start-offices.ps1" -ForegroundColor White
Write-Host "  3. Buka Godot -> D:\Games\my-first-game -> Project Settings -> Plugins -> Godot MCP -> Enable" -ForegroundColor White
Write-Host "  4. Buka 9router: http://localhost:20128 -> setup provider AI" -ForegroundColor White
Write-Host ""
Write-Host "SELESAI!" -ForegroundColor Green
