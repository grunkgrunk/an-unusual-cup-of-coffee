extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var topleft = $topleft.global_position
	var bottomright = $bottomright.global_position
	
	limit_top = topleft.y
	limit_left = topleft.x
	
	limit_bottom = bottomright.y
	limit_right = bottomright.x
	