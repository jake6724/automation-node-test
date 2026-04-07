class_name Port
extends TextureRect

enum Type {INPUT_FIRE, INPUT_WATER}

@export var type: Type
@export var is_input: bool = true
@export var connected: bool = false
var parent_module: Module
@export var max_connections: int = 1
var connections: Array[Connection] = []

@export var connected_texture: Texture2D
@export var unconnected_texture: Texture2D

signal mouse_entered_port
signal mouse_exited_port

func _ready():
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func on_mouse_entered() -> void:
	mouse_entered_port.emit(self)

func on_mouse_exited() -> void:
	mouse_exited_port.emit()

func process_connection_limit() -> void:
	if (connections.size() + 1) > max_connections:
		var connection_to_remove = connections[-1]
		connections.remove_at(-1)
		if is_instance_valid(connection_to_remove):
			connection_to_remove.queue_free()

func add_connection(_connect: Connection) -> void:
	pass

func update_all_connections() -> void:
	for _connection: Connection in connections:
		if is_instance_valid(_connection):
			_connection.draw_to_target_port()