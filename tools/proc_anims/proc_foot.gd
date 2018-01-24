extends Node2D

var foot_size = 10
var toe_size = 6

var raised_scale = 1.2
var is_raised = false

func _ready():
	set_process(true)

func _draw():
	draw_foot(Vector2())

func _process(delta):
	update()

func draw_foot(var pos):
	var adj_toe_size = toe_size
	var adj_foot_size = foot_size
	if is_raised:
		adj_toe_size *= raised_scale
		adj_foot_size *= raised_scale
	
	var blk = Color(0, 0, 0)
	var t_s = Vector2(adj_toe_size, adj_toe_size)
	var t_h = adj_toe_size / 2
	var d = adj_toe_size + t_h
	var dm = adj_toe_size - t_h
	var r1 = Rect2(pos + Vector2(-t_h, dm), t_s)
	var r2 = Rect2(pos + Vector2(-t_h, -d), t_s)
	var r3 = Rect2(pos + Vector2(dm, -t_h), t_s)
	var r4 = Rect2(pos + Vector2(-d, -t_h), t_s)
	
	draw_circle(pos, adj_toe_size, blk)
	draw_rect(r1, blk)
	draw_rect(r2, blk)
	draw_rect(r3, blk)
	draw_rect(r4, blk)