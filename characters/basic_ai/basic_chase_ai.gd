extends KinematicBody2D

onready var health = get_node("Health")

export var speed = 200
var atk_range = 100
var damage = 2
var atk_rate = 0.4
var atk_time = 0.0

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
	

	if in_range():
		atk_time += delta
		if atk_time >= atk_rate:
			atk_time -= atk_rate
			player.deal_damage(damage)
		
	else:
		var dir = (p_pos - pos).normalized()
		move(dir * speed * delta)
		atk_time = 0



func in_range():
	var dis = pos.distance_squared_to(p_pos)
	return dis <= atk_range * atk_range

func deal_damage(var dmg):
	health.deal_damage(dmg)

func set_player(var p):
	player = p