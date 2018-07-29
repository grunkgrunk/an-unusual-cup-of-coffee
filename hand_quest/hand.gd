extends Area2D

func _ready():
	for q in get_tree().get_nodes_in_group("player"):
		connect("area_entered", q, "_on_quest_area_enter")