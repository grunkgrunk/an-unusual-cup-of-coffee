extends Area2D

var coffee_state = "empty"
var heat_state = "normal"
var missing_beans = 3

const coffee_state_to_frame = {
	"coffee_milk": 27,
	"milk": 28,
	"empty": 36,
}

const heat_state_to_frame = {
	"normal": 25,
	"low": 18,
	"medium": 19,
	"high": 20
}

var contents = {
	"coffee_beans": false,
	"milk": false,
}

func _ready():
	set_coffee_state(coffee_state)
	set_heat_state(heat_state)

func add_content(content):
	contents[content] = true
	
	if not contents["milk"] and not contents["coffee_beans"]:
		set_coffee_state("empty")
	if contents["milk"]:
		set_coffee_state("milk")
		
func add_bean():
	if missing_beans > 0:
		add_content("coffee_beans")
		match missing_beans:
			3:
				$beans/b3.show()
			2: 
				$beans/b2.show()
			1:
				$beans/b1.show()
		missing_beans -= 1

func set_coffee_state(state):
	coffee_state = state
	$content.frame = coffee_state_to_frame[state]

func set_heat_state(state):
	heat_state = state
	$sprite.frame = heat_state_to_frame[state]

func heat_up():
	match heat_state:
		"normal":
			set_heat_state("low")
		"low":
			set_heat_state("medium")
		"medium":
			set_heat_state("high")
	
func heat_down():
	match heat_state:
		"high":
			set_heat_state("medium")
		"medium":
			set_heat_state("low")
		"low":
			set_heat_state("normal")