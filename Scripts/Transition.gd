extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var next_scene_path = ""

func _ready() -> void:
	if not animation_player.animation_finished.is_connected(_on_animation_player_animation_finished):
		animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func fade_to_scene(scene_path: String) -> void:
	next_scene_path = scene_path
	# Hide HUD scene
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.visible = false
		
	animation_player.play("Fade_Out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Fade_Out":
		await get_tree().create_timer(1.0).timeout #wait 1 sec
		var change_result := get_tree().change_scene_to_file(next_scene_path)
		if change_result != OK:
			push_error("Transition failed to change scene to: %s" % next_scene_path)
			return
		animation_player.play("Fade_In")
