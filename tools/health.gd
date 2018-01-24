extends Node2D

onready var health_bar = get_node("HealthBar")

export var hp_max = 20
var cur_hp = 20

export var hp_regen_rate = 0.0
var cur_regen = 0.0

func _ready():
	set_process(true)
	cur_hp = hp_max

func _process(delta):
	regen_hp(delta)

func regen_hp(var delta):
	if cur_hp == hp_max:
		cur_regen = 0
		return
	
	cur_regen += hp_regen_rate * delta
	if cur_regen >= 1:
		cur_regen -= 1
		deal_damage(-1)

func deal_damage(var dmg):
	cur_hp = clamp(cur_hp - dmg, 0, hp_max)
	health_bar.set_prop(cur_hp * 1.0 / hp_max)
	if cur_hp <= 0:
		cur_hp = 0
		death()

func death():
	if get_parent() != null:
		if get_parent().has_method("death"):
			get_parent().death()
		else:
			get_parent().queue_free()
	else:
		queue_free()
