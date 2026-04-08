class_name Connection
extends Line2D

var connected: bool = false

var start_port: Port
var start: Vector2
var elbow: Vector2
var start_static_points: Array[Vector2]

var target_port: Port
var target_point: Vector2
var target_elbow_point: Vector2
var target_static_points: Array[Vector2]

var parent_module: Module

const HORIZONTAL_OFFSET_DISTANCE: float = 35
var horizontal_offset_distance_increment: float = 0

signal connected_to_port
signal disconnected_from_port

func _ready():
	z_as_relative = false
	z_index = -1
	width = 5
	default_color = Color.WHITE

func initialize(_start_port: Port) -> void:
	start_port = _start_port
	parent_module = start_port.parent_module
	calc_static_points()

func calc_static_points() -> void:
	if start_port:
		var _h_offset: Vector2 = Vector2(HORIZONTAL_OFFSET_DISTANCE, 0)	# Calc horizontal offset based on if port is input or output
		if start_port.is_input: _h_offset *= -1
		var start_port_offset = start_port.size/2

		start = to_local(start_port.global_position + start_port_offset)
		elbow = start + _h_offset
		start_static_points = [start, elbow]

		if target_port:
			var target_port_offset = target_port.size/2
			target_point = to_local(target_port.global_position + target_port_offset)
			target_elbow_point = target_point + -_h_offset
			target_static_points = [target_elbow_point, target_point]

func draw_to_mouse() -> void:
	points = start_static_points
	var local_mouse_pos: Vector2 = to_local(get_global_mouse_position())
	add_point(Vector2(elbow.x, (local_mouse_pos.y)))
	add_point(Vector2(local_mouse_pos.x, (local_mouse_pos.y)))

func draw_to_target_port() -> void:
	if target_port:
		calc_static_points()
		points = start_static_points

		var mid_point: Vector2 = Vector2(elbow.x, target_static_points[0].y) # Point which connects the start elbow to the target elbow
		add_point(mid_point)

		add_point(target_static_points[0])
		add_point(target_static_points[1])

func connect_to_port(_port: Port) -> void:
	target_port = _port
	connected = true
	var linked_module: Module = target_port.parent_module
	connected_to_port.emit(self, linked_module)

func disconnect_from_target_port() -> void:
	if target_port:
		var linked_module: Module = target_port.parent_module
		target_port = null
		connected = false
		disconnected_from_port.emit(self, linked_module)
