extends Node2D

var holding = null
signal begin_grab
signal end_grab
# validate the coffee here
# also have different messages here
const welcome = "hi, i would like a cup of steaming hot milk with three added coffee beans. I would like the milk to come straight from the cow please."
const win = "perfect! exactly what i asked for. have a nice day!"
const empty = "ehhhhhh... are you seriously serving me an empty cup sir??"
func _ready():
	$layer/speech/label.text = welcome

func validate(coffee):
	match coffee.contents:
		{ "milk": true, "coffee": true }:
			$label.text = win
		{ "milk": false, "coffee": false }:
			$label.text = empty
		{ "milk": false, "coffee": true }:
			pass

func _on_hand_area_entered(area):
	if area.is_in_group("grab"):
		emit_signal("begin_grab", self, area)
		holding = area
		holding.position = $hold.global_position

func _on_hand_area_exited(area):
	if area == holding:
		emit_signal("end_grab", self, area)
		holding = null
