class_name LineTest
extends Control

@onready var node2d: Node2D = Node2D.new()
@onready var line: Line2D = Line2D.new()

var line_start: Vector2

func _ready():
	
	add_child(node2d)
	add_child(line)
	line_start = line.to_local(get_global_mouse_position())
	line.add_point(line_start)

	line.add_point(Vector2(0,0))

func _process(delta):
	line.points = [line_start]
	var mouse_pos_margin: float = 30.0
	var local_mouse_pos: Vector2 = line.to_local(get_global_mouse_position())

	var flipped = (local_mouse_pos - line_start).x < 0
	if flipped:
		mouse_pos_margin = -30
	else:
		mouse_pos_margin = 30

	var mouse_pos_outer: Vector2 =  local_mouse_pos - Vector2(mouse_pos_margin, 0)
	line.add_point(Vector2(mouse_pos_outer.x, line_start.y))
	line.add_point(mouse_pos_outer)
	line.add_point(local_mouse_pos)
	
	


	# line.points[-1] = line.to_local(get_global_mouse_position())

# func _input(event: InputEvent) -> void:
#     if Input.is_action_just_pressed("left_click"):
#         var new_line: Line2D = Line2D.new()
#         node2d.add_child(new_line)
#         new_line.add_point(node2d.to_local(get_global_mouse_position()))
