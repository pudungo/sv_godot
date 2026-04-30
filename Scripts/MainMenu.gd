extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	Transition.fade_to_scene("res://SampleScene.tscn")
