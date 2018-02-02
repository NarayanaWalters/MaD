extends Node2D

onready var sp = get_node("Sparks")
onready var fi = get_node("Fire")
onready var bo = get_node("Boom")

var life_time = 10
var cur_time = 0

func _ready():
	sp.set_emitting(true)
	fi.set_emitting(true)
	bo.set_emitting(true)
	set_process(true)

func _process(delta):
	cur_time += delta
	if cur_time >= life_time:
		queue_free()
