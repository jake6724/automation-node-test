class_name PlayerCamera
extends Camera2D

var zoom_step: float = 0.1
var zoom_speed: float = 0.1
var zoom_target: Vector2 = Vector2(1.0, 1.0) # Always works as initial zoom
var zoom_min: Vector2 = Vector2(0.25, 0.25) # How far OUT camera can zoom
var zoom_max: Vector2 = Vector2(1.6, 1.6) # How far IN camera can zoom

var is_panning: bool = false
var drag_sensitivity: float = 1.0
var camera_move_speed: float = 25

func _process(delta):
	# print(zoom)
	if zoom != zoom_target:
		zoom = lerp(zoom, zoom_target, zoom_speed)

	var input_vector = Input.get_vector("move_camera_left", "move_camera_right", "move_camera_up", "move_camera_down")
	if input_vector != Vector2(0,0):
		is_panning = true
		var new_camera_vector = (input_vector * camera_move_speed) / zoom
		position += ((new_camera_vector * camera_move_speed) * delta)
	else:
		is_panning = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_target = clamp((zoom_target + Vector2(zoom_step, zoom_step)), zoom_min, zoom_max)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_target = clamp((zoom_target - Vector2(zoom_step, zoom_step)), zoom_min, zoom_max)
				
	if not is_panning:
		if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			position -= (event.relative * drag_sensitivity) / zoom
			return
