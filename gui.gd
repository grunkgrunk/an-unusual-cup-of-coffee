extends CanvasLayer

onready var tween = $tween

var invis = Color(1, 1, 1, 0)
var vis = Color(1, 1, 1, 1)
var begin = true

var knows_controls = false

var up_pressed = false
var down_pressed = false
var left_pressed = false
var right_pressed = false
var grab_pressed = false
var touch_pressed = false

func _input(event):
	if knows_controls:
		return
	if event.is_action_pressed("ui_up"):
		up_pressed = true
	if event.is_action_pressed("ui_down"):
		down_pressed = true
	if event.is_action_pressed("ui_left"):
		left_pressed = true
	if event.is_action_pressed("ui_right"):
		right_pressed = true
	if event.is_action_pressed("grab"):
		grab_pressed = true
	if event.is_action_pressed("touch"):
		touch_pressed = true
	
	var arrows = up_pressed and down_pressed and left_pressed and right_pressed
	var actions = grab_pressed and touch_pressed
	knows_controls = arrows and actions
	if knows_controls:
		tween.interpolate_property($controls, "modulate",vis, invis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 2)
		$tween.start()
		

func _ready():
	$heading.modulate = invis
	$controls.modulate = invis
	$game_over.modulate = invis
	$entire_screen.modulate = invis
	$by.modulate = invis
	$source_button.modulate = invis
	tween.interpolate_property($heading, "modulate",invis, vis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 1)
	tween.interpolate_property($by, "modulate",invis, vis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 1)
	tween.interpolate_property($controls, "modulate",invis, vis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 2)
	
	tween.interpolate_property($heading, "modulate",vis, invis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 6)
	tween.interpolate_property($by, "modulate",vis, invis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 6)
	tween.start()

func _on_hand_quest_game_over():
	$tween.interpolate_property($entire_screen, "modulate",invis, vis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 2)
	$tween.interpolate_property($game_over, "modulate",invis, vis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 3.5)
	$tween.interpolate_property($source_button, "modulate",invis, vis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 5)
	$tween.start()
