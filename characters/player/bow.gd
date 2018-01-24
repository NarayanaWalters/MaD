extends Node2D

onready var arrow_sprite = get_node("ArrowSprite")
var arrow_sprite_pos = Vector2()
var arrow_height = 105
var max_pull_dis = 80

var arrow_scene = preload("res://characters/player/arrow.tscn")
var last_shoot_flag = false

var max_draw_time = 0.5
var min_draw_time = 0.1

var draw_time = 0

var was_drawing = false

var curve_power = 0
var curve_sens = 0.1

var arrow_ref = null

var bow_width = 3
var bow_string_width = 1

var bow_height = 80
var bow_pull = 30
var bow_x = 40
var bow_mid_height = 30
var bow_mid_pull = 10
var bow_mid_x = 60

func _ready():
	arrow_sprite_pos = arrow_sprite.get_pos()
	arrow_ref = arrow_scene.instance()
	self.add_child(arrow_ref)
	arrow_ref.hide()
	arrow_ref.hit_something = true
	
	set_process(true)

func _draw():
	#draw bow and string
	var blk = Color(0, 0, 0)
	var pull = draw_time / max_draw_time
	var b_x = lerp(bow_x, bow_x - bow_pull, pull)
	var b_m_x = lerp(bow_mid_x, bow_mid_x - bow_mid_pull, pull)
	var s_p = lerp(bow_x, bow_x - max_pull_dis, pull)
	
	arrow_sprite.set_pos(Vector2(0, s_p + arrow_height))
	
	var bow_top = Vector2(bow_height, b_x)
	var bow_bot = Vector2(-bow_height, b_x)
	var bow_mid_top = Vector2(bow_mid_height, b_m_x)
	var bow_mid_bot = Vector2(-bow_mid_height, b_m_x)
	
	draw_line(Vector2(0, bow_mid_x - 6), bow_mid_top, blk, bow_width)
	draw_line(Vector2(0, bow_mid_x - 6), bow_mid_bot, blk, bow_width)
	draw_line(bow_mid_top, bow_top, blk, bow_width)
	draw_line(bow_mid_bot, bow_bot, blk, bow_width)
	
	draw_line(Vector2(0, s_p), bow_top, blk, bow_string_width)
	draw_line(Vector2(0, s_p), bow_bot, blk, bow_string_width)
	
	
	arrow_ref.set_power(calc_power_from_draw(), curve_power)
	var speed = arrow_ref.speed
	
	var pos = arrow_sprite.get_pos() + Vector2(0, -50)
	for t in range(20):
		var v = arrow_ref.calc_local_move_vec() * speed * 0.1
		draw_circle(v + pos, 2, Color(1, 0, 0))
		arrow_ref.curve_speed += curve_power * 0.1
		pos += v


func _process(delta):
	var mouse_pos = get_global_mouse_pos()
	var pos = get_global_pos()
	var offset = mouse_pos - pos
	var angle = atan2(offset.x, offset.y)
	
	if !Input.is_action_pressed("curve"):
		set_global_rot(angle)
		#curve_power = 0
	else:
		calc_curve(angle)

	calc_draw(delta)
	
	if Input.is_action_pressed("return"):
		get_tree().call_group(0, "arrows", "return_to_player")
	update()
	

func calc_curve(var a):
	var cur_angle = get_global_rotd()
	var angle = rad2deg(a)
	
	var angle_diff = angle - cur_angle
	if abs(angle_diff) > 180:
		angle_diff = angle_diff - sign(angle_diff) * 360
	
	curve_power = curve_sens * angle_diff
	

func calc_draw(delta):
	var is_drawing = Input.is_action_pressed("fire")
	
	if is_drawing:
		arrow_sprite.show()
		var ypos = arrow_sprite_pos.y
		var power = calc_power_from_draw()
		draw_time += delta
		draw_time = clamp(draw_time, 0, max_draw_time)
	
	if was_drawing and !is_drawing:
		fire()
	
	if !is_drawing:
		arrow_sprite.hide()
		draw_time = 0
	
	was_drawing = is_drawing

func fire():
	if draw_time < min_draw_time:
		return
	
	var arrow = arrow_scene.instance()
	get_tree().get_root().add_child(arrow)
	arrow.set_global_rot(get_global_rot())
	arrow.set_global_pos(arrow_sprite.get_global_pos())
	arrow.set_power(calc_power_from_draw(), curve_power)
	arrow.set_objs_to_ignore([get_parent()])
	arrow.set_player_ref(get_parent())
	arrow.add_to_group("arrows")

func calc_power_from_draw():
	var p = (draw_time - min_draw_time)  * 1.0 / (max_draw_time - min_draw_time)
	return p
	