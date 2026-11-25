---
name: roblox-game-dev
description: Expert Roblox Studio developer. Use when building Roblox games, writing Luau scripts, working with the DataModel, services, RemoteEvents, physics, UI, or any Roblox Studio task.
---

# Roblox Studio Game Development Skill

## Platform Context
- Roblox Studio with built-in AI Assistant
- Language: Luau (typed superset of Lua 5.1)
- MCP bridge available via roblox-studio MCP server
- External editor workflow: VS Code / Cursor + Rojo for file sync

## MCP Tools (requires Roblox Studio open)
Use roblox-studio MCP to:
- Read/write scripts in Studio
- Manipulate DataModel instances
- Control playtest
- Sync workspace

## Luau Style Guide
- Use type annotations: `local speed: number = 200`
- Strict mode: `--!strict` at top of every script
- PascalCase for services, ModuleScript names
- camelCase for variables and functions
- SCREAMING_SNAKE_CASE for constants

## Script Types
| Type | Location | Purpose |
|---|---|---|
| Script | Server (ServerScriptService) | Server-only logic |
| LocalScript | Client (StarterPlayerScripts) | Client-side UI, input |
| ModuleScript | Anywhere | Shared library code |

## Service Cheat Sheet
```lua
--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
```

## Client-Server Communication
```lua
-- Server Script: fire event to client
local event = ReplicatedStorage.RemoteEvent
event:FireClient(player, data)

-- LocalScript: listen
local event = ReplicatedStorage:WaitForChild("RemoteEvent")
event.OnClientEvent:Connect(function(data)
    print(data)
end)

-- LocalScript: call server function
local func = ReplicatedStorage:WaitForChild("RemoteFunction")
local result = func:InvokeServer(args)
```

## Common Patterns

### Player Character
```lua
--!strict
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player: Player)
    player.CharacterAdded:Connect(function(character: Model)
        local humanoid = character:WaitForChild("Humanoid") :: Humanoid
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end)
end)
```

### Touched Event (pickup/trigger)
```lua
local part = script.Parent :: BasePart
local debounce = false

part.Touched:Connect(function(hit: BasePart)
    if debounce then return end
    local character = hit.Parent
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid?
    if humanoid then
        debounce = true
        -- do something
        task.wait(1)
        debounce = false
    end
end)
```

### Tween Animation
```lua
local TweenService = game:GetService("TweenService")
local part = workspace.Part :: BasePart
local info = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(part, info, {Position = Vector3.new(0, 10, 0)})
tween:Play()
```

## Rojo Workflow (External Editor)
1. Install Rojo plugin in Studio
2. Run `rojo serve` in project folder
3. Click Connect in Studio Rojo plugin
4. Edit .lua/.luau files in VS Code/Cursor — syncs live

## Important Rules
- NEVER store sensitive data on client
- Validate all RemoteEvent/RemoteFunction calls on server
- Use task.wait() not wait() (deprecated)
- Use task.spawn() not spawn() (deprecated)
