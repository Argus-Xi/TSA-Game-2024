extends Node


# player traits

var player_total_lives = 3

var player_health = 3

var player_sword_damage = 1

var player_arrow_damage = 1

# Experience variables

var first_health_increase = true

var first_wetstone = true

var has_sword = false

var has_bow = false

# universal traits

var current_saved_stage = 0

# this count does not include the 0th stage or title screen: if 7 literal scenes, this number will be 6
var max_stages = 2

var time = 1

var hearts_visible = true




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func new_game():
	player_total_lives = 3
	player_health = 3
	player_sword_damage = 1
	player_arrow_damage = 1
	first_health_increase = true
	first_wetstone = true
	has_sword = false
	has_bow = false
	
