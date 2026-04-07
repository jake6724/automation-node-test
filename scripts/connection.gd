class_name Connection
extends Line2D

var connected: bool = false
var start: Vector2
var elbow: Vector2
var static_points: Array[Vector2]
var parent_module: Module

var start_port: Port
var target_port: Port

const HORIZONTAL_OFFSET_DISTANCE: float = 35

signal connected_to_port
signal disconnected_from_port

func _ready():
	z_as_relative = false
	z_index = 100
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
		var port_offset = start_port.size/2

		start = to_local(start_port.global_position + port_offset)
		elbow = start + _h_offset
		static_points = [start, elbow]

func draw_to_mouse() -> void:
	points = static_points
	var local_mouse_pos: Vector2 = to_local(get_global_mouse_position())
	add_point(Vector2(elbow.x, (local_mouse_pos.y)))
	add_point(Vector2(local_mouse_pos.x, (local_mouse_pos.y)))

func draw_to_target_port() -> void:
	if target_port:
		calc_static_points()
		points = static_points
		var port_offset = target_port.size/2
		var local_target_port_pos: Vector2 = to_local(target_port.global_position) + port_offset
		add_point(Vector2(elbow.x, (local_target_port_pos.y)))
		add_point(Vector2(local_target_port_pos.x, (local_target_port_pos.y)))

func connect_to_port(_port: Port) -> void:
	target_port = _port
	connected = true
	var linked_module: Module = target_port.parent_module
	connected_to_port.emit(self, linked_module)

func disconnect_from_target_port() -> void:
	if target_port:
		print("Fuckd")
		var linked_module: Module = target_port.parent_module
		target_port = null
		connected = false
		disconnected_from_port.emit(self, linked_module)
