extends KinematicBody2D

onready var health = get_node("Health")

export var speed = 200

var atk_range = 100
var player = null

var pos = Vector2()
var p_pos = Vector2()

func _ready():
	set_fixed_process(true)
	add_to_group("enemies")

func _fixed_process(delta):
	if player == null:
		return
	
	pos = get_global_pos()
	p_pos = player.get_global_pos()
	

	if !in_range() and can_see_player():
		var dir = (p_pos - pos).normalized()
		move(dir * speed * delta)

func can_see_player():
	var to_ignore = get_tree().get_nodes_in_group("enemies")
	var space_state = get_world_2d().get_direct_space_state()
	var pos = get_global_pos()
	var p_pos = player.get_global_pos()
	var result = space_state.intersect_ray( pos, p_pos , to_ignore)
	return not result.empty() && result.collider == player

func in_range():
	var dis = pos.distance_squared_to(p_pos)
	return dis <= atk_range * atk_range

func deal_damage(var dmg):
	health.deal_damage(dmg)

func set_player(var p):
	player = p