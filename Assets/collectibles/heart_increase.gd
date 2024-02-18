extends Area2D


var title = ""

var content = "You found a health increase! This mystical item will increase your life force by one!"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_heart_increase_body_entered(body):
	if body.name == "Player":
		body.increase_total_lives(2)
		body.save_position()
		if Global.first_total_lives_increase:
			get_tree().call_group("dialogue", "type", title, content)
			Global.first_total_lives_increase = false
		queue_free()
