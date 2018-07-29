extends Node

#onready var timer = Timer()

func _ready():
	var topleft = $borders/topleft.global_position
	var bottomright = $borders/bottomright.global_position
	
	$camera.limit_top = topleft.y
	$camera.limit_left = topleft.x
	
	$camera.limit_bottom = bottomright.y
	$camera.limit_right = bottomright.x
	