extends Node2D

var foot_scene = preload("res://tools/proc_anims/foot.tscn")

onready var foot1 = get_node("Foot1")
onready var foot2 = get_node("Foot2")

var chassis_width = 60
var chassis_height = 10
var leg_width = 3
var stride_length = 50
var hinge_back_dis = 10

var last_pos = Vector2()
var turn_speed = 10
var cur_time = 0
var osc_speed = 10
var osc_angle = 15
var last_osc = 0


var foot_move_speed = 15
var foot1_last_pos = Vector2()
var foot2_last_pos = Vector2()

var foot1_start_pos_orig = Vector2()
var foot2_start_pos_orig = Vector2()

var foot1_start_pos = Vector2()
var foot2_start_pos = Vector2()

var foot1_was_raised = false
var foot2_was_raised = false

var zoom = 1

var foot_place_var = 10

var is_paused = false

func _ready():
	add_to_group("zoom_affected")
	foot1_last_pos = foot1.get_global_pos()
	foot2_last_pos = foot2.get_global_pos()
	foot1_start_pos_orig = foot1.get_pos()
	foot2_start_pos_orig = foot2.get_pos()
	
	foot1_start_pos = foot1_start_pos_orig
	foot2_start_pos = foot2_start_pos_orig
	
	set_process(true)

func _draw():
	var pos = Vector2(chassis_width / -2, chassis_height / -2)
	var size = Vector2(chassis_width, chassis_height)
	draw_rect(Rect2(pos, size), Color(0, 0, 0))
	
	var l_hip_pos = Vector2(chassis_width / -2, 0)
	var r_hip_pos = Vector2(chassis_width / 2,  0)
	
	#calc oscillation
	var h_b = sin(cur_time * osc_speed)
	var hinge1_pos = Vector2(foot1_start_pos.x, -h_b * hinge_back_dis + foot1_start_pos.y)
	var hinge2_pos = Vector2(foot2_start_pos.x, h_b * hinge_back_dis + foot2_start_pos.y)
	
	draw_line(l_hip_pos, hinge1_pos, Color(0, 0, 0), leg_width / zoom)
	draw_line(r_hip_pos, hinge2_pos, Color(0, 0, 0), leg_width / zoom)
	draw_line(hinge1_pos, foot1.get_pos(), Color(0, 0, 0), leg_width / zoom)
	draw_line(hinge2_pos, foot2.get_pos(), Color(0, 0, 0), leg_width / zoom)

func _process(delta):
	var f1_r = foot1.get_global_rot()
	var f2_r = foot2.get_global_rot()
	
	var pos = get_global_pos()
	var is_moving = pos != last_pos
	
	if is_moving:
		cur_time += delta
		calc_angle()
	else:
		foot1.is_raised = false
		foot2.is_raised = false
	
	if !is_moving or !foot1.is_raised:
		foot1.set_global_rot(f1_r)
		foot1.set_global_pos(foot1_last_pos)
	
	if !is_moving or !foot2.is_raised:
		foot2.set_global_rot(f2_r)
		foot2.set_global_pos(foot2_last_pos)
	
	
	
	if foot1.is_raised:
		var pos = foot1.get_pos()
		var goal_pos = Vector2(foot1_start_pos.x, stride_length)
		var offset = goal_pos - pos
		pos = move_towards(pos, goal_pos)
		#pos += offset.normalized() * foot_move_speed
		foot1.set_pos(pos)
	if foot2.is_raised:
		var pos = foot2.get_pos()
		var goal_pos = Vector2(foot2_start_pos.x, stride_length)
		var offset = goal_pos - pos
		pos = move_towards(pos, goal_pos)
		#pos += offset.normalized() * foot_move_speed
		foot2.set_pos(pos)
	
	last_pos = pos
	foot1_last_pos = foot1.get_global_pos()
	foot2_last_pos = foot2.get_global_pos()
	
	if !foot1.is_raised and foot1_was_raised:
		var foot = foot_scene.instance()
		get_tree().get_root().add_child(foot)
		foot.alpha = 0.2
		foot.delete_after_time = true
		foot.set_global_rot(f1_r)
		foot.set_global_pos(foot1_last_pos)
		
		foot1_start_pos = foot1_start_pos_orig + rand_vec2()
	if !foot2.is_raised and foot2_was_raised:
		var foot = foot_scene.instance()
		get_tree().get_root().add_child(foot)
		foot.alpha = 0.2
		foot.delete_after_time = true
		foot.set_global_rot(f2_r)
		foot.set_global_pos(foot2_last_pos)
		foot2_start_pos = foot2_start_pos_orig + rand_vec2()
	
	foot1_was_raised = foot1.is_raised
	foot2_was_raised = foot2.is_raised
	update()

func rand_vec2():
	var x = randi() % (foot_place_var * 2) - foot_place_var
	var y = randi() % (foot_place_var * 2) - foot_place_var
	return Vector2(x, y)

func move_towards(var pos, var goal_pos):
	var offset = goal_pos - pos
	var dis = offset.normalized() * foot_move_speed
	pos += dis
	var dis_l = dis.length_squared()
	var offset_l = offset.length_squared()
	if dis_l > offset_l:
		pos = goal_pos
	return pos


func calc_angle():
	#calculate chassis oscillation
	var cur_osc = sin(cur_time * osc_speed) * osc_angle
	if cur_osc > last_osc:
		foot1.is_raised = true
		foot2.is_raised = false
	else:
		foot1.is_raised = false
		foot2.is_raised = true
	#smoothly turn current angle to direction of travel
	var pos = get_global_pos()
	var offset = pos - last_pos
	var goal_angle = rad2deg(atan2(offset.x, offset.y))
	var cur_angle = get_global_rotd()
	var angle_diff = goal_angle - cur_angle
	var dir_to_turn = sign(angle_diff)
	if abs(angle_diff) > 180:
		dir_to_turn *= -1
	
	var new_angle = cur_angle + dir_to_turn * turn_speed
	if abs(angle_diff) < turn_speed or abs(abs(angle_diff) - 180) < turn_speed:
		new_angle = goal_angle
	
	# add that angle to the oscillation
	set_global_rotd(cur_osc + new_angle)
	last_osc = cur_osc

func set_zoom(var z):
	zoom = z

var s_f1_pos = Vector2()
var s_f2_pos = Vector2()
func save_state():
	s_f1_pos = foot1.get_pos()
	s_f2_pos = foot2.get_pos()
func restore_state():
	foot1.set_pos(s_f1_pos)
	foot2.set_pos(s_f2_pos)
	foot1_last_pos = foot1.get_global_pos()
	foot2_last_pos = foot2.get_global_pos()