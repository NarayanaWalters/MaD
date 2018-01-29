extends Node2D

onready var cam = get_node("Camera2D")

var cur_zoom = 1.5
var zoom = 1.5
var max_zoom_out = 2
var zoom_increments = 0.1
var zoom_smoothing = 1

func _ready():
	set_process(true)
	set_process_input(true)

func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON):
		if (event.button_index == BUTTON_WHEEL_UP):
			zoom -= zoom_increments
		if (event.button_index == BUTTON_WHEEL_DOWN):
			zoom += zoom_increments
	zoom = clamp(zoom, 1, max_zoom_out)

func _process(delta):
	var m_pos = get_global_mouse_pos()
	var pos = get_parent().get_global_pos()
	var offset = m_pos - pos
	var dis = pos.distance_to(m_pos)
	set_global_pos(pos + offset.normalized() * (dis / 3))
	
	if cur_zoom < zoom:
		cur_zoom += delta * zoom_smoothing
		if cur_zoom > zoom:
			cur_zoom = zoom
	elif cur_zoom > zoom:
		cur_zoom -= delta * zoom_smoothing
		if cur_zoom < zoom:
			cur_zoom = zoom
	get_tree().call_group(0, "zoom_affected", "set_zoom", zoom)
	cam.set_zoom(Vector2(cur_zoom, cur_zoom))
	
