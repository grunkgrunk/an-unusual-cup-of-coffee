extends Area2D

var start_pos = Vector2()

func _ready():
	start_pos = position

func _draw():
	var black = Color(0, 0, 0)
	draw_line(start_pos - position, Vector2(), black, 8)

func _process(delta):
	update()
	
func interact(hand):
	position = hand.position