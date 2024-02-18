extends Area2D


var title = "Sword"

var content = "You got the village sword! As one of the only weapons outside of the castle, it will be your most valuable tool! It’s gotten quite dull over the years, but it’ll still hurt. "

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.have_sword = true
		Global.has_sword = true
		get_tree().call_group("dialogue", "type", title, content)
		queue_free()
