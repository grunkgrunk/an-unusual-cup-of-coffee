extends Area2D

func _ready():
	hide()

func interact(hand):
	pass
	
func _on_begin_touch(hand, obj):
	if obj == self and visible:
		for s in $sources.get_children():
			s.start_milk()

func _on_tits_mounted():
	show()
	add_to_group("flesh")
	$moo.play()
	