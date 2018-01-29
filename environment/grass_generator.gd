extends Node2D

var grass_scene = preload("res://environment/grass.tscn")

var tile_size = 32

var x_size = 64
var y_size = 64

func _ready():
	gen_grass()

func gen_grass():
	for i in range(x_size):
		for j in range(y_size):
			var g = grass_scene.instance()
			add_child(g)
			var p = Vector2(i * tile_size, j * tile_size)
			g.set_pos(g.get_pos() + p)
			var r = randi() % 2
			

func perlin(var x, var y):
	var xi = int(x & 255)
	var yi = int(y & 255)
	var xf = x - int(x)
	var yf = y - int(y)
	var u = fade(xf)
	var v = fade(yf)
	

func fade(var t):
	return t * t * t * (t * (t * 6 - 15) + 10)