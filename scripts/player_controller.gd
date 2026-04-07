class_name PlayerController
extends Control

@export var module_parent: Node
var modules: Array[Module] = []

var active_connection: Connection
var active_module: Module

var source_port: Port

const HORIZONTAL_OFFSET_DISTANCE: float = 25
const HORIZONTAL_OFFSET: Vector2 = Vector2(HORIZONTAL_OFFSET_DISTANCE, 0)

func _ready():
	configure_modules()

func _input(event):
	# TODO: Change this to call whenever a port is clicked with _gui_input
	if Input.is_action_just_pressed("left_click"):
		if source_port:
			source_port.process_connection_limit()

			create_connection(source_port)
			set_modules_port_type_target(source_port)
			set_module_ports_ignore_mouse(true)
			
	if Input.is_action_just_released("left_click"):
		if active_connection and not active_connection.connected:
			active_connection.queue_free()

		active_connection = null
		set_module_ports_ignore_mouse(false)

	if event is InputEventMouseMotion:
		if active_module:
			active_module.move(event.relative)

func _process(_delta):
	if active_connection:
		if active_connection.target_port:
			active_connection.draw_to_target_port()
		else:
			active_connection.draw_to_mouse()

func configure_modules() -> void:
	for module: Module in module_parent.get_children():
		module.valid_input_port_available.connect(on_module_valid_input_port_available)
		module.module_exited.connect(on_module_exited)
		module.header_button_down.connect(on_module_header_button_down)
		module.header_button_up.connect(on_module_header_button_up)
		connect_to_module_ports(module)
		modules.append(module)

func connect_to_module_ports(_module: Module) -> void:
	for port: Port in _module.ports:
		port.mouse_entered_port.connect(on_mouse_entered_port)
		port.mouse_exited_port.connect(on_mouse_exited_port)

func on_module_valid_input_port_available(_module: Module, _port: Port) -> void:
	if active_connection and _module != active_connection.parent_module:
		active_connection.connect_to_port(_port)

func on_module_exited() -> void:
	if active_connection:
		active_connection.disconnect_from_target_port()

func on_module_header_button_down(_module: Module) -> void:
	active_module = _module

func on_module_header_button_up(_module: Module) -> void:
	if active_module == _module:
		active_module = null

func set_module_ports_ignore_mouse(_ignore: bool) -> void:
	for module: Module in modules:
		module.set_ports_ignore_mouse(_ignore)

func set_modules_port_type_target(_port: Port) -> void:
	for _module: Module in modules:
		_module.port_type_target = _port.type
		_module.port_target_is_input = not _port.is_input

func on_mouse_entered_port(_port) -> void:
	source_port = _port

func on_mouse_exited_port() -> void:
	source_port = null

func create_connection(_start_port: Port) -> void:
	var new_connection: Connection = Connection.new()
	add_child(new_connection)
	new_connection.initialize(_start_port)
	_start_port.connections.append(new_connection)
	active_connection = new_connection