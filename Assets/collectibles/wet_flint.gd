extends Area2D


var title = "Wet Stone"

var content = "You… who put wet flint here?? *sigh* It won’t do anything for your sword, so you might as well sharpen your arrows. "

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_wet_flint_body_entered(body):
	if body.name == "Player":
		body.bow_damage += 1
		Global.player_bow_damage = body.bow_damage
		body.save_position()
		if Global.first_wetflint:
			get_tree().call_group("dialogue", "type", title, content)
			Global.first_wetflint = false
		queue_free()
