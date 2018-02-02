extends Node2D

var foot_size = 10
var toe_size = 6

var raised_scale = 1.3
var is_raised = false

var zoom = 1

var alpha = 1
var delete_after_time = false
var life_span = 5.0
var cur_time = 0

func _ready():
	add_to_group("zoom_affected")
	set_process(true)

func _draw():
	draw_foot()

func _process(delta):
	if delete_after_time:
		cur_time += delta
		if cur_time >= life_span:
			queue_free()
	
	update()

func draw_foot():
	var alph = alpha
	if delete_after_time:
		alph = lerp(alpha, 0, cur_time / life_span)
	var adj_toe_size = toe_size
	
	var adj_foot_size = foot_size
	if is_raised:
		adj_toe_size *= raised_scale
		adj_foot_size *= raised_scale
	
	var blk = Color(0, 0, 0, alph)
	var t_size = Vector2(adj_toe_size, adj_toe_size) / zoom
	var t_half = adj_toe_size / 2
	
	var d = adj_foot_size + t_half
	var dm = adj_foot_size - t_half
	var r1 = Rect2(Vector2(-t_half, dm), t_size)
	var r2 = Rect2(Vector2(-t_half, -d), t_size)
	var r3 = Rect2(Vector2(dm, -t_half), t_size)
	var r4 = Rect2(Vector2(-d, -t_half), t_size)
	
	draw_circle(Vector2(), adj_foot_size, blk)
	draw_rect(r1, blk)
	draw_rect(r2, blk)
	draw_rect(r3, blk)
	draw_rect(r4, blk)

func set_zoom(var z):
	zoom = z