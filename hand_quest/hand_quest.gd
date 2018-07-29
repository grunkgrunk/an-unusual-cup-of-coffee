extends Node2D

var holding = null
signal begin_grab
signal end_grab
# validate the coffee here
# also have different messages here
const welcome = "hi, i would like a cup of steaming hot milk with three added coffee beans. I would like the milk to come straight from the cow please."
const win = "perfect! exactly what i asked for. have a nice day!"
const empty = "ehhhhhh... are you seriously serving me an empty cup sir??"
const only_milk = "this cup only has milk in it.. i also asked for coffee beans!"
const only_coffee = ""
const coffee_milk = ""

onready var label = $layer/speech/label

func _ready():
	label.text = welcome
	for q in get_tree().get_nodes_in_group("player"):
		connect("begin_grab", q, "_on_other_hand_begin_grab")

func validate(coffee):
	if not coffee.is_in_group("coffee"):
		return "ehhh this is not coffee you know that??"
		
	match coffee.coffee_state:
		"milk":
			return only_milk
		"coffee":
			return only_coffee
		"coffee_milk":
			return coffee_milk

func _on_hand_area_entered(area):
	if area.is_in_group("grab") and holding == null:
		emit_signal("begin_grab", self, area)
		holding = area
		holding.position = $hand/hold.global_position
		label.set_text(validate(holding))

func _on_hand_area_exited(area):
	if area == holding:
		emit_signal("end_grab", self, area)
		holding = null
