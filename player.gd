extends KinematicBody2D

var movespeed = 30
var coffee = 100 
var vel = Vector2()
enum hand_states {HOVERING, POINTING, TOUCHING, GRABBING}
var hand_state = HOVERING
var in_area = null
var is_holding = false

export (NodePath) var camera_path
onready var camera = get_node(camera_path)

const HOVER = 2
const TOUCH = 3
const GRAB = 5
const POINT = 4

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	var movement = move()
	
	print(Input.action_press())
	
	if Input.is_action_pressed("grab"):
		$sprite.frame = GRAB
		switch_state(GRABBING)
	elif Input.is_action_pressed("touch"):
		$sprite.frame = TOUCH
		switch_state(TOUCHING)
	else:
		$sprite.frame = HOVER
		switch_state(GRABBING)

	match hand_state:
		HOVER:
			vel = move_and_slide(movement)
		GRAB:
			vel = move_and_slide(movement)
			if is_holding:
				in_area.position = position - in_area.get_node("offset").position
		TOUCH:
			camera.position -= movement * delta

func switch_state(state):
	var prev_hand_state = hand_state
	if (prev_hand_state == state):
		return
	
	match state:
		HOVERING:
			vel = Vector2()
			is_holding = false
		TOUCHING:
			vel = Vector2()
			is_holding = false
		GRAB:
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
	vel *= 0.9
	return vel
		

func _on_grab_area_entered(area):
	if area.is_in_group("grab") and not is_holding:
		in_area = area

func _on_grab_area_exited(area):
	if area == in_area:
		in_area = null
		is_holding = false
