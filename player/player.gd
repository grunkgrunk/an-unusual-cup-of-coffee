extends KinematicBody2D

var movespeed = 100
var coffee = 100 
var vel = Vector2()
enum hand_states {HOVERING, POINTING, TOUCHING, GRABBING}
var hand_state = HOVERING
var in_area = null
var is_holding = false

var blocked = false

const half_screen = 128 * 6 / 2

export (NodePath) var camera_path
onready var camera = get_node(camera_path)

const HOVER = 2
const TOUCH = 3
const GRAB = 5
const POINT = 4

signal begin_hover
signal end_hover

signal begin_grab
signal end_grab

signal begin_touch
signal end_touch

const state_to_frame = {
	HOVERING: HOVER,
	TOUCHING: TOUCH,
	POINTING: POINT,
	GRABBING: GRAB
}

func _draw():
	#var pos = position + $bottom.position
	var pos = $bottom.position - Vector2(30, 0)
	var size = Vector2(60, 800)
	var rect = Rect2(pos, size)
	var color = Color(0, 0.52, 0.32)
	draw_rect(rect, color)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$sprite.frame = state_to_frame[hand_state]

func _process(delta):
	update()
	var movement = move() * delta
	
	var state = current_state()
	switch_state(state)
	
	match hand_state:
		HOVERING:
			position += movement
			var diff = position - camera.position
			position.x = camera.position.x + clamp(diff.x, -half_screen, half_screen)
			position.y = camera.position.y + clamp(diff.y, -half_screen, half_screen)
		GRABBING:
			position += movement
			var diff = position - camera.position
			position.x = camera.position.x + clamp(diff.x, -half_screen, half_screen)
			position.y = camera.position.y + clamp(diff.y, -half_screen, half_screen)
			
			if is_holding:
				if in_area.has_method("interact"):
					in_area.interact(self)
				else:
					in_area.position = position - in_area.get_node("offset").position
		TOUCHING:
			camera.position -= movement
			var diff = position - camera.position
			camera.position.x = position.x - clamp(diff.x, -half_screen, half_screen)
			camera.position.y = position.y - clamp(diff.y, -half_screen, half_screen)

func current_state():
	if Input.is_action_pressed("grab"):
		return GRABBING
	elif Input.is_action_pressed("touch"):
		return TOUCHING
	
	return HOVERING

func switch_state(state):
	var prev_hand_state = hand_state
	if (prev_hand_state == state):
		return
		
	# ending this state
	match prev_hand_state:
		HOVERING:
			emit_signal("end_hover")
		TOUCHING:
			emit_signal("end_touch")
		GRABBING:
			emit_signal("end_grab")
	hand_state = state
	$sprite.frame = state_to_frame[hand_state]
	match hand_state:
		HOVERING:
			emit_signal("begin_hover")
			vel = Vector2()
			is_holding = false
		TOUCHING:
			emit_signal("begin_touch")
			vel = Vector2()
			is_holding = false
		GRABBING:
			emit_signal("begin_grab")
			is_holding = in_area != null

func move():
	var dir = Vector2()
	if Input.is_action_pressed("ui_up"):
		dir.y = -1
	if Input.is_action_pressed("ui_left"):
		dir.x = -1
	if Input.is_action_pressed("ui_right"):
		dir.x = 1
	if Input.is_action_pressed("ui_down"):
		dir.y = 1
		
	vel += dir.normalized() * movespeed
	
	vel *= 0.85
	return vel

func _on_grab_area_entered(area):
	if area.is_in_group("blocking"):
		blocked = true
	
	var is_door = area.is_in_group("door")
	
	if area.is_in_group("grab") and not is_holding and (not blocked or is_door):
		in_area = area

func _on_grab_area_exited(area):
	if area.is_in_group("blocking"):
		blocked = false
	if area == in_area:
		in_area = null
		is_holding = false


func _on_surface_area_entered(area):
	pass


func _on_surface_area_exited(area):
	pass # replace with function body
