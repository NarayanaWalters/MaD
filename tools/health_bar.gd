extends Control

var width = 60
var height = 6
var prop_filled = 1

func _draw():
	var r1 = Rect2(Vector2(-width / 2.0, 0), Vector2(width, height))
	draw_rect(r1, Color(1, 0, 0))
	
	var r2 = Rect2(Vector2(-width / 2.0, 0), Vector2(width * prop_filled, height))
	draw_rect(r2, Color(0, 1, 0))

func _process(delta):
    update()

func _ready():
    set_process(true)

func set_prop(var p):
	prop_filled = clamp(p, 0, 1)