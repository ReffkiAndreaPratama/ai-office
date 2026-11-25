---
name: godot-game-dev
description: Expert Godot 4 game developer. Use when building games, writing GDScript, creating scenes, working with nodes, physics, UI, audio, shaders, or any Godot engine task.
---

# Godot 4 Game Development Skill

## Engine Context
- Godot 4.7.2
- GDScript 2.0 with static typing
- Project: D:\Games\my-first-game
- Godot executable: D:\dwnld\Godot_v4.7.2-stable_win64.exe

## MCP Tools (requires Godot editor open)
Use godot-mcp to directly control the editor:
- Create/modify scenes and nodes
- Write and attach scripts
- Run the game
- Inspect scene tree

## GDScript 2.0 Rules
- ALWAYS use static typing: `var speed: float = 200.0`
- Use `@export` for inspector-visible properties
- Use `@onready` for node references: `@onready var sprite: Sprite2D = $Sprite2D`
- Use signals for decoupled communication
- Extend the right base class for each purpose

## Node Type Selection
| Purpose | Node |
|---|---|
| Player / enemy (physics) | CharacterBody2D / CharacterBody3D |
| Trigger / hitbox / pickup | Area2D / Area3D |
| Static geometry | StaticBody2D / StaticBody3D |
| Moving platform | AnimatableBody2D |
| Projectile | RigidBody2D |
| Camera | Camera2D / Camera3D |
| UI root | CanvasLayer + Control |
| Sounds | AudioStreamPlayer / AudioStreamPlayer2D |
| VFX | GPUParticles2D / GPUParticles3D |

## Common Patterns

### Player Controller (2D)
```gdscript
extends CharacterBody2D

const SPEED: float = 200.0
const JUMP_VELOCITY: float = -400.0

@export var health: int = 100
@onready var anim: AnimationPlayer = $AnimationPlayer

signal died

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity += get_gravity() * delta
    
    var direction: float = Input.get_axis("ui_left", "ui_right")
    velocity.x = direction * SPEED
    
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY
    
    move_and_slide()
```

### Singleton / Autoload
```gdscript
# GameManager.gd - add to Project > Project Settings > Autoload
extends Node

var score: int = 0
var lives: int = 3

signal score_changed(new_score: int)

func add_score(points: int) -> void:
    score += points
    score_changed.emit(score)
```

### Signal Connection
```gdscript
# In _ready():
enemy.died.connect(_on_enemy_died)

func _on_enemy_died() -> void:
    GameManager.add_score(100)
```

## Scene File Tips
- .tscn = scene (nodes + properties)
- .tres = resource (data, materials, curves)
- .gd = script
- .gdshader = shader code

## Export & Platform
- HTML5: Project > Export > Web
- Windows: Project > Export > Windows Desktop
- Android: requires Android SDK + export templates
