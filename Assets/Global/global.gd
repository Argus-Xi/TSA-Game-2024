extends Node


# player traits

var player_total_lives = 6

var player_health = 6

var player_sword_damage = 1

var player_bow_damage = 1

# Experience variables

var first_total_lives_increase = true

var first_wetstone = true

var first_wetflint = true

var has_sword = false

var has_bow = false

var num_of_keys = 0

# universal traits

var current_saved_stage = 0

# this count does not include the 0th stage or title screen: if 7 literal scenes, this number will be 6
var max_stages = 5

var time = 1

var hearts_visible = false

# Saving position

var save_position_bool = false

var save_position_vector = Vector2(0,0)




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func new_game():
	player_total_lives = 6
	player_health = 6
	player_sword_damage = 1
	player_bow_damage = 1
	first_total_lives_increase = true
	first_wetstone = true
	has_sword = false
	has_bow = false
	
