class_name Module
extends Panel

@export var input_parent: VBoxContainer
@export var output_parent: VBoxContainer
@export var header: Button

var inputs: Array[Port]
var outputs: Array[Port]
var ports: Array[Port]

var port_type_target: Port.Type = Port.Type.INPUT_FIRE
var port_target_is_input: bool = false
var flag: bool = true

signal valid_input_port_available
signal module_exited
signal header_button_down
signal header_button_up
signal moved

func _input(_event):
	if Input.is_action_just_pressed("right_click"):
		if flag:
			port_type_target = Port.Type.INPUT_WATER
		else:
			port_type_target = Port.Type.INPUT_FIRE
		flag = !flag

func _ready():
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	configure_ports()

	header.button_down.connect(on_header_button_down)
	header.button_up.connect(on_header_button_up)

func on_mouse_entered() -> void:
	var target_port: Port = get_highest_available_port_by_type(port_type_target, port_target_is_input)
	if target_port:
		valid_input_port_available.emit(self, target_port)

func on_mouse_exited() -> void:
	module_exited.emit()

func move(move_vector: Vector2) -> void:
	global_position += move_vector
	update_all_port_connections()
	moved.emit(self)

func configure_ports() -> void:
	for child in input_parent.get_children():
		var port: Port = child as Port
		if port:
			inputs.append(port)
			ports.append(port)
			port.parent_module = self
			
	for child in output_parent.get_children():
		var port: Port = child as Port
		if port:
			outputs.append(port)
			ports.append(port)
			port.parent_module = self

func get_highest_available_port_by_type(_type: Port.Type, _is_input: bool) -> Port:
	var res: Port = null
	var port_array: Array[Port] = inputs if _is_input else outputs
	for port: Port in port_array:
		if port.type == _type:
			return port
	return res

func set_ports_ignore_mouse(_ignore: bool) -> void:
	var mode: MouseFilter
	if _ignore:
		mode = MOUSE_FILTER_IGNORE
	else:
		mode = MOUSE_FILTER_STOP

	for port: Port in ports:
		port.mouse_filter = mode

func update_all_port_connections() -> void:
	for _port: Port in ports:
		_port.update_all_connections()

func on_header_pressed() -> void:
	header_button_down.emit(self)

func on_header_button_down() -> void:
	header_button_down.emit(self)

func on_header_button_up() -> void:
	header_button_up.emit(self)