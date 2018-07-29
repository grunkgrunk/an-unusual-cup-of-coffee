extends Node2D

var holding = null
signal begin_grab
signal end_grab
# validate the coffee here
# also have different messages here
const welcome = "hi, i would like a cup of burning hot milk with three added coffee beans. I would like the milk to come straight from the cow please."
const win = "perfect! exactly what i asked for. have a nice day!"
const empty = "ehhhhhh... are you seriously serving me an empty cup sir?? i asked for 3 coffee beans and hot milk in this cup!"
const only_milk = "this cup only has milk in it.. i also asked for coffee beans!"
const missing_beans = "i ordered 3 coffee beans and there are only %s in this cup..."
const missing_milk = "so by handing me this you think you are done or? i don't see the milk that i asked for.. go on... i'll wait."
const cold_coffee_milk = "nice.. it has all the ingredients i asked for. but it's cold af. i want it burning hot please."

onready var label = $speech/label
onready var speech = $speech

export(NodePath) var camera_path
onready var camera = get_node(camera_path)
var start_pos = null
var target_pos = null

func _process(delta):
	if camera:
		speech.global_position.x = camera.position.x - 384

func _ready():
	target_pos = position
	start_pos = $start_pos.global_position
	position = start_pos
	
	$tween.interpolate_property(self, "position",
        start_pos, target_pos, 2,
        Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$tween.start()
	
	label.text = welcome
	for q in get_tree().get_nodes_in_group("player"):
		connect("begin_grab", q, "_on_other_hand_begin_grab")

func validate(coffee):
	if not coffee.is_in_group("coffee"):
		return "really?? you give me a %s?! i'm not gonna pay for that." % coffee.name

			
	match coffee.contents:
		{ "coffee_beans": true, "milk": true }:
			if coffee.heat_state == "high":
				return win
			return cold_coffee_milk
		{ "coffee_beans": false, "milk": false }:
			return empty
		{ "coffee_beans": false, "milk": true}:
			return only_milk
		{ "coffee_beans": true, "milk": false}:
			if coffee.missing_beans > 0:
				return missing_beans % (3 - coffee.missing_beans)
			return missing_milk

	
	return "i don't even know what to say about this.. can i get my coffee soon?"

func _on_hand_area_entered(area):
	if area.is_in_group("grab") and holding == null:
		emit_signal("begin_grab", self, area)
		holding = area
		holding.position = $hand/hold.global_position
		label.set_text(validate(holding))
		speech.show()
		
		var rand_dir = Vector2(1, 0).rotated(rand_range(0, 2*PI))*10
		
		#$tween.interpolate_property(self, "position",
	    #    position, position + rand_dir,
	    #    Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		#$tween.start()
		

func _on_hand_area_exited(area):
	if area == holding:
		emit_signal("end_grab", self, area)
		holding = null
		speech.hide()
