extends KinematicBody2D

var time_to_delete_after = 15.0
var time_alive = 0

var start_r = 0

var max_speed = 2000
var min_speed = 1900
var speed = 1000
var curve_speed = 0
var curve_power = 0

var cur_speed = Vector2()

var max_impale = 16
var min_impale = 6
var impale_amount = 12
var impale_variance = 4

var max_dmg = 25
var min_dmg = 10
var cur_dmg = 20

var hit_something = false

var objs_to_ignore = null
var player = null
func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if hit_something:
		return
	
	
	var last_pos = get_global_pos()
	
	var move_vec = calc_local_move_vec().rotated(start_r)
	
	move(move_vec * speed * delta)
	set_global_rot(atan2(move_vec.x, move_vec.y))
	
	curve_speed += curve_power * delta
	
	var pos = get_global_pos()
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray( last_pos, pos , objs_to_ignore)
	
	
	if not result.empty():
		var r = get_global_rot()
		
		get_parent().remove_child(self)
		result.collider.add_child(self)
		
		set_global_rot(r)
		
		hit_something = true
		set_global_pos(result.position)
		var imp = randi() % impale_variance
		move(move_vec * (impale_amount + imp))
		
		if result.collider.has_method("deal_damage"):
			result.collider.deal_damage(cur_dmg)
	
	time_alive += delta
	if time_alive > time_to_delete_after:
		remove_from_group("arrows")
		queue_free()

func calc_local_move_vec():
	#var m_pos = get_global_mouse_pos()
	#var pos = get_global_pos()
	
	#var v1 = (m_pos - pos).normalized() * .5
	#cur_speed += v1
	#return cur_speed
	
	return Vector2(curve_speed, 1).normalized()


func set_power(var p, var c):
	start_r = get_global_rot()
	curve_power = c
	curve_speed = 0
	speed = lerp(min_speed, max_speed, p)
	impale_amount = lerp(min_impale, max_impale, p)
	cur_dmg = lerp(min_dmg, max_dmg, p)

func set_player_ref(var p):
	player = p

func return_to_player():
	if hit_something:
		return
	
	var p_pos = player.get_global_pos() + Vector2(0, -20)
	var pos = get_global_pos()
	var angle = angle_between_vecs(pos, p_pos)
	start_r = angle
	curve_power = 0
	curve_speed = 0
	objs_to_ignore.erase(player)

func angle_between_vecs(var base, var goal):
	var offset = goal - base
	return atan2(offset.x, offset.y)

func set_objs_to_ignore(var objs):
	objs_to_ignore = objs