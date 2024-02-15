extends KinematicBody2D


var character_name = "npc"

var dialogue_script = [
	"First sentence.",
	"Second sentence.",
	"Third sentence",
]

var is_speaking = false

signal increment_dialogue

onready var talkbox = $talkbox



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if !is_speaking:
			for body in talkbox.get_overlapping_bodies():
				if body.name == "Player":
					speak()
					break
		elif is_speaking:
			emit_signal("increment_dialogue")


# when the npc speaks; is_speaking is set to true as a state, and the npc broadcasts messages to the dialogue box, waiting for the player to interact to move on
# SETS Global.time TO ZERO (until dialogue has stopped)
func speak():
	is_speaking = true
	Global.time = 0
	for sentence in dialogue_script:
		get_tree().call_group("dialogue", "type", character_name, sentence)
		yield(self, "increment_dialogue")
	is_speaking = false
	Global.time = 1
