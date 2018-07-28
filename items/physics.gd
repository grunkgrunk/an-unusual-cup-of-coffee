extends Area2D

var vel = Vector2()

var is_on_surface = false
var is_moved = false

func _ready():
	connect("area_entered", self, "_on_bottom_area_entered")
	connect("area_exited", self, "_on_bottom_area_exited")

func _process(delta):
	if is_on_surface or is_moved:
		return
	vel += Vector2(0, 20)
	get_parent().position += vel * delta

func _on_bottom_area_entered(area):
	if area.is_in_group("surface"):
		vel = Vector2()
		is_on_surface = true


func _on_bottom_area_exited(area):
	if area.is_in_group("surface"):
		is_on_surface = false
		
func _on_move_begin():
	vel = Vector2()
	is_moved = true
	
func _on_move_end():
	is_moved = false
	
