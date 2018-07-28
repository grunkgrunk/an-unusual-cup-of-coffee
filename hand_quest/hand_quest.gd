extends Node2D

var holding = null
signal begin_grab
signal end_grab
# validate the coffee here
# also have different messages here

func _on_hand_area_entered(area):
	if area.is_in_group("grab"):
		emit_signal("begin_grab", self, area)
		holding = area
		holding.position = $hold.global_position

func _on_hand_area_exited(area):
	if area == holding:
		emit_signal("end_grab", self, area)
		holding = null
