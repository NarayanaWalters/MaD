extends KinematicBody2D

onready var anim_sprite = get_node("AnimatedSprite")
onready var health = get_node("Health")

var speed = 3

func _ready():
	set_fixed_process(true)
	anim_sprite.play("idle")
	get_tree().set_pause(true)
	yield(get_tree(), "idle_frame")
	get_tree().call_group(0, "enemies", "set_player", self)

func _fixed_process(delta):
	do_move()

func do_move():
	var move_vec = Vector2(0, 0)
	
	if Input.is_action_pressed("move_down"):
		get_tree().set_pause(false)
		move_vec.y += 1
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	
	if move_vec == Vector2(0, 0) and anim_sprite.get_animation() != "idle":
		anim_sprite.play("idle")
	elif move_vec != Vector2(0, 0) and anim_sprite.get_animation() != "run":
		anim_sprite.play("run")
	
	if move_vec.x < 0 and !anim_sprite.is_flipped_h():
		anim_sprite.set_flip_h(true)
	elif move_vec.x > 0 and anim_sprite.is_flipped_h():
		anim_sprite.set_flip_h(false)
	
	move(move_vec.normalized() * speed)

func deal_damage(var dmg):
	health.deal_damage(dmg)

func death():
	get_tree().reload_current_scene()
	#TODO delete arrows