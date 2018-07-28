extends Area2D

signal tits_mounted

var mounted = false
var holding = false

func _ready():
	for m in get_tree().get_nodes_in_group("tits_mount"):
		connect("tits_mounted", m, "_on_tits_mounted")
		

func _on_tits_area_entered(area):
	if area.is_in_group("tits_mount") and holding:
		emit_signal("tits_mounted")
		mounted = true
		hide()

func _on_begin_grab(hand, obj):
	if obj == self:
		holding = true

func _on_end_grab(hand, obj):
	if obj == self:
		holding = false
		if mounted:
			queue_free()
		