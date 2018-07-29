extends Area2D

var mounted = false
var holding = false	

func _on_begin_grab(hand, obj):
	if obj == self:
		holding = true

func _on_end_grab(hand, obj):
	if obj == self:
		holding = false
		if mounted:
			queue_free()
		

func _on_bean_area_entered(area):
	if area.is_in_group("coffee") and holding and not mounted:
		mounted = true
		area.add_bean()
		hide()
