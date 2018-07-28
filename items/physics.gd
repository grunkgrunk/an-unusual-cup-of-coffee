extends Area2D

var vel = Vector2()

var is_on_surface = false
var holding_hand = null

func _ready():
	connect("area_entered", self, "_on_bottom_area_entered")
	connect("area_exited", self, "_on_bottom_area_exited")
	
	for h in get_tree().get_nodes_in_group("hand"):
		h.connect("begin_grab", self, "_on_begin_grab")
		h.connect("end_grab", self, "_on_end_grab")
	
func _process(delta):
	if is_on_surface or holding_hand != null:
		return
	vel += Vector2(0, 15)
	vel = vel.clamped(800)
	get_parent().position += vel * delta

func _on_bottom_area_entered(area):
	if area.is_in_group("surface"):
		vel = Vector2()
		is_on_surface = true

func _on_bottom_area_exited(area):
	if area.is_in_group("surface"):
		vel = Vector2()
		is_on_surface = false
	
func _on_begin_grab(hand, obj):
	if obj == get_parent():
		holding_hand = hand
		vel = Vector2()
		
func _on_end_grab(hand, obj):
	if obj == get_parent() and hand == holding_hand:
		holding_hand = null