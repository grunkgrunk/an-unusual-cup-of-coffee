extends Area2D

var is_on = true
var heating = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_burn_area_entered(area):
	if is_on and area.is_in_group("heatable"):
		$fire/timer.start()
		heating = area


func _on_burn_area_exited(area):
	if area == heating:
		heating = null
		$fire/timer.stop()


func _on_timer_timeout():
	heating.heat_up()
