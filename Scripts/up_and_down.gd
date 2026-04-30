extends Node3D

@export var speed: float = 2.0
@export_range(0.01, 500.0) var travel_distance: float = 4.0

var _start: Vector3
var _t: float = 0.0
var _going_up: bool = true
var _is_frozen: bool = false


func _ready() -> void:
	_start = position


func _physics_process(delta: float) -> void:
	if _is_frozen:
		return
	var step: float = speed * delta
	if _going_up:
		_t += step
		if _t >= travel_distance:
			_t = travel_distance
			_going_up = false
	else:
		_t -= step
		if _t <= 0.0:
			_t = 0.0
			_going_up = true

	position = _start + Vector3.UP * _t


func toggle_frozen() -> void:
	_is_frozen = not _is_frozen
