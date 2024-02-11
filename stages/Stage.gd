extends Node2D

signal scene_change_2(save, destination_stage_count)

signal player_died

export var local_stage_count = 0

# This dialogue is to preface the following stage, but it is put in the prior stage. We may put this in the global variable eventually.
export var next_dialogue = "Starting New Stage"

# this is a node in the level to detect the player to switch the stage, not a godot signal
onready var stage_switch_signal = $Stage_switch_signal

func _ready():
	stage_switch_signal.connect("scene_change", self, "scene_change_2_func")
	

func _process(delta):
	pass


# This sends the 2nd signal in the chain (starting from the Scene_switch_signal in the stage) up to the SceneSwitcher, telling it to switch scenes and passes along the information
func scene_change_2_func():
	emit_signal("scene_change_2", true, local_stage_count + 1)#, local_stage_count, next_dialogue)
	print("scene_change_2 sent")

#  Functions to send level events up to SceneSwitcher

func solved():   # Calculates the score and sends it to the SceneSwitcher for the UI
	pass
	
func died():
	emit_signal("player_died")
