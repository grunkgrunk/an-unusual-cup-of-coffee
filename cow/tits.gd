extends Area2D

func _ready():
	monitoring = false
	hide()

func interact(hand):
	pass
	
func _on_begin_touch(hand, obj):
	if obj == self:
		for s in $sources.get_children():
			s.start_milk()

func _on_tits_mounted():
	monitoring = true
	show()
	$moo.play()
	