extends CanvasLayer

onready var tween = $tween

var invis = Color(1, 1, 1, 0)
var vis = Color(1, 1, 1, 1)
var begin = true

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
	tween.interpolate_property($controls, "modulate",vis, invis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 6)
	tween.start()

func _on_hand_quest_game_over():
	$tween.interpolate_property($entire_screen, "modulate",invis, vis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 2)
	$tween.interpolate_property($game_over, "modulate",invis, vis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 3.5)
	$tween.interpolate_property($source_button, "modulate",invis, vis, 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 5)
	$tween.start()
