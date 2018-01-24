extends KinematicBody2D

var target = null

export var speed = 100
var detonate_distance = 100
var cruising = false
var cruise_time = 0
var fuse_time = 1.0
var detonated = false

onready var aimer = get_node("Aimer")
onready var expl = get_node("Explosion")
onready var particles = get_node("Aimer/Particles2D")

var particles_life = 0

func _ready():
	particles_life = particles.get_lifetime()
	add_to_group("enemies")
	set_fixed_process(true)

func _fixed_process(delta):
	if detonated:
		return
	if target != null:
		var pos = get_global_pos()
		var p_pos = target.get_global_pos()
		var dis = pos.distance_squared_to(p_pos)
		if dis < detonate_distance * detonate_distance:
			cruising = true
	
	var cur_speed = speed
	if cruising:
		cruise_time += delta
		var t = cruise_time / fuse_time
		t = clamp(t, 0, 1)
		cur_speed = lerp(speed, 0, t) 
		var p_l = lerp(particles_life, 0, t)
		particles.set_lifetime(p_l)
		if cruise_time >= fuse_time:
			expl.explode()
			queue_free()
	
	var move_vec = Vector2(0, cur_speed)
	var r = aimer.get_global_rot()
	move_vec = move_vec.rotated(r)
	move(move_vec * delta)

func set_player(var p):
	target = p