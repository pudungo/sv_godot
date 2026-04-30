extends Node


@onready var coin_sound: AudioStreamPlayer = $CoinSound
@onready var music_player: AudioStreamPlayer = $MusicPlayer

# Preload music
var main_menu_music = preload("res://Sounds/ICO Atmospheres [_K1KbfP9WAA].mp3")
var gameplay_music = preload("res://Sounds/Killer7 OST Unreleased #19 - White Sugar (Margarita Mix).mp3")
var game_over_music = preload("res://Sounds/seTitle04L [1].wav")

func _ready() -> void:
	CollectibleManager.collectible_added.connect(_on_collectible_sound)
	Transition.scene_changed.connect(_on_scene_changed)
	
	# play music for the starting scene
	var current_scene = get_tree().current_scene.scene_file_path
	_on_scene_changed(current_scene)
	
# music control
func play_music(stream: AudioStream):
	if music_player.stream == stream:
		return
	music_player.stop()
	music_player.stream = stream
	music_player.play()
	
	# music router
func _on_scene_changed(scene_path):
	match scene_path:
		"res://Scenes/MainMenuScene.tscn":
			play_music(main_menu_music)
		"res://SampleScene.tscn":
			play_music(gameplay_music)
		"res://Scenes/GameOver.tscn":
			play_music(game_over_music)

func _on_collectible_sound(type: int) -> void:
	match type:
		CollectibleManager.CollectibleType.COIN:
			coin_sound.play()
