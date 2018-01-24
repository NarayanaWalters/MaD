extends Node2D

var target = null
export var fire_rate = 2
var time = 0
var missile_obj = preload("res://characters/missile/missile.tscn")

func _ready():
	add_to_group("enemies")
	set_process(true)

func _process(delta):
	time += delta
	if time > fire_rate:
		time -= fire_rate
		fire()

func fire():
	var missile = missile_obj.instance()
	missile.target = target
	missile.get_node("Aimer").target = target
	get_tree().get_root().add_child(missile)
	missile.set_global_rot(get_global_rot())
	missile.set_global_pos(get_global_pos())

func set_player(var t):
	target = t
