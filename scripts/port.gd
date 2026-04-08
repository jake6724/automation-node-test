class_name Port
extends TextureRect

enum Type {INPUT_FIRE, INPUT_WATER}

@export var type: Type
@export var is_input: bool = true
@export var connected: bool = false
var parent_module: Module
@export var max_connections: int = 1
var connections: Array[Connection] = []

var linked_modules: Dictionary[Module, Array] = {}

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
			connection_to_remove.disconnect_from_target_port()
			connection_to_remove.queue_free()

func add_connection(_connection: Connection) -> void:
	connections.append(_connection)
	_connection.connected_to_port.connect(on_connection_connected_to_port)
	_connection.disconnected_from_port.connect(on_connection_disconnected_from_port)

func on_connection_connected_to_port(_connection: Connection, _linked_module: Module) -> void:
	if _connection.target_port:
		var callback: Callable = Callable(self, "on_connection_linked_module_moved")
		if not _linked_module.moved.is_connected(callback): # This is PER PORT; if a port's max connection is 1 this is not relevant
			_linked_module.moved.connect(callback)

		if not linked_modules.has(_linked_module):
			linked_modules[_linked_module] = []

		linked_modules[_linked_module].append(_connection)
	else:
		push_error("Port.on_connection_connected_to_port(): _connection.target_port = null")

func on_connection_disconnected_from_port(_connection: Connection, _linked_module: Module) -> void:
	linked_modules[_linked_module].erase(_connection)
	if linked_modules[_linked_module].size() <= 0: # Stop observing this module if no child connections are linked to it
		_linked_module.moved.disconnect(on_connection_linked_module_moved)

func update_all_connections() -> void:
	for _connection: Connection in connections:
		if is_instance_valid(_connection):
			_connection.draw_to_target_port()
	
func on_connection_linked_module_moved(_module: Module) -> void:
	for _connection in linked_modules[_module]:
		if is_instance_valid(_connection):
			_connection.draw_to_target_port()
