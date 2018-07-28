extends KinematicBody2D

export (NodePath) var camera_path

enum hand_states {HOVERING, POINTING, TOUCHING, GRABBING}
const movespeed = 100
const state_to_frame = {
	HOVERING: 2,
	TOUCHING: 3,
	POINTING: 4,
	GRABBING: 5
}
const half_screen = 128 * 6 / 2

var vel = Vector2()
var hand_state = HOVERING
var holding = null
var touching = null

onready var camera = get_node(camera_path)

signal begin_hover
signal end_hover

signal begin_grab
signal end_grab

signal begin_touch
signal end_touch

func _draw():
	var pos = $bottom.position - Vector2(30, 0)
	var size = Vector2(60, 800)
	var rect = Rect2(pos, size)
	var color = Color(0, 0.52, 0.32)
	draw_rect(rect, color)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$sprite.frame = state_to_frame[hand_state]
	
	for i in get_tree().get_nodes_in_group("item"):
		if i.has_method("_on_begin_touch"):
			connect("begin_touch", i, "_on_begin_touch")
		if i.has_method("_on_end_touch"):
			connect("end_touch", i, "_on_end_touch")
		if i.has_method("_on_begin_grab"):
			connect("begin_grab", i, "_on_begin_grab")
		if i.has_method("_on_end_grab"):
			connect("end_grab", i, "_on_end_grab")
		

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
			
			
			if holding:
				if holding.has_method("interact"):
					holding.interact(self)
				else:
					holding.position = position - holding.get_node("offset").position
		TOUCHING:
			camera.position -= movement
			var diff = position - camera.position
			camera.position.x = position.x - clamp(diff.x, -half_screen, half_screen)
			camera.position.y = position.y - clamp(diff.y, -half_screen, half_screen)
			
			
			camera.position.x = max(camera.position.x, camera.limit_left + half_screen)
			camera.position.x = min(camera.position.x, camera.limit_right - half_screen)
			camera.position.y = max(camera.position.y, camera.limit_top + half_screen)
			camera.position.y = min(camera.position.y, camera.limit_bottom - half_screen)


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
			pass
		TOUCHING:
			emit_signal("end_touch", self, touching)
			touching = null
		GRABBING:
			if holding != null:
				holding.z_index = 0
				emit_signal("end_grab", self, holding)
				holding = null
	hand_state = state
	$sprite.frame = state_to_frame[hand_state]
	
	match hand_state:
		HOVERING:
			vel = Vector2()
		TOUCHING:
			var touching = get_overlap($surface)
			emit_signal("begin_touch", self, touching)
			vel = Vector2()
		GRABBING:
			holding = get_overlap($grab)
			if holding != null:
				holding.z_index = 99
				emit_signal("begin_grab", self, holding)

func get_overlap(node):
	var overlapping = node.get_overlapping_areas()
	var blocking = false
	var item = null
	for o in overlapping:
		if o.is_in_group("grab") and item == null:
			item = o
		if o.is_in_group("door"):
			return o
		if o.is_in_group("blocking"):
			blocking = true
	if not blocking:
		return item
	return null
	

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