extends Node

onready var StageContainer = $StageContainer  # child that contains the levels below the UI of SceneSwitcher

onready var current_Stage = $StageContainer/stageroot  # Initiates current_level variable with the Title Screen

onready var menu_screen = $GUI/Menu  # menu screen UI reference

onready var die_screen = $GUI/Die_screen

#Cutscene elements

onready var cutscene_dialogue = $GUI/Cutscene_Dialogue

onready var cutscene_title = $GUI/Cutscene_Dialogue/Title

onready var cutscene_content = $GUI/Cutscene_Dialogue/Content


var scene_change_dialogues = [
	{
		"title": "Crisis at Hand",
		"content": "The kingdom of Mathonia has fallen into disarray in recent months; monster invasions have become more frequent, villages are being raided, and the castle has gone silent. Although the royal family were ill-equipped to fight off the monsters, ancient legend hints at the existence of the Scroll Of Destiny: an invaluable piece of knowledge that gives any fighter the ability to banish evil from the land. In an attempt to save the kingdom, you, a mere farmer, go on a journey to save Mathonia…"
	},
	{
		"title": "The Boss Chamber",
		"content": "Say your prayers"
	},
	{
		"title": "Rocky Island",
		"content": "With the scroll of destiny found to be empty, you returned to your home village, unsure of what else you could do. As you stood at the gate, listening to the sounds of monsters roaring at terrified civilians, you realized the truth of the scroll of destiny and chuckled, wondering how you could have been such a fool. The scroll of destiny was not what mattered: your courage to stand up for the kingdom was, in itself, a mystical power that would prove to banish all evil from the land of Mathonia."
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
		if menu_screen.visible:
			Global.time = 0
		elif !menu_screen.visible:
			Global.time = 1
	if Input.is_action_just_pressed("interact"):
		cutscene_dialogue.visible = false
		Global.time = 1

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
		Global.time = 0
		
		
	if stage_count > Global.max_stages:  # checks whether or not it's the last level, cycles back to title screen if it is, comes AFTER cutscene for final cutscene
		stage_count = 0
		
		# Changing global variables according to scene change:
	if stage_count == 0:
		Global.hearts_visible = false
	elif stage_count > 0:
		Global.hearts_visible = true
	
	# instantiates the new scene, adds it under the stage container, connects to its signals, and deletes the old scene
	next_Stage = load("res://stages/Stage" + str(stage_count) + ".tscn").instance()
	StageContainer.call_deferred("add_child", next_Stage)
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
	Global.time = 0


func _on_BacktoMain_button_down():
	menu_screen.visible = false
	Global.time = 1
	handle_next_level(false, 0)
	



# Retrying after dying
func _on_Retry_button_down():
	Global.player_health = Global.player_total_lives
	Global.time = 1
	handle_next_level(false, Global.current_saved_stage)
	


func _on_SavePos_button_down():
	for node in get_tree().get_nodes_in_group("player"):
		node.save_position()
