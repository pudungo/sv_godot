extends Node

enum CollectibleType {COIN, GEM, ORB} # defines type for dictionary
const WIN_UI_SCENE := preload("res://Scenes/WinUI.tscn") # for winUI scene to load but not show up later
const WIN_COIN_TARGET := 11 # number of coins to win
const WIN_RESET_DELAY := 2.0 # timer to delay

signal collectibles_updated
# Dictionary<CollectibleType, int>

var collectibles : Dictionary[int, int] = {} 
var _has_won := false

func _ready() -> void:
	reset()

func reset() -> void: # resets coin number when scene resets
	collectibles.clear()
	_has_won = false

	for type in CollectibleType.values():
		collectibles[type] = 0

	emit_signal("collectibles_updated") # calls out signal for UI to hear

func add_collectible(type: CollectibleType, amount := 1) -> void:
	if not collectibles.has(type): 
		collectibles[type] = 0 

	collectibles[type] += amount
	print(CollectibleType.keys()[type], ": ", collectibles[type]) 
	emit_signal("collectibles_updated")
	_check_win_condition()

func get_amount(type: CollectibleType) -> int:
	return collectibles.get(type, 0)


func _check_win_condition() -> void:
	if _has_won:
		return
	if get_amount(CollectibleType.COIN) < WIN_COIN_TARGET: # enable winUI scene to show up
		return

	_has_won = true
	call_deferred("_show_win_ui_and_reset_scene")


func _show_win_ui_and_reset_scene() -> void: # will reset scene after winUI scene is displayed
	var current_scene := get_tree().current_scene
	if current_scene != null:
		var win_ui := WIN_UI_SCENE.instantiate()
		current_scene.add_child(win_ui)

	await get_tree().create_timer(WIN_RESET_DELAY).timeout
	Transition.fade_to_scene("res://Scenes/MainMenuScene.tscn")
