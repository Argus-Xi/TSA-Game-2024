extends Area2D


signal scene_change

export var dialogue = "next scene"

export var stage_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# sends 1st signal in chain up to the current stage in order to change stages
func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("scene_change")
