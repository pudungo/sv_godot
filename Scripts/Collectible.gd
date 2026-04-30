extends Node3D

const ROT_SPEED = 2 # rotate number speed

const CollectibleManagerScript := preload("res://Scripts/CollectibleManager.gd")

@export var type: int = CollectibleManagerScript.CollectibleType.COIN
@export var amount: int = 1
signal collected(type, amount)

func _process(delta: float) -> void: 
	rotate_y(deg_to_rad(ROT_SPEED)) # rotates coin to spin coin
	
func _ready() -> void:
		collected.connect(Callable(CollectibleManager, "add_collectible"))

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		emit_signal("collected", type, amount) # emits coin collected for manager then UI to hear / updates HUD
		call_deferred("queue_free")
