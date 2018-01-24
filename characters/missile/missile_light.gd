extends Sprite

var root

func _ready():
	root = get_parent().get_parent()
	set_process(true)

func _process(delta):
	#update()
	pass

func _draw():
	"""
	var cruising = root.cruising
	var cruise_time = root.cruise_time
	
	var radi = 12
	var pos = Vector2(0, -100)
	if cruising:
		draw_circle(pos, radi, Color(1, 0, 0))
	else:
		draw_circle(pos, radi, Color(0, 1, 0))
	"""
	pass