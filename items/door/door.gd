extends Area2D

var max_left = -220
var start_pos = Vector2()

func _ready():
	start_pos = global_position
	show()
	
func interact(hand):
	var pos = hand.position - $offset.position
	global_position.x = clamp(pos.x, start_pos.x - 140, start_pos.x)