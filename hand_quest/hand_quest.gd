extends Node2D

var holding = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
# validate the coffee here
# also have different messages here

func _on_hand_area_entered(area):
	if area.is_in_group("coffee"):
		holding = area
		holding.position = $hold.global_position

func _on_hand_area_exited(area):
	if area == holding:
		holding = null
