extends TileMap





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func apply_damage(num):
	queue_free()
	
func apply_force(pos, num):
	pass
