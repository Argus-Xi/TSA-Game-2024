extends Node2D

signal scene_change_2(save, destination_stage_count)

signal player_died

export var local_stage_count = 0

export var required_num_of_keys = 0

# This dialogue is to preface the following stage, but it is put in the prior stage. We may put this in the global variable eventually.
export var next_dialogue = "Starting New Stage"

# this is a node in the level to detect the player to switch the stage, not a godot signal
onready var stage_switch_signal = $Stage_switch_signal

onready var player = $Player

func _ready():
	stage_switch_signal.connect("scene_change", self, "scene_change_2_func")
	player.connect("player_died_1", self, "died")
	

func _process(_delta):
	pass


# This sends the 2nd signal in the chain (starting from the Scene_switch_signal in the stage) up to the SceneSwitcher, telling it to switch scenes and passes along the information
func scene_change_2_func():
	Global.save_position_bool = false # going into next scene, doesn't keep the saved position
	if Global.num_of_keys >= required_num_of_keys:
		emit_signal("scene_change_2", true, local_stage_count + 1)#, local_stage_count, next_dialogue)
	else:
		get_tree().call_group("dialogue", "type", "", "You do not have enough keys to pass. Be sure to complete everything up to this point.")
	

#  Functions to send level events up to SceneSwitcher

func died():
	emit_signal("player_died")
