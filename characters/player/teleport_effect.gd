extends Node2D

var fade_time = 4.0
var cur_time = 0

func _ready():
	set_process(true)

func _draw():
	cur_time = clamp(cur_time, 0, fade_time)
	#draw_tri(0, 50, 30)
	#draw_tri(120, 50, 30)
	#draw_tri(240, 50, 30)
	draw_tri(60, 10, -60)
	draw_tri(180, 10, -60)
	draw_tri(300, 10, -60)
	draw_tri(0, 20, -50)
	draw_tri(120, 20, -50)
	draw_tri(240, 20, -50)
	draw_tri(60, 10, 60)
	draw_tri(180, 10, 60)
	draw_tri(300, 10, 60)
	var alph = 1 - cur_time / fade_time
	draw_circle(Vector2(), 4, Color(1, 1, 1, alph))

func draw_tri(var rot, var size, var dis):
	var alph = 1 - cur_time / fade_time
	var col = Color(1, 1, 1, alph)

	var n1 = 0.866 #cos(deg2rad(30))
	var n2 = 0.5 #sin(deg2rad(30))
	var d = Vector2(dis, 0)
	var p1 = (Vector2() + d).rotated(deg2rad(rot))
	var p2 = (Vector2(n1, n2) * size + d).rotated(deg2rad(rot))
	var p3 = (Vector2(n1, -n2) * size + d).rotated(deg2rad(rot))
	draw_line(p1, p2, col)
	draw_line(p2, p3, col)
	draw_line(p3, p1, col)

func _process(delta):
	cur_time += delta
	if cur_time >= fade_time:
		queue_free()
	update()