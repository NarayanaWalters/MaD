extends Area2D

onready var particles = get_node("Particles2D")

var explosion_area = 100

var damage = 15

var time = 0.0
var max_time = 1
var exploded = false

var an = randi() % 360

func _ready():
	get_node("CollisionShape2D").get_shape().set_radius(explosion_area)
	#explode()
	an = randi() % 360
	set_process(true)


func _draw():
	if exploded:
		
		draw_shape(6, 0 + an, explosion_area)
		draw_shape(3, 0 + an, explosion_area)
		draw_shape(3, 60 + an, explosion_area)
		draw_shape(3, 0 + an, explosion_area / 2)
		draw_shape(3, 60 + an, explosion_area / 2)


func draw_shape(var points_size, var angle, var radius):
	angle = deg2rad(angle)
	
	var points = []
	for i in range(points_size):
		var an = 360 / points_size * i
		var pos = Vector2(cos(deg2rad(an)), sin(deg2rad(an))) * radius
		pos = pos.rotated(angle)
		points.append(pos)
	
	var whit = Color(1, 1, 1, 1 - time / max_time)
	
	for i in range(points_size):
		var target_pos = points[(i + 1) % points_size]
		
		draw_line(points[i], target_pos, whit, 1)
		draw_line(points[i], Vector2(), whit, 1)

func _process(delta):
	if exploded:
		time += delta
		update()
	if time > max_time:
			queue_free()


func explode():
	if exploded:
		return
	exploded = true
	particles.set_emitting(true)
	var bodies = get_overlapping_bodies()
	
	var root = get_tree().get_root()
	var pos = get_global_pos()
	get_parent().remove_child(self)
	root.add_child(self) 
	set_global_pos(pos)
	
	for body in bodies:
		if body.has_method("deal_damage"):
			body.deal_damage(damage)
