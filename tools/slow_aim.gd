extends Node2D

var target = null
export var aim_at_player = true
export var turn_speed = 1

func _ready():
	add_to_group("enemies")
	set_process(true)
	
func _process(delta):
	var t_pos = get_global_mouse_pos()
	if aim_at_player and target != null:
		t_pos = target.get_global_pos()
	var pos = get_global_pos()
	var offset = t_pos - pos
	var goal_angle = rad2deg(atan2(offset.x, offset.y))
	
	var cur_angle = get_global_rotd()
	
	
	var angle_diff = goal_angle - cur_angle
	var dir_to_turn = sign(angle_diff)
	if abs(angle_diff) > 180:
		dir_to_turn *= -1
	

	var new_angle = cur_angle + dir_to_turn * turn_speed
	if abs(angle_diff) < turn_speed or abs(abs(angle_diff) - 180) < turn_speed:
		new_angle = goal_angle
	
	set_global_rotd(new_angle)
	


func set_player(var p):
	target = p