extends Particles2D 

var is_on = true
var heating = null

func _on_burn_area_entered(area):
	if is_on and area.is_in_group("heatable"):
		$timer.start()
		heating = area
		
func _on_burn_area_exited(area):
	if area == heating:
		heating = null
		$timer.stop()

func _on_timer_timeout():
	heating.heat_up()
