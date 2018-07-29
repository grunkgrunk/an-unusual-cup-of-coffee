extends Node2D

signal game_over

var holding = null
signal begin_grab
signal end_grab

const welcome = "hi, i would like a cup of burning hot milk with three added coffee beans. I would like the milk to come straight from the cow please."
const win = "perfect! exactly what i asked for. have a nice day!"
const empty = "ehhhhhh... are you seriously serving me an empty cup sir?? i asked for 3 coffee beans and hot milk in this cup!"
const only_milk = "this cup only has milk in it.. i also asked for coffee beans!"
const missing_beans = "i ordered 3 coffee beans and there are only %s in this cup..."
const missing_milk = "so by handing me this you think you are done or? i don't see the milk that i asked for.. go on... i'll wait."
const cold_coffee_milk = "nice.. it has all the ingredients i asked for. but it's cold af. i want it burning hot please."

onready var label = $speech/label
onready var speech = $speech

var invis = Color(1, 1, 1, 0)
var vis = Color(1, 1, 1, 1)

export(NodePath) var camera_path
onready var camera = get_node(camera_path)
var start_pos = null
var target_pos = null

func _process(delta):
	if camera:
		speech.global_position.x = camera.position.x - 384
		
	if holding != null:
		pass
		#holding.position = $hand/hold.global_position

func _ready():
	speech.modulate = invis
	target_pos = position
	start_pos = $start_pos.global_position
	position = start_pos
	
	$tween.interpolate_property(self, "position",
        start_pos, target_pos, 1,
        Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT, 7)
	show_speech(8)
	$speech_timer.wait_time = 8
	$speech_timer.start()
	
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
				emit_signal("game_over")
				return win
			return cold_coffee_milk
		{ "coffee_beans": false, "milk": false }:
			#$empty_cup.play()
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
		show_speech()
		$timer.start()
		#speech.show()
		
		#$tween.interpolate_property(self, "position",
	    #    target_pos, start_pos, 1,
	    #    Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
			
		#$tween.interpolate_property(self, "position",
	    #    start_pos, target_pos, 1,
	    #    Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT, 2)
			
		#tween.start()
		
	

func _on_hand_area_exited(area):
	if area == holding:
		emit_signal("end_grab", self, area)
		holding = null
		
		hide_speech()

func show_speech(delay=0):
	if speech.modulate == vis:
		return
	$tween.interpolate_property(speech, "modulate",invis, vis, 0.5,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, delay)
	$tween.start()


func hide_speech():
	if speech.modulate == invis:
		return
	$tween.interpolate_property(speech, "modulate", vis,invis, 0.5,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()

func _on_timer_timeout():
	if holding != null:
		hide_speech()


func _on_speech_timer_timeout():
	pass
	#$welcome.play()
