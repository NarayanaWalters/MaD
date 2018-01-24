extends Node2D

var foot_size = 10
var toe_size = 6
var stride_length = 70
var chassis_width = 60
var chassis_height = 20

onready var foot1 = get_node("Foot1")
onready var foot2 = get_node("Foot2")
onready var chassis = get_node("Chassis")

var foot1_last_pos = Vector2()
var foot2_last_pos = Vector2()

var last_stride_pos = Vector2()

func _ready():
	foot1.set_pos(Vector2(chassis_width, 0))
	foot2.set_pos(Vector2(-chassis_width, 0))
	foot1_last_pos = foot1.get_global_pos()
	foot2_last_pos = foot2.get_global_pos()
	last_stride_pos = get_global_pos()
	
	chassis.chassis_height = chassis_height
	chassis.chassis_width = chassis_width
	
	set_process(true)

func _draw():
	var foot1_loc_pos = foot1.get_pos()
	var foot2_loc_pos = foot2.get_pos()
	
	var c_a = chassis.get_global_rot()
	
	draw_line(Vector2((chassis_width - 10) / 2, 0).rotated(c_a), foot1_loc_pos, Color(0, 0, 0), 2)
	draw_line(Vector2((10 - chassis_width) / 2, 0).rotated(c_a), foot2_loc_pos, Color(0, 0, 0), 2)
	
	draw_foot(foot1_loc_pos)
	draw_foot(foot2_loc_pos)
	

func _process(delta):
	foot1.set_global_pos(foot1_last_pos)
	foot2.set_global_pos(foot2_last_pos)
	var pos = get_global_pos()
	if pos.distance_squared_to(last_stride_pos) > stride_length * stride_length:
		stride()
	
	
	update()


func stride():
	var foot1_pos = foot1.get_global_pos()
	var foot2_pos = foot2.get_global_pos()
	var pos = get_global_pos()
	
	var dis1 = foot1_pos.distance_squared_to(pos)
	var dis2 = foot2_pos.distance_squared_to(pos)
	var use_foot1 = true
	if dis1 < dis2:
		use_foot1 = false
	
	var offset = pos - last_stride_pos
	var dir = atan2(offset.x, offset.y)
	
	if use_foot1:
		var step_pos = Vector2(chassis_width, stride_length)
		
		foot1.set_pos(step_pos.rotated(dir))
	else:
		var step_pos = Vector2(-chassis_width, stride_length)
		foot2.set_pos(step_pos.rotated(dir))
	
	last_stride_pos = get_global_pos()
	foot1_last_pos = foot1.get_global_pos()
	foot2_last_pos = foot2.get_global_pos()


func draw_foot(var pos):
	var blk = Color(0, 0, 0)
	var t_s = Vector2(toe_size, toe_size)
	var t_h = toe_size / 2
	var d = foot_size + t_h
	var dm = foot_size - t_h
	var r1 = Rect2(pos + Vector2(-t_h, dm), t_s)
	var r2 = Rect2(pos + Vector2(-t_h, -d), t_s)
	var r3 = Rect2(pos + Vector2(dm, -t_h), t_s)
	var r4 = Rect2(pos + Vector2(-d, -t_h), t_s)
	
	draw_circle(pos, foot_size, blk)
	draw_rect(r1, blk)
	draw_rect(r2, blk)
	draw_rect(r3, blk)
	draw_rect(r4, blk)
