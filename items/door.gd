extends Area2D

var max_left = -220
var start_pos = Vector2()

func _ready():
	start_pos = position
	

func interact(hand):
	var pos = hand.position - $offset.position
	position.x = clamp(pos.x, start_pos.x - 180, start_pos.x + 10)