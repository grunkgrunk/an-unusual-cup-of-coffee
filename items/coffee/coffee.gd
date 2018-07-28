extends Area2D

enum INGREDIENTS { }

enum COFFEE_STATE { COFFEE_MILK, COFFEE_BLACK, MILK, WATER, EMPTY }
enum HEAT_STATE { NORMAL, LOW, MEDIUM, HIGH }
enum HEAT_DIRECTION { UP, DOWN }
enum CONTENT {MILK, WATER, COFFEE}

var coffee_state = EMPTY
var heat_state = NORMAL

const coffee_state_to_frame = {
	COFFEE_MILK: 27,
	COFFEE_BLACK: 35,
	MILK: 28,
	WATER: 29,
	EMPTY: 36,
}

const heat_state_to_frame = {
	NORMAL: 25,
	LOW: 18,
	MEDIUM: 19,
	HIGH: 20
}

var contents = {
	"coffee": false,
	"milk": false,
	"water": false
}

func _ready():
	set_coffee_state(EMPTY)
	set_heat_state(NORMAL)

func add_content(content):
	contents[content] = true
	match contents:
		{ "coffee": true, "milk": true, "water": true }:
			set_coffee_state(COFFEE_MILK)
		{ "coffee": true, "milk": false, "water": true }:
			set_coffee_state(COFFEE_BLACK)
		{ "coffee": false, "milk": false, "water": false }:
			set_coffee_state(EMPTY)
		{ "coffee": true, "milk": false, "water": false }:
			# should display three levels of powder, or just the coffee beans
			pass
		{ "coffee": false, "milk": false, "water": true }:
			set_coffee_state(WATER)

func set_coffee_state(state):
	coffee_state = state
	$content.frame = coffee_state_to_frame[state]

func set_heat_state(state):
	heat_state = state
	$sprite.frame = heat_state_to_frame[state]

func heat_up():
	match heat_state:
		NORMAL:
			set_heat_state(LOW)
		LOW:
			set_heat_state(MEDIUM)
		MEDIUM:
			set_heat_state(HIGH)
	
func heat_down():
	match heat_state:
		HIGH:
			set_heat_state(MEDIUM)
		MEDIUM:
			set_heat_state(LOW)
		LOW:
			set_heat_state(NORMAL)