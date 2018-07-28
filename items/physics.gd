extends Area2D

var vel = Vector2()

var is_on_surface = false
var is_moved = false

func _ready():
	connect("area_entered", self, "_on_bottom_area_entered")
	connect("area_exited", self, "_on_bottom_area_exited")
	
	for h in get_tree().get_nodes_in_group("hand"):
		h.connect("begin_grab", self, "_on_begin_grab")
		h.connect("end_grab", self, "_on_end_grab")
	
func _process(delta):
	if is_on_surface or is_moved:
		return
	vel += Vector2(0, 15)
	vel = vel.clamped(800)
	get_parent().position += vel * delta

func _on_bottom_area_entered(area):
	if area.is_in_group("surface"):
		$collide_timer.wait_time = rand_range(0.05, 0.1)
		$collide_timer.start()


func _on_bottom_area_exited(area):
	if area.is_in_group("surface"):
		is_on_surface = false
	
func _on_begin_grab():
	vel = Vector2()
	is_moved = true
func _on_end_grab():
	is_moved = false

func _on_collide_timer_timeout():
	vel = Vector2()
	is_on_surface = true
