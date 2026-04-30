extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenuScene.tscn")
