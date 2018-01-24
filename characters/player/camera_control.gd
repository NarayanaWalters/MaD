extends Node2D



func _ready():
	set_process(true)

func _process(delta):
	var m_pos = get_global_mouse_pos()
	var pos = get_parent().get_global_pos()
	var offset = m_pos - pos
	var dis = pos.distance_to(m_pos)
	set_global_pos(pos + offset.normalized() * (dis / 3))
	pass
