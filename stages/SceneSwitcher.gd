extends Node

onready var StageContainer = $StageContainer  # child that contains the levels below the UI of SceneSwitcher

onready var current_Stage = $StageContainer/stageroot  # Initiates current_level variable with the Title Screen

onready var menu_screen = $Menu  # menu screen UI reference

onready var die_screen = $Die_screen

#Cutscene elements

onready var cutscene_dialogue = $Cutscene_Dialogue

onready var cutscene_title = $Cutscene_Dialogue/Title

onready var cutscene_content = $Cutscene_Dialogue/Content

onready var cutscene_timer = $Cutscene_Dialogue/Timer


var scene_change_dialogues = [
	{
		"title": "Forest Island",
		"content": "Home sweet home"
	},
	{
		"title": "Beach Island",
		"content": "The hot home of the Yellow Key"
	},
	{
		"title": "Rocky Island",
		"content": "Home of the Rocks"
	},
	{
		"title": "Ice Island",
		"content": "Home of the Rocks"
	},
	{
		"title": "Rocky Island",
		"content": "Home of the Rocks"
	},
	{
		"title": "Forest Island",
		"content": "Home Sweet home: but desolated"
	},
	{
		"title": "The Castle",
		"content": "Say your prayers"
	},
]


# Local variable to store which stage the player is in, not necessarily where they have their current slot saved
var stage_count = 0

func _ready() -> void:
	current_Stage.connect("scene_change_2", self, "handle_next_level")
	current_Stage.connect("player_died", self, "handle_player_death")

# checks if the menu button is pressed
func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		menu_screen.visible = !menu_screen.visible

# handles the second incoming signal from the stage in the chain, changes current stage
func handle_next_level(save, destination_stage_count):#new_stage_count, next_dialogue):
#	solve_screen.visible = false   # After a level is solved and "next" button is pressed, the solve screen should disappear
	die_screen.visible = false    # Same as solve screen above
	menu_screen.visible = false
	stage_count = destination_stage_count # so we can change it if it's too high

#	print("The new stage count received by the SceneSwitcher is: " + new_stage_count)
#	print(next_dialogue)
#

	var next_Stage
	
		
	# handles the cutscene
	if stage_count > 0: # checks if it should play a cutscene dialogue in between
		cutscene_title.text = scene_change_dialogues[stage_count - 1]["title"]
		cutscene_content.text = scene_change_dialogues[stage_count - 1]["content"]
		cutscene_dialogue.visible = true
		cutscene_timer.start(3)
		
		
	if stage_count > Global.max_stages:  # checks whether or not it's the last level, cycles back to title screen if it is, comes AFTER cutscene for final cutscene
		stage_count = 0
	
	# instantiates the new scene, adds it under the stage container, connects to its signals, and deletes the old scene
	next_Stage = load("res://stages/Stage" + str(stage_count) + ".tscn").instance()
	StageContainer.add_child(next_Stage)
	next_Stage.connect("scene_change_2", self, "handle_next_level")
	next_Stage.connect("player_died", self, "handle_player_death")
	current_Stage.queue_free()
	current_Stage = next_Stage
	
	# Saves the new stage in Global if the "save" parameter sent up is true - not all scene changes are saved, such as back to title and whatnot
	if save:
		Global.current_saved_stage = stage_count

	
#  Handles when one of the players die, signal from the level, asks to retry
func handle_player_death():
	die_screen.visible = true

# Pulls up menu screen
func _on_MenuButton_pressed():
	menu_screen.visible = not menu_screen.visible
	
	


func _on_BacktoMain_button_down():
	handle_next_level(false, 0)
	menu_screen.visible = false


# times out when the cutscene is done playing - may be temporary
func _on_Timer_timeout():
	cutscene_dialogue.visible = false
	
# Retrying after dying
func _on_Retry_button_down():
	Global.player_health = Global.player_total_lives
	handle_next_level(false, Global.current_saved_stage)
	
