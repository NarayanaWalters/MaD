extends Node2D

var max_height = 30
var max_width = 3

var height = 10
var width = 1

var max_rotation = 20
var rotation = 0

var x_var = 30
var y_var = 30

func _ready():
	var h = randi() % (max_height - height)
	height = h + height
	var w = randi() % (max_width - width)
	width = w + width
	
	var x = randi() % x_var - x_var / 2
	var y = randi() % y_var - y_var / 2
	set_pos(Vector2(x, y))
	
	var r = randi() % max_rotation
	r -= max_rotation / 2
	rotation = r + rotation
	set_rotd(rotation)


func _draw():
	var c = Color(56 / 255.0, 99 / 255.0, 77 / 255.0)
	draw_line(Vector2(), Vector2(0, height), c, width)