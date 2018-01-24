extends StaticBody2D

onready var explosion = get_node("Explosion")
var exploded = false

func deal_damage(var dmg):
	if !exploded:
		exploded = true
		explosion.explode()
		queue_free()
