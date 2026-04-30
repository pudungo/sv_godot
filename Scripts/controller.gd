extends CharacterBody3D

@export_group("Camera")

@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export var move_speed := 3.0
@export var acceleration := 10.0
@export var rotation_speed := 12.0
@export var click_interact_distance := 100.0

@export var jump_impulse := 12.0
var gravity := -30.0

var last_movement_direction := Vector3.BACK
var _camera_input_direction := Vector2.ZERO

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/SpringArm3D/Camera3D
@onready var character_visual: Node3D = $kajanim_go2
@onready var animation_player: AnimationPlayer = $kajanim_go2/AnimationPlayer

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED # Gets mouse controll
		)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_toggle_clicked_mover()
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _toggle_clicked_mover() -> void:
	var viewport := get_viewport()
	var mouse_pos := viewport.get_mouse_position()
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_pos = viewport.get_visible_rect().size * 0.5

	var ray_from := camera.project_ray_origin(mouse_pos)
	var ray_to := ray_from + camera.project_ray_normal(mouse_pos) * click_interact_distance
	var ray_params := PhysicsRayQueryParameters3D.create(ray_from, ray_to)
	ray_params.collide_with_bodies = true
	ray_params.collide_with_areas = true
	ray_params.exclude = [self]

	var hit := get_world_3d().direct_space_state.intersect_ray(ray_params)
	if hit.is_empty():
		return

	var clicked_node: Node = hit["collider"]
	while clicked_node != null:
		if clicked_node.has_method("toggle_frozen"):
			clicked_node.call("toggle_frozen")
			return
		clicked_node = clicked_node.get_parent()
		
func _physics_process(delta: float) -> void: 
	# Mouse look/aim control
	camera_pivot.rotation.x -= _camera_input_direction.y * delta
	
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI / 6.0, PI/3.0)
	
	camera_pivot.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	# Velocity Control
	var raw_input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var forward := -camera.global_basis.z
	var right := camera.global_basis.x
	
	var move_direction := forward * -raw_input.y + right * raw_input.x # Moving y is backwards as character is rotated -180 degrees
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)


	move_and_slide()
	
	# Rotates character body to face move direction
	if move_direction.length() > 0.0:
		last_movement_direction = move_direction.normalized()
		
	var target_angle := atan2(last_movement_direction.x, last_movement_direction.z) + PI
	character_visual.rotation.y = lerp_angle(
		character_visual.rotation.y,
		target_angle, 
		rotation_speed * delta
	)
	

		
	var y_velocity := velocity.y
	velocity.y = 0.0
	
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	
	velocity.y = y_velocity + gravity * delta
	
	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
			velocity.y +=jump_impulse
			
	move_and_slide()
	
	# fall detection / Animaton Player
	if is_starting_jump:
		animation_player.play("jump")
	elif not is_on_floor() and velocity.y < 0:
		animation_player.play("fall")
	
	elif is_on_floor():
		var ground_speed := velocity.length()
		if ground_speed > 0.0:
			animation_player.play("walk")
		else:
			animation_player.play("idle")
