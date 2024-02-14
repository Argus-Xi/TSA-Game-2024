extends Area2D

var speed=600

var damage = 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position+=(Vector2.RIGHT*speed).rotated(rotation) * delta
	
	
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Arrow_body_entered(_body):
	queue_free()

