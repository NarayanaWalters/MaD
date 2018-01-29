extends Area2D

onready var col = get_node("CollisionShape2D")

var atk_range = 200
var damage = 6
var atk_rate = 0.8
var atk_time = 0.0
var flash_time = 0.3
var min_flash = 0.1
var min_width = 1
var max_width = 8

func _ready():
	col.set_pos(Vector2(-atk_range / 2, 0))
	col.get_shape().set_extents(Vector2(atk_range / 2, max_width))
	set_process(true)

func _draw():

	var al = min_flash
	var fl = flash_time / 2
	var wi = min_width
	
	if atk_time <= fl:
		var t = atk_time / fl
		al = lerp(1, min_flash, t)
		wi = lerp(max_width, min_width, t)
	elif atk_time >= atk_rate - fl:
		var t = (atk_rate - atk_time) / fl
		al = lerp(1, min_flash, t)
		wi = lerp(min_width, max_width, t)
	draw_line(Vector2(), Vector2(-atk_range, 0), Color(1, 0, 0, al), wi)

func _process(delta):
	atk_time += delta
	if atk_time >= atk_rate:
		atk_time -= atk_rate
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.has_meta("team") and body.get_meta("team") == "player":
				body.deal_damage(damage)
	update()
