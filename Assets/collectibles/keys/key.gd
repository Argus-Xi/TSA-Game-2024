extends Area2D

export var title = "Key"

export var content = "Content"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Key_body_entered(body):
	if body.name == "Player":
		get_tree().call_group("dialogue", "type", title, content)
		Global.num_of_keys += 1
		queue_free()
