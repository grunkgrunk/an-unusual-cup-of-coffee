extends Particles2D

var cup = null

func _on_area_area_entered(area):
	if area.is_in_group("coffee"):
		cup = area


func start_milk():
	emitting = true
	$timer.start()
	

func _on_timer_timeout():
	if cup != null:
		cup.add_content("milk")

func _on_area_area_exited(area):
	if area == cup:
		cup = null
