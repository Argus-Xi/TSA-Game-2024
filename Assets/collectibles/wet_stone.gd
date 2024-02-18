extends Area2D


var title = "Wet Stone"

var content = "You found a… wet stone? Who would want this? I guess it’s worth a shot to try and sharpen your sword…"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_wet_stone_body_entered(body):
	if body.name == "Player":
		body.sword_damage += 1
		Global.player_sword_damage = body.sword_damage
		body.save_position()
		if Global.first_wetstone:
			get_tree().call_group("dialogue", "type", title, content)
			Global.first_wetstone = false
		queue_free()

