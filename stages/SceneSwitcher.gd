extends Node

onready var StageContainer = $StageContainer  # child that contains the levels below the UI of SceneSwitcher

onready var current_Stage = $StageContainer/stageroot  # Initiates current_level variable with the Title Screen

onready var menu_screen = $Menu  # menu screen UI reference

onready var die_screen = $Die_screen

onready var cutscene_dialogue = $Cutscene_Dialogue

var stage_count = 0

func _ready() -> void:
	current_Stage.connect("scene_change_2", self, "handle_next_level")
	current_Stage.connect("player_died", self, "handle_player_death")

# handles the second incoming signal from the stage in the chain, changes current stage
func handle_next_level(save, destination_stage_count):#new_stage_count, next_dialogue):
#	solve_screen.visible = false   # After a level is solved and "next" button is pressed, the solve screen should disappear
#	die_screen.visible = false    # Same as solve screen above
#	end_screen.visible = false
	var local_des_stage = destination_stage_count # so we can change it if it's too high
	print("scene_change_2 received")

#	print("The new stage count received by the SceneSwitcher is: " + new_stage_count)
#	print(next_dialogue)
#

	var next_Stage
	if local_des_stage > Global.max_stages:  # checks whether or not it's the last level, cycles back to title screen if it is
		local_des_stage = 0
	next_Stage = load("res://stages/Stage" + str(local_des_stage) + ".tscn").instance()
	StageContainer.add_child(next_Stage)
	next_Stage.connect("scene_change_2", self, "handle_next_level")
	next_Stage.connect("player_died", self, "handle_player_death")
	current_Stage.queue_free()
	current_Stage = next_Stage

	
#  Handles when one of the players die, signal from the level, asks to retry
func handle_player_death():
	die_screen.visible = true

# Pulls up menu screen
func _on_MenuButton_pressed():
	menu_screen.visible = not menu_screen.visible
	
	

#  FUNCTIONS FOR ALL BUTTONS IN SOLVE SCREEN

#  FUNCTIONS FOR ALL BUTTONS IN THE DIE SCREEN

#func _on_RetryButton_pressed():
#	handle_next_level(current_Stage.local_stage_count - 1, "try again") # Retry button essentially moves to the next level, but pretends it was on the level before
#
##  FUNCTIONS FOR ALL BUTTONS IN END SCREEN
#
#
##  FUNCTIONS FOR ALL BUTTONS IN MENU SCREEN
#
#func _on_TitleButton_pressed():
#	handle_next_level(0, "back to main menu")
#	menu_screen.visible = false
#
#func _on_ReloadButton_pressed():
#	handle_next_level(current_Stage.local_stage_count - 1, "reloading") # Reload button essentially moves to the next level, but pretends it was on the level before
#	menu_screen.visible = false
