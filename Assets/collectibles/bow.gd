extends Area2D


var title = "Bow"

var content = "You found the bow! Notch an arrow, pull back the string, and then…What?? What do you mean you don’t know how to do that?? You’ve gotten this far already, surely you should be able to figure this out. Maybe right click?"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.have_bow = true
		Global.has_bow = true
		get_tree().call_group("dialogue", "type", title, content)
		queue_free()
