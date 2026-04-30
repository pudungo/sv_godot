extends Area3D

@export var respawn_position: Vector3

func _ready() -> void:
	monitoring = true
	monitorable = true
	# Detect bodies on layer 1 
	collision_mask |= 1


func _on_body_entered(body: Node3D) -> void:
	if not (body is CharacterBody3D): # Reads tagged player as CharacerBody3D (makes sure it's only the player detected)
		return
	if respawn_position != Vector3.ZERO: 
		body.global_position = respawn_position # Resets scene to respawn location
	call_deferred("reset_scene") 


func reset_scene() -> void:
	await get_tree().create_timer(2.0).timeout # Delay timer before the scene is reset after death
	get_tree().reload_current_scene()
