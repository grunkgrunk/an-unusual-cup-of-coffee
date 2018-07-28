extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_end_grab(hand, obj):
	if obj == self:
		for o in get_overlapping_areas():
			if o.is_in_group("coffee"):
				o.add_bean()
				queue_free()
	