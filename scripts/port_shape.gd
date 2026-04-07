class_name PortShape
extends Control

var shape_scale: float = 15

var triangle_up: PackedVector2Array = [
    Vector2(0,10)*shape_scale,
    Vector2(5,.5)*shape_scale,
    Vector2(10,10)*shape_scale,
    Vector2(0,10)*shape_scale,
]

var triangle_down: PackedVector2Array = [
    Vector2(0,0)*shape_scale,
    Vector2(5,9.5)*shape_scale,
    Vector2(10,0)*shape_scale,
    Vector2(0,0)*shape_scale,
]


func _draw():
    draw_polygon(triangle_down, [Color.BLUE])
    draw_polyline(triangle_down, Color.RED, 2, true)