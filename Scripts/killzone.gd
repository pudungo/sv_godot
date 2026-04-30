extends Area3D

@export var respawn_position: Vector3

func _ready() -> void:
	monitoring = true
	monitorable = true
	# Detect bodies on layer 1 
	collision_mask |= 1


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D: # Reads tagged player as CharacerBody3D (makes sure it's only the player detected)
		Transition.fade_to_scene("res://Scenes/GameOver.tscn")
