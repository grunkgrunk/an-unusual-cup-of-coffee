extends Area2D

const resting = Vector2(20, 0) 
var connected = false
var is_moved = false

signal wire_connected

func _ready():
	position = resting

func _draw():
	var black = Color(0, 0, 0)
	draw_line(Vector2(), -position, black, 8)

func _process(delta):
	update()
	
func interact(hand):
	if connected:
		return
	if position.length() < 400:
		global_position = hand.position
	else:
		position = position.clamped(398)
		hand.vel *= 0.1
		hand.position = global_position

func _on_begin_grab(hand, obj):
	if obj == self:
		is_moved = true

func _on_end_grab(hand, obj):
	if obj == self and not connected:
		$tween.interpolate_property(self, "position",
                position, resting, 0.7,
                Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$tween.start()
		is_moved = false

func _on_wire_area_entered(area):
	if area.is_in_group("butt") and is_moved == true:
		area.get_node("farts").emitting = false
		global_position = area.global_position
		connected = true
		remove_from_group("grab")
		emit_signal("wire_connected")
		
