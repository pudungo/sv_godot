extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_pressed() -> void:
	Transition.fade_to_scene("res://Scenes/MainMenuScene.tscn")
